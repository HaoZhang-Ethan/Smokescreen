/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2022-12-01 15:44:15
 * @FilePath: /Smokescreen/Flow/Circuits/CONV/PIM/conv.v
 * @Description: the basic component of PIM
 * 
 * Copyright (c) 2022 by haozhang-hoge haozhang@mail.sdu.edu.cn, All Rights Reserved. 
 */



`define MAX_SIZE 64 // the max size of the ReRAM Crossbar lines

// Parameter:
// INPUT_SIZE, the size of inpuit vector (default: 64), we use 64 for 64x64 crossbar
// MAP_WIDTH, the column of crossbar we used (default: 6), we use log(64) for 64x64 crossbar
// ADC_P, ADC precision, we use 8 bits ADC

module conv #(parameter INPUT_SIZE = 64, DEPTH = 6, ADC_P = 8) (
	input clk, 
	input rst,
	input en,	// enable
	input [INPUT_SIZE-1:0] Input_feature,
	input [DEPTH-1:0] Address,
	output [ADC_P-1:0] Output	// size should increase to hold the sum of products
	);
	
	if (INPUT_SIZE > `MAX_SIZE) begin
		wire signed[ADC_P-1:0] tmp_out_1;
		wire signed[ADC_P-1:0] tmp_out_2; 
		wire [ADC_P-1:0] Resout;
		conv #(.INPUT_SIZE(INPUT_SIZE/2), .DEPTH(DEPTH), .ADC_P(ADC_P)) pim_conv_line_s_inst1(
			.clk(clk),
			.rst(rst),
			.en(en),
			.Input_feature(Input_feature[INPUT_SIZE-1:INPUT_SIZE/2]),
			.Address(Address),
			.Output(tmp_out_1) 
		);
		conv #(.INPUT_SIZE(INPUT_SIZE/2), .DEPTH(DEPTH), .ADC_P(ADC_P)) pim_conv_line_s_inst2(
			.clk(clk),
			.rst(rst),
			.en(en),
			.Input_feature(Input_feature[INPUT_SIZE/2-1:0]),
			.Address(Address),
			.Output(tmp_out_2)
		);
		qadd #(.BIT_WIDTH(ADC_P), .OUT_WIDTH(ADC_P)) qadd_inst(
			.a(tmp_out_1),
			.b(tmp_out_2),
			.c(Resout)
		);
		assign Output = Resout;
	end
	else begin
		wire [INPUT_SIZE-1:0] Input_pim;
		wire [INPUT_SIZE-1:0] Address_pim;
		wire [ADC_P-1:0] Resout;
		assign Input_pim = Input_feature;
		assign Address_pim = Address;
		bram_pim single_pim(
			.data(Input_pim),
			.addr(Address_pim),
			.we(en),
			.out(Resout),
			.clk(clk)
		);
		assign Output = Resout;
	end


endmodule



