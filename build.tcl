# read design sources (add one line for each file)
read_verilog "build/dram_phy/gateware/dram_phy.v"
read_verilog "build/dram_ctrl/gateware/dram_ctrl.v"
#read_verilog "build/dram_phy/gateware/dram_phy_mem.init"
#read_verilog "build/dram_phy/gateware/dram_phy_sram.init"
#read_verilog "build/dram_phy/gateware/dram_phy_rom.init"
read_verilog "third_party/pythondata-cpu-vexriscv/pythondata_cpu_vexriscv/verilog/VexRiscv_Min.v"
read_verilog "rtl/top.v"

# read constraints
read_xdc "lpddr4-test-board.xdc"

# synth
synth_design -top "top" -part "xc7k70tfbg484-1"

# place and route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force "build/top.bit"
