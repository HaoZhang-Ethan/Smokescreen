/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2022-12-07 22:01:22
 * @FilePath: /Smokescreen/Flow/Circuits/CONV/PIM/conv_top.v
 * @Description: the basic component of PIM conv. It can caculate the output for every address.
 * 
 * Copyright (c) 2022 by haozhang-hoge haozhang@mail.sdu.edu.cn, All Rights Reserved. 
 */



function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = -1; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction

// Parameter:
// INPUT_SIZE, the size of inpuit vector (default: 64), we use 64 for 64x64 crossbar
// DEPTH, the column of used crossbar
// ADC_P, ADC precision, we use 8 bits ADC
module conv_top #(parameter INPUT_SIZE = 32, INPUT_P = 8, DEPTH = 32, ADC_P = 4, OUT_P = 8) (
	input clk, 
	input rst,
	input [(INPUT_SIZE*INPUT_P)-1:0] Input_feature,
	input [clogb2(DEPTH)-1:0] Address,
	output [OUT_P-1:0] Output,	// size should increase to hold the sum of products
	output done_flag,
	);

	reg [INPUT_P/2-1:0] input_vector_H [INPUT_SIZE-1:0];
	reg [INPUT_P/2-1:0] input_vector_L [INPUT_SIZE-1:0];
	reg Compute_flag;
	// int i;
	genvar i;
	generate
		for (i = 0; i < INPUT_SIZE; i = i + 1) begin
			assign input_vector_H[i] = Input_feature[i*INPUT_P + 7  : i*INPUT_P + 3];
			assign input_vector_L[i] = Input_feature[i*INPUT_P + 3 : i*INPUT_P + 0];
		end
	endgenerate

	wire [INPUT_SIZE-1:0] input_vector_bit_L;
	wire [INPUT_SIZE-1:0] input_vector_bit_H;
	reg done_flag;
	reg [clogb2(INPUT_SIZE)-1:0] bit_counter;
	reg [clogb2(DEPTH)-1:0] add_counter;
	always @ (posedge clk) begin
		if (!rst) begin
			bit_counter <= 0;
			add_counter <= 0;
			done_flag <= 1'b0;
			Compute_flag <= 1'b0;
		end else if (bit_counter > INPUT_P/2 + DEPTH - 1) begin
			bit_counter <= 0;
			add_counter <= 0;
			done_flag <= 1'b1;
			Compute_flag <= 1'b0;
		end else if (bit_counter < INPUT_P/2) begin
			bit_counter <= bit_counter + 1'b1;
			Compute_flag <= 1'b1;
		end else if (bit_counter < INPUT_P/2 + DEPTH) begin
			bit_counter <= bit_counter + 1'b1;
			add_counter <= add_counter + 1'b1;
			Compute_flag <= 1'b0;
		end
	end


	generate
		for (i = 0; i < INPUT_SIZE; i = i + 1) begin
			assign input_vector_bit_L[i] = input_vector_L[i][bit_counter];
			assign input_vector_bit_H[i] = input_vector_H[i][bit_counter];
		end
	endgenerate

//  HH Unit
	wire [ADC_P-1:0] resout_HH;
	conv #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(clogb2(DEPTH)), .ADC_P(ADC_P)) single_conv_HH(
		.Input_feature(input_vector_bit_H),
		.Address(add_counter),
		.en(Compute_flag),
		.Output(resout_HH),
		.clk(clk)
	);

//  HL Unit
	wire [ADC_P-1:0] resout_HL;
	conv #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(clogb2(DEPTH)), .ADC_P(ADC_P)) single_conv_HL(
		.Input_feature(input_vector_bit_H),
		.Address(add_counter),
		.en(Compute_flag),
		.Output(resout_HL),
		.clk(clk)
	);

//  LH Unit
	wire [ADC_P-1:0] resout_LH;
	conv #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(clogb2(DEPTH)), .ADC_P(ADC_P)) single_conv_LH(
		.Input_feature(input_vector_bit_L),
		.Address(add_counter),
		.en(Compute_flag),
		.Output(resout_LH),
		.clk(clk)
	);

//  LL Unit
	wire [ADC_P-1:0] resout_LL;
	conv #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(clogb2(DEPTH)), .ADC_P(ADC_P)) single_conv_LL(
		.Input_feature(input_vector_bit_L),
		.Address(add_counter),
		.en(Compute_flag),
		.Output(resout_LL),
		.clk(clk)
	);

//  Adder Tree
	wire [ADC_P-1:0] tmp_out_1;
	wire [ADC_P-1:0] tmp_out_2;
	wire [ADC_P-1:0] tmp_out_3;
	qadd #(.BIT_WIDTH(ADC_P), .OUT_WIDTH(ADC_P)) qadd_inst_0(
	.a(resout_HH),
	.b(resout_HL),
	.c(tmp_out_1)
	);
	qadd #(.BIT_WIDTH(ADC_P), .OUT_WIDTH(ADC_P)) qadd_inst_1(
	.a(resout_LH),
	.b(resout_LL),
	.c(tmp_out_2)
	);
	qadd #(.BIT_WIDTH(ADC_P), .OUT_WIDTH(ADC_P)) qadd_inst_2(
	.a(tmp_out_1),
	.b(tmp_out_2),
	.c(tmp_out_3)
	);
	assign Output = tmp_out_3;
endmodule