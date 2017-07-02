`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/17 19:58:03
// Design Name: 
// Module Name: FACE_DETECTION_ENGINE
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


module FACE_DETECTION_ENGINE
#(
	parameter
		WIDTH_INTE = 5'd20,
		WIDTH_INTE_ADDR = 5'd16,
		WIDTH_ADDR = 4'd10,
		WIDTH_POSI = 4'd8
)
(
	
	input clk, rst_n,

	// imager interface
	input                   new_image_ready,
	output                  write_next_frame,

	// Block RAM of integrated image
	input  [WIDTH_INTE-1:0]       din_bram_int,
	output				       	  re_bram_int,
	output [WIDTH_INTE_ADDR-1:0]  addr_bram_int,

	// result writer
	input                   write_result_done_rw,
	output                  write_result_start_rw,
	output [WIDTH_POSI-1:0] xpos,
	output [WIDTH_POSI-1:0] ypos,
	output [WIDTH_POSI-1:0] length,

	output [2:0] state,
	output detected

);

	// imager interface
	wire new_image_ready_dp;
	wire write_next_frame_dp;
	// window selector
	wire windows_out_ws;
	wire done_ws;
	wire break_ws;
	wire select_window_start_ws;
	// window rescaler
	wire rescaler_busy_wr;
	wire rescaler_start_wr;
	// classifier filter
	wire classifier_done_cf;
	wire final_judge_cf;
	wire classifier_start_cf;
	// result writer
	wire write_result_start_dp;
	// wire write_result_done_dp;

	assign detected = final_judge_cf;
	FACE_DETECTION_CU _fdc0 (
		.clk 						(clk),
		.rst_n						(rst_n),
		// imager interface
		.imager_done_im				(new_image_ready_dp),
		.write_next_frame_im		(write_next_frame_dp),
		// window selector
		.windows_out_ws				(windows_out_ws),
		.done_ws					(done_ws),
		.break_ws					(break_ws),
		.select_window_start_ws		(select_window_start_ws),
		// window rescaler
		.rescaler_busy_wr			(rescaler_busy_wr),
		.rescaler_start_wr			(rescaler_start_wr),
		// classifier filter
		.calculation_done_cf		(classifier_done_cf),
		.face_detected_cf			(final_judge_cf),
		.classifier_start_cf		(classifier_start_cf),
		// write result
		.write_result_done_rw		(write_result_done_rw),
		.write_result_start_rw		(write_result_start_dp),

		.state						(state)
		);


	FACE_DETECTION_DP _fdp0 (
		.clk 						(clk),
		.rst_n						(rst_n),
	////// Control Unit
		// imager interface
		.write_next_frame_dp		(write_next_frame_dp),
		.new_image_ready_dp			(new_image_ready_dp),
		// window selector
		.select_window_start_ws		(select_window_start_ws),
		.break_ws					(break_ws),
		.done_ws					(done_ws),
		.windows_out_ws				(windows_out_ws),
		// window rescaler
		.rescaler_start_wr			(rescaler_start_wr),
		.busy_wr					(rescaler_busy_wr),
		// classifier filter
		.classifier_start_c			(classifier_start_cf),
		.final_judge_c				(final_judge_cf),
		.classifier_done_c			(classifier_done_cf),
		// result writer
		.write_result_start_dp      (write_result_start_dp),
		// .write_result_done_dp 		(write_result_done_dp),
	////// outside 
		// BRAM of integrated image
		.data_int					(din_bram_int),
		.re_bram_int				(re_bram_int),
		.addr_bram_int				(addr_bram_int),
		// imager interface
		.new_image_ready			(new_image_ready),
		.write_next_frame 			(write_next_frame),
		// result writer
		.write_result_start 		(write_result_start_rw),
		// .write_result_done 			(write_result_done_rw),
		.xpos_ws 					(xpos),
		.ypos_ws 					(ypos),
		.length_ws					(length)
		);

endmodule
