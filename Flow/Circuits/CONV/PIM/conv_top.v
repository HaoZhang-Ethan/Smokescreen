/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2022-12-01 15:52:20
 * @FilePath: /Smokescreen/Flow/Circuits/CONV/PIM/conv_top.v
 * @Description: the basic component of PIM conv. It can caculate the output for every address.
 * 
 * Copyright (c) 2022 by haozhang-hoge haozhang@mail.sdu.edu.cn, All Rights Reserved. 
 */



function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction

// Parameter:
// INPUT_SIZE, the size of inpuit vector (default: 64), we use 64 for 64x64 crossbar
// DEPTH, the column of used crossbar
// ADC_P, ADC precision, we use 8 bits ADC
module conv_top #(parameter INPUT_SIZE = 128, DEPTH = 32, ADC_P = 8) (
	input clk, 
	input rst,
	input en,	// enable
	input [INPUT_SIZE-1:0] input_feature,
	input [clogb2(DEPTH)-1:0] address,
	output [ADC_P-1:0] Output,	// size should increase to hold the sum of products
	output [clogb2(DEPTH)-1:0] add_counter,
	output done_flag,
	);



	wire [INPUT_SIZE-1:0] input_pim;
	wire [INPUT_SIZE-1:0] address_pim;
	wire [ADC_P-1:0] resout;
	assign input_pim = input_feature;
	assign address_pim = address;
	conv #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(DEPTH), .ADC_P(ADC_P)) single_conv(
		.Input_feature(input_pim),
		.Address(address_pim),
		.en(en),
		.Output(resout),
		.clk(clk)
	);
	assign Output = resout;


	reg [clogb2(DEPTH)-1:0]	add_counter;
	reg done_flag;
	always @ (posedge clk) begin
		if (!rst) begin
			add_counter <= 4'b0;
			done_flag <= 1'b0;
		end else if (add_counter > DEPTH -1) begin
			add_counter <= 4'b0;
			done_flag <= 1'b1;
		end else if (add_counter < DEPTH) begin
			add_counter <= add_counter + 1'b1;
		end
	end

endmodule