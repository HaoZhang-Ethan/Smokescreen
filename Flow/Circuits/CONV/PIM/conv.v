/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2022-11-29 20:17:14
 * @FilePath: /Smokescreen/Flow/Circuits/CONV/PIM/conv.v
 * @Description: the basic component of PIM
 * 
 * Copyright (c) 2022 by haozhang-hoge haozhang@mail.sdu.edu.cn, All Rights Reserved. 
 */




// Parameter:
// CROSS_SIZE, crossbar size (number of input ports) (default: 64), we use 64 for 64x64 crossbar
// MAP_WIDTH, the column of crossbar we used (default: 6), we use log(64) for 64x64 crossbar
// ADC_P, ADC precision, we use 8 bits ADC
module conv #(parameter CROSS_SIZE = 64, DEPTH = 6, ADC_P = 8) (
	input clk, 
	input rst,
	input en,	// enable
	input [CROSS_SIZE-1:0] Input_feature,
	input [DEPTH-1:0] Address,
	output [ADC_P-1:0] Output	// size should increase to hold the sum of products
	);
	
	wire [CROSS_SIZE-1:0] Input_pim;
	wire [CROSS_SIZE-1:0] Address_pim;
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

endmodule