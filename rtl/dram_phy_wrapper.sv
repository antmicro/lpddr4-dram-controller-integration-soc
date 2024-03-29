`timescale 1ns / 1ps

module dram_phy_wrapper
    import top_pkg::*;
    import mem_pkg::*;
(
    // Clock and reset inputs
    input  wire clk_ext,
    input  wire rst_ext,

    // Clock and reset outputs
    output wire clk_sys,
    output wire rst_sys,

    // UART
    output wire serial_tx,
    input  wire serial_rx,

    // DFI memory training interface
    input  wire dfi_init_start,
    output wire dfi_init_complete,

    // DDR memory
    output wire [ 5:0] ddram_ca,
    output wire        ddram_cs,
    inout  wire [15:0] ddram_dq,
    inout  wire [ 1:0] ddram_dqs_p,
    inout  wire [ 1:0] ddram_dqs_n,
    inout  wire [ 1:0] ddram_dmi,
    output wire        ddram_clk_p,
    output wire        ddram_clk_n,
    output wire        ddram_cke,
    output wire        ddram_odt,
    output wire        ddram_reset_n,

    // DDR PHY
    input  wire        dfi_cke_p0,
    input  wire        dfi_reset_n_p0,
    input  wire        dfi_mode_2n_p0,
    output wire        dfi_alert_n_w0,
    input  wire [16:0] dfi_address_p0,
    input  wire [ 5:0] dfi_bank_p0,
    input  wire        dfi_cas_n_p0,
    input  wire        dfi_cs_n_p0,
    input  wire        dfi_ras_n_p0,
    input  wire        dfi_act_n_p0,
    input  wire        dfi_odt_p0,
    input  wire        dfi_we_n_p0,
    input  wire [31:0] dfi_wrdata_p0,
    input  wire        dfi_wrdata_en_p0,
    input  wire [ 3:0] dfi_wrdata_mask_p0,
    input  wire        dfi_rddata_en_p0,
    output wire [31:0] dfi_rddata_w0,
    output wire        dfi_rddata_valid_w0,
    input  wire        dfi_cke_p1,
    input  wire        dfi_reset_n_p1,
    input  wire        dfi_mode_2n_p1,
    output wire        dfi_alert_n_w1,
    input  wire [16:0] dfi_address_p1,
    input  wire [ 5:0] dfi_bank_p1,
    input  wire        dfi_cas_n_p1,
    input  wire        dfi_cs_n_p1,
    input  wire        dfi_ras_n_p1,
    input  wire        dfi_act_n_p1,
    input  wire        dfi_odt_p1,
    input  wire        dfi_we_n_p1,
    input  wire [31:0] dfi_wrdata_p1,
    input  wire        dfi_wrdata_en_p1,
    input  wire [ 3:0] dfi_wrdata_mask_p1,
    input  wire        dfi_rddata_en_p1,
    output wire [31:0] dfi_rddata_w1,
    output wire        dfi_rddata_valid_w1,
    input  wire        dfi_cke_p2,
    input  wire        dfi_reset_n_p2,
    input  wire        dfi_mode_2n_p2,
    output wire        dfi_alert_n_w2,
    input  wire [16:0] dfi_address_p2,
    input  wire [ 5:0] dfi_bank_p2,
    input  wire        dfi_cas_n_p2,
    input  wire        dfi_cs_n_p2,
    input  wire        dfi_ras_n_p2,
    input  wire        dfi_act_n_p2,
    input  wire        dfi_odt_p2,
    input  wire        dfi_we_n_p2,
    input  wire [31:0] dfi_wrdata_p2,
    input  wire        dfi_wrdata_en_p2,
    input  wire [ 3:0] dfi_wrdata_mask_p2,
    input  wire        dfi_rddata_en_p2,
    output wire [31:0] dfi_rddata_w2,
    output wire        dfi_rddata_valid_w2,
    input  wire        dfi_cke_p3,
    input  wire        dfi_reset_n_p3,
    input  wire        dfi_mode_2n_p3,
    output wire        dfi_alert_n_w3,
    input  wire [16:0] dfi_address_p3,
    input  wire [ 5:0] dfi_bank_p3,
    input  wire        dfi_cas_n_p3,
    input  wire        dfi_cs_n_p3,
    input  wire        dfi_ras_n_p3,
    input  wire        dfi_act_n_p3,
    input  wire        dfi_odt_p3,
    input  wire        dfi_we_n_p3,
    input  wire [31:0] dfi_wrdata_p3,
    input  wire        dfi_wrdata_en_p3,
    input  wire [ 3:0] dfi_wrdata_mask_p3,
    input  wire        dfi_rddata_en_p3,
    output wire [31:0] dfi_rddata_w3,
    output wire        dfi_rddata_valid_w3,
    input  wire        dfi_cke_p4,
    input  wire        dfi_reset_n_p4,
    input  wire        dfi_mode_2n_p4,
    output wire        dfi_alert_n_w4,
    input  wire [16:0] dfi_address_p4,
    input  wire [ 5:0] dfi_bank_p4,
    input  wire        dfi_cas_n_p4,
    input  wire        dfi_cs_n_p4,
    input  wire        dfi_ras_n_p4,
    input  wire        dfi_act_n_p4,
    input  wire        dfi_odt_p4,
    input  wire        dfi_we_n_p4,
    input  wire [31:0] dfi_wrdata_p4,
    input  wire        dfi_wrdata_en_p4,
    input  wire [ 3:0] dfi_wrdata_mask_p4,
    input  wire        dfi_rddata_en_p4,
    output wire [31:0] dfi_rddata_w4,
    output wire        dfi_rddata_valid_w4,
    input  wire        dfi_cke_p5,
    input  wire        dfi_reset_n_p5,
    input  wire        dfi_mode_2n_p5,
    output wire        dfi_alert_n_w5,
    input  wire [16:0] dfi_address_p5,
    input  wire [ 5:0] dfi_bank_p5,
    input  wire        dfi_cas_n_p5,
    input  wire        dfi_cs_n_p5,
    input  wire        dfi_ras_n_p5,
    input  wire        dfi_act_n_p5,
    input  wire        dfi_odt_p5,
    input  wire        dfi_we_n_p5,
    input  wire [31:0] dfi_wrdata_p5,
    input  wire        dfi_wrdata_en_p5,
    input  wire [ 3:0] dfi_wrdata_mask_p5,
    input  wire        dfi_rddata_en_p5,
    output wire [31:0] dfi_rddata_w5,
    output wire        dfi_rddata_valid_w5,
    input  wire        dfi_cke_p6,
    input  wire        dfi_reset_n_p6,
    input  wire        dfi_mode_2n_p6,
    output wire        dfi_alert_n_w6,
    input  wire [16:0] dfi_address_p6,
    input  wire [ 5:0] dfi_bank_p6,
    input  wire        dfi_cas_n_p6,
    input  wire        dfi_cs_n_p6,
    input  wire        dfi_ras_n_p6,
    input  wire        dfi_act_n_p6,
    input  wire        dfi_odt_p6,
    input  wire        dfi_we_n_p6,
    input  wire [31:0] dfi_wrdata_p6,
    input  wire        dfi_wrdata_en_p6,
    input  wire [ 3:0] dfi_wrdata_mask_p6,
    input  wire        dfi_rddata_en_p6,
    output wire [31:0] dfi_rddata_w6,
    output wire        dfi_rddata_valid_w6,
    input  wire        dfi_cke_p7,
    input  wire        dfi_reset_n_p7,
    input  wire        dfi_mode_2n_p7,
    output wire        dfi_alert_n_w7,
    input  wire [16:0] dfi_address_p7,
    input  wire [ 5:0] dfi_bank_p7,
    input  wire        dfi_cas_n_p7,
    input  wire        dfi_cs_n_p7,
    input  wire        dfi_ras_n_p7,
    input  wire        dfi_act_n_p7,
    input  wire        dfi_odt_p7,
    input  wire        dfi_we_n_p7,
    input  wire [31:0] dfi_wrdata_p7,
    input  wire        dfi_wrdata_en_p7,
    input  wire [ 3:0] dfi_wrdata_mask_p7,
    input  wire        dfi_rddata_en_p7,
    output wire [31:0] dfi_rddata_w7,
    output wire        dfi_rddata_valid_w7
);


// Memory buses
mem_pkg::mem_h2d_t rom_h2d;
mem_pkg::mem_d2h_t rom_d2h;
mem_pkg::mem_h2d_t ram_h2d;
mem_pkg::mem_d2h_t ram_d2h;


// ROM memory model
sim_rom # (
  .AW         (top_pkg::MEM_AW),
  .DW         (top_pkg::MEM_DW),
  .SIZE       (1024 * 64),   // 64kB
  .FILE       ("../../build/run/sim/fw/rom.hex")
) u_rom (
  .clk_i      (clk_sys),
  .rst_ni     (~rst_sys),

  .req        (rom_h2d.req & !rom_h2d.we),
  .addr       (rom_h2d.addr),
  .rdata      (rom_d2h.data),
  .rvalid     (rom_d2h.valid)
);

assign rom_d2h.gnt    = 1'b1;
assign rom_d2h.error  = 2'b00;

// RAM memory model
sim_ram # (
  .AW         (top_pkg::MEM_AW),
  .DW         (top_pkg::MEM_DW),
  .SIZE       (1024 * 64)    // 64kB
) u_ram (
  .clk_i      (clk_sys),
  .rst_ni     (~rst_sys),

  .req        (ram_h2d.req),
  .we         (ram_h2d.we),
  .addr       (ram_h2d.addr),
  .wdata      (ram_h2d.data),
  .wmask      (ram_h2d.mask),
  .rdata      (ram_d2h.data),
  .rvalid     (ram_d2h.valid)
);

assign ram_d2h.gnt    = 1'b1;
assign ram_d2h.error  = 2'b00;

dram_phy_soc_top phy_inst (
    .clk_i(clk_ext),
    .rst_ni(rst_ext),
    .clk_1x_o(clk_sys),
    .rst_1x_o(rst_sys),
    .tx(serial_tx),
    .rx(serial_rx),

    .rom_o(rom_h2d),
    .rom_i(rom_d2h),
    .ram_o(ram_h2d),
    .ram_i(ram_d2h),

    .ddram_ca(ddram_ca),
    .ddram_cs(ddram_cs),
    .ddram_dq(ddram_dq),
    .ddram_dqs_p(ddram_dqs_p),
    .ddram_dqs_n(ddram_dqs_n),
    .ddram_dmi(ddram_dmi),
    .ddram_clk_p(ddram_clk_p),
    .ddram_clk_n(ddram_clk_n),
    .ddram_cke(ddram_cke),
    .ddram_odt(ddram_odt),
    .ddram_reset_n(ddram_reset_n),

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

    .dfi_init_start_i   (dfi_init_start),
    .dfi_init_done_o    (dfi_init_complete)
);

endmodule
