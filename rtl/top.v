`timescale 1ns / 1ps
`default_nettype none

module top (
    (* dont_touch = "true" *)
    input  wire          clk100,
    output wire          serial0_tx,
    input  wire          serial0_rx,
    output wire          serial1_tx,
    input  wire          serial1_rx,
    output wire          lpddr4_clk_p,
    output wire          lpddr4_clk_n,
    output wire          lpddr4_cke,
    output wire          lpddr4_odt,
    output wire          lpddr4_reset_n,
    output wire          lpddr4_cs,
    output wire    [5:0] lpddr4_ca,
    inout  wire   [15:0] lpddr4_dq,
    inout  wire    [1:0] lpddr4_dqs_p,
    inout  wire    [1:0] lpddr4_dqs_n,
    inout  wire    [1:0] lpddr4_dmi,
    output wire          user_led0,
    output wire          user_led1,
    output wire          user_led2,
    output wire          user_led3,
    output wire          user_led4,
    input  wire          user_btn0,
    input  wire          user_btn1,
    input  wire          user_btn2,
    input  wire          user_btn3
);

wire sys_clk;
wire sys_rst;

wire [16:0] dfi_address_p0;
wire  [5:0] dfi_bank_p0;
wire [31:0] dfi_wrdata_p0;
wire  [3:0] dfi_wrdata_mask_p0;
wire [16:0] dfi_address_p1;
wire  [5:0] dfi_bank_p1;
wire [31:0] dfi_wrdata_p1;
wire  [3:0] dfi_wrdata_mask_p1;
wire [16:0] dfi_address_p2;
wire  [5:0] dfi_bank_p2;
wire [31:0] dfi_wrdata_p2;
wire  [3:0] dfi_wrdata_mask_p2;
wire [16:0] dfi_address_p3;
wire  [5:0] dfi_bank_p3;
wire [31:0] dfi_wrdata_p3;
wire  [3:0] dfi_wrdata_mask_p3;
wire [16:0] dfi_address_p4;
wire  [5:0] dfi_bank_p4;
wire [31:0] dfi_wrdata_p4;
wire  [3:0] dfi_wrdata_mask_p4;
wire [16:0] dfi_address_p5;
wire  [5:0] dfi_bank_p5;
wire [31:0] dfi_wrdata_p5;
wire  [3:0] dfi_wrdata_mask_p5;
wire [16:0] dfi_address_p6;
wire  [5:0] dfi_bank_p6;
wire [31:0] dfi_wrdata_p6;
wire  [3:0] dfi_wrdata_mask_p6;
wire [16:0] dfi_address_p7;
wire  [5:0] dfi_bank_p7;
wire [31:0] dfi_wrdata_p7;
wire  [3:0] dfi_wrdata_mask_p7;

wire dfi_cke_p0;
wire dfi_reset_n_p0;
wire dfi_mode_2n_p0;
wire dfi_alert_n_w0;
wire dfi_cas_n_p0;
wire dfi_cs_n_p0;
wire dfi_ras_n_p0;
wire dfi_act_n_p0;
wire dfi_odt_p0;
wire dfi_we_n_p0;
wire dfi_wrdata_en_p0;
wire dfi_rddata_en_p0;
wire dfi_rddata_valid_w0;

wire dfi_cke_p1;
wire dfi_reset_n_p1;
wire dfi_mode_2n_p1;
wire dfi_alert_n_w1;
wire dfi_cas_n_p1;
wire dfi_cs_n_p1;
wire dfi_ras_n_p1;
wire dfi_act_n_p1;
wire dfi_odt_p1;
wire dfi_we_n_p1;
wire dfi_wrdata_en_p1;
wire dfi_rddata_en_p1;
wire dfi_rddata_valid_w1;

wire dfi_cke_p2;
wire dfi_reset_n_p2;
wire dfi_mode_2n_p2;
wire dfi_alert_n_w2;
wire dfi_cas_n_p2;
wire dfi_cs_n_p2;
wire dfi_ras_n_p2;
wire dfi_act_n_p2;
wire dfi_odt_p2;
wire dfi_we_n_p2;
wire dfi_wrdata_en_p2;
wire dfi_rddata_en_p2;
wire dfi_rddata_valid_w2;

