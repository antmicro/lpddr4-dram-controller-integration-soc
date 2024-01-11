import argparse
import os

from soc_generator.scripts.generate_soc import SoC
from litex_boards.platforms.antmicro_lpddr4_test_board import Platform
from litex_boards.targets import antmicro_lpddr4_test_board

from litex.soc.cores.uart import UARTBone, UARTPHY
from litex.soc.integration.builder import *
from litex.soc.integration.soc import SoCRegion
from litex.soc.interconnect import wishbone
from litex.soc.cores.led import LedChaser
from migen import *


class LPDDR4IntegrationSoC(SoC):
    def __init__(self, platform, sim, build_dir):
        sys_clk_freq = 50e6
        uart_type = "uart"

        sys_rst = Signal(name="sys_rst")
        super().__init__(platform, sim, uart_type, build_dir)

        led0 = Signal(name="user_led0")
        led1 = Signal(name="user_led1")
        led2 = Signal(name="user_led2")
        led3 = Signal(name="user_led3")
        led4 = Signal(name="user_led4")
        leds = led0, led1, led2, led3, led4
        self.ios.update((leds))
        self.leds = LedChaser(pads=Cat(leds), sys_clk_freq=sys_clk_freq)
        self.submodules += self.leds

        self.uartbone_pads = self.platform.request("serial", 0)

        self.submodules.uartbone_phy = UARTPHY(self.uartbone_pads, clk_freq=sys_clk_freq, baudrate=115200)
        self.ios.update(self.uartbone_pads.flatten())
        self.submodules.uartbone = UARTBone(phy=self.uartbone_phy, clk_freq=sys_clk_freq)
        self.masters["uartbone"] = self.uartbone.wishbone

        wb_bus_dram_if = wishbone.Interface(adr_width=32)
        wb_bus_dram_region = SoCRegion(origin=0x40000000, size=0x20000000, mode="rw", cached=True)
        self.slaves["wb_bus_dram"] = (wb_bus_dram_if, wb_bus_dram_region)

        wb_bus_ctrl_if = wishbone.Interface(adr_width=32)
        wb_bus_ctrl_region = SoCRegion(origin=0x83000000, size=0x00010000, mode="rw", cached=False)
        self.slaves["wb_bus_ctrl"] = (wb_bus_ctrl_if, wb_bus_ctrl_region)

        self.create_interconnect(self.masters, self.slaves)

        self.crg.pll.clkin = Signal(name="clk")

        self.comb += self.crg.pll.reset.eq(~sys_rst)
        self.ios.update([self.crg.pll.clkin, self.crg.cd_sys.clk, sys_rst])
        self.ios.update(wb_bus_dram_if.flatten())
        self.ios.update(wb_bus_ctrl_if.flatten())


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
    group.add_argument(
        "--sim",
        action="store_true",
        help="Generate build files appropriate for use in a verilator \
            simulation (controls behavior of other generation options)",
    )

    args = parser.parse_args()

    platform = Platform(device="xc7k70tfbg484-3")
    soc = LPDDR4IntegrationSoC(platform, args.sim, args.build_dir)
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
