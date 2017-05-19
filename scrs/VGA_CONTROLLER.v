`timescale 1ns / 1ps

// Note: 
// 1. requiring image memory with delay that is less than 1 pixel_clocks

module VGA_CONTROLLER
# (
	parameter
		// V for vertical, H for horizontal
		T_PW_V   = 10'd1,	// pulse width
		T_BP_V   = 10'd30,	// back porch
		T_DISP_V = 10'd510,	// display time
		T_FP_V   = 10'd520,	// front porch
		T_PW_H   = 10'd95,
		T_BP_H   = 10'd143,
		T_DISP_H = 10'd783,
		T_FP_H   = 10'd799,

		WIDTH    = 4'd10	// width of counters/positions
)
(
	input rst_n,
	input pixel_clk,
	output reg [WIDTH-1:0] xpos, ypos,
	output reg en_color,
	output reg hsync, vsync
);
	wire Assert_hsync, Deassert_hsync;
	wire Assert_vsync, Deassert_vsync;
	wire Add_hcounter, Add_vcounter;
	wire Enable_vertical_counter;
	wire Assert_en_color;

	reg [WIDTH-1:0] next_xpos, next_ypos;
	reg [WIDTH-1:0] next_hcounter, next_vcounter;

	reg [WIDTH-1:0] hcounter;
	reg [WIDTH-1:0] vcounter;

	// logic for determining hsync and vsync
	assign Assert_hsync   = (next_hcounter==T_PW_H);
	assign Deassert_hsync = (next_hcounter==T_FP_H);
	assign Assert_vsync   = (next_vcounter==T_PW_V);
	assign Deassert_vsync = (next_vcounter==T_FP_V);

	// logic for determining counters
	assign Add_hcounter = (hcounter <= T_FP_H-1);
	assign Add_vcounter = (vcounter <= T_FP_V-1);
	assign Enable_vertical_counter = Deassert_hsync;

	// logic for enable_color signal
	assign Assert_en_color = (    (next_hcounter>T_BP_H && next_hcounter<=T_DISP_H)
				   && (next_vcounter>T_BP_V && next_vcounter<=T_DISP_V) );

	// next hcounter logic
	always @(*) begin
		if (Add_hcounter) begin
			next_hcounter = hcounter + 10'd1;
		end
		else begin
			next_hcounter = {WIDTH{1'b0}};
		end
	end

	// next vcounter logic
	always @(*) begin
		if (Add_vcounter) begin
			next_vcounter = vcounter + 1;
		end
		else begin
			next_vcounter = {WIDTH{1'b0}};
		end
	end

	// next position logic
	always @(*) begin
		
		// next position of x
		if (hsync && next_hcounter>T_BP_H && next_hcounter<=T_DISP_H) begin
			next_xpos = next_hcounter - T_BP_H - 1;
		end
		else begin
			next_xpos = {WIDTH{1'b0}};
		end

		// next position of y
		if (vsync && next_vcounter>T_BP_V && next_vcounter<=T_DISP_V) begin
			next_ypos = next_vcounter - T_BP_V - 1;
		end
		else begin
			next_ypos = {WIDTH{1'b0}};
		end
		
	end



	// horizontal counter
	always @(posedge pixel_clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			hcounter <= {WIDTH{1'b0}};
		end
		else begin
			hcounter <= next_hcounter;
		end
	end // always

	// horizontal synch
	always @(posedge pixel_clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			hsync <= 1'b0;
		end
		else if (Assert_hsync) begin
			hsync <= 1'b1;
		end
		else if (Deassert_hsync) begin
			hsync <= 1'b0;
		end
	end // always

	// vertical counter
	always @(posedge pixel_clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			vcounter <= {WIDTH{1'b0}};
		end
		else if (Enable_vertical_counter) begin
			vcounter <= next_vcounter;
		end
	end // always

	// vertical synch
	always @(posedge pixel_clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			vsync <= 1'b0;
		end
		else if (Assert_vsync) begin
			vsync <= 1'b1;
		end
		else if (Deassert_vsync) begin
			vsync <= 1'b0;
		end
	end // always

	// position of pixel
	always @(posedge pixel_clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			xpos <= {WIDTH{1'b0}};
			ypos <= {WIDTH{1'b0}};
		end
		else begin
			xpos <= next_xpos;
			ypos <= next_ypos;
		end
	end // always

	// enable_color signal
	always @(posedge pixel_clk or negedge rst_n) begin
		if (!rst_n) begin
			// reset
			en_color <= 1'b0;
		end
		else if (Assert_en_color) begin
			en_color <= 1'b1;
		end
		else begin
			en_color <= 1'b0;
		end
	end // always

endmodule
