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

# read constraints
read_xdc "lpddr4-test-board.xdc"

# synth
synth_design -top "project_top" -part "xc7k70tfbg484-1"

# place and route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force "build/top.bit"
