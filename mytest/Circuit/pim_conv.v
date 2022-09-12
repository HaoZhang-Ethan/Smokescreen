`define MAX_SIZE 128
module conv #(parameter KERNEL_SIZE = 5, CHANNEL = 6, DEPTH = 16, BIT_WIDTH = 8, OUT_WIDTH = 32) (
    	input clk, rst,
		input en,	// enable
		// input signed[BIT_WIDTH-1:0] in1, in2, in3, in4, in5,
		// input signed[(BIT_WIDTH*25)-1:0] filter,	// 5x5 filter
		// //input [BIT_WIDTH-1:0] bias,
		// output signed[OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
		output signed[8:0] convValue	// size should increase to hold the sum of products
		);
pim_conv_line_s #(.SIZE(KERNEL_SIZE*KERNEL_SIZE*CHANNEL)) conv1(
		.clk(clk), 
		.rst(rst),
		.en(en),
		.convValue(convValue)
		);
endmodule





module pim_conv_line_s #(parameter SIZE = 128) (
	input clk, rst,
	input en,	// enable
	output signed[8:0] convValue	// size should increase to hold the sum of products
	);

	if (SIZE > `MAX_SIZE) begin
		wire signed[8:0] tmp_out_1;
		wire signed[8:0] tmp_out_2; 
		pim_conv_line_s #(SIZE/2) pim_conv_line_s_inst(
			.clk(clk),
			.rst(rst),
			.en(en),
			.convValue(tmp_out_1) 
		);
		pim_conv_line_s #(SIZE/2) pim_conv_line_s_inst2(
			.clk(clk),
			.rst(rst),
			.en(en),
			.convValue(tmp_out_2)
		);
		qadd #(.BIT_WIDTH(9), .OUT_WIDTH(9)) qadd_inst(
			.a(tmp_out_1),
			.b(tmp_out_2),
			.c(convValue)
		);
	end
	else begin
		wire [8:0] data;
		wire [5-1:0] addr;
		wire [0:0] we;

		bram_pim new_ram(
			.data(data),
			.addr(addr),
			.we(we),
			.out(convValue),
			.clk(clk)
		);
	end
endmodule