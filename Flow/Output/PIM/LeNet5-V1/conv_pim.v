module conv_pim #(parameter BIT_WIDTH = 8, OUT_WIDTH = 8, KERNEL_SIZE = 5, CHANNEL = 6, DEPTH = 8) (
		input clk, 
		input rst,
		input en,	// whether to latch or not
		input [(BIT_WIDTH*KERNEL_SIZE*CHANNEL)-1:0] input_feature,
        // input [(BIT_WIDTH*KERNEL_SIZE*KERNEL_SIZE*CHANNEL)-1:0] filter,	// 5x5x3 filter
		input address,
        output [OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);


	reg [BIT_WIDTH*KERNEL_SIZE*KERNEL_SIZE-1:0] res [CHANNEL];
	reg [KERNEL_SIZE*KERNEL_SIZE*BIT_WIDTH-1:0] input_feature_reg [CHANNEL];
	reg done_flag [CHANNEL];
	wire [BIT_WIDTH-1:0] conv_out [CHANNEL];
    genvar i;
    generate
	    for (i = 0; i < CHANNEL; i = i+1) begin : gen_input_reg
			conv55_input_reg #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) input_reg(
				.clk(clk),
				.en(en),
				.in1(input_feature[(i*BIT_WIDTH*KERNEL_SIZE + 1 * BIT_WIDTH )-1: (i*BIT_WIDTH*KERNEL_SIZE + 0 * BIT_WIDTH )]),
				.in2(input_feature[(i*BIT_WIDTH*KERNEL_SIZE + 2 * BIT_WIDTH )-1: (i*BIT_WIDTH*KERNEL_SIZE + 1 * BIT_WIDTH )]),
				.in3(input_feature[(i*BIT_WIDTH*KERNEL_SIZE + 3 * BIT_WIDTH )-1: (i*BIT_WIDTH*KERNEL_SIZE + 2 * BIT_WIDTH )]),
				.in4(input_feature[(i*BIT_WIDTH*KERNEL_SIZE + 4 * BIT_WIDTH )-1: (i*BIT_WIDTH*KERNEL_SIZE + 3 * BIT_WIDTH )]),
				.in5(input_feature[(i*BIT_WIDTH*KERNEL_SIZE + 5 * BIT_WIDTH )-1: (i*BIT_WIDTH*KERNEL_SIZE + 4 * BIT_WIDTH )]),
				.res(res[i])	// size should increase to hold the sum of products
				);
			assign input_feature_reg [i] = res[i];
			conv_top #(.INPUT_SIZE(KERNEL_SIZE*KERNEL_SIZE),.INPUT_P(BIT_WIDTH),.DEPTH(2),.ADC_P(BIT_WIDTH/2),.OUT_P(OUT_WIDTH)) conv_top_inst(
				.clk(clk),
				.rst(rst),
				.Input_feature(input_feature_reg[i]),
				.Address(address),
				.Output(conv_out[i]),	// size should increase to hold the sum of products
				.done_flag(done_flag[i])
				);
		end
	endgenerate


	wire [BIT_WIDTH-1:0] conv_out_0;
	wire [BIT_WIDTH-1:0] conv_out_1;
	wire [BIT_WIDTH-1:0] conv_out_2;
	wire [BIT_WIDTH-1:0] conv_out_3;
	

	qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_0(
		.a(conv_out[0]),
		.b(conv_out[1]),
		.c(conv_out_0)
	);

	qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_1(
		.a(conv_out[2]),
		.b(conv_out[3]),
		.c(conv_out_1)
	);

	qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_2(
		.a(conv_out[4]),
		.b(conv_out[5]),
		.c(conv_out_2)
	);


	qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_3(
		.a(conv_out_0),
		.b(conv_out_1),
		.c(conv_out_3)
	);

	qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_4(
		.a(conv_out_3),
		.b(conv_out_2),
		.c(convValue)
	);

endmodule
