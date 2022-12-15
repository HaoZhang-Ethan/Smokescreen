module conv_pim #(parameter BIT_WIDTH = 8, OUT_WIDTH = 8, KERNEL_SIZE = 5, CHANNEL = 4, DEPTH = 8) (
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


	if (CHANNEL == 6) begin
		wire [BIT_WIDTH-1:0] conv_out_tmp [4];
		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_0(
			.a(conv_out[0]),
			.b(conv_out[1]),
			.c(conv_out_tmp[0])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_1(
			.a(conv_out[2]),
			.b(conv_out[3]),
			.c(conv_out_tmp[1])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_2(
			.a(conv_out[4]),
			.b(conv_out[5]),
			.c(conv_out_tmp[2])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_3(
			.a(conv_out_tmp[0]),
			.b(conv_out_tmp[1]),
			.c(conv_out_tmp[3])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_4(
			.a(conv_out_tmp[2]),
			.b(conv_out_tmp[3]),
			.c(convValue)
		);
	end else if (CHANNEL == 16) begin
		
		wire [BIT_WIDTH-1:0] conv_out_tmp [14];
		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_0(
			.a(conv_out[0]),
			.b(conv_out[1]),
			.c(conv_out_tmp[0])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_1(
			.a(conv_out[2]),
			.b(conv_out[3]),
			.c(conv_out_tmp[1])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_2(
			.a(conv_out[4]),
			.b(conv_out[5]),
			.c(conv_out_tmp[2])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_3(
			.a(conv_out[6]),
			.b(conv_out[7]),
			.c(conv_out_tmp[3])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_4(
			.a(conv_out[8]),
			.b(conv_out[9]),
			.c(conv_out_tmp[4])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_5(
			.a(conv_out[10]),
			.b(conv_out[11]),
			.c(conv_out_tmp[5])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_6(
			.a(conv_out[12]),
			.b(conv_out[13]),
			.c(conv_out_tmp[6])
		);


		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_7(
			.a(conv_out[14]),
			.b(conv_out[15]),
			.c(conv_out_tmp[7])
		);


		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_8(
			.a(conv_out_tmp[0]),
			.b(conv_out_tmp[1]),
			.c(conv_out_tmp[8])
		);


		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_9(
			.a(conv_out_tmp[2]),
			.b(conv_out_tmp[3]),
			.c(conv_out_tmp[9])
		);


		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_10(
			.a(conv_out_tmp[4]),
			.b(conv_out_tmp[5]),
			.c(conv_out_tmp[10])
		);


		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_11(
			.a(conv_out_tmp[6]),
			.b(conv_out_tmp[7]),
			.c(conv_out_tmp[11])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_12(
			.a(conv_out_tmp[8]),
			.b(conv_out_tmp[9]),
			.c(conv_out_tmp[12])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_13(
			.a(conv_out_tmp[10]),
			.b(conv_out_tmp[11]),
			.c(conv_out_tmp[13])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_14(
			.a(conv_out_tmp[12]),
			.b(conv_out_tmp[13]),
			.c(convValue)
		);

	end else if (CHANNEL == 3) begin
		wire [BIT_WIDTH-1:0] conv_out_tmp [1];
		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_0(
			.a(conv_out[0]),
			.b(conv_out[1]),
			.c(conv_out_tmp[0])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_1(
			.a(conv_out[2]),
			.b(conv_out_tmp[0]),
			.c(convValue)
		);
	
	end else if (CHANNEL == 4) begin
		wire [BIT_WIDTH-1:0] conv_out_tmp [2];
		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_0(
			.a(conv_out[0]),
			.b(conv_out[1]),
			.c(conv_out_tmp[0])
		);
		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_1(
			.a(conv_out[2]),
			.b(conv_out[3]),
			.c(conv_out_tmp[1])
		);

		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst_2(
			.a(conv_out_tmp[0]),
			.b(conv_out_tmp[1]),
			.c(convValue)
		);

	end else if (CHANNEL == 1) begin
		assign convValue = conv_out[0];
	end
		
		


endmodule
