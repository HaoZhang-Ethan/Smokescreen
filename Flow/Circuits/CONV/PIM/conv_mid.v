/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2022-12-06 10:57:44
 * @FilePath: /Smokescreen/Flow/Circuits/CONV/PIM/conv_mid.v
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
module conv_mid #(parameter INPUT_SIZE = 32, INPUT_P = 4, DEPTH = 32, ADC_P = 4) (
	input clk, 
	input rst,
	input [(INPUT_SIZE*INPUT_P)-1:0] Input_feature,
	input [clogb2(DEPTH)-1:0] Address,
	output [ADC_P-1:0] Output,	// size should increase to hold the sum of products
	output done_flag,
	);

	reg [INPUT_P-1:0] input_vector [INPUT_SIZE-1:0];
	reg Compute_flag;
	// int i;
	genvar i;
	generate
		for (i = 0; i < INPUT_SIZE; i = i + 1) begin
			assign input_vector[i] = Input_feature[i*INPUT_P +: INPUT_P];
		end
	endgenerate

	wire [INPUT_SIZE-1:0] input_vector_bit;
	reg done_flag;
	reg [clogb2(INPUT_SIZE)-1:0] bit_counter;
	reg [clogb2(DEPTH)-1:0] add_counter;
	always @ (posedge clk) begin
		if (!rst) begin
			bit_counter <= 0;
			add_counter <= 0;
			done_flag <= 1'b0;
			Compute_flag <= 1'b0;
		end else if (bit_counter > INPUT_P + DEPTH - 1) begin
			bit_counter <= 0;
			add_counter <= 0;
			done_flag <= 1'b1;
			Compute_flag <= 1'b0;
		end else if (bit_counter < INPUT_P) begin
			bit_counter <= bit_counter + 1'b1;
			Compute_flag <= 1'b1;
		end else if (bit_counter < INPUT_P + DEPTH) begin
			bit_counter <= bit_counter + 1'b1;
			add_counter <= add_counter + 1'b1;
			Compute_flag <= 1'b0;
		end
	end


	generate
		for (i = 0; i < INPUT_SIZE; i = i + 1) begin
			assign input_vector_bit[i] = input_vector[i][bit_counter];
		end
	endgenerate
	wire [ADC_P-1:0] resout;
	conv #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(clogb2(DEPTH)), .ADC_P(ADC_P)) single_conv(
		.Input_feature(input_vector_bit),
		.Address(add_counter),
		.en(Compute_flag),
		.Output(resout),
		.clk(clk)
	);
	assign Output = resout;


endmodule