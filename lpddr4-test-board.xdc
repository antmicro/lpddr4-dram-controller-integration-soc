################################################################################
# IO constraints
################################################################################
# clk100:0
set_property LOC L19 [get_ports {clk100}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk100}]

# serial:0.tx
set_property LOC AB18 [get_ports {serial0_tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {serial0_tx}]

# serial:0.rx
set_property LOC AA18 [get_ports {serial0_rx}]
set_property IOSTANDARD LVCMOS33 [get_ports {serial0_rx}]

# serial:1.tx
set_property LOC AA20 [get_ports {serial1_tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {serial1_tx}]

# serial:1.rx
set_property LOC AB20 [get_ports {serial1_rx}]
set_property IOSTANDARD LVCMOS33 [get_ports {serial1_rx}]

# serial:2.tx
set_property LOC W20 [get_ports {serial2_tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {serial2_tx}]

# serial:2.rx
set_property LOC W22 [get_ports {serial2_rx}]
set_property IOSTANDARD LVCMOS33 [get_ports {serial2_rx}]

# lpddr4:0.clk_p
set_property LOC Y3 [get_ports {lpddr4_clk_p}]
set_property SLEW FAST [get_ports {lpddr4_clk_p}]
set_property IOSTANDARD DIFF_SSTL12 [get_ports {lpddr4_clk_p}]

# lpddr4:0.clk_n
set_property LOC Y2 [get_ports {lpddr4_clk_n}]
set_property SLEW FAST [get_ports {lpddr4_clk_n}]
set_property IOSTANDARD DIFF_SSTL12 [get_ports {lpddr4_clk_n}]

# lpddr4:0.cke
set_property LOC N4 [get_ports {lpddr4_cke}]
set_property SLEW FAST [get_ports {lpddr4_cke}]
set_property IOSTANDARD SSTL12 [get_ports {lpddr4_cke}]

# lpddr4:0.odt
set_property LOC N5 [get_ports {lpddr4_odt}]
set_property SLEW FAST [get_ports {lpddr4_odt}]
set_property IOSTANDARD SSTL12 [get_ports {lpddr4_odt}]

# lpddr4:0.reset_n
set_property LOC P4 [get_ports {lpddr4_reset_n}]
set_property SLEW FAST [get_ports {lpddr4_reset_n}]
set_property IOSTANDARD SSTL12 [get_ports {lpddr4_reset_n}]

# lpddr4:0.cs
set_property LOC N3 [get_ports {lpddr4_cs}]
set_property SLEW FAST [get_ports {lpddr4_cs}]
set_property IOSTANDARD SSTL12 [get_ports {lpddr4_cs}]

# lpddr4:0.ca
set_property LOC L3 [get_ports {lpddr4_ca[0]}]
set_property SLEW FAST [get_ports {lpddr4_ca[0]}]
set_property IOSTANDARD SSTL12 [get_ports {lpddr4_ca[0]}]

# lpddr4:0.ca
set_property LOC L5 [get_ports {lpddr4_ca[1]}]
set_property SLEW FAST [get_ports {lpddr4_ca[1]}]
set_property IOSTANDARD SSTL12 [get_ports {lpddr4_ca[1]}]

# lpddr4:0.ca
set_property LOC AA4 [get_ports {lpddr4_ca[2]}]
set_property SLEW FAST [get_ports {lpddr4_ca[2]}]
set_property IOSTANDARD SSTL12 [get_ports {lpddr4_ca[2]}]

# lpddr4:0.ca
set_property LOC AA3 [get_ports {lpddr4_ca[3]}]
set_property SLEW FAST [get_ports {lpddr4_ca[3]}]
set_property IOSTANDARD SSTL12 [get_ports {lpddr4_ca[3]}]

# lpddr4:0.ca
set_property LOC AB3 [get_ports {lpddr4_ca[4]}]
set_property SLEW FAST [get_ports {lpddr4_ca[4]}]
set_property IOSTANDARD SSTL12 [get_ports {lpddr4_ca[4]}]

# lpddr4:0.ca
set_property LOC AB2 [get_ports {lpddr4_ca[5]}]
set_property SLEW FAST [get_ports {lpddr4_ca[5]}]
set_property IOSTANDARD SSTL12 [get_ports {lpddr4_ca[5]}]

# lpddr4:0.dq
set_property LOC L1 [get_ports {lpddr4_dq[0]}]
set_property SLEW FAST [get_ports {lpddr4_dq[0]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[0]}]

# lpddr4:0.dq
set_property LOC K2 [get_ports {lpddr4_dq[1]}]
set_property SLEW FAST [get_ports {lpddr4_dq[1]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[1]}]

# lpddr4:0.dq
set_property LOC K1 [get_ports {lpddr4_dq[2]}]
set_property SLEW FAST [get_ports {lpddr4_dq[2]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[2]}]

# lpddr4:0.dq
set_property LOC K3 [get_ports {lpddr4_dq[3]}]
set_property SLEW FAST [get_ports {lpddr4_dq[3]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[3]}]

# lpddr4:0.dq
set_property LOC R1 [get_ports {lpddr4_dq[4]}]
set_property SLEW FAST [get_ports {lpddr4_dq[4]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[4]}]

# lpddr4:0.dq
set_property LOC P2 [get_ports {lpddr4_dq[5]}]
set_property SLEW FAST [get_ports {lpddr4_dq[5]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[5]}]

# lpddr4:0.dq
set_property LOC P1 [get_ports {lpddr4_dq[6]}]
set_property SLEW FAST [get_ports {lpddr4_dq[6]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[6]}]

# lpddr4:0.dq
set_property LOC N2 [get_ports {lpddr4_dq[7]}]
set_property SLEW FAST [get_ports {lpddr4_dq[7]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[7]}]

# lpddr4:0.dq
set_property LOC W2 [get_ports {lpddr4_dq[8]}]
set_property SLEW FAST [get_ports {lpddr4_dq[8]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[8]}]

# lpddr4:0.dq
set_property LOC Y1 [get_ports {lpddr4_dq[9]}]
set_property SLEW FAST [get_ports {lpddr4_dq[9]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[9]}]

# lpddr4:0.dq
set_property LOC AA1 [get_ports {lpddr4_dq[10]}]
set_property SLEW FAST [get_ports {lpddr4_dq[10]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[10]}]

# lpddr4:0.dq
set_property LOC AB1 [get_ports {lpddr4_dq[11]}]
set_property SLEW FAST [get_ports {lpddr4_dq[11]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[11]}]

# lpddr4:0.dq
set_property LOC R2 [get_ports {lpddr4_dq[12]}]
set_property SLEW FAST [get_ports {lpddr4_dq[12]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[12]}]

# lpddr4:0.dq
set_property LOC T1 [get_ports {lpddr4_dq[13]}]
set_property SLEW FAST [get_ports {lpddr4_dq[13]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[13]}]

# lpddr4:0.dq
set_property LOC T3 [get_ports {lpddr4_dq[14]}]
set_property SLEW FAST [get_ports {lpddr4_dq[14]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[14]}]

# lpddr4:0.dq
set_property LOC U1 [get_ports {lpddr4_dq[15]}]
set_property SLEW FAST [get_ports {lpddr4_dq[15]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dq[15]}]

# lpddr4:0.dqs_p
set_property LOC M2 [get_ports {lpddr4_dqs_p[0]}]
set_property SLEW FAST [get_ports {lpddr4_dqs_p[0]}]
set_property IOSTANDARD DIFF_SSTL12 [get_ports {lpddr4_dqs_p[0]}]

# lpddr4:0.dqs_p
set_property LOC U2 [get_ports {lpddr4_dqs_p[1]}]
set_property SLEW FAST [get_ports {lpddr4_dqs_p[1]}]
set_property IOSTANDARD DIFF_SSTL12 [get_ports {lpddr4_dqs_p[1]}]

# lpddr4:0.dqs_n
set_property LOC M1 [get_ports {lpddr4_dqs_n[0]}]
set_property SLEW FAST [get_ports {lpddr4_dqs_n[0]}]
set_property IOSTANDARD DIFF_SSTL12 [get_ports {lpddr4_dqs_n[0]}]

# lpddr4:0.dqs_n
set_property LOC V2 [get_ports {lpddr4_dqs_n[1]}]
set_property SLEW FAST [get_ports {lpddr4_dqs_n[1]}]
set_property IOSTANDARD DIFF_SSTL12 [get_ports {lpddr4_dqs_n[1]}]

# lpddr4:0.dmi
set_property LOC M3 [get_ports {lpddr4_dmi[0]}]
set_property SLEW FAST [get_ports {lpddr4_dmi[0]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dmi[0]}]

# lpddr4:0.dmi
set_property LOC W1 [get_ports {lpddr4_dmi[1]}]
set_property SLEW FAST [get_ports {lpddr4_dmi[1]}]
set_property IOSTANDARD SSTL12_T_DCI [get_ports {lpddr4_dmi[1]}]

# user_led:0
set_property LOC F8 [get_ports {user_led0}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_led0}]

# user_led:1
set_property LOC C8 [get_ports {user_led1}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_led1}]

# user_led:2
set_property LOC A8 [get_ports {user_led2}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_led2}]

