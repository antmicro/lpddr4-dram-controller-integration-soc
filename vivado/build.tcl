# Copyright (C) 2023-2024 Antmicro
# SPDX-License-Identifier: Apache-2.0

# This file is assumed to be run in Vivado from a build directory

# Read design sources
read_verilog "dram_phy/gateware/dram_phy.v"
read_verilog "dram_ctrl/gateware/dram_ctrl.v"
read_verilog "lpddr4_soc/wishbone_interconnect.v"
read_verilog "lpddr4_soc/lpddr4_soc.v"
read_verilog "phy_core_inst.v"
read_verilog "dram_ctrl_inst.v"
read_verilog "lpddr4_soc_inst.v"
read_verilog "../third_party/pythondata-cpu-vexriscv/pythondata_cpu_vexriscv/verilog/VexRiscv_Full.v"
read_verilog "project_top.v"

# Add constraints
read_xdc "../vivado/lpddr4-test-board.xdc"

# Synthesis
synth_design -top "project_top" -part "xc7k70tfbg484-3"

# Synthesis report
report_timing_summary -file lpddr4_soc_timing_synth.rpt
report_utilization -hierarchical -file lpddr4_soc_utilization_hierarchical_synth.rpt
report_utilization -file lpddr4_soc_utilization_synth.rpt

# Optimize design
opt_design

# Placement
place_design

# Placement report
report_utilization -hierarchical -file lpddr4_soc_utilization_hierarchical_place.rpt
report_utilization -file lpddr4_soc_utilization_place.rpt
report_io -file lpddr4_soc_io.rpt
report_control_sets -verbose -file lpddr4_soc_control_sets.rpt
report_clock_utilization -file lpddr4_soc_clock_utilization.rpt

# Routing
route_design

# Routing report
report_timing_summary -no_header -no_detailed_paths
report_route_status -file lpddr4_soc_route_status.rpt
report_drc -file lpddr4_soc_drc.rpt
report_timing_summary -datasheet -max_paths 10 -file lpddr4_soc_timing.rpt
report_power -file lpddr4_soc_power.rpt
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
write_checkpoint -force "imp.dcp"

# Bitstream generation
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
write_bitstream -force "top.bit"
write_cfgmem -force -format bin -interface spix4 -size 16 -loadbit "up 0x0 top.bit" -file "top.bin"
