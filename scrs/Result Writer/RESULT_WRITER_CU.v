`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/20 19:28:13
// Design Name: 
// Module Name: RESULT_WRITER_CU
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


module RESULT_WRITER_CU
#(
	parameter
		WIDTH_PIXEL = 3'd4,
		WIDTH_ADDR  = 5'd16,
		WIDTH_POSI  = 4'd8,
		S_IDLE      = 2'b00,
		S_START     = 2'b01,
		S_BUSY      = 2'b11,
		S_WAIT      = 2'b10
)
(
	
	input  clk, rst_n,

	// general
	input      start,
	output reg done,

	// Image Migration
	input      busy_im,
	output reg start_im,

	// FDE
	input      [WIDTH_POSI-1:0] xposin,
	input      [WIDTH_POSI-1:0] yposin,
	input      [WIDTH_POSI-1:0] lengthin,
	output reg [WIDTH_POSI-1:0] xpos,
	output reg [WIDTH_POSI-1:0] ypos,
	output reg [WIDTH_POSI-1:0] length,
	output     [1:0]            state,
	output     [1:0]            n_state

);



	reg [1:0] current_state, next_state;
	reg [2:0] cnt;
	wire      cnt_pos;
	assign cnt_pos = |cnt;
	assign state = current_state;
	assign n_state = next_state;

	// next_state logic
	always @(*) begin
		case (current_state)
			S_IDLE: begin
				if (start) begin
					next_state = S_START;
				end
				else begin
					next_state = S_IDLE;
				end
			end
			S_START: begin
				next_state = S_BUSY;
			end
			S_BUSY: begin
				if (busy_im) begin
					next_state = S_BUSY;
				end
				else if (cnt_pos) begin
					next_state = S_START;
				end
				else begin
					next_state = S_WAIT;
				end
			end
			S_WAIT: begin
				next_state = S_IDLE;
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
			{xpos,ypos,length} <= {{3{{WIDTH_POSI{1'b0}}}}};
			start_im <= 1'b0;
			done <= 1'b0;
			cnt <= 3'd0;
		end
		else begin
			case (next_state)
				S_IDLE: begin
					{xpos,ypos,length} <= {{3{{WIDTH_POSI{1'b0}}}}};
					start_im <= 1'b0;
				   done <= 1'b0;
				   cnt  <= 3'd0;
				end
				S_START: begin
					xpos <= (cnt==3'd0)? xposin : xpos;
					ypos <= (cnt==3'd0)? yposin : ypos;
					length <= lengthin;
					start_im <= 1'b1;
					done <= 1'b0;
					cnt <= cnt + 3'd1;
				end
				S_BUSY: begin
					xpos <= xpos;
					ypos <= ypos;
					length <= length;
					start_im <= 1'b0;
					done <= 1'b0;
					cnt  <= cnt;
				end
				S_WAIT: begin
					{xpos,ypos,length} <= {{3{{WIDTH_POSI{1'b0}}}}};
					start_im <= 1'b0;
					done <= 1'b1;
					cnt  <= 3'd0;
				end
				default: begin
					{xpos,ypos,length} <= {{3{{WIDTH_POSI{1'b0}}}}};
					start_im <= 1'b0;
					done <= 1'b1;
					cnt <= 3'd0;
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

endmodule
