#!/usr/bin/env python3
"""
This script performs DRAM controller configuration and initialization sequence
for Lattice ECP5 VIP board.

It requires EtherBone/UARTBone to be present in the RTL design.
"""

import argparse
import time

from litex import RemoteClient

# ==============================================================================


def dram_init(wb):

    print("Initializing DRAM...")

    def dfi_command(cmd):
        print(" DRAM cmd 0x{:02X}".format(cmd))
        wb.regs.dram_ctrl_dfii_pi0_command.write(cmd)
        wb.regs.dram_ctrl_dfii_pi0_command_issue.write(1)

    print(" Setting timings...")
    wb.regs.dram_ctrl_controller_tRP.write   (  2)
    wb.regs.dram_ctrl_controller_tRCD.write  (  2)
    wb.regs.dram_ctrl_controller_tWR.write   (  2)
    wb.regs.dram_ctrl_controller_tWTR.write  (  2)
    wb.regs.dram_ctrl_controller_tREFI.write (196)
    wb.regs.dram_ctrl_controller_tRFC.write  ( 10)
    wb.regs.dram_ctrl_controller_tFAW.write  (  3)
    wb.regs.dram_ctrl_controller_tCCD.write  (  4)
    wb.regs.dram_ctrl_controller_tRRD.write  (  2)
    wb.regs.dram_ctrl_controller_tRC.write   (  5)
    wb.regs.dram_ctrl_controller_tRAS.write  (  3)
    #wb.regs.dram_ctrl_controller_tZQCS.write ( 32)

    print(" SW control...")
    wb.regs.dram_ctrl_dfii_control.write(0xE) # RST | CKE | ODT

    print(" DRAM chip reset...")
    wb.regs.ddrphy_rst.write(1)
    time.sleep(0.1)
    wb.regs.ddrphy_rst.write(0)
    time.sleep(0.1)

    print(" SW control (#2)...")
    wb.regs.dram_ctrl_dfii_control.write(0x8) # RST

    dfi_command(0x0) # To set CS high

    print(" PHY training...")
    wb.regs.dram_ctrl_controller_phy_ctl.write(1)
    while True:
        res = wb.regs.dram_ctrl_controller_phy_sts.read()
        if res: break

    print(" HW control...")
    wb.regs.dram_ctrl_dfii_control.write(0x1)

    print(" Setting status regs...")
    wb.regs.ddrctrl_init_done.write(1)
    wb.regs.ddrctrl_init_error.write(0)

    print("DRAM initalized.")

# ==============================================================================


def main():

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--csr-csv",
        type=str,
        required=True,
        help="Path to csr.csv",
    )

    args = parser.parse_args()

    # Connect
    print("Connecting...")
    wb = RemoteClient(csr_csv=args.csr_csv)
    wb.open()

    # Initialize DRAM
    dram_init(wb)


if __name__ == "__main__":
    main()