wire dfi_cke_p3;
wire dfi_reset_n_p3;
wire dfi_mode_2n_p3;
wire dfi_alert_n_w3;
wire dfi_cas_n_p3;
wire dfi_cs_n_p3;
wire dfi_ras_n_p3;
wire dfi_act_n_p3;
wire dfi_odt_p3;
wire dfi_we_n_p3;
wire dfi_wrdata_en_p3;
wire dfi_rddata_en_p3;
wire dfi_rddata_valid_w3;

wire dfi_cke_p4;
wire dfi_reset_n_p4;
wire dfi_mode_2n_p4;
wire dfi_alert_n_w4;
wire dfi_cas_n_p4;
wire dfi_cs_n_p4;
wire dfi_ras_n_p4;
wire dfi_act_n_p4;
wire dfi_odt_p4;
wire dfi_we_n_p4;
wire dfi_wrdata_en_p4;
wire dfi_rddata_en_p4;
wire dfi_rddata_valid_w4;

wire dfi_cke_p5;
wire dfi_reset_n_p5;
wire dfi_mode_2n_p5;
wire dfi_alert_n_w5;
wire dfi_cas_n_p5;
wire dfi_cs_n_p5;
wire dfi_ras_n_p5;
wire dfi_act_n_p5;
wire dfi_odt_p5;
wire dfi_we_n_p5;
wire dfi_wrdata_en_p5;
wire dfi_rddata_en_p5;
wire dfi_rddata_valid_w5;

wire dfi_cke_p6;
wire dfi_reset_n_p6;
wire dfi_mode_2n_p6;
wire dfi_alert_n_w6;
wire dfi_cas_n_p6;
wire dfi_cs_n_p6;
wire dfi_ras_n_p6;
wire dfi_act_n_p6;
wire dfi_odt_p6;
wire dfi_we_n_p6;
wire dfi_wrdata_en_p6;
wire dfi_rddata_en_p6;
wire dfi_rddata_valid_w6;

wire dfi_cke_p7;
wire dfi_reset_n_p7;
wire dfi_mode_2n_p7;
wire dfi_alert_n_w7;
wire dfi_cas_n_p7;
wire dfi_cs_n_p7;
wire dfi_ras_n_p7;
wire dfi_act_n_p7;
wire dfi_odt_p7;
wire dfi_we_n_p7;
wire dfi_wrdata_en_p7;
wire dfi_rddata_en_p7;
wire dfi_rddata_valid_w7;

wire [31:0] dfi_rddata_w0;
wire [31:0] dfi_rddata_w1;
wire [31:0] dfi_rddata_w2;
wire [31:0] dfi_rddata_w3;
wire [31:0] dfi_rddata_w4;
wire [31:0] dfi_rddata_w5;
wire [31:0] dfi_rddata_w6;
wire [31:0] dfi_rddata_w7;

wire mem_rst;
wire dfi_init_start;
wire dfi_init_complete;

wire [29:0] wb_dram_adr;
wire [31:0] wb_dram_dat_w;
wire [31:0] wb_dram_dat_r;
wire  [3:0] wb_dram_sel;
wire        wb_dram_cyc;
wire        wb_dram_stb;
wire        wb_dram_ack;
wire        wb_dram_we;
wire  [2:0] wb_dram_cti;
wire  [1:0] wb_dram_bte;
wire        wb_dram_err;
wire [26:0] wb_ctrl_adr;
wire [31:0] wb_ctrl_dat_w;
wire [31:0] wb_ctrl_dat_r;
wire  [3:0] wb_ctrl_sel;
wire        wb_ctrl_cyc;
wire        wb_ctrl_stb;
wire        wb_ctrl_ack;
wire        wb_ctrl_we;
wire  [2:0] wb_ctrl_cti;
wire  [1:0] wb_ctrl_bte;
wire        wb_ctrl_err;

