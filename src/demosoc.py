#!/usr/bin/env python3

# Copyright (c) 2023 Antmicro
# SPDX-License-Identifier: BSD-2-Clause

from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer

from litex.gen import *

from litex_boards.platforms import antmicro_lpddr4_test_board
from litex.build.generic_platform import GenericPlatform, Pins, Subsignal
#from litex.build.generic_toolchain import GenericToolchain

from litex.soc.cores.clock import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.integration.soc import SoCRegion, SoCIORegion
from litex.soc.cores.led import LedChaser
from litex.soc.cores.uart import UARTPHY
from litex.soc.cores.uart import UART, UARTBone

from litex.soc.interconnect.csr import *
from litex.soc.interconnect import wishbone


# BaseSoC ----------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq=50e6, phy_inst_name="phy",
        integrated_rom_size    = 0x20000,
        with_led_chaser        = False,
        **kwargs):

        # Platform, IOs --------------------------------------------------------
        common_ios = [
            ("clk", 0, Pins(1)),
            ("rst", 0, Pins(1)),
        ]
        platform = antmicro_lpddr4_test_board.Platform()
        platform.add_extension(common_ios)

        self.cd_sys = ClockDomain()
        self.comb += [
            self.cd_sys.clk.eq(platform.request("clk")),
            self.cd_sys.rst.eq(platform.request("rst")),
        ]

        # SoCCore --------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq, ident="TRISTAN / Antmicro LPDDR4 Test SoC",
                         cpu_type="vexriscv", cpu_variant="minimal", with_uart=False,
                         integrated_rom_size=integrated_rom_size, **kwargs)

        # UART -------------------------------------------------------------------------------------

        uart_pads   = self.platform.request("serial", 0)
        uart_kwargs = {
            "tx_fifo_depth": 16,
            "rx_fifo_depth": 16,
        }

        self.uart_phy = uart_phy = UARTPHY(uart_pads, clk_freq=self.sys_clk_freq, baudrate=kwargs.get("uart_baudrate", 115200))
        self.uart = UART(uart_phy, **uart_kwargs)

        if self.irq.enabled:
            self.irq.add("uart", use_loc_if_exists=True)
        else:
            self.add_constant("UART_POLLING")

        # Expose system bus ----------------------------------------------------

        # DRAM data bus
        self.bus.add_region(name="dram", region=SoCRegion(
            origin  = 0x40000000,
            size    = 512 * 1024 * 1024,
            mode    = "rw",
            cached  = True,
        ))
        wb_bus_dram = wishbone.Interface()
        self.bus.add_slave(name="dram", slave=wb_bus_dram)

        platform.add_extension(wb_bus_dram.get_ios("wb_dram"))
        wb_pads = platform.request("wb_dram")

        self.comb += wb_bus_dram.connect_to_pads(wb_pads, mode="master")

        # DRAM contol bus
        self.bus.add_region(name="ctrl", region=SoCRegion(
            origin  = 0x83000000,
            size    = 0x00010000,
            mode    = "rw",
            cached  = False,
        ))
        wb_bus_ctrl = wishbone.Interface()
        self.bus.add_slave(name="ctrl", slave=wb_bus_ctrl)

        platform.add_extension(wb_bus_ctrl.get_ios("wb_ctrl"))
        wb_pads = platform.request("wb_ctrl")

        self.comb += wb_bus_ctrl.connect_to_pads(wb_pads, mode="master")

        self.add_constant("MEMTEST_BUS_DEBUG")

        # UARTbone  -------------------------------------------------------------------------------

        uart_pads = self.platform.request("serial", 1)

        self.uartbone_phy = uartbone_phy = UARTPHY(uart_pads, clk_freq=self.sys_clk_freq, baudrate=kwargs.get("uart_baudrate", 115200))
        self.uartbone = UARTBone(uartbone_phy, clk_freq=self.sys_clk_freq)
        self.bus.add_master(name="uartbone", master=self.uartbone.wishbone)

# Build --------------------------------------------------------------------------------------------

def main():
    soc = BaseSoC(sys_clk_freq = 75e6)
    builder = Builder(soc, compile_software=True, compile_gateware=False, csr_csv="csr.csv")
    builder.build()

if __name__ == "__main__":
    main()
