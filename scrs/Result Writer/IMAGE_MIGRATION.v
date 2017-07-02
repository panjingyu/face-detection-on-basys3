`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/15 15:09:15
// Design Name: 
// Module Name: IMAGE_MIGRATION
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


module IMAGE_MIGRATION
#(
	parameter
		WIDTH_ADDR = 5 'd16,
		WIDTH_DATA = 3 'd4,
		ADDR_MAX   = 16'd40000,
		S_IDLE     = 2 'b00,
		S_READ     = 2 'b01,
		S_WRIT     = 2 'b11
)
(
	input  clk, rst_n,
////// data & address of source BRAM
	input       [WIDTH_DATA-1:0] din,
	output      [WIDTH_ADDR-1:0] addrin,
	output 	reg      			 ein,
////// data & address of target BRAM
	output  reg [WIDTH_DATA-1:0] dout,
	output      [WIDTH_ADDR-1:0] addrout,
	output	reg                  eout,
	output	reg                  ewout,
	// output                       clkin,
	output					     clkout,   
////// communication & status signals
	input      start,
	output reg busy
    );
//    reg [WIDTH_ADDR-1:0] addrout;
	reg [1:0] current_state, next_state;
	reg [1:0] latency_cnt;
	reg [WIDTH_ADDR-1:0] addr;

	// clock
	// assign clkin  = ~clk;
	assign clkout = ~clk;
	// address
	assign addrin  = addr;	
	assign addrout = addr;

	// next_state logic
	always @(*) begin
		case (current_state)
			S_IDLE: begin
				if (start) begin
					next_state = S_READ;
				end
				else begin
					next_state = S_IDLE;
				end
			end
			S_READ: begin
				if (latency_cnt!=2'b10) begin
					next_state = S_READ;
				end
				else begin
					next_state = S_WRIT;
				end
			end
			S_WRIT: begin
				if (addr<ADDR_MAX-1) begin
					next_state = S_READ;
				end
				else begin
					next_state = S_IDLE;
				end
			end
			default: begin
				next_state = S_IDLE;
			end
		endcase
	end

	// output
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			addr <= {WIDTH_ADDR{1'b0}};
			{ein,eout,ewout} <= 3'b000;
			busy <= 1'b0;
		end
		else begin
			case (next_state)
				S_IDLE: begin
					addr <= {WIDTH_ADDR{1'b0}};
					{ein,eout,ewout} <= 3'b000;
					busy <= 1'b0;
				end
				S_READ: begin
					if (latency_cnt==2'b00) begin
						addr <= addr + 1;
					end
					else begin
						addr <= addr;
					end
					{ein,eout,ewout} <= 3'b100;
					busy <= 1'b1;
				end
				S_WRIT: begin
					addr <= addr;
					{ein,eout,ewout} <= 3'b111;
					busy <= 1'b1;
				end
				default: begin
                    addr <= {WIDTH_ADDR{1'b0}};
                    {ein,eout,ewout} <= 3'b000;
                    busy <= 1'b0;
               end
			endcase
		end
	end // always

	// state transmission
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			current_state <= S_IDLE;
		end
		else begin
			current_state <= next_state;
		end
	end // always

	// data transmission
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			dout <= {WIDTH_DATA{1'b0}};
		end
		else if (next_state==S_WRIT) begin
			dout <= din;
		end
		else begin
			dout <= {WIDTH_DATA{1'b0}};
		end
	end // always

	// latency_cnt
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			latency_cnt <= 2'b0;
		end
		else if (next_state==S_READ) begin
			latency_cnt <= latency_cnt + 2'd1;
		end
		else begin
			latency_cnt <= 2'b0;
		end
	end // always

endmodule
