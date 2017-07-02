`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/20 19:02:35
// Design Name: 
// Module Name: RESULT_WRITER
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


module RESULT_WRITER
#(
	parameter
		WIDTH_PIXEL = 3'd4,
		WIDTH_ADDR  = 5'd16,
		WIDTH_POSI  = 4'd8
)
(
	input  clk, rst_n,

	// BRAM of fetched image
	input  [WIDTH_PIXEL-1:0] doutb_blk1,
	output [WIDTH_ADDR-1:0]  addrb_blk1,
	output                   enb_blk1,
	// output                   clkb_blk1,

	// BRAM of displaying image
	output [WIDTH_PIXEL-1:0] dina_blk0,
	output [WIDTH_ADDR-1:0]  addra_blk0,
	output                   ena_blk0,
	output                   wea_blk0,
	output					 clka_blk0,

	// Face Detection Engine
	input  					 start,
	output                   done,
	input  [WIDTH_POSI-1:0]  xposin,
	input  [WIDTH_POSI-1:0]  yposin,
	input  [WIDTH_POSI-1:0]  lengthin,

	output busy_im0,
	output [1:0] state,
	output [1:0] n_state
);

	// Image Migration
	wire start_im0;

	// Face Marker
	wire [WIDTH_PIXEL-1:0] datain;
	wire [WIDTH_ADDR-1:0]  addrin;

	wire  [WIDTH_POSI-1:0]  xpos, ypos, length;


	RESULT_WRITER_CU _rwcu0 (
		.clk 				(clk),
		.rst_n				(rst_n),
		// Face Detection Engine
		.start 				(start),
		.done 				(done),
		.xposin 			(xposin),
		.yposin				(yposin),
		.lengthin			(lengthin),
		// Image Migration
		.start_im 			(start_im0),
		.busy_im 			(busy_im0),
		.state 				(state),
		.n_state 			(n_state),
		// Face Marker
		.xpos 				(xpos),
		.ypos 				(ypos),
		.length 			(length)
		);

    IMAGE_MIGRATION _im0 (
        .clk                (clk),
        .rst_n              (rst_n),
        .start              (start_im0),
        .busy               (busy_im0),
        // input ports
        .din                (doutb_blk1),
        .addrin             (addrb_blk1),
        .ein                (enb_blk1),
        // .clkin              (clkb_blk1),
        // output ports
        .dout               (datain),
        .addrout            (addrin),
        .eout               (ena_blk0),
        .ewout              (wea_blk0),
        .clkout             (clka_blk0)
        );

    FACE_MARKER _fm0 (
    	// input
    	.xpos				(xpos),
    	.ypos				(ypos),
    	.length				(length),
    	.data_in			(datain),
    	.addr_in			(addrin),
    	// output
    	.data_out			(dina_blk0),
    	.addr_out			(addra_blk0)
    	);

endmodule