dram_phy phy_inst (
    .serial_tx(),
    .serial_rx(),
    .clk(clk100),
    .rst(~user_btn0),
    .clk_idelay(),
    .rst_idelay(),
    .clk_sys(sys_clk),
    .rst_sys(sys_rst),
    .clk_sys2x(),
    .rst_sys2x(),
    .clk_sys8x(),
    .rst_sys8x(),

    .ddram_ca(lpddr4_ca),
    .ddram_cs(lpddr4_cs),
    .ddram_dq(lpddr4_dq),
    .ddram_dqs_p(lpddr4_dqs_p),
    .ddram_dqs_n(lpddr4_dqs_n),
    .ddram_dmi(lpddr4_dmi),
    .ddram_clk_p(lpddr4_clk_p),
    .ddram_clk_n(lpddr4_clk_n),
    .ddram_cke(lpddr4_cke),
    .ddram_odt(lpddr4_odt),
    .ddram_reset_n(lpddr4_reset_n),

    .dfi_cke_p0         (dfi_cke_p0),
    .dfi_reset_n_p0     (dfi_reset_n_p0),
    .dfi_mode_2n_p0     (dfi_mode_2n_p0),
    .dfi_alert_n_w0     (dfi_alert_n_w0),
    .dfi_address_p0     (dfi_address_p0),
    .dfi_bank_p0        (dfi_bank_p0),
    .dfi_cas_n_p0       (dfi_cas_n_p0),
    .dfi_cs_n_p0        (dfi_cs_n_p0),
    .dfi_ras_n_p0       (dfi_ras_n_p0),
    .dfi_act_n_p0       (dfi_act_n_p0),
    .dfi_odt_p0         (dfi_odt_p0),
    .dfi_we_n_p0        (dfi_we_n_p0),
    .dfi_wrdata_p0      (dfi_wrdata_p0),
    .dfi_wrdata_en_p0   (dfi_wrdata_en_p0),
    .dfi_wrdata_mask_p0 (dfi_wrdata_mask_p0),
    .dfi_rddata_en_p0   (dfi_rddata_en_p0),
    .dfi_rddata_w0      (dfi_rddata_w0),
    .dfi_rddata_valid_w0(dfi_rddata_valid_w0),

    .dfi_cke_p1         (dfi_cke_p1),
    .dfi_reset_n_p1     (dfi_reset_n_p1),
    .dfi_mode_2n_p1     (dfi_mode_2n_p1),
    .dfi_alert_n_w1     (dfi_alert_n_w1),
    .dfi_address_p1     (dfi_address_p1),
    .dfi_bank_p1        (dfi_bank_p1),
    .dfi_cas_n_p1       (dfi_cas_n_p1),
    .dfi_cs_n_p1        (dfi_cs_n_p1),
    .dfi_ras_n_p1       (dfi_ras_n_p1),
    .dfi_act_n_p1       (dfi_act_n_p1),
    .dfi_odt_p1         (dfi_odt_p1),
    .dfi_we_n_p1        (dfi_we_n_p1),
    .dfi_wrdata_p1      (dfi_wrdata_p1),
    .dfi_wrdata_en_p1   (dfi_wrdata_en_p1),
    .dfi_wrdata_mask_p1 (dfi_wrdata_mask_p1),
    .dfi_rddata_en_p1   (dfi_rddata_en_p1),
    .dfi_rddata_w1      (dfi_rddata_w1),
    .dfi_rddata_valid_w1(dfi_rddata_valid_w1),

    .dfi_cke_p2         (dfi_cke_p2),
    .dfi_reset_n_p2     (dfi_reset_n_p2),
    .dfi_mode_2n_p2     (dfi_mode_2n_p2),
    .dfi_alert_n_w2     (dfi_alert_n_w2),
    .dfi_address_p2     (dfi_address_p2),
    .dfi_bank_p2        (dfi_bank_p2),
    .dfi_cas_n_p2       (dfi_cas_n_p2),
    .dfi_cs_n_p2        (dfi_cs_n_p2),
    .dfi_ras_n_p2       (dfi_ras_n_p2),
    .dfi_act_n_p2       (dfi_act_n_p2),
    .dfi_odt_p2         (dfi_odt_p2),
    .dfi_we_n_p2        (dfi_we_n_p2),
    .dfi_wrdata_p2      (dfi_wrdata_p2),
    .dfi_wrdata_en_p2   (dfi_wrdata_en_p2),
    .dfi_wrdata_mask_p2 (dfi_wrdata_mask_p2),
    .dfi_rddata_en_p2   (dfi_rddata_en_p2),
    .dfi_rddata_w2      (dfi_rddata_w2),
    .dfi_rddata_valid_w2(dfi_rddata_valid_w2),

    .dfi_cke_p3         (dfi_cke_p3),
    .dfi_reset_n_p3     (dfi_reset_n_p3),
    .dfi_mode_2n_p3     (dfi_mode_2n_p3),
    .dfi_alert_n_w3     (dfi_alert_n_w3),
    .dfi_address_p3     (dfi_address_p3),
    .dfi_bank_p3        (dfi_bank_p3),
    .dfi_cas_n_p3       (dfi_cas_n_p3),
    .dfi_cs_n_p3        (dfi_cs_n_p3),
    .dfi_ras_n_p3       (dfi_ras_n_p3),
    .dfi_act_n_p3       (dfi_act_n_p3),
    .dfi_odt_p3         (dfi_odt_p3),
    .dfi_we_n_p3        (dfi_we_n_p3),
    .dfi_wrdata_p3      (dfi_wrdata_p3),
    .dfi_wrdata_en_p3   (dfi_wrdata_en_p3),
    .dfi_wrdata_mask_p3 (dfi_wrdata_mask_p3),
    .dfi_rddata_en_p3   (dfi_rddata_en_p3),
    .dfi_rddata_w3      (dfi_rddata_w3),
    .dfi_rddata_valid_w3(dfi_rddata_valid_w3),

    .dfi_cke_p4         (dfi_cke_p4),
    .dfi_reset_n_p4     (dfi_reset_n_p4),
    .dfi_mode_2n_p4     (dfi_mode_2n_p4),
    .dfi_alert_n_w4     (dfi_alert_n_w4),
    .dfi_address_p4     (dfi_address_p4),
    .dfi_bank_p4        (dfi_bank_p4),
    .dfi_cas_n_p4       (dfi_cas_n_p4),
    .dfi_cs_n_p4        (dfi_cs_n_p4),
    .dfi_ras_n_p4       (dfi_ras_n_p4),
    .dfi_act_n_p4       (dfi_act_n_p4),
    .dfi_odt_p4         (dfi_odt_p4),
    .dfi_we_n_p4        (dfi_we_n_p4),
    .dfi_wrdata_p4      (dfi_wrdata_p4),
    .dfi_wrdata_en_p4   (dfi_wrdata_en_p4),
    .dfi_wrdata_mask_p4 (dfi_wrdata_mask_p4),
    .dfi_rddata_en_p4   (dfi_rddata_en_p4),
    .dfi_rddata_w4      (dfi_rddata_w4),
    .dfi_rddata_valid_w4(dfi_rddata_valid_w4),

    .dfi_cke_p5         (dfi_cke_p5),
    .dfi_reset_n_p5     (dfi_reset_n_p5),
    .dfi_mode_2n_p5     (dfi_mode_2n_p5),
    .dfi_alert_n_w5     (dfi_alert_n_w5),
    .dfi_address_p5     (dfi_address_p5),
    .dfi_bank_p5        (dfi_bank_p5),
    .dfi_cas_n_p5       (dfi_cas_n_p5),
    .dfi_cs_n_p5        (dfi_cs_n_p5),
    .dfi_ras_n_p5       (dfi_ras_n_p5),
    .dfi_act_n_p5       (dfi_act_n_p5),
    .dfi_odt_p5         (dfi_odt_p5),
    .dfi_we_n_p5        (dfi_we_n_p5),
    .dfi_wrdata_p5      (dfi_wrdata_p5),
    .dfi_wrdata_en_p5   (dfi_wrdata_en_p5),
    .dfi_wrdata_mask_p5 (dfi_wrdata_mask_p5),
    .dfi_rddata_en_p5   (dfi_rddata_en_p5),
    .dfi_rddata_w5      (dfi_rddata_w5),
    .dfi_rddata_valid_w5(dfi_rddata_valid_w5),

    .dfi_cke_p6         (dfi_cke_p6),
    .dfi_reset_n_p6     (dfi_reset_n_p6),
    .dfi_mode_2n_p6     (dfi_mode_2n_p6),
    .dfi_alert_n_w6     (dfi_alert_n_w6),
    .dfi_address_p6     (dfi_address_p6),
    .dfi_bank_p6        (dfi_bank_p6),
    .dfi_cas_n_p6       (dfi_cas_n_p6),
    .dfi_cs_n_p6        (dfi_cs_n_p6),
    .dfi_ras_n_p6       (dfi_ras_n_p6),
    .dfi_act_n_p6       (dfi_act_n_p6),
    .dfi_odt_p6         (dfi_odt_p6),
    .dfi_we_n_p6        (dfi_we_n_p6),
    .dfi_wrdata_p6      (dfi_wrdata_p6),
    .dfi_wrdata_en_p6   (dfi_wrdata_en_p6),
    .dfi_wrdata_mask_p6 (dfi_wrdata_mask_p6),
    .dfi_rddata_en_p6   (dfi_rddata_en_p6),
    .dfi_rddata_w6      (dfi_rddata_w6),
    .dfi_rddata_valid_w6(dfi_rddata_valid_w6),

    .dfi_cke_p7         (dfi_cke_p7),
    .dfi_reset_n_p7     (dfi_reset_n_p7),
    .dfi_mode_2n_p7     (dfi_mode_2n_p7),
    .dfi_alert_n_w7     (dfi_alert_n_w7),
    .dfi_address_p7     (dfi_address_p7),
    .dfi_bank_p7        (dfi_bank_p7),
    .dfi_cas_n_p7       (dfi_cas_n_p7),
    .dfi_cs_n_p7        (dfi_cs_n_p7),
    .dfi_ras_n_p7       (dfi_ras_n_p7),
    .dfi_act_n_p7       (dfi_act_n_p7),
    .dfi_odt_p7         (dfi_odt_p7),
    .dfi_we_n_p7        (dfi_we_n_p7),
    .dfi_wrdata_p7      (dfi_wrdata_p7),
    .dfi_wrdata_en_p7   (dfi_wrdata_en_p7),
    .dfi_wrdata_mask_p7 (dfi_wrdata_mask_p7),
    .dfi_rddata_en_p7   (dfi_rddata_en_p7),
    .dfi_rddata_w7      (dfi_rddata_w7),
    .dfi_rddata_valid_w7(dfi_rddata_valid_w7),

    .dfi_init_start     (dfi_init_start),
    .dfi_init_complete  (dfi_init_complete)
);

