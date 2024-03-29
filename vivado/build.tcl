# Copyright (C) 2023-2024 Antmicro
# SPDX-License-Identifier: Apache-2.0

# This file is assumed to be run in Vivado from a build directory

# ===

# Process .f and return filelist
proc process_filelist {filelist_path files_dir} {
    set filelist    [list]
    set fd_filelist [open "${filelist_path}" r]
    while {[gets $fd_filelist line] >= 0} {
        if {![regexp {^(\s*#.*|^$)} $line]} {
            set filepath "[file normalize "${files_dir}/${line}"]"
            if {![regexp {^-I} $line]} {
            if {![file exists $filepath]} {
                puts "ERROR: File not found '$filepath'"
                exit 2
            } else {
                lappend filelist $filepath
                puts $filepath
            }}
        }
    }
    close $fd_filelist
    return $filelist
}

proc process_filelist_includes {filelist_path files_dir} {
    set filelist    [list]
    set fd_filelist [open "${filelist_path}" r]
    while {[gets $fd_filelist line] >= 0} {
        if {![regexp {^(\s*#.*|^$)} $line]} {
            if {[regexp {^-I} $line]} {
                set line [string map {"-I" ""} $line ]
                set filepath "[file normalize "${files_dir}/${line}"]"
                if {![file exists $filepath]} {
                    puts "ERROR: File not found '$filepath'"
                    exit 2
                } else {
                    lappend filelist $filepath
                    puts $filepath
                }
            }
        }
    }
    close $fd_filelist
    return $filelist
}

set dram_phy_files [process_filelist "../third_party/tristan-dram-phy/build/filelist.f" ""]
set dram_phy_includes [process_filelist_includes "../third_party/tristan-dram-phy/build/filelist.f" ""]
set_property include_dirs $dram_phy_includes [current_fileset]

foreach {file} $dram_phy_files {
    read_verilog $file
}

# ===

# Read design sources
read_verilog "../rtl/dram_phy_wrapper.sv"
read_verilog "../rtl/dram_phy.v"
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

# Constrain PHY core
# constrain PHY core
set phy_pblock "phy"
set phy_area   {CLOCKREGION_X1Y1}

create_pblock $phy_pblock
add_cells_to_pblock -quiet [get_pblocks $phy_pblock] [get_cells -quiet -hier -leaf u_phy_core -filter {REF_NAME =~ "LUT*"}]
add_cells_to_pblock -quiet [get_pblocks $phy_pblock] [get_cells -quiet -hier -leaf u_phy_core -filter {REF_NAME =~ "FD*"}]
add_cells_to_pblock -quiet [get_pblocks $phy_pblock] [get_cells -quiet -hier -leaf u_phy_core -filter {REF_NAME =~ "LD*"}]
resize_pblock [get_pblocks $phy_pblock] -add $phy_area

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
