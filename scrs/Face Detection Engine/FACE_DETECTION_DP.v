`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/17 19:58:03
// Design Name: 
// Module Name: FACE_DETECTION_DP
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


module FACE_DETECTION_DP
#(
	parameter
		WIDTH_ADDR = 4'd10,
		WIDTH_INTE_ADDR = 5'd16,
		WIDTH_POSI = 4'd8,
		WIDTH_INTE = 5'd20
)
(
	input  clk, rst_n,

////// CU
	// imager interface
	input  write_next_frame_dp,
	output new_image_ready_dp,

	// window selector
	input  select_window_start_ws,
	input  break_ws,
	output done_ws,
	output windows_out_ws,

	// window rescaler
	input  rescaler_start_wr,
	output busy_wr,

	// classifier
	input  classifier_start_c,
	output final_judge_c,
	output classifier_done_c,

    // result writer
	input  write_result_start_dp,
	// output write_result_done_dp,

////// outside
	// Block RAM of integrated image
	input  [WIDTH_INTE-1:0] data_int,
	output                  re_bram_int,
	output [WIDTH_INTE_ADDR-1:0] addr_bram_int,

	// imager interface
	input  new_image_ready,
	output write_next_frame,

	// result writer
	// input      write_result_done,
	output reg write_result_start,
	output     [WIDTH_POSI-1:0] xpos_ws,
	output     [WIDTH_POSI-1:0] ypos_ws,
	output     [WIDTH_POSI-1:0] length_ws

);

////// classifier
	wire final_judge, all_done;
////// window selector
    wire [3:0] multiple_ws;
////// ram window
	wire we_rw;
	wire [WIDTH_ADDR-1:0] dpra_rw;
	wire [WIDTH_ADDR-1:0] a_rw1, a_rw2;
	wire [WIDTH_ADDR-1:0] a_rw;
	wire [WIDTH_INTE-1:0] d_rw, dpo_rw;

	assign a_rw = a_rw1 | a_rw2;
	
	// imager interface signals
	assign new_image_ready_dp = new_image_ready;
	assign write_next_frame   = write_next_frame_dp;

	// assign write_result_done_dp = write_result_done;

	WINDOW_SELECTOR _ws (
		.clk				(clk),
		.rst_n				(rst_n),
		// input
		.sel_next_window	(select_window_start_ws),
		.break				(break_ws),
		// output
		.done				(done_ws),
		.xpos				(xpos_ws),
		.ypos				(ypos_ws),
		.multiple			(multiple_ws),
		.length 			(length_ws),
		.windows_out_dp 	(windows_out_ws)
		);
		
    CLASSIFIER _c (
        .clk			(clk),
        .rst_n			(rst_n),
        // input
        .start          (classifier_start_c),
        .data_in		(dpo_rw),
        // output
        .add 			(a_rw1),
        .final_judge	(final_judge_c),
        .all_done 		(classifier_done_c)
        );

    RAM_WINDOW _rw (
    	// input
    	.clk			(clk),
    	.a 				(a_rw),
    	.d 				(d_rw),
    	.dpra 			(dpra_rw),
    	.we  			(we_rw),
    	//output
    	.dpo 			(dpo_rw)
    	);
    
    wire re2;   // abondoned
    RESCALER _r (
    	.clk 			(clk),
    	.rst 			(rst_n),
    	// input
    	.col			(xpos_ws),
    	.row 			(ypos_ws),
    	.n 				(multiple_ws),
    	.H 				(rescaler_start_wr),
    	.A 				(data_int),
    	.B 				(dpo_rw),
    	// output
    	.F 				(d_rw),
    	.WE             (we_rw),
    	.RE1			(re_bram_int),
    	.raddra1		(addr_bram_int),
    	.RE2            (re2), // not needed
    	.raddra2		(a_rw2),
    	.waddra			(dpra_rw),
    	.Busy 			(busy_wr)
    	);

    always @(posedge clk or negedge rst_n) begin
    	if (!rst_n) begin
    		// reset
    		write_result_start <= 1'b0;
    	end
    	else if (write_result_start_dp) begin
    		write_result_start <= 1'b1;
    	end
    	else begin
    		write_result_start <= 1'b0;
    	end
    end // always

endmodule
