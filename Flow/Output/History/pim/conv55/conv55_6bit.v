/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2023-03-21 07:08:35
 * @FilePath: /Smokescreen/Flow/Circuits/conv55/PIM/conv55_6bit.v
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



module conv5x5 (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8, input [5:0] in_data_9, input [5:0] in_data_10, input [5:0] in_data_11, input [5:0] in_data_12, input [5:0] in_data_13, input [5:0] in_data_14, input [5:0] in_data_15, input [5:0] in_data_16, input [5:0] in_data_17, input [5:0] in_data_18, input [5:0] in_data_19, input [5:0] in_data_20, input [5:0] in_data_21, input [5:0] in_data_22, input [5:0] in_data_23, input [5:0] in_data_24, // 输入数据
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output reg [17:0] out_data // 输出数据
);  

	wire [5:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
//  HH Unit
	conv #(.INPUT_SIZE(75), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH(
		.Input_feature({in_data_0[5:3], in_data_1[5:3], in_data_2[5:3], in_data_3[5:3], in_data_4[5:3], in_data_5[5:3], in_data_6[5:3], in_data_7[5:3], in_data_8[5:3], in_data_9[5:3], in_data_10[5:3], in_data_11[5:3], in_data_12[5:3], in_data_13[5:3], in_data_14[5:3], in_data_15[5:3], in_data_16[5:3], in_data_17[5:3], in_data_18[5:3], in_data_19[5:3], in_data_20[5:3], in_data_21[5:3], in_data_22[5:3], in_data_23[5:3], in_data_24[5:3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(75), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL(
		.Input_feature({in_data_0[5:3], in_data_1[5:3], in_data_2[5:3], in_data_3[5:3], in_data_4[5:3], in_data_5[5:3], in_data_6[5:3], in_data_7[5:3], in_data_8[5:3], in_data_9[5:3], in_data_10[5:3], in_data_11[5:3], in_data_12[5:3], in_data_13[5:3], in_data_14[5:3], in_data_15[5:3], in_data_16[5:3], in_data_17[5:3], in_data_18[5:3], in_data_19[5:3], in_data_20[5:3], in_data_21[5:3], in_data_22[5:3], in_data_23[5:3], in_data_24[5:3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(75), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH(
		.Input_feature({in_data_0[3:0], in_data_1[3:0], in_data_2[3:0], in_data_3[3:0], in_data_4[3:0], in_data_5[3:0], in_data_6[3:0], in_data_7[3:0], in_data_8[3:0], in_data_9[3:0], in_data_10[3:0], in_data_11[3:0], in_data_12[3:0], in_data_13[3:0], in_data_14[3:0], in_data_15[3:0], in_data_16[3:0], in_data_17[3:0], in_data_18[3:0], in_data_19[3:0], in_data_20[3:0], in_data_21[3:0], in_data_22[3:0], in_data_23[3:0], in_data_24[3:0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH),
		.clk(clk)
	);

// // //  LL Unit
// 	conv #(.INPUT_SIZE(27), .DEPTH(clogb2(9)), .ADC_P(6)) single_conv_LL(
// 		.Input_feature({in_data_0[3:0], in_data_1[3:0], in_data_2[3:0], in_data_3[3:0], in_data_4[3:0], in_data_5[3:0], in_data_6[3:0], in_data_7[3:0], in_data_8[3:0]}),
// 		.Address(add_counter),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LL),
// 		.clk(clk)
// 	);

	wire [5:0] tmp_out_1;
	// assign tmp_out_1 = tmp_result_HH + {tmp_result_HL[5:3], 3'b000};
	// assign out_data = tmp_out_1 + {tmp_result_LH[5:4], 4'b0000};
	// assign out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH;

		qadd1 #(.BIT_WIDTH(6), .OUT_WIDTH(6)) qadd_inst_1(
			.a(tmp_result_HH),
			.b(tmp_result_HL),
			.c(tmp_out_1)
		);
		qadd1 #(.BIT_WIDTH(6), .OUT_WIDTH(6)) qadd_inst_2(
			.a(tmp_out_1),
			.b(tmp_result_LH),
			.c(out_data)
		);

endmodule

module qadd1 #(parameter BIT_WIDTH = 6, OUT_WIDTH = 8)(a,b,c);
input [BIT_WIDTH-1:0] a;
input [BIT_WIDTH-1:0] b;
output [BIT_WIDTH-1:0] c;

assign c = a + b;
//DW01_add #(`DWIDTH) u_add(.A(a), .B(b), .CI(1'b0), .SUM(c), .CO());
endmodule