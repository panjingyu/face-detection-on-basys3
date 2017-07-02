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

module FACE_MARKER
#(
	parameter
		WIDTH_WINDOW		=		8,
		WIDTH_DATA			=		4,
		WIDTH_ADDR			=		16
)(
	input 	[WIDTH_WINDOW-1:0] 	 xpos,ypos,length,
	input 	[WIDTH_DATA-1:0]	 data_in,
	input	[WIDTH_ADDR-1:0]	 addr_in,
	///////////////////source window bram//////////////////
	output	reg [WIDTH_DATA-1:0]	 data_out,
	output		[WIDTH_ADDR-1:0]	 addr_out
	///////////////////target window bram//////////////////
);
	wire [WIDTH_ADDR-1:0] addr_leftup , addr_rightup , addr_leftdown , addr_rightdown;

	assign addr_leftup = (ypos-1) * 200 + (xpos-1);							//识别框最左上角像素点对应的bram地址
	assign addr_leftdown = (ypos+length-1) * 200 + (xpos-1);				//识别框最左下角像素点对应的bram地址
	assign addr_rightup = (ypos-1) * 200 + (xpos+length-1);					//识别框最右上角像素点对应的bram地址
	assign addr_rightdown = (ypos+length-1) * 200 + (xpos+length-1);		//识别框最右下角像素点对应的bram地址
	assign addr_out = addr_in;
	
	always @(*) begin
		if(length == 0) begin
			data_out <= data_in;
		end
		else if(
				(
				(
				(addr_in - addr_leftup == 200) ||
				(addr_in - addr_leftup == 400) ||
				(addr_in - addr_leftup == 600) ||
				(addr_in - addr_leftup == 800) ||
				(addr_in - addr_leftup == 1000) ||
				(addr_in - addr_leftup == 1200) ||
				(addr_in - addr_leftup == 1400) ||
				(addr_in - addr_leftup == 1600) ||
				(addr_in - addr_leftup == 1800) ||
				(addr_in - addr_leftup == 2000) ||
				(addr_in - addr_leftup == 2200) ||
				(addr_in - addr_leftup == 2400) ||
				(addr_in - addr_leftup == 2600) ||
				(addr_in - addr_leftup == 2800) ||
				(addr_in - addr_leftup == 3000) ||
				(addr_in - addr_leftup == 3200) ||
				(addr_in - addr_leftup == 3400) ||
				(addr_in - addr_leftup == 3600) ||
				(addr_in - addr_leftup == 3800) ||
				(addr_in - addr_leftup == 4000) ||
				(addr_in - addr_leftup == 4200) ||
				(addr_in - addr_leftup == 4400) ||
				(addr_in - addr_leftup == 4600) ||
				(addr_in - addr_leftup == 4800) ||
				(addr_in - addr_leftup == 5000) ||
				(addr_in - addr_leftup == 5200) ||
				(addr_in - addr_leftup == 5400) ||
				(addr_in - addr_leftup == 5600) ||
				(addr_in - addr_leftup == 5800) ||
				(addr_in - addr_leftup == 6000) ||
				(addr_in - addr_leftup == 6200) ||
				(addr_in - addr_leftup == 6400) ||
				(addr_in - addr_leftup == 6600) ||
				(addr_in - addr_leftup == 6800) ||
				(addr_in - addr_leftup == 7000) ||
				(addr_in - addr_leftup == 7200) ||
				(addr_in - addr_leftup == 7400) ||
				(addr_in - addr_leftup == 7600) ||
				(addr_in - addr_leftup == 7800) ||
				(addr_in - addr_leftup == 8000) ||
				(addr_in - addr_leftup == 8200) ||
				(addr_in - addr_leftup == 8400) ||
				(addr_in - addr_leftup == 8600) ||
				(addr_in - addr_leftup == 8800) ||
				(addr_in - addr_leftup == 9000) ||
				(addr_in - addr_leftup == 9200) ||
				(addr_in - addr_leftup == 9400) ||
				(addr_in - addr_leftup == 9600) ||
				(addr_in - addr_leftup == 9800) ||
				(addr_in - addr_leftup == 10000) ||
				(addr_in - addr_leftup == 10200) ||
				(addr_in - addr_leftup == 10400) ||
				(addr_in - addr_leftup == 10600) ||
				(addr_in - addr_leftup == 10800) ||
				(addr_in - addr_leftup == 11000) ||
				(addr_in - addr_leftup == 11200) ||
				(addr_in - addr_leftup == 11400) ||
				(addr_in - addr_leftup == 11600) ||
				(addr_in - addr_leftup == 11800) ||
				(addr_in - addr_leftup == 12000) ||
				(addr_in - addr_leftup == 12200) ||
				(addr_in - addr_leftup == 12400) ||
				(addr_in - addr_leftup == 12600) ||
				(addr_in - addr_leftup == 12800) ||
				(addr_in - addr_leftup == 13000) ||
				(addr_in - addr_leftup == 13200) ||
				(addr_in - addr_leftup == 13400) ||
				(addr_in - addr_leftup == 13600) ||
				(addr_in - addr_leftup == 13800) ||
				(addr_in - addr_leftup == 14000) ||
				(addr_in - addr_leftup == 14200) ||
				(addr_in - addr_leftup == 14400) ||
				(addr_in - addr_leftup == 14600) ||
				(addr_in - addr_leftup == 14800) ||
				(addr_in - addr_leftup == 15000) ||
				(addr_in - addr_leftup == 15200) ||
				(addr_in - addr_leftup == 15400) ||
				(addr_in - addr_leftup == 15600) ||
				(addr_in - addr_leftup == 15800) ||
				(addr_in - addr_leftup == 16000) ||
				(addr_in - addr_leftup == 16200) ||
				(addr_in - addr_leftup == 16400) ||
				(addr_in - addr_leftup == 16600) ||
				(addr_in - addr_leftup == 16800) ||
				(addr_in - addr_leftup == 17000) ||
				(addr_in - addr_leftup == 17200) ||
				(addr_in - addr_leftup == 17400) ||
				(addr_in - addr_leftup == 17600) ||
				(addr_in - addr_leftup == 17800) ||
				(addr_in - addr_leftup == 18000) ||
				(addr_in - addr_leftup == 18200) ||
				(addr_in - addr_leftup == 18400) ||
				(addr_in - addr_leftup == 18600) ||
				(addr_in - addr_leftup == 18800) ||
				(addr_in - addr_leftup == 19000) ||
				(addr_in - addr_leftup == 19200) ||
				(addr_in - addr_leftup == 19400) ||
				(addr_in - addr_leftup == 19600) ||
				(addr_in - addr_leftup == 19800) ||
				(addr_in - addr_leftup == 20000) ||
				(addr_in - addr_leftup == 20200) ||
				(addr_in - addr_leftup == 20400) ||
				(addr_in - addr_leftup == 20600) ||
				(addr_in - addr_leftup == 20800) ||
				(addr_in - addr_leftup == 21000) ||
				(addr_in - addr_leftup == 21200) ||
				(addr_in - addr_leftup == 21400) ||
				(addr_in - addr_leftup == 21600) ||
				(addr_in - addr_leftup == 21800) ||
				(addr_in - addr_leftup == 22000) ||
				(addr_in - addr_leftup == 22200) ||
				(addr_in - addr_leftup == 22400) ||
				(addr_in - addr_leftup == 22600) ||
				(addr_in - addr_leftup == 22800) ||
				(addr_in - addr_leftup == 23000) ||
				(addr_in - addr_leftup == 23200) ||
				(addr_in - addr_leftup == 23400) ||
				(addr_in - addr_leftup == 23600) ||
				(addr_in - addr_leftup == 23800) ||
				(addr_in - addr_leftup == 24000) ||
				(addr_in - addr_leftup == 24200) ||
				(addr_in - addr_leftup == 24400) ||
				(addr_in - addr_leftup == 24600) ||
				(addr_in - addr_leftup == 24800) ||
				(addr_in - addr_leftup == 25000) ||
				(addr_in - addr_leftup == 25200) ||
				(addr_in - addr_leftup == 25400) ||
				(addr_in - addr_leftup == 25600) ||
				(addr_in - addr_leftup == 25800) ||
				(addr_in - addr_leftup == 26000) ||
				(addr_in - addr_leftup == 26200) ||
				(addr_in - addr_leftup == 26400) ||
				(addr_in - addr_leftup == 26600) ||
				(addr_in - addr_leftup == 26800) ||
				(addr_in - addr_leftup == 27000) ||
				(addr_in - addr_leftup == 27200) ||
				(addr_in - addr_leftup == 27400) ||
				(addr_in - addr_leftup == 27600) ||
				(addr_in - addr_leftup == 27800) ||
				(addr_in - addr_leftup == 28000) ||
				(addr_in - addr_leftup == 28200) ||
				(addr_in - addr_leftup == 28400) ||
				(addr_in - addr_leftup == 28600) ||
				(addr_in - addr_leftup == 28800) ||
				(addr_in - addr_leftup == 29000) ||
				(addr_in - addr_leftup == 29200) ||
				(addr_in - addr_leftup == 29400) ||
				(addr_in - addr_leftup == 29600) ||
				(addr_in - addr_leftup == 29800) ||
				(addr_in - addr_leftup == 30000) ||
				(addr_in - addr_leftup == 30200) ||
				(addr_in - addr_leftup == 30400) ||
				(addr_in - addr_leftup == 30600) ||
				(addr_in - addr_leftup == 30800) ||
				(addr_in - addr_leftup == 31000) ||
				(addr_in - addr_leftup == 31200) ||
				(addr_in - addr_leftup == 31400) ||
				(addr_in - addr_leftup == 31600) ||
				(addr_in - addr_leftup == 31800) ||
				(addr_in - addr_leftup == 32000) ||
				(addr_in - addr_leftup == 32200) ||
				(addr_in - addr_leftup == 32400) ||
				(addr_in - addr_leftup == 32600) ||
				(addr_in - addr_leftup == 32800) ||
				(addr_in - addr_leftup == 33000) ||
				(addr_in - addr_leftup == 33200) ||
				(addr_in - addr_leftup == 33400) ||
				(addr_in - addr_leftup == 33600) ||
				(addr_in - addr_leftup == 33800) ||
				(addr_in - addr_leftup == 34000) ||
				(addr_in - addr_leftup == 34200) ||
				(addr_in - addr_leftup == 34400) ||
				(addr_in - addr_leftup == 34600) ||
				(addr_in - addr_leftup == 34800) ||
				(addr_in - addr_leftup == 35000) ||
				(addr_in - addr_leftup == 35200) ||
				(addr_in - addr_leftup == 35400) ||
				(addr_in - addr_leftup == 35600) ||
				(addr_in - addr_leftup == 35800) ||
				(addr_in - addr_leftup == 36000) ||
				(addr_in - addr_leftup == 36200) ||
				(addr_in - addr_leftup == 36400) ||
				(addr_in - addr_leftup == 36600) ||
				(addr_in - addr_leftup == 36800) ||
				(addr_in - addr_leftup == 37000) ||
				(addr_in - addr_leftup == 37200) ||
				(addr_in - addr_leftup == 37400) ||
				(addr_in - addr_leftup == 37600) ||
				(addr_in - addr_leftup == 37800) ||
				(addr_in - addr_leftup == 38000) ||
				(addr_in - addr_leftup == 38200) ||
				(addr_in - addr_leftup == 38400) ||
				(addr_in - addr_leftup == 38600) ||
				(addr_in - addr_leftup == 38800) ||
				(addr_in - addr_leftup == 39000) ||
				(addr_in - addr_leftup == 39200) ||
				(addr_in - addr_leftup == 39400) ||
				(addr_in - addr_leftup == 39600) ||
				(addr_in - addr_leftup == 39800)    )&&
				(addr_in <= addr_leftdown)
				)				||				(
				(
				(addr_in - addr_rightup == 200) ||
				(addr_in - addr_rightup == 400) ||
				(addr_in - addr_rightup == 600) ||
				(addr_in - addr_rightup == 800) ||
				(addr_in - addr_rightup == 1000) ||
				(addr_in - addr_rightup == 1200) ||
				(addr_in - addr_rightup == 1400) ||
				(addr_in - addr_rightup == 1600) ||
				(addr_in - addr_rightup == 1800) ||
				(addr_in - addr_rightup == 2000) ||
				(addr_in - addr_rightup == 2200) ||
				(addr_in - addr_rightup == 2400) ||
				(addr_in - addr_rightup == 2600) ||
				(addr_in - addr_rightup == 2800) ||
				(addr_in - addr_rightup == 3000) ||
				(addr_in - addr_rightup == 3200) ||
				(addr_in - addr_rightup == 3400) ||
				(addr_in - addr_rightup == 3600) ||
				(addr_in - addr_rightup == 3800) ||
				(addr_in - addr_rightup == 4000) ||
				(addr_in - addr_rightup == 4200) ||
				(addr_in - addr_rightup == 4400) ||
				(addr_in - addr_rightup == 4600) ||
				(addr_in - addr_rightup == 4800) ||
				(addr_in - addr_rightup == 5000) ||
				(addr_in - addr_rightup == 5200) ||
				(addr_in - addr_rightup == 5400) ||
				(addr_in - addr_rightup == 5600) ||
				(addr_in - addr_rightup == 5800) ||
				(addr_in - addr_rightup == 6000) ||
				(addr_in - addr_rightup == 6200) ||
				(addr_in - addr_rightup == 6400) ||
				(addr_in - addr_rightup == 6600) ||
				(addr_in - addr_rightup == 6800) ||
				(addr_in - addr_rightup == 7000) ||
				(addr_in - addr_rightup == 7200) ||
				(addr_in - addr_rightup == 7400) ||
				(addr_in - addr_rightup == 7600) ||
				(addr_in - addr_rightup == 7800) ||
				(addr_in - addr_rightup == 8000) ||
				(addr_in - addr_rightup == 8200) ||
				(addr_in - addr_rightup == 8400) ||
				(addr_in - addr_rightup == 8600) ||
				(addr_in - addr_rightup == 8800) ||
				(addr_in - addr_rightup == 9000) ||
				(addr_in - addr_rightup == 9200) ||
				(addr_in - addr_rightup == 9400) ||
				(addr_in - addr_rightup == 9600) ||
				(addr_in - addr_rightup == 9800) ||
				(addr_in - addr_rightup == 10000) ||
				(addr_in - addr_rightup == 10200) ||
				(addr_in - addr_rightup == 10400) ||
				(addr_in - addr_rightup == 10600) ||
				(addr_in - addr_rightup == 10800) ||
				(addr_in - addr_rightup == 11000) ||
				(addr_in - addr_rightup == 11200) ||
				(addr_in - addr_rightup == 11400) ||
				(addr_in - addr_rightup == 11600) ||
				(addr_in - addr_rightup == 11800) ||
				(addr_in - addr_rightup == 12000) ||
				(addr_in - addr_rightup == 12200) ||
				(addr_in - addr_rightup == 12400) ||
				(addr_in - addr_rightup == 12600) ||
				(addr_in - addr_rightup == 12800) ||
				(addr_in - addr_rightup == 13000) ||
				(addr_in - addr_rightup == 13200) ||
				(addr_in - addr_rightup == 13400) ||
				(addr_in - addr_rightup == 13600) ||
				(addr_in - addr_rightup == 13800) ||
				(addr_in - addr_rightup == 14000) ||
				(addr_in - addr_rightup == 14200) ||
				(addr_in - addr_rightup == 14400) ||
				(addr_in - addr_rightup == 14600) ||
				(addr_in - addr_rightup == 14800) ||
				(addr_in - addr_rightup == 15000) ||
				(addr_in - addr_rightup == 15200) ||
				(addr_in - addr_rightup == 15400) ||
				(addr_in - addr_rightup == 15600) ||
				(addr_in - addr_rightup == 15800) ||
				(addr_in - addr_rightup == 16000) ||
				(addr_in - addr_rightup == 16200) ||
				(addr_in - addr_rightup == 16400) ||
				(addr_in - addr_rightup == 16600) ||
				(addr_in - addr_rightup == 16800) ||
				(addr_in - addr_rightup == 17000) ||
				(addr_in - addr_rightup == 17200) ||
				(addr_in - addr_rightup == 17400) ||
				(addr_in - addr_rightup == 17600) ||
				(addr_in - addr_rightup == 17800) ||
				(addr_in - addr_rightup == 18000) ||
				(addr_in - addr_rightup == 18200) ||
				(addr_in - addr_rightup == 18400) ||
				(addr_in - addr_rightup == 18600) ||
				(addr_in - addr_rightup == 18800) ||
				(addr_in - addr_rightup == 19000) ||
				(addr_in - addr_rightup == 19200) ||
				(addr_in - addr_rightup == 19400) ||
				(addr_in - addr_rightup == 19600) ||
				(addr_in - addr_rightup == 19800) ||
				(addr_in - addr_rightup == 20000) ||
				(addr_in - addr_rightup == 20200) ||
				(addr_in - addr_rightup == 20400) ||
				(addr_in - addr_rightup == 20600) ||
				(addr_in - addr_rightup == 20800) ||
				(addr_in - addr_rightup == 21000) ||
				(addr_in - addr_rightup == 21200) ||
				(addr_in - addr_rightup == 21400) ||
				(addr_in - addr_rightup == 21600) ||
				(addr_in - addr_rightup == 21800) ||
				(addr_in - addr_rightup == 22000) ||
				(addr_in - addr_rightup == 22200) ||
				(addr_in - addr_rightup == 22400) ||
				(addr_in - addr_rightup == 22600) ||
				(addr_in - addr_rightup == 22800) ||
				(addr_in - addr_rightup == 23000) ||
				(addr_in - addr_rightup == 23200) ||
				(addr_in - addr_rightup == 23400) ||
				(addr_in - addr_rightup == 23600) ||
				(addr_in - addr_rightup == 23800) ||
				(addr_in - addr_rightup == 24000) ||
				(addr_in - addr_rightup == 24200) ||
				(addr_in - addr_rightup == 24400) ||
				(addr_in - addr_rightup == 24600) ||
				(addr_in - addr_rightup == 24800) ||
				(addr_in - addr_rightup == 25000) ||
				(addr_in - addr_rightup == 25200) ||
				(addr_in - addr_rightup == 25400) ||
				(addr_in - addr_rightup == 25600) ||
				(addr_in - addr_rightup == 25800) ||
				(addr_in - addr_rightup == 26000) ||
				(addr_in - addr_rightup == 26200) ||
				(addr_in - addr_rightup == 26400) ||
				(addr_in - addr_rightup == 26600) ||
				(addr_in - addr_rightup == 26800) ||
				(addr_in - addr_rightup == 27000) ||
				(addr_in - addr_rightup == 27200) ||
				(addr_in - addr_rightup == 27400) ||
				(addr_in - addr_rightup == 27600) ||
				(addr_in - addr_rightup == 27800) ||
				(addr_in - addr_rightup == 28000) ||
				(addr_in - addr_rightup == 28200) ||
				(addr_in - addr_rightup == 28400) ||
				(addr_in - addr_rightup == 28600) ||
				(addr_in - addr_rightup == 28800) ||
				(addr_in - addr_rightup == 29000) ||
				(addr_in - addr_rightup == 29200) ||
				(addr_in - addr_rightup == 29400) ||
				(addr_in - addr_rightup == 29600) ||
				(addr_in - addr_rightup == 29800) ||
				(addr_in - addr_rightup == 30000) ||
				(addr_in - addr_rightup == 30200) ||
				(addr_in - addr_rightup == 30400) ||
				(addr_in - addr_rightup == 30600) ||
				(addr_in - addr_rightup == 30800) ||
				(addr_in - addr_rightup == 31000) ||
				(addr_in - addr_rightup == 31200) ||
				(addr_in - addr_rightup == 31400) ||
				(addr_in - addr_rightup == 31600) ||
				(addr_in - addr_rightup == 31800) ||
				(addr_in - addr_rightup == 32000) ||
				(addr_in - addr_rightup == 32200) ||
				(addr_in - addr_rightup == 32400) ||
				(addr_in - addr_rightup == 32600) ||
				(addr_in - addr_rightup == 32800) ||
				(addr_in - addr_rightup == 33000) ||
				(addr_in - addr_rightup == 33200) ||
				(addr_in - addr_rightup == 33400) ||
				(addr_in - addr_rightup == 33600) ||
				(addr_in - addr_rightup == 33800) ||
				(addr_in - addr_rightup == 34000) ||
				(addr_in - addr_rightup == 34200) ||
				(addr_in - addr_rightup == 34400) ||
				(addr_in - addr_rightup == 34600) ||
				(addr_in - addr_rightup == 34800) ||
				(addr_in - addr_rightup == 35000) ||
				(addr_in - addr_rightup == 35200) ||
				(addr_in - addr_rightup == 35400) ||
				(addr_in - addr_rightup == 35600) ||
				(addr_in - addr_rightup == 35800) ||
				(addr_in - addr_rightup == 36000) ||
				(addr_in - addr_rightup == 36200) ||
				(addr_in - addr_rightup == 36400) ||
				(addr_in - addr_rightup == 36600) ||
				(addr_in - addr_rightup == 36800) ||
				(addr_in - addr_rightup == 37000) ||
				(addr_in - addr_rightup == 37200) ||
				(addr_in - addr_rightup == 37400) ||
				(addr_in - addr_rightup == 37600) ||
				(addr_in - addr_rightup == 37800) ||
				(addr_in - addr_rightup == 38000) ||
				(addr_in - addr_rightup == 38200) ||
				(addr_in - addr_rightup == 38400) ||
				(addr_in - addr_rightup == 38600) ||
				(addr_in - addr_rightup == 38800) ||
				(addr_in - addr_rightup == 39000) ||
				(addr_in - addr_rightup == 39200) ||
				(addr_in - addr_rightup == 39400) ||
				(addr_in - addr_rightup == 39600) ||
				(addr_in - addr_rightup == 39800)    ) &&
				(addr_in <= addr_rightdown)
				)				||				(
				addr_in >= addr_leftup	 &&
				addr_in <= addr_rightup
				)				||				(
				addr_in >= addr_leftdown &&
				addr_in <= addr_rightdown
				)
		)begin
			data_out <= 4'b1111;
		end
		else begin
			data_out <= data_in;
		end
	end
	
endmodule
