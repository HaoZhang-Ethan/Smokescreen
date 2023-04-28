/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2023-04-16 07:15:32
 * @FilePath: /Smokescreen/Flow/Circuits/lenet5/Adapt/conv55_6bit_PIM.v
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



module conv55_6bit_PIM (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8, input [5:0] in_data_9, input [5:0] in_data_10, input [5:0] in_data_11, input [5:0] in_data_12, input [5:0] in_data_13, input [5:0] in_data_14, input [5:0] in_data_15, input [5:0] in_data_16, input [5:0] in_data_17, input [5:0] in_data_18, input [5:0] in_data_19, input [5:0] in_data_20, input [5:0] in_data_21, input [5:0] in_data_22, input [5:0] in_data_23, input [5:0] in_data_24, // 输入数据
  input [5:0] kernel_0, input [5:0] kernel_1, input [5:0] kernel_2, input [5:0] kernel_3, input [5:0] kernel_4, input [5:0] kernel_5, input [5:0] kernel_6, input [5:0] kernel_7, input [5:0] kernel_8, input [5:0] kernel_9, input [5:0] kernel_10, input [5:0] kernel_11, input [5:0] kernel_12, input [5:0] kernel_13, input [5:0] kernel_14, input [5:0] kernel_15, input [5:0] kernel_16, input [5:0] kernel_17, input [5:0] kernel_18, input [5:0] kernel_19, input [5:0] kernel_20, input [5:0] kernel_21, input [5:0] kernel_22, input [5:0] kernel_23, input [5:0] kernel_24,// 卷积核
  input clk,
  output [17:0] out_data // 输出数据
);  

conv5x5 single_conv(
  .in_data_0(in_data_0), .in_data_1(in_data_1), .in_data_2(in_data_2), .in_data_3(in_data_3), .in_data_4(in_data_4), .in_data_5(in_data_5), .in_data_6(in_data_6), .in_data_7(in_data_7), .in_data_8(in_data_8), .in_data_9(in_data_9), .in_data_10(in_data_10), .in_data_11(in_data_11), .in_data_12(in_data_12), .in_data_13(in_data_13), .in_data_14(in_data_14), .in_data_15(in_data_15), .in_data_16(in_data_16), .in_data_17(in_data_17), .in_data_18(in_data_18), .in_data_19(in_data_19), .in_data_20(in_data_20), .in_data_21(in_data_21), .in_data_22(in_data_22), .in_data_23(in_data_23), .in_data_24(in_data_24),
  .Add_pim(4'b0000),
  .Compute_flag(1'b1),
  .clk(clk),
  .Out_data(out_data)
);

endmodule

module conv5x5 (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8, input [5:0] in_data_9, input [5:0] in_data_10, input [5:0] in_data_11, input [5:0] in_data_12, input [5:0] in_data_13, input [5:0] in_data_14, input [5:0] in_data_15, input [5:0] in_data_16, input [5:0] in_data_17, input [5:0] in_data_18, input [5:0] in_data_19, input [5:0] in_data_20, input [5:0] in_data_21, input [5:0] in_data_22, input [5:0] in_data_23, input [5:0] in_data_24, // 输入数据
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [17:0] Out_data // 输出数据
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

//  LL Unit
	conv #(.INPUT_SIZE(75), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL(
		.Input_feature({in_data_0[3:0], in_data_1[3:0], in_data_2[3:0], in_data_3[3:0], in_data_4[3:0], in_data_5[3:0], in_data_6[3:0], in_data_7[3:0], in_data_8[3:0], in_data_9[3:0], in_data_10[3:0], in_data_11[3:0], in_data_12[3:0], in_data_13[3:0], in_data_14[3:0], in_data_15[3:0], in_data_16[3:0], in_data_17[3:0], in_data_18[3:0], in_data_19[3:0], in_data_20[3:0], in_data_21[3:0], in_data_22[3:0], in_data_23[3:0], in_data_24[3:0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL),
		.clk(clk)
	);

	wire [5:0] tmp_out_1, tmp_out_2;
	// assign tmp_out_1 = tmp_result_HH + {tmp_result_HL[5:3], 3'b000};
	// assign out_data = tmp_out_1 + {tmp_result_LH[5:4], 4'b0000};
	// assign out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH;

		qadd1 #(.BIT_WIDTH(6), .OUT_WIDTH(6)) qadd_inst_1(
			.a(tmp_result_HH),
			.b(tmp_result_HL),
			.c(tmp_out_1)
		);
		qadd1 #(.BIT_WIDTH(6), .OUT_WIDTH(6)) qadd_inst_2(
			.a(tmp_result_LL),
			.b(tmp_result_LH),
			.c(tmp_out_2)
		);

		qadd1 #(.BIT_WIDTH(6), .OUT_WIDTH(6)) qadd_inst_3(
			.a(tmp_out_1),
			.b(tmp_out_2),
			.c(Out_data)
		);

endmodule

module qadd1 #(parameter BIT_WIDTH = 6, OUT_WIDTH = 8)(a,b,c);
input [BIT_WIDTH-1:0] a;
input [BIT_WIDTH-1:0] b;
output [BIT_WIDTH-1:0] c;

assign c = a + b;
//DW01_add #(`DWIDTH) u_add(.A(a), .B(b), .CI(1'b0), .SUM(c), .CO());
endmodule