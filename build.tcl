# read design sources (add one line for each file)
read_verilog "build/dram_phy/gateware/dram_phy.v"
read_verilog "build/dram_ctrl/gateware/dram_ctrl.v"
read_verilog "build/lpddr4_soc/wishbone_interconnect.v"
read_verilog "build/lpddr4_soc/lpddr4_soc.v"
read_verilog "build/phy_core_inst.v"
read_verilog "build/dram_ctrl_inst.v"
read_verilog "build/lpddr4_soc_inst.v"
read_verilog "third_party/pythondata-cpu-vexriscv/pythondata_cpu_vexriscv/verilog/VexRiscv_Min.v"
read_verilog "build/project_top.v"

# Add constraints
read_xdc "lpddr4-test-board.xdc"

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

# Bitstream generation
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
write_bitstream -force "build/top.bit"
write_cfgmem -force -format bin -interface spix4 -size 16 -loadbit "up 0x0 build/top.bit" -file "build/top.bin"
