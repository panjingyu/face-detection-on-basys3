`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/08 19:21:11
// Design Name: 
// Module Name: IMAGE_READER
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


module IMAGE_READER
#(
	parameter
		WIDTH_ADDR  =     16,       // width of 200x200=40000 addresses
		WIDTH_COLOR =     4,
		WIDTH_POS   = 4'd 10,	    // width of position (in 640x480 resolution)
		WIDTH_IMG   = 8'd 200,
		HEIGHT_IMG  = 8'd 200
)
(
// ports for VGA output
	input                   	pixel_clk,
	input                   	rst_n,
	input  [WIDTH_COLOR-1:0]	din,
	output [WIDTH_ADDR-1:0]  	address,
	output 						en_read,
	// below should be direct outputs
	output hsync, vsync,
	output [WIDTH_COLOR-1:0] vgaRed, vgaGreen, vgaBlue

);

///////////////////////////// VGA ///////////////////////////////////////

	wire [WIDTH_POS-1:0]     xpos, ypos;

    wire [3*WIDTH_COLOR-1:0] color;
    wire in_range;

	VGA_INTERFACE _vga0 (
		.pixel_clk 	(pixel_clk),
		.rst_n 		(rst_n),
		.color		(color),
		.xpos		(xpos),
		.ypos		(ypos),
		// direct outputs
		.hsync		(hsync),
		.vsync		(vsync),
		.red  		(vgaRed),
		.green     	(vgaGreen),
		.blue 		(vgaBlue)
		);


	assign in_range = ( xpos < WIDTH_IMG && ypos < HEIGHT_IMG );
	assign color    = in_range ? {3{din}} : {3*WIDTH_COLOR{1'b0}};
	assign address  = in_range ? xpos + ypos * WIDTH_IMG : {WIDTH_ADDR{1'b0}};
	assign en_read  = 1'b1;	// always enable reading

endmodule
