`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/05/12 08:25:04
// Design Name: 
// Module Name: IMAGER_INTERFACE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// This module is for formating the inputs of our system
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IMAGER_INTERFACE
#(
	parameter
		WIDTH_ADDR  = 5'd  16,	// width of address
		WIDTH_COLOR = 3'd  4 ,
		WIDTH_IMG   = 8'd  200,
		HEIGHT_IMG  = 8'd  200,
		PIXEL_NUL   = 16'd 40000,
		WIDTH_MAX	= 10'd 640,
		HEIGHT_MAX	= 9'd  480,
		IDLE 		= 2'd  0,
		READY		= 2'd  1,
		WRITING 	= 2'd  2, 
		PAUSE		= 2'd  3
)
(
	input  rst_n, pixel_clk,	// pixel_clk shoule be 25MHz

////// communication with CPU
	input      write_next_frame,
	output     done,

////// write data to BRAM
	output      [WIDTH_COLOR-1:0] 	color_write,
	output      [WIDTH_ADDR-1:0]  	address,
	output 	         				ena,
	output	     	     			wea,
	output reg			     		clka,

////// clk for integral computer
	output     clk_int,
	output     rst_ic,
	
////// OV7670
    // I2C Side
    output                ov_I2C_SCLK,    // I2C CLOCK
    inout                 ov_I2C_SDAT,    // I2C DATA
    // Sensor Interface
    output                ov_CMOS_RST_N,        // cmos work state(5ms delay for sccb config)
    output                ov_CMOS_PWDN,         // cmos power on    
    output                ov_CMOS_XCLK,         // 25MHz
    input                 ov_CMOS_PCLK,         // 25MHz
    input    [7:0]        ov_CMOS_iDATA,        // CMOS Data
    input                 ov_CMOS_VSYNC,        // L: Vaild
    input                 ov_CMOS_HREF,         // H: Vaild

    output busy,
	output ov_vsync, ov_href,
	output [WIDTH_COLOR-1:0] data,
	output valid,
	output oclk,
	output [1:0] state,
	output address_valid,
	output [9:0] xpos, ypos,
	output       flagx, flagy
);


////// Ouput Sensor Data
	wire 	    ov_CMOS_oCLK;		//1/2 PCLK
	wire [11:0]	ov_CMOS_oDATA;
	wire        ov_CMOS_VALID;

	I2C_AV_CONFIG _i2cavconfig (
		.iCLK			(pixel_clk),
		.iRST_N			(rst_n),
		.I2C_SCLK		(ov_I2C_SCLK),
		.I2C_SDAT		(ov_I2C_SDAT),
		.CMOS_RST_N		(ov_CMOS_RST_N),
		.CMOS_PWDN		(ov_CMOS_PWDN),
		.CMOS_XCLK		(ov_CMOS_XCLK),
		.CMOS_PCLK		(ov_CMOS_PCLK),
		.CMOS_iDATA		(ov_CMOS_iDATA),
		.CMOS_VSYNC		(ov_CMOS_VSYNC),
		.CMOS_HREF		(ov_CMOS_HREF),
		.CMOS_oCLK		(ov_CMOS_oCLK),
		.CMOS_oDATA		(ov_CMOS_oDATA),
		.VSYNC			(ov_vsync),
		.HREF     		(ov_href),
		.CMOS_VALID		(ov_CMOS_VALID)
		);

////// convert RGB to Gray
	RGB2GRAY _rgb2g (
	    .rgb   (ov_CMOS_oDATA),
	    .gray  (data)
	    );

	IMAGER_INTERFACE_CU _ii_cu (
		.pixel_clk			(pixel_clk),
		.rst_n 				(rst_n),
		.write_next_frame	(write_next_frame),
		.done				(done),
		.color_write		(color_write),
		.ena 				(ena),
		.wea 				(wea),
		// .clka 				(clka),
		.data 				(data),
		.ov_href            (ov_href),
		.ov_vsync           (ov_vsync),
		.ov_CMOS_oCLK 		(ov_CMOS_oCLK),
		.ov_CMOS_VALID 		(ov_CMOS_VALID),
		.address 			(address),
		.rst_ic				(rst_ic),
		.busy               (busy),
		.state 				(state),
		.address_valid 		(address_valid),
		.xpos 				(xpos),
		.ypos				(ypos),
		.flagx 				(flagx),
		.flagy 				(flagy)
		);
		
//		assign clk_int = ov_CMOS_oCLK;
	assign valid = ov_CMOS_VALID;
	assign oclk  = ov_CMOS_oCLK;
	assign clk_int  = clka;

	always @(posedge ov_CMOS_oCLK or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			clka <= 1'b1;
		end
		else if (!ov_CMOS_VALID) begin
			clka <= 1'b1;
		end
		else begin
			clka <= ~clka;
		end
	end // always

endmodule

module IMAGER_INTERFACE_CU 
#(
	parameter
		WIDTH_ADDR  = 5'd  16,	// width of address
		WIDTH_COLOR = 3'd  4 ,
		WIDTH_IMG   = 8'd  200,
		HEIGHT_IMG  = 8'd  200,
		PIXEL_NUL   = 16'd 40000,
		WIDTH_MAX	= 10'd 640,
		HEIGHT_MAX	= 9'd  480,
		IDLE 		= 2'd  0,
		READY		= 2'd  1,
		WRITING 	= 2'd  2, 
		PAUSE		= 2'd  3
)
(
	input  pixel_clk, rst_n,

////// communication with CPU
	input      write_next_frame,
	output reg done,

////// write data to BRAM
	output  reg [WIDTH_COLOR-1:0] 	color_write,
	output 	reg      				ena,
	output	reg  	     			wea,
	// output	     		     		clka,
	input 		[WIDTH_COLOR-1:0]	data,
////// control signals
	input  							ov_CMOS_oCLK,
	input 							ov_CMOS_VALID,
	input                           ov_href,
	input                           ov_vsync,
	output  	[WIDTH_ADDR-1:0] 	address,
	output  reg 					rst_ic,
	output  reg                     busy,
	output             [1:0]        state,
	output 							address_valid,
	output  reg [9:0]	xpos, ypos,
	output  reg         flagx, flagy
);

	reg [1:0] current_state,next_state;
	reg old_href, old_vsync;
//	reg busy;

	// reg [2:0] cnt;

//////////////write data to bram//////////////////
	// wire address_valid;
	// assign clka = ~pixel_clk;
	assign address_valid = (xpos<=WIDTH_IMG-1 && ypos<=HEIGHT_IMG-1);
	assign address = (address_valid)? xpos + ypos*WIDTH_IMG : {WIDTH_ADDR{1'b0}};
	assign state = current_state;

////// Control FSM

	// next_state logic
	always @(*) begin
		if (!ov_CMOS_VALID) begin
			next_state = IDLE;
		end
		else begin
			case(current_state)
				IDLE: begin
					if (write_next_frame) begin 
						next_state = READY;
					end
					else begin
						next_state = IDLE;
					end
				end
				READY: begin
					if (ov_vsync) begin
						next_state = PAUSE;
					end
					else begin
						next_state = READY;
					end
				end
				WRITING: begin
					if (ov_href && address_valid) begin
						next_state = WRITING;
					end
					else begin
						next_state = PAUSE;
					end
				end
				PAUSE: begin
					if  (!old_vsync && ov_vsync) begin
						next_state = IDLE;
					end
					else if (!old_href && ov_href) begin
						next_state = WRITING;
					end
					else begin
						next_state = PAUSE;
					end
				end
				default: next_state = IDLE;
			endcase
		end
	end
	
	// old ov_href
	always @(posedge ov_CMOS_oCLK or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			old_href  <= 1'b0;
			old_vsync <= 1'b0;
		end
		else if (!ov_CMOS_VALID) begin
			old_href  <= 1'b0;
			old_vsync <= 1'b0;
		end
		else begin
			old_href  <= ov_href;
			old_vsync <= ov_vsync;
		end
	end // always


	// state transmission
	always @(posedge ov_CMOS_oCLK or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			current_state <= IDLE;
		end
		else if (!ov_CMOS_VALID) begin
			current_state <= IDLE;
		end
		else begin
			current_state <= next_state;
		end
	end

	// output
	always @(posedge pixel_clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			ena <= 1'b0;
			wea <= 1'b0;
			busy <= 1'b0;
			color_write <= {WIDTH_COLOR{1'b0}};
			rst_ic <= 1'b0;
			done <= 1'b0;

			// cnt <= 3'd0;
		end
		else if (!ov_CMOS_VALID) begin
			ena <= 1'b0;
			wea <= 1'b0;
			busy <= 1'b0;
			color_write <= {WIDTH_COLOR{1'b0}};
			rst_ic <= 1'b0;
			done <= 1'b0;

			// cnt <= 3'd0;
		end
		else begin

			case (next_state)
				IDLE: begin
				    ena  <= 1'b0;
					wea  <= 1'b0;
					busy <= 1'b0;
					color_write <= {WIDTH_COLOR{1'b0}};
					rst_ic <= 1'b0;
				end
				READY: begin
					ena  <= 1'b0;
					wea  <= 1'b0;
					busy <= 1'b1;
					color_write <= {WIDTH_COLOR{1'b0}};
					rst_ic <= 1'b1;
				end
				WRITING: begin
					ena  <= (flagy) ? 1'b1 : 1'b0;
					wea  <= (flagx&&flagy) ? 1'b1 : 1'b0;
					busy <= 1'b1;
					color_write <= (flagx&&flagy) ? data : color_write;
					rst_ic <= 1'b1;
				end
				PAUSE: begin
					ena  <= 1'b0;
					wea  <= 1'b0;
					busy <= 1'b1;
					color_write <= {WIDTH_COLOR{1'b0}};
					rst_ic <= 1'b1;
				end
			endcase

			if (next_state==IDLE && busy) begin
				done <= 1'b1;
			end
			else begin
				done <= 1'b0;
			end
		end
	end



///////////////////////////////////////////////////////////////

	// position
	always @(posedge ov_CMOS_oCLK or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			xpos <= 10'd0;
			ypos <= 10'd0;
			flagx <= 1'b0;
			flagy <= 1'b0;
		end
		else if (!ov_CMOS_VALID) begin
			xpos <= 10'd0;
			ypos <= 10'd0;
			flagx <= 1'b0;
			flagy <= 1'b0;
		end
		else begin
			// ypos
			if (old_href && !ov_href && ypos<HEIGHT_MAX-1) begin
				ypos <= flagy ? ypos + 10'd1 : ypos;
				flagy <= ~flagy;
			end
			else if (next_state==IDLE) begin
				ypos <= 10'd0;
				flagy <= 1'b0;
			end
			else begin
				ypos  <= ypos;
				flagy <= flagy;
			end
			// xpos
			if (ov_href && xpos<WIDTH_MAX-1 && next_state==WRITING) begin
				xpos <= flagx ? xpos + 10'd1 : xpos;
				flagx <= ~flagx;
			end
			else begin
				xpos <= 10'd0;
				flagx <= 1'b0;
			end
		end
	end // always

endmodule
