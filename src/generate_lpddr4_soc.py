import argparse
import os

from soc_generator.scripts.generate_soc import SoC
from litex_boards.platforms.antmicro_lpddr4_test_board import Platform
from litex_boards.targets import antmicro_lpddr4_test_board

from soc_generator.gen.amaranth_wrapper import Amaranth2Migen
from soc_generator.gen.wishbone_interconnect import WishboneRRInterconnect
from litex.soc.cores.uart import UART, UARTPHY
from litex.soc.integration.soc import SoCRegion
from litex.soc.interconnect import wishbone
from migen import *


class LPDDR4IntegrationSoC(SoC):
    def __init__(self, platform, sim, build_dir):
        uart_type = "uartbone"

        sys_rst = Signal(name="sys_rst")
        super().__init__(platform, sim, uart_type, build_dir)

        # Remove not needed components
        # self.interconnect = None

        self.uart_pads = self.platform.request("serial", 0)
        uart_kwargs = {
            "tx_fifo_depth": 16,
            "rx_fifo_depth": 16,
        }

        self.submodules.uart_phy = uart_phy = UARTPHY(self.uart_pads, clk_freq=50e6, baudrate=115200)
        self.ios.update(self.uart_pads.flatten())
        self.submodules.uart = UART(uart_phy, **uart_kwargs)

        # lpddr4_wb_ic = WishboneRRInterconnect(
        #     addr_width=30, data_width=32, granularity=8, features={"bte", "cti", "err"}
        # )
        # lpddr4_wb_ic.add_master(name=uart_type)

        # wb_bus_dram = wishbone.Interface()
        # lpddr4_wb_ic.add_peripheral(name="wb_dram", addr=0x40000000, size=((512 * 1024 * 1024)>>1))

        # wb_bus_ctrl = wishbone.Interface()
        # lpddr4_wb_ic.add_peripheral(name="wb_ctrl", addr=0x83000000, size=0x00010000)

        # self.submodules.lpddr4_wb_ic = Amaranth2Migen(
        #     lpddr4_wb_ic, self.platform, "lpddr4_wb_ic", self.build_dir
        # )

        # self.comb += self.uart.wishbone.connect(self.lpddr4_wb_ic.interfaces[uart_type])
        # self.comb += self.lpddr4_wb_ic.interfaces["wb_dram"].connect(wb_bus_dram)
        # self.comb += self.lpddr4_wb_ic.interfaces["wb_ctrl"].connect(wb_bus_ctrl)

        wb_bus_dram_if = wishbone.Interface()
        wb_bus_dram_region = SoCRegion(origin=0x40000000, size=((512 * 1024 * 1024)>>1))
        self.slaves["wb_bus_dram"] = (wb_bus_dram_if, wb_bus_dram_region)

        wb_bus_ctrl_if = wishbone.Interface()
        wb_bus_ctrl_region = SoCRegion(origin=0x83000000, size=0x00010000)
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
    # Workaround - because litex does os.chdir in platform.build(), we also have to change
    # the working directory to be consistent (this is important for internal modules of
    # the SoC that might also generate verilog)
    os.chdir(args.build_dir)
    platform.get_verilog(soc, ios=soc.ios).write("lpddr4_soc.v")
    if args.bitstream:
        platform.build(soc, build_dir=args.build_dir, build_name="lpddr4_soc", run=False)
    if args.headers:
        soc.write_headers()


if __name__ == "__main__":
    main()