// DRAM controller
dram_ctrl dram_ctrl_inst (
    .clk                (sys_clk),
    .rst                (sys_rst),

    .mem_rst            (mem_rst),

    .dfi_cke_p0         (dfi_cke_p0),
    .dfi_reset_n_p0     (dfi_reset_n_p0),
    .dfi_mode_2n_p0     (dfi_mode_2n_p0),
    .dfi_alert_n_w0     (dfi_alert_n_w0),
    .dfi_address_p0     (dfi_address_p0),
    .dfi_bank_p0        (dfi_bank_p0),
    .dfi_cas_n_p0       (dfi_cas_n_p0),
    .dfi_cs_n_p0        (dfi_cs_n_p0),
    .dfi_ras_n_p0       (dfi_ras_n_p0),
    .dfi_act_n_p0       (dfi_act_n_p0),
    .dfi_odt_p0         (dfi_odt_p0),
    .dfi_we_n_p0        (dfi_we_n_p0),
    .dfi_wrdata_p0      (dfi_wrdata_p0),
    .dfi_wrdata_en_p0   (dfi_wrdata_en_p0),
    .dfi_wrdata_mask_p0 (dfi_wrdata_mask_p0),
    .dfi_rddata_en_p0   (dfi_rddata_en_p0),
    .dfi_rddata_w0      (dfi_rddata_w0),
    .dfi_rddata_valid_w0(dfi_rddata_valid_w0),

    .dfi_cke_p1         (dfi_cke_p1),
    .dfi_reset_n_p1     (dfi_reset_n_p1),
    .dfi_mode_2n_p1     (dfi_mode_2n_p1),
    .dfi_alert_n_w1     (dfi_alert_n_w1),
    .dfi_address_p1     (dfi_address_p1),
    .dfi_bank_p1        (dfi_bank_p1),
    .dfi_cas_n_p1       (dfi_cas_n_p1),
    .dfi_cs_n_p1        (dfi_cs_n_p1),
    .dfi_ras_n_p1       (dfi_ras_n_p1),
    .dfi_act_n_p1       (dfi_act_n_p1),
    .dfi_odt_p1         (dfi_odt_p1),
    .dfi_we_n_p1        (dfi_we_n_p1),
    .dfi_wrdata_p1      (dfi_wrdata_p1),
    .dfi_wrdata_en_p1   (dfi_wrdata_en_p1),
    .dfi_wrdata_mask_p1 (dfi_wrdata_mask_p1),
    .dfi_rddata_en_p1   (dfi_rddata_en_p1),
    .dfi_rddata_w1      (dfi_rddata_w1),
    .dfi_rddata_valid_w1(dfi_rddata_valid_w1),

    .dfi_cke_p2         (dfi_cke_p2),
    .dfi_reset_n_p2     (dfi_reset_n_p2),
    .dfi_mode_2n_p2     (dfi_mode_2n_p2),
    .dfi_alert_n_w2     (dfi_alert_n_w2),
    .dfi_address_p2     (dfi_address_p2),
    .dfi_bank_p2        (dfi_bank_p2),
    .dfi_cas_n_p2       (dfi_cas_n_p2),
    .dfi_cs_n_p2        (dfi_cs_n_p2),
    .dfi_ras_n_p2       (dfi_ras_n_p2),
    .dfi_act_n_p2       (dfi_act_n_p2),
    .dfi_odt_p2         (dfi_odt_p2),
    .dfi_we_n_p2        (dfi_we_n_p2),
    .dfi_wrdata_p2      (dfi_wrdata_p2),
    .dfi_wrdata_en_p2   (dfi_wrdata_en_p2),
    .dfi_wrdata_mask_p2 (dfi_wrdata_mask_p2),
    .dfi_rddata_en_p2   (dfi_rddata_en_p2),
    .dfi_rddata_w2      (dfi_rddata_w2),
    .dfi_rddata_valid_w2(dfi_rddata_valid_w2),

    .dfi_cke_p3         (dfi_cke_p3),
    .dfi_reset_n_p3     (dfi_reset_n_p3),
    .dfi_mode_2n_p3     (dfi_mode_2n_p3),
    .dfi_alert_n_w3     (dfi_alert_n_w3),
    .dfi_address_p3     (dfi_address_p3),
    .dfi_bank_p3        (dfi_bank_p3),
    .dfi_cas_n_p3       (dfi_cas_n_p3),
    .dfi_cs_n_p3        (dfi_cs_n_p3),
    .dfi_ras_n_p3       (dfi_ras_n_p3),
    .dfi_act_n_p3       (dfi_act_n_p3),
    .dfi_odt_p3         (dfi_odt_p3),
    .dfi_we_n_p3        (dfi_we_n_p3),
    .dfi_wrdata_p3      (dfi_wrdata_p3),
    .dfi_wrdata_en_p3   (dfi_wrdata_en_p3),
    .dfi_wrdata_mask_p3 (dfi_wrdata_mask_p3),
    .dfi_rddata_en_p3   (dfi_rddata_en_p3),
    .dfi_rddata_w3      (dfi_rddata_w3),
    .dfi_rddata_valid_w3(dfi_rddata_valid_w3),

    .dfi_cke_p4         (dfi_cke_p4),
    .dfi_reset_n_p4     (dfi_reset_n_p4),
    .dfi_mode_2n_p4     (dfi_mode_2n_p4),
    .dfi_alert_n_w4     (dfi_alert_n_w4),
    .dfi_address_p4     (dfi_address_p4),
    .dfi_bank_p4        (dfi_bank_p4),
    .dfi_cas_n_p4       (dfi_cas_n_p4),
    .dfi_cs_n_p4        (dfi_cs_n_p4),
    .dfi_ras_n_p4       (dfi_ras_n_p4),
    .dfi_act_n_p4       (dfi_act_n_p4),
    .dfi_odt_p4         (dfi_odt_p4),
    .dfi_we_n_p4        (dfi_we_n_p4),
    .dfi_wrdata_p4      (dfi_wrdata_p4),
    .dfi_wrdata_en_p4   (dfi_wrdata_en_p4),
    .dfi_wrdata_mask_p4 (dfi_wrdata_mask_p4),
    .dfi_rddata_en_p4   (dfi_rddata_en_p4),
    .dfi_rddata_w4      (dfi_rddata_w4),
    .dfi_rddata_valid_w4(dfi_rddata_valid_w4),

    .dfi_cke_p5         (dfi_cke_p5),
    .dfi_reset_n_p5     (dfi_reset_n_p5),
    .dfi_mode_2n_p5     (dfi_mode_2n_p5),
    .dfi_alert_n_w5     (dfi_alert_n_w5),
    .dfi_address_p5     (dfi_address_p5),
    .dfi_bank_p5        (dfi_bank_p5),
    .dfi_cas_n_p5       (dfi_cas_n_p5),
    .dfi_cs_n_p5        (dfi_cs_n_p5),
    .dfi_ras_n_p5       (dfi_ras_n_p5),
    .dfi_act_n_p5       (dfi_act_n_p5),
    .dfi_odt_p5         (dfi_odt_p5),
    .dfi_we_n_p5        (dfi_we_n_p5),
    .dfi_wrdata_p5      (dfi_wrdata_p5),
    .dfi_wrdata_en_p5   (dfi_wrdata_en_p5),
    .dfi_wrdata_mask_p5 (dfi_wrdata_mask_p5),
    .dfi_rddata_en_p5   (dfi_rddata_en_p5),
    .dfi_rddata_w5      (dfi_rddata_w5),
    .dfi_rddata_valid_w5(dfi_rddata_valid_w5),

    .dfi_cke_p6         (dfi_cke_p6),
    .dfi_reset_n_p6     (dfi_reset_n_p6),
    .dfi_mode_2n_p6     (dfi_mode_2n_p6),
    .dfi_alert_n_w6     (dfi_alert_n_w6),
    .dfi_address_p6     (dfi_address_p6),
    .dfi_bank_p6        (dfi_bank_p6),
    .dfi_cas_n_p6       (dfi_cas_n_p6),
    .dfi_cs_n_p6        (dfi_cs_n_p6),
    .dfi_ras_n_p6       (dfi_ras_n_p6),
    .dfi_act_n_p6       (dfi_act_n_p6),
    .dfi_odt_p6         (dfi_odt_p6),
    .dfi_we_n_p6        (dfi_we_n_p6),
    .dfi_wrdata_p6      (dfi_wrdata_p6),
    .dfi_wrdata_en_p6   (dfi_wrdata_en_p6),
    .dfi_wrdata_mask_p6 (dfi_wrdata_mask_p6),
    .dfi_rddata_en_p6   (dfi_rddata_en_p6),
    .dfi_rddata_w6      (dfi_rddata_w6),
    .dfi_rddata_valid_w6(dfi_rddata_valid_w6),

    .dfi_cke_p7         (dfi_cke_p7),
    .dfi_reset_n_p7     (dfi_reset_n_p7),
    .dfi_mode_2n_p7     (dfi_mode_2n_p7),
    .dfi_alert_n_w7     (dfi_alert_n_w7),
    .dfi_address_p7     (dfi_address_p7),
    .dfi_bank_p7        (dfi_bank_p7),
    .dfi_cas_n_p7       (dfi_cas_n_p7),
    .dfi_cs_n_p7        (dfi_cs_n_p7),
    .dfi_ras_n_p7       (dfi_ras_n_p7),
    .dfi_act_n_p7       (dfi_act_n_p7),
    .dfi_odt_p7         (dfi_odt_p7),
    .dfi_we_n_p7        (dfi_we_n_p7),
    .dfi_wrdata_p7      (dfi_wrdata_p7),
    .dfi_wrdata_en_p7   (dfi_wrdata_en_p7),
    .dfi_wrdata_mask_p7 (dfi_wrdata_mask_p7),
    .dfi_rddata_en_p7   (dfi_rddata_en_p7),
    .dfi_rddata_w7      (dfi_rddata_w7),
    .dfi_rddata_valid_w7(dfi_rddata_valid_w7),

    .dfi_init_start     (dfi_init_start),
    .dfi_init_complete  (dfi_init_complete),

    .init_done          (),
    .init_error         (),

    .wb_ctrl_adr        (wb_ctrl_adr),
    .wb_ctrl_dat_w      (wb_ctrl_dat_w),
    .wb_ctrl_dat_r      (wb_ctrl_dat_r),
    .wb_ctrl_sel        (wb_ctrl_sel),
    .wb_ctrl_cyc        (wb_ctrl_cyc),
    .wb_ctrl_stb        (wb_ctrl_stb),
    .wb_ctrl_ack        (wb_ctrl_ack),
    .wb_ctrl_we         (wb_ctrl_we),
    .wb_ctrl_cti        (wb_ctrl_cti),
    .wb_ctrl_bte        (wb_ctrl_bte),
    .wb_ctrl_err        (wb_ctrl_err),

    .user_port_wishbone_0_adr   (wb_dram_adr),
    .user_port_wishbone_0_dat_w (wb_dram_dat_w),
    .user_port_wishbone_0_dat_r (wb_dram_dat_r),
    .user_port_wishbone_0_sel   (wb_dram_sel),
    .user_port_wishbone_0_cyc   (wb_dram_cyc),
    .user_port_wishbone_0_stb   (wb_dram_stb),
    .user_port_wishbone_0_ack   (wb_dram_ack),
    .user_port_wishbone_0_we    (wb_dram_we),
    .user_port_wishbone_0_err   (wb_dram_err)
);