# user_led:3
set_property LOC D9 [get_ports {user_led3}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_led3}]

# user_led:4
set_property LOC F9 [get_ports {user_led4}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_led4}]

# user_btn:0
set_property LOC E8 [get_ports {user_btn0}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_btn0}]

# user_btn:1
# set_property LOC B8 [get_ports {user_btn1}]
# set_property IOSTANDARD LVCMOS33 [get_ports {user_btn1}]

# user_btn:2
# set_property LOC C9 [get_ports {user_btn2}]
# set_property IOSTANDARD LVCMOS33 [get_ports {user_btn2}]

# user_btn:3
# set_property LOC E9 [get_ports {user_btn3}]
# set_property IOSTANDARD LVCMOS33 [get_ports {user_btn3}]

################################################################################
# Design constraints
################################################################################

################################################################################
# Clock constraints
################################################################################


create_clock -name clk100 -period 10.0 [get_ports clk100]

################################################################################
# False path constraints
################################################################################


set_false_path -quiet -to [get_cells -hierarchical -filter { mr_ff == TRUE }]

set_false_path -quiet -to [get_pins -filter {REF_PIN_NAME == PRE} -of_objects [get_cells -hierarchical -filter {ars_ff1 == TRUE || ars_ff2 == TRUE}]]

set_max_delay 2 -quiet -from [get_pins -filter {REF_PIN_NAME == C} -of_objects [get_cells -hierarchical -filter {ars_ff1 == TRUE}]] -to [get_pins -filter {REF_PIN_NAME == D} -of_objects [get_cells -hierarchical -filter {ars_ff2 == TRUE}]]

set_max_delay -quiet -through [get_pins -filter {REF_PIN_NAME == Q} -of_objects [get_cells -hierarchical -filter {slow_ff == TRUE}]] 250

set_max_delay -quiet -to [get_pins -filter {REF_PIN_NAME == D} -of_objects [get_cells -hierarchical -filter {slow_in == TRUE}]] 250
