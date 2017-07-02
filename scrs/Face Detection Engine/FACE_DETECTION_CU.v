`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/17 19:58:03
// Design Name: 
// Module Name: FACE_DETECTION_CU
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


module FACE_DETECTION_CU
#(
	parameter
		S_IDLE    = 3'b000,
		S_SEL_STA = 3'b001,
		S_SEL_WIN = 3'b011,
		S_RES_STA = 3'b010,
		S_RES_WIN = 3'b110,
		S_CAL_STA = 3'b111,
		S_CAL     = 3'b101,
		S_WRITE   = 3'b100
)
(
	input      clk, rst_n,
	// imager interface
	input      imager_done_im,
	output reg write_next_frame_im,
	// window selector
	input      windows_out_ws,
	input      done_ws,
	output reg break_ws,
	output reg select_window_start_ws,
	// window rescaler
	input      rescaler_busy_wr,
	output reg rescaler_start_wr,
	// classifier filter
	input      calculation_done_cf,
	input      face_detected_cf,
	output reg classifier_start_cf,
	// result writer
	input      write_result_done_rw,
	output reg write_result_start_rw,

	output [2:0] state
);

	reg [2:0] current_state, next_state;

	assign state = current_state;

	// next_state logic
	always @(*) begin
		case (current_state)
			S_IDLE: begin
				if (!imager_done_im) begin
					next_state = S_IDLE;
				end
				else begin
					next_state = S_SEL_STA;
				end
			end
			S_SEL_STA: begin
				next_state = S_SEL_WIN;
			end
			S_SEL_WIN: begin
				if (!done_ws) begin
					next_state = S_SEL_WIN;
				end
				else if (!windows_out_ws) begin
					next_state = S_RES_STA;
				end
				else begin
					next_state = S_WRITE;
				end
			end
			S_RES_STA: begin
				next_state = S_RES_WIN;
			end
			S_RES_WIN: begin
				if (rescaler_busy_wr) begin
					next_state = S_RES_WIN;
				end
				else begin
					next_state = S_CAL_STA;
				end
			end
			S_CAL_STA: begin
				next_state = S_CAL;
			end
			S_CAL: begin
				if (!calculation_done_cf) begin
					next_state = S_CAL;
				end
				else if (calculation_done_cf && !face_detected_cf) begin
					next_state = S_SEL_STA;
				end
				else begin
					next_state = S_WRITE;
				end
			end
			S_WRITE: begin
				if (!write_result_done_rw) begin
					next_state = S_WRITE;
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
			write_next_frame_im    <= 1'b0;
			break_ws			   <= 1'b0;
			select_window_start_ws <= 1'b0;
			rescaler_start_wr      <= 1'b0;
			classifier_start_cf    <= 1'b0;
			write_result_start_rw  <= 1'b0;
		end
		else begin
			case (next_state)
				S_IDLE: begin
					write_next_frame_im    <= 1'b1;//
					break_ws			   <= 1'b1;//
					select_window_start_ws <= 1'b0;
					rescaler_start_wr      <= 1'b0;
					classifier_start_cf    <= 1'b0;
					write_result_start_rw  <= 1'b0;
				end
				S_SEL_STA: begin
					write_next_frame_im    <= 1'b0;
					break_ws			   <= 1'b0;
					select_window_start_ws <= 1'b1;//
					rescaler_start_wr      <= 1'b0;
					classifier_start_cf    <= 1'b0;
					write_result_start_rw  <= 1'b0;
				end
				S_SEL_WIN: begin
					write_next_frame_im    <= 1'b0;
					break_ws			   <= 1'b0;
					select_window_start_ws <= 1'b0;
					rescaler_start_wr      <= 1'b0;
					classifier_start_cf    <= 1'b0;
					write_result_start_rw  <= 1'b0;
				end
				S_RES_STA: begin
					write_next_frame_im    <= 1'b0;
					break_ws			   <= 1'b0;
					select_window_start_ws <= 1'b0;
					rescaler_start_wr      <= 1'b1;//
					classifier_start_cf    <= 1'b0;
					write_result_start_rw  <= 1'b0;
				end
				S_RES_WIN: begin
					write_next_frame_im    <= 1'b0;
					break_ws			   <= 1'b0;
					select_window_start_ws <= 1'b0;
					rescaler_start_wr      <= 1'b0;
					classifier_start_cf    <= 1'b0;
					write_result_start_rw  <= 1'b0;
				end
				S_CAL_STA: begin
					write_next_frame_im    <= 1'b0;
					break_ws			   <= 1'b0;
					select_window_start_ws <= 1'b0;
					rescaler_start_wr      <= 1'b0;
					classifier_start_cf    <= 1'b1;//
					write_result_start_rw  <= 1'b0;
				end
				S_CAL: begin
					write_next_frame_im    <= 1'b0;
					break_ws			   <= 1'b0;
					select_window_start_ws <= 1'b0;
					rescaler_start_wr      <= 1'b0;
					classifier_start_cf    <= 1'b0;
					write_result_start_rw  <= 1'b0;
				end
				S_WRITE: begin
					write_next_frame_im    <= 1'b0;
					if (windows_out_ws) begin
						break_ws <= 1'b1;
					end
					else begin
						break_ws <= 1'b0;
					end
					select_window_start_ws <= 1'b0;
					rescaler_start_wr      <= 1'b0;
					classifier_start_cf    <= 1'b0;
					write_result_start_rw  <= 1'b1;//
				end
				default: begin
					write_next_frame_im    <= 1'b0;
					break_ws			   <= 1'b0;
					select_window_start_ws <= 1'b0;
					rescaler_start_wr      <= 1'b0;
					classifier_start_cf    <= 1'b0;
					write_result_start_rw  <= 1'b0;
				end
			endcase
		end
	end // always

	// state transmision
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
