/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2023-05-26 03:00:59
 * @FilePath: /Smokescreen/Flow/Circuits/CONV33/conv6.v
 * @Description: the basic component of PIM
 * 
 * Copyright (c) 2022 by haozhang-hoge haozhang@mail.sdu.edu.cn, All Rights Reserved. 
 */


`define MAX_SIZE_ROW 96 // the max size of the ReRAM Crossbar rows  32*6
`define MAX_SIZE_COL 5 // the max size of the ReRAM Crossbar cols , (default: 5 = log(32) )

// Parameter:
// INPUT_SIZE, the size of inpuit vector (default: 32), we use 64 for 32x32 crossbar
// MAP_WIDTH, the column of crossbar we used (default: 5), we use log(32) for 32x32 crossbar
// ADC_P, ADC precision, we use 8 bits ADC
module conv6 #(parameter INPUT_SIZE = 96, DEPTH = 5, ADC_P = 6) (
	input clk, 
	input rst,
	input en,	// enable
	input [INPUT_SIZE-1:0] Input_feature,
	input [DEPTH-1:0] Address,
	output [ADC_P-1:0] Output	// size should increase to hold the sum of products
	);
	wire [INPUT_SIZE-1:0] input_pim;
	wire [INPUT_SIZE-1:0] address_pim;
	wire [ADC_P-1:0] resout;
	assign input_pim = Input_feature;
	assign address_pim = Address;
	conv_col #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(DEPTH), .ADC_P(ADC_P)) conv_inst(
		.Input_feature(input_pim),
		.Address(address_pim),
		.en(en),
		.Output(resout),
		.clk(clk)
	);
	assign Output = resout;
endmodule



// split the used crossbar colunm into 2 parts, and select one of the conv_col modules
module conv_col #(parameter INPUT_SIZE = 96, DEPTH = 5, ADC_P = 8) (
	input clk, 
	input rst,
	input en,	// enable
	input [INPUT_SIZE-1:0] Input_feature,
	input [DEPTH-1:0] Address,
	output [ADC_P-1:0] Output	
	);
	if (DEPTH > `MAX_SIZE_COL) begin
		wire [ADC_P-1:0] Resout_1;
		wire [ADC_P-1:0] Resout_2;
		conv_col #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(DEPTH-1), .ADC_P(ADC_P)) pim_conv_col_s_inst1(
			.clk(clk),
			.rst(rst),
			.en(en),
			.Input_feature(Input_feature),
			.Address(Address[DEPTH-2:0]),
			.Output(Resout_1)
		);
		conv_col #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(DEPTH-1), .ADC_P(ADC_P)) pim_conv_col_s_inst2(
			.clk(clk),
			.rst(rst),
			.en(en),
			.Input_feature(Input_feature),
			.Address(Address[DEPTH-2:0]),
			.Output(Resout_2)
		);
		assign Output = (Address[DEPTH-1]) ? Resout_1 : Resout_2;
	end
	else begin
		wire [INPUT_SIZE-1:0] input_pim;
		wire [INPUT_SIZE-1:0] address_pim;
		wire [ADC_P-1:0] resout;
		assign input_pim = Input_feature;
		assign address_pim = Address;
		conv_row #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(DEPTH), .ADC_P(ADC_P)) single_conv(
			.Input_feature(input_pim),
			.Address(address_pim),
			.en(en),
			.Output(resout),
			.clk(clk)
		);
		assign Output = resout;
	end

endmodule


// split the input vector into 2 parts, and use 2 conv_row to calculate the output
module conv_row #(parameter INPUT_SIZE = 96, DEPTH = 5, ADC_P = 8) (
	input clk, 
	input rst,
	input en,	// enable
	input [INPUT_SIZE-1:0] Input_feature,
	input [DEPTH-1:0] Address,
	output [ADC_P-1:0] Output	// size should increase to hold the sum of products
	);
	
	if (INPUT_SIZE > `MAX_SIZE_ROW) begin
		wire signed[ADC_P-1:0] tmp_out_1;
		wire signed[ADC_P-1:0] tmp_out_2; 
		wire [ADC_P-1:0] Resout;
		conv_row #(.INPUT_SIZE(INPUT_SIZE/2), .DEPTH(DEPTH), .ADC_P(ADC_P)) pim_conv_row_s_inst1(
			.clk(clk),
			.rst(rst),
			.en(en),
			.Input_feature(Input_feature[INPUT_SIZE-1:INPUT_SIZE/2]),
			.Address(Address),
			.Output(tmp_out_1) 
		);
		conv_row #(.INPUT_SIZE(INPUT_SIZE/2), .DEPTH(DEPTH), .ADC_P(ADC_P)) pim_conv_row_s_inst2(
			.clk(clk),
			.rst(rst),
			.en(en),
			.Input_feature(Input_feature[INPUT_SIZE/2-1:0]),
			.Address(Address),
			.Output(tmp_out_2)
		);
		qadd_con #(.BIT_WIDTH(ADC_P), .OUT_WIDTH(ADC_P)) qadd_con_inst(
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




module qadd_con #(parameter BIT_WIDTH = 6, OUT_WIDTH = 8)(a,b,c);
input [BIT_WIDTH-1:0] a;
input [BIT_WIDTH-1:0] b;
output [BIT_WIDTH-1:0] c;

assign c = a + b;
//DW01_add #(`DWIDTH) u_add(.A(a), .B(b), .CI(1'b0), .SUM(c), .CO());
endmodule