antmicro_lpddr4_test_board demo_soc (
    .clk            (sys_clk),
    .rst            (sys_rst),
    .serial0_tx     (serial0_tx),
    .serial0_rx     (serial0_rx),
    .wb_dram_adr    (wb_dram_adr  ),
    .wb_dram_dat_w  (wb_dram_dat_w),
    .wb_dram_dat_r  (wb_dram_dat_r),
    .wb_dram_sel    (wb_dram_sel  ),
    .wb_dram_cyc    (wb_dram_cyc  ),
    .wb_dram_stb    (wb_dram_stb  ),
    .wb_dram_ack    (wb_dram_ack  ),
    .wb_dram_we     (wb_dram_we   ),
    .wb_dram_cti    (wb_dram_cti  ),
    .wb_dram_bte    (wb_dram_bte  ),
    .wb_dram_err    (wb_dram_err  ),
    .wb_ctrl_adr    (wb_ctrl_adr  ),
    .wb_ctrl_dat_w  (wb_ctrl_dat_w),
    .wb_ctrl_dat_r  (wb_ctrl_dat_r),
    .wb_ctrl_sel    (wb_ctrl_sel  ),
    .wb_ctrl_cyc    (wb_ctrl_cyc  ),
    .wb_ctrl_stb    (wb_ctrl_stb  ),
    .wb_ctrl_ack    (wb_ctrl_ack  ),
    .wb_ctrl_we     (wb_ctrl_we   ),
    .wb_ctrl_cti    (wb_ctrl_cti  ),
    .wb_ctrl_bte    (wb_ctrl_bte  ),
    .wb_ctrl_err    (wb_ctrl_err  ),
    .serial1_tx     (serial1_tx),
    .serial1_rx     (serial1_tx)
);

endmodule
