`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/21 18:43:22
// Design Name: 
// Module Name: TOP_TEST
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TOP_TEST
#(
    parameter
        WIDTH_ADDR_PIXEL = 5'd16,
        WIDTH_DATA_PIXEL = 3'd4,
        WIDTH_DATA_INTEG = 5'd20,
        WIDTH_POSITION   = 4'd8
)
(
    
//    input [3:0] debug,

	input clk_s, rst_n_in,
    
////// OV7670
    // I2C Side
    output                ov_I2C_SCLK,     // I2C CLOCK
    inout                 ov_I2C_SDAT,     // I2C DATA
    // Sensor Interface
    output                ov_CMOS_RST_N,   // cmos work state(5ms delay for sccb config)
    output                ov_CMOS_PWDN,    // cmos power on    
    output                ov_CMOS_XCLK,    // 25MHz
    input                 ov_CMOS_PCLK,    // 25MHz
    input    [7:0]        ov_CMOS_iDATA,   // CMOS Data
    input                 ov_CMOS_VSYNC,   // L: Vaild
    input                 ov_CMOS_HREF,    // H: Vaild
        
////// VGA
    output [3:0] vgaRed, vgaGreen, vgaBlue,
    output       vgaHsync, vgaVsync,

////// debug
   // output [5:0] debug,
    input  [1:0] dbg_in,

    output [8:0] state
    );

    reg [1:0] dbg_temp, dbg;

/////////////////////////////////// definitions
////// Clock Wizard
    wire pixel_clk, clk, clk_debug;
    wire reset_cw0;
    wire locked_cw0;
////// signals
    // IMAGER_INTERFACE _ii0
    wire write_next_frame_ii0;
    wire new_image_ready_ii0;
    // RESULT_WRITER _rw0
    wire start_rw0;
    wire done_rw0;
    wire [WIDTH_POSITION-1:0] xpos;
    wire [WIDTH_POSITION-1:0] ypos;
    wire [WIDTH_POSITION-1:0] length;
    // INTEGRAL_COMPUTER
    wire clk_int;   // 12.5MHz
    wire idle_ic0;
    wire rst_ic0;

////// BRAMs
    // image displaying blk0
    wire clka_blk0;
    wire clkb_blk0;
    wire ena_blk0;
    wire wea_blk0;
    wire enb_blk0;
    wire [WIDTH_ADDR_PIXEL-1:0] addra_blk0;
    wire [WIDTH_ADDR_PIXEL-1:0] addrb_blk0;
    wire [WIDTH_DATA_PIXEL-1:0] dina_blk0;
    wire [WIDTH_DATA_PIXEL-1:0] doutb_blk0;
    // image fetched blk1
    wire clka_blk1;
    wire clkb_blk1;
    wire ena_blk1;
    wire wea_blk1;
    wire enb_blk1;
    wire [WIDTH_ADDR_PIXEL-1:0] addra_blk1;
    wire [WIDTH_ADDR_PIXEL-1:0] addrb_blk1;
    wire [WIDTH_DATA_PIXEL-1:0] dina_blk1;
    wire [WIDTH_DATA_PIXEL-1:0] doutb_blk1;
    // image integrated blk2
    wire clka_blk2;
    wire clkb_blk2;
    wire ena_blk2;
    wire wea_blk2;
    wire enb_blk2;
    wire [WIDTH_ADDR_PIXEL-1:0] addra_blk2;
    wire [WIDTH_ADDR_PIXEL-1:0] addrb_blk2;
    wire [WIDTH_DATA_INTEG-1:0] dina_blk2;
    wire [WIDTH_DATA_INTEG-1:0] doutb_blk2;

///////////////////////////////////////////// synchronizer & clock divider
    // synchronizer for rst_n
    reg rst_n_temp, rst_n;
    always @(posedge clk_s) begin
       if (!locked_cw0) begin
           {rst_n_temp,rst_n} <= 2'b00;
       end
       else begin
            {rst_n_temp,rst_n} <= {rst_n_in,rst_n_temp};
       end
    end

//////////////////////////////////////////////////// Modules
////// Clock Wizard
    CLK_WIZ cw1 (
        .clk_in1            (clk_s),
        .reset              (reset_cw0),
        .clk_out1           (pixel_clk),  // 25MHz
        .clk_out2           (clk),        // 200MHz
        .clk_out3           (clk_debug),  // 400MHz
        .locked             (locked_cw0)
        );
    assign reset_cw0 = 1'b0;

////// Block RAMs
    BRAM_RAW_IMAGE _blk0_displaying1 (
       // port a
       .clka               (clka_blk0),
       .ena                (ena_blk0),
       .wea                (wea_blk0),
       .addra              (addra_blk0),
       .dina               (dina_blk0),
       // port b
       .clkb               (clkb_blk0),
       .enb                (enb_blk0),
       .addrb              (addrb_blk0),
       .doutb              (doutb_blk0)
       );
    assign clkb_blk0 = clk_s;   // clk used to scan the displaying bram

    BRAM_RAW_IMAGE _blk1_fetched1 (
        // port a
        .clka               (clka_blk1),
        .ena                (ena_blk1),
        .wea                (wea_blk1),
        .addra              (addra_blk1),
        .dina               (dina_blk1),
        // port b
        .clkb               (clkb_blk1),
        .enb                (enb_blk1),
        .addrb              (addrb_blk1),
        .doutb              (doutb_blk1)
        );
    assign clkb_blk1 = clk_s;      // clk used to read from the fetched image bram
                                   // result writer clk 25MHz

    BRAM_INTEGRAL_IMAGE _blk2_integrated1 (
       // port a
       .clka               (clka_blk2),    
       .ena                (ena_blk2),
       .wea                (wea_blk2),
       .addra              (addra_blk2),
       .dina               (dina_blk2),
       // port b
       .clkb               (clkb_blk2),
       .enb                (enb_blk2),
       .addrb              (addrb_blk2),
       .doutb              (doutb_blk2)
       );
    assign clka_blk2 = clk_int;
    assign clkb_blk2 = clk_s;
    assign ena_blk2  = 1'b1 ;


    // wire detected;
//    assign done_rw0 = 1'b1;
    FACE_DETECTION_ENGINE _fde01 (
       .clk                    (clk),
       .rst_n                  (rst_n),
       // imager interface
       .new_image_ready        (new_image_ready_ii0),
       .write_next_frame       (write_next_frame_ii0),
       // BRAM of integrated image
       .din_bram_int           (doutb_blk2),
       .re_bram_int            (enb_blk2),
       .addr_bram_int          (addrb_blk2),
       // result writer
       .write_result_done_rw   (done_rw0),
       .write_result_start_rw  (start_rw0),
       .xpos                   (xpos),
       .ypos                   (ypos),
       .length                 (length),
       .state                  (state[2:0]),
       .detected               (detected)
       );

    wire busy_im0;
    // assign start_rw0 = dbg[0];
    RESULT_WRITER _rw01 (
       .clk                (pixel_clk),
       .rst_n              (rst_n),
       .start              (start_rw0),
       .done               (done_rw0),
       // input BRAM
       .doutb_blk1         (doutb_blk1),
       .addrb_blk1         (addrb_blk1),
       .enb_blk1           (enb_blk1),
       // output BRAM
       .dina_blk0          (dina_blk0),
       .addra_blk0         (addra_blk0),
       .ena_blk0           (ena_blk0),
       .wea_blk0           (wea_blk0),
       .clka_blk0          (clka_blk0),
       // FED
       .xposin             (xpos),
       .yposin             (ypos),
       .lengthin           (length),

       .busy_im0           (busy_im0),
       .state              (state[6:5]),
       .n_state            (state[8:7])
       );
    // assign xpos = 1;
    // assign ypos = 1;
    // assign length = 0;
    
    wire debug_busy_ii0;
    wire debug_href_ii0;
    wire debug_vsync_ii0;
    wire [3:0] debug_data_ii0;
    wire debug_valid_ii0;
    wire debug_oclk_ii0;
    wire [WIDTH_ADDR_PIXEL-1:0] debug_addr_ii0;
    wire address_valid;
    wire [9:0] debug_xpos, debug_ypos;
    wire debug_flagx, debug_flagy;
    assign debug_addr_ii0 = addra_blk1;
    IMAGER_INTERFACE _ii01 (
        .rst_n              (rst_n),
        .pixel_clk          (pixel_clk),
    ////// communication with CPU
        .write_next_frame   (write_next_frame_ii0),
        .done               (new_image_ready_ii0),
    ////// write data to BRAM
        .color_write        (dina_blk1),
        .address            (addra_blk1),
        .ena                (ena_blk1),
        .wea                (wea_blk1),
        .clka               (clka_blk1),
    ////// clk for integral computer
        .clk_int            (clk_int),
        .rst_ic             (rst_ic0),
    ////// OV7670
        // I2C Side
        .ov_I2C_SCLK        (ov_I2C_SCLK),    // I2C CLOCK
        .ov_I2C_SDAT        (ov_I2C_SDAT),    // I2C DATA
        // Sensor Interface
        .ov_CMOS_RST_N      (ov_CMOS_RST_N),  // cmos work state(5ms delay for sccb config)
        .ov_CMOS_PWDN       (ov_CMOS_PWDN),   // cmos power on    
        .ov_CMOS_XCLK       (ov_CMOS_XCLK),   // 25MHz
        .ov_CMOS_PCLK       (ov_CMOS_PCLK),   // 25MHz
        .ov_CMOS_iDATA      (ov_CMOS_iDATA),  // CMOS Data
        .ov_CMOS_VSYNC      (ov_CMOS_VSYNC),  // L: Vaild
        .ov_CMOS_HREF       (ov_CMOS_HREF),    // H: Vaild

        .busy               (debug_busy_ii0),
        .ov_href            (debug_href_ii0),
        .ov_vsync           (debug_vsync_ii0),
        .data               (debug_data_ii0),
        .valid              (debug_valid_ii0),
        .oclk               (debug_oclk_ii0),
        .state              (state[4:3]),
        .address_valid      (address_valid),
        .xpos               (debug_xpos),
        .ypos               (debug_ypos),
        .flagx              (debug_flagx),
        .flagy              (debug_flagy)
        );
   // assign write_next_frame_ii0 = dbg[1];

    INTEGRAL_COMPUTER _ic01 (
       .clk            (clk_int),
       .rst            (rst_ic0),
       .gray_in        (dina_blk1),
       .WE             (ena_blk1),
       .WE1            (wea_blk2),
       .A              (dina_blk2),
       .Waddra         (addra_blk2),
       .I              (idle_ic0)
       );
        
    IMAGE_READER _ir01 (
        .pixel_clk      (pixel_clk),
        .rst_n          (rst_n),
        .din            (doutb_blk0),
        .address        (addrb_blk0),
        .en_read        (enb_blk0),
        // direct outputs
        .vgaRed         (vgaRed),
        .vgaGreen       (vgaGreen),
        .vgaBlue        (vgaBlue),
        .hsync          (vgaHsync),
        .vsync          (vgaVsync)
        );
    

    wire addra_blk2_out_of_range;
    wire addra_blk1_out_of_range;
    assign addra_blk2_out_of_range = addra_blk2 >= 16'd40000;
    assign addra_blk1_out_of_range = addra_blk1 >= 16'd40000;
    ILA_FD _ila0_ii (
        .clk        (clk_debug),
        .probe0     (state[2:0]),
        .probe1     (state[4:3]),
        .probe2     (state[6:5]),
        .probe3     (detected),
        .probe4     (clka_blk0),
        .probe5     (ena_blk0),
        .probe6     (wea_blk0),
        .probe7     (dina_blk0[1:0]),
        .probe8     (addra_blk0[1:0])
        );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            {dbg,dbg_temp} <= 2'd0;
        end
        else begin
            {dbg,dbg_temp} <= {dbg_temp,dbg_in};
        end
    end // always
   
endmodule
