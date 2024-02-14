import argparse
import os

from litex_boards.platforms.antmicro_lpddr4_test_board import Platform

import litex.soc.integration.export as export
import litex.soc.interconnect.csr_bus as csr_bus
from litex.soc.cores.uart import UART, UARTPHY
from litex.soc.integration.builder import *
from litex.soc.integration.soc import SoCCSRRegion, SoCRegion, SoCController, SoCIRQHandler
from litex.soc.interconnect import wishbone
from litex.soc.cores.led import LedChaser
from litex.soc.cores.cpu.vexriscv import VexRiscv
from litex.soc.cores import timer
from migen import *
from litex.soc.interconnect.csr_eventmanager import *

from soc_generator.gen.amaranth_wrapper import Amaranth2Migen
from soc_generator.gen.wishbone_interconnect import WishboneRRInterconnect

class LPDDR4IntegrationSoC(Module):
    def __init__(self, platform, build_dir):
        self.sys_clk_freq = 50e6

        self.clock_domains.cd_sys = ClockDomain()

        self.slaves = {}
        self.masters = {}
        self.mem_regions = {}
        self.mem_map = {
            "rom":       0x0000_0000,
            "sram":      0x1000_0000,
            "main_ram":  0x4000_0000,
            "dram_ctrl": 0x8300_0000,
            "csr":       0xe000_0000,
        }
        self.csr_addr_map = {
            "ctrl": 0,
            "uart": 3,
            "timer0": 5,
        }
        self.irq_map = {
            "timer0": 1,
            "uart": 2,
        }
        self.csr_paging = 0x200

        self.platform = platform
        self.build_dir = build_dir

        # CPU
        self.submodules.cpu = VexRiscv(platform, variant="standard")
        self.cpu.set_reset_address(self.mem_map["sram"])

        self.irq = SoCIRQHandler(n_irqs=31, reserved_irqs={})
        self.irq.enable()

        self.submodules.ctrl = SoCController()
        self.comb += self.cpu.reset.eq(self.ctrl.soc_rst | self.ctrl.cpu_rst)

        self.submodules.timer0 = timer.Timer()
        self.timer0.add_uptime()
        self.irq.add("timer0", n=self.irq_map["timer0"])

        self.masters["cpu_ibus"] = self.cpu.ibus
        self.masters["cpu_dbus"] = self.cpu.dbus

        # UART
        self.uart_pads = platform.request("serial", number=1)
        self.submodules.uart_phy = UARTPHY(self.uart_pads, self.sys_clk_freq, 115200)
        self.submodules.uart = UART(phy=self.uart_phy)
        self.irq.add("uart", n=self.irq_map["uart"])

        # CSR bus
        csr_master = csr_bus.Interface(data_width=32)
        self.submodules.csrs = csr_bus.CSRBankArray(
            self, lambda name, _: self.csr_addr_map[name],data_width=32, paging=self.csr_paging
        )
        if self.csrs.get_buses():
            self.submodules += csr_bus.Interconnect(master=csr_master, slaves=self.csrs.get_buses())

        csr_wishbone = wishbone.Interface()
        self.submodules += wishbone.Wishbone2CSR(bus_wishbone=csr_wishbone, bus_csr=csr_master)

        csr_region = SoCRegion(origin=self.mem_map["csr"], size=0x1000)
        self.slaves["csr"] = (csr_wishbone, csr_region)

        # ROM + RAM
        self.add_memory(self.mem_map["rom"], 0xA000, read_only=True, name="rom")
        self.add_memory(self.mem_map["sram"], 0x40000, name="sram")

        # LED chaser
        led0 = Signal(name="user_led0")
        led1 = Signal(name="user_led1")
        led2 = Signal(name="user_led2")
        led3 = Signal(name="user_led3")
        led4 = Signal(name="user_led4")
        leds = led0, led1, led2, led3, led4
        self.leds = LedChaser(pads=Cat(leds), sys_clk_freq=self.sys_clk_freq)
        self.submodules += self.leds

        # Wishbone DRAM interface
        wb_bus_dram_if = wishbone.Interface()
        wb_bus_dram_region = SoCRegion(origin=self.mem_map["main_ram"], size=0x20000000, mode="rw", cached=True)
        self.slaves["wb_bus_dram"] = (wb_bus_dram_if, wb_bus_dram_region)

        # Wishbone Controller interface
        wb_bus_ctrl_if = wishbone.Interface()
        wb_bus_ctrl_region = SoCRegion(origin=self.mem_map["dram_ctrl"], size=0x00010000, mode="rw", cached=False)
        self.slaves["wb_bus_ctrl"] = (wb_bus_ctrl_if, wb_bus_ctrl_region)

        # Wishbone interconnect
        self.create_interconnect(self.masters, self.slaves)
        for name, loc in sorted(self.irq.locs.items()):
            module = getattr(self, name)
            ev = None
            if hasattr(module, "ev"):
                ev = module.ev
            elif isinstance(module, EventManager):
                ev = module
            self.comb += self.cpu.interrupt[loc].eq(ev.irq)

        # I/O
        self.ios = set()
        self.ios.update([self.cd_sys.clk, self.cd_sys.rst])
        self.ios.update(leds)
        self.ios.update(self.uart_pads.flatten())
        self.ios.update(wb_bus_dram_if.flatten())
        self.ios.update(wb_bus_ctrl_if.flatten())

    def create_interconnect(self, masters, slaves):
        ic = WishboneRRInterconnect(
            addr_width=30, data_width=32, granularity=8, features={"bte", "cti", "err"}
        )

        for name, _ in masters.items():
            ic.add_master(name=name)
        for name, (_, mem_region) in slaves.items():
            ic.add_peripheral(name=name, addr=mem_region.origin, size=mem_region.size)

        self.submodules.interconnect = Amaranth2Migen(
            ic, self.platform, "wishbone_interconnect", self.build_dir
        )

        for name, master in masters.items():
            self.comb += master.connect(self.interconnect.interfaces[name])

        for name, (slave, _) in slaves.items():
            self.comb += self.interconnect.interfaces[name].connect(slave)

    def gen_csr_header(self):
        header = ""
        csr_regions = {}
        for csr_group, csr_list, _, _ in self.csrs.banks:
            offset = self.csr_addr_map[csr_group] * self.csr_paging
            csr_regions[csr_group] = SoCCSRRegion(
                origin=self.mem_map["csr"] + offset, busword=32, obj=csr_list
            )
        if csr_regions:
            header += export.get_csr_header(csr_regions, {}, self.mem_map["csr"])
            header += "#define UART_POLLING\n"
        return header

    def gen_soc_header(self):
        header = ""
        header += "#define CONFIG_CSR_DATA_WIDTH 32\n"
        header += '#define CONFIG_CPU_NOP "nop"\n'
        header += "#define CONFIG_CLOCK_FREQUENCY {}\n".format(int(self.sys_clk_freq))

        if self.irq.locs:
            header += '#define CONFIG_CPU_HAS_INTERRUPT\n'

        for irq_name, irq_loc in self.irq.locs.items():
            header += "#define {}_INTERRUPT {}\n".format(irq_name.upper(), irq_loc)

        return header

    def gen_mem_header(self):
        header = ""
        if self.mem_regions:
            header += export.get_mem_header(self.mem_regions)
        return header

    def write_headers(self):
        header_path = f"{self.build_dir}/generated"
        to_generate = {
            f"{header_path}/csr.h": self.gen_csr_header,
            f"{header_path}/soc.h": self.gen_soc_header,
            f"{header_path}/mem.h": self.gen_mem_header,
        }

        try:
            os.makedirs(header_path)
        except FileExistsError:
            if not os.path.isdir(header_path):
                raise

        for path, gen_f in to_generate.items():
            with open(path, "w") as file:
                file.write(gen_f())

    def add_memory(self, origin, size, read_only=False, init=[], name=None):
        bus = wishbone.Interface()
        self.submodules += wishbone.SRAM(size, bus=bus, read_only=read_only, init=init, name=name)
        mem_region = SoCRegion(origin=origin, size=size)
        self.slaves[name] = (bus, mem_region)


def main():
    parser = argparse.ArgumentParser(prog="SoC generator")
    parser.add_argument(
        "--headers",
        action="store_true",
        help="Generate headers required for compiling firmware",
    )
    parser.add_argument(
        "--build-dir",
        action="store",
        default="build/",
        help="Directory to write build files to",
    )

    group = parser.add_mutually_exclusive_group()
    group.add_argument(
        "--bitstream",
        action="store_true",
        help="Generate verilog sources and bitstream (invokes vivado)",
    )

    args = parser.parse_args()

    platform = Platform(device="xc7k70tfbg484-3")
    soc = LPDDR4IntegrationSoC(platform, args.build_dir)
    if args.bitstream:
        platform.build(soc, ios=soc.ios, build_dir=args.build_dir, build_name="lpddr4_soc", run=False)
    else:
        # Workaround - because litex does os.chdir in platform.build(), we also have to change
        # the working directory to be consistent (this is important for internal modules of
        # the SoC that might also generate verilog)
        os.chdir(args.build_dir)
        platform.get_verilog(soc, ios=soc.ios, build_name="lpddr4_soc").write("lpddr4_soc.v")
    if args.headers:
        soc.write_headers()


if __name__ == "__main__":
    main()
