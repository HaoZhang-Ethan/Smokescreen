/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2022-11-29 17:08:53
 * @FilePath: /Smokescreen/Flow/Circuit/CONV/PIM/conv_top.v
 * @Description: the basic component of PIM
 * 
 * Copyright (c) 2022 by haozhang-hoge haozhang@mail.sdu.edu.cn, All Rights Reserved. 
 */




// Parameter:
// CROSS_SIZE, crossbar size (number of input ports) (default: 64), we use 64 for 64x64 crossbar
// MAP_WIDTH, the column of crossbar we used (default: 6), we use log(64) for 64x64 crossbar
// ADC_P, ADC precision, we use 8 bits ADC

module conv_top #(parameter CROSS_SIZE = 64, DEPTH = 6, ADC_P = 8) (
	input clk, 
	input rst,
	input en,	// enable
	input [CROSS_SIZE-1:0] input_feature,
	input [DEPTH-1:0] address,
	output [ADC_P-1:0] Output	// size should increase to hold the sum of products
	);


	integer      i ;
	reg [3:0]    counter2 ;
	initial begin
		counter2 = 'b0 ;
		for (i=0; i<=10; i=i+1) begin
			#10 ;
			counter2 = counter2 + 1'b1 ;
		end
	end
	wire [CROSS_SIZE-1:0] input_pim;
	wire [CROSS_SIZE-1:0] address_pim;
	wire [ADC_P-1:0] resout;
	assign input_pim = input_feature;
	assign address_pim = address;
	conv single_pim(
		.Input_feature(input_pim),
		.Address(address_pim),
		.en(en),
		.Output(resout),
		.clk(clk)
	);
	assign Output = resout;



	always @ (posedge clk or negedge rst) begin
		if (!rst_n) begin
			resout = 0;
			// i = 0;
			// while(i < 8) begin
			// 	mem[i] <= 0;
			// 	i = i + 1'b1;
			// end
		end
		// else begin
		// 	i = 0;
		// 	mem[0] <= d;
		// 	while(i < 7) begin
		// 		mem[i+1] <= mem[i];
		// 		i = i + 1'b1;
		// 	end
		// end
		// q <= mem[7];
	end

endmodule