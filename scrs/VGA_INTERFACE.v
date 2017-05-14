`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/05/12 08:35:45
// Design Name: 
// Module Name: VGA_INTERFACE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 640x480x60Hz Resolution
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA_INTERFACE
#(
	parameter
		WIDTH_COLOR = 4'd12,	// basys3 uses 12bit per pixel
		WIDTH_POS   = 4'd10	// width of position
)
(
	input rst_n,
	input pixel_clk,
	input [WIDTH_COLOR-1:0] color,
	output [WIDTH_POS-1:0] xpos, ypos,
	output hsync, vsync,
	output [WIDTH_COLOR/3-1:0] red, green, blue
);

	VGA_CONTROLLER vc0 (
		.rst_n(rst_n),
		.pixel_clk(pixel_clk),
		.xpos(xpos),
		.ypos(ypos),
		.hsync(hsync),
		.vsync(vsync)
		);

	assign red   = color [WIDTH_COLOR-1:WIDTH_COLOR/3*2-1];
	assign green = color [WIDTH_COLOR/3*2-1:WIDTH_COLOR/3-1];
	assign blue  = color [WIDTH_COLOR/3-1:0];

endmodule
