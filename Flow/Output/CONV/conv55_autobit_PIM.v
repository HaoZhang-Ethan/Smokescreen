/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2023-05-09 01:59:33
 * @FilePath: /Smokescreen/Flow/Circuits/CNN_self/conv55_autobit_PIM.v
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



module conv55_autobit_PIM #(parameter P_IN = 12) (
  input [P_IN-1:0] in_data_0, input [P_IN-1:0] in_data_1, input [P_IN-1:0] in_data_2, input [P_IN-1:0] in_data_3, input [P_IN-1:0] in_data_4, input [P_IN-1:0] in_data_5, input [P_IN-1:0] in_data_6, input [P_IN-1:0] in_data_7, input [P_IN-1:0] in_data_8, input [P_IN-1:0] in_data_9, input [P_IN-1:0] in_data_10, input [P_IN-1:0] in_data_11, input [P_IN-1:0] in_data_12, input [P_IN-1:0] in_data_13, input [P_IN-1:0] in_data_14, input [P_IN-1:0] in_data_15, input [P_IN-1:0] in_data_16, input [P_IN-1:0] in_data_17, input [P_IN-1:0] in_data_18, input [P_IN-1:0] in_data_19, input [P_IN-1:0] in_data_20, input [P_IN-1:0] in_data_21, input [P_IN-1:0] in_data_22, input [P_IN-1:0] in_data_23, input [P_IN-1:0] in_data_24, // 输入数据
  input [P_IN-1:0] kernel_0, input [P_IN-1:0] kernel_1, input [P_IN-1:0] kernel_2, input [P_IN-1:0] kernel_3, input [P_IN-1:0] kernel_4, input [P_IN-1:0] kernel_5, input [P_IN-1:0] kernel_6, input [P_IN-1:0] kernel_7, input [P_IN-1:0] kernel_8, input [P_IN-1:0] kernel_9, input [P_IN-1:0] kernel_10, input [P_IN-1:0] kernel_11, input [P_IN-1:0] kernel_12, input [P_IN-1:0] kernel_13, input [P_IN-1:0] kernel_14, input [P_IN-1:0] kernel_15, input [P_IN-1:0] kernel_16, input [P_IN-1:0] kernel_17, input [P_IN-1:0] kernel_18, input [P_IN-1:0] kernel_19, input [P_IN-1:0] kernel_20, input [P_IN-1:0] kernel_21, input [P_IN-1:0] kernel_22, input [P_IN-1:0] kernel_23, input [P_IN-1:0] kernel_24,// 卷积核
  input clk,
  output [17:0] out_data // 输出数据
);  

	if (P_IN > 6) begin
		wire [17:0] result_HH, result_HL, result_LH, result_LL;
		// wire [18:0] tmp_result_1, tmp_result_2;
		conv55_autobit_PIM  #(.P_IN(P_IN/2)) conv55_autobit_PIM_inst_HH(
		.in_data_0(in_data_0[P_IN-1:P_IN/2]), .in_data_1(in_data_1[P_IN-1:P_IN/2]), .in_data_2(in_data_2[P_IN-1:P_IN/2]), .in_data_3(in_data_3[P_IN-1:P_IN/2]), .in_data_4(in_data_4[P_IN-1:P_IN/2]), .in_data_5(in_data_5[P_IN-1:P_IN/2]), .in_data_6(in_data_6[P_IN-1:P_IN/2]), .in_data_7(in_data_7[P_IN-1:P_IN/2]), .in_data_8(in_data_8[P_IN-1:P_IN/2]), .in_data_9(in_data_9[P_IN-1:P_IN/2]), .in_data_10(in_data_10[P_IN-1:P_IN/2]), .in_data_11(in_data_11[P_IN-1:P_IN/2]), .in_data_12(in_data_12[P_IN-1:P_IN/2]), .in_data_13(in_data_13[P_IN-1:P_IN/2]), .in_data_14(in_data_14[P_IN-1:P_IN/2]), .in_data_15(in_data_15[P_IN-1:P_IN/2]), .in_data_16(in_data_16[P_IN-1:P_IN/2]), .in_data_17(in_data_17[P_IN-1:P_IN/2]), .in_data_18(in_data_18[P_IN-1:P_IN/2]), .in_data_19(in_data_19[P_IN-1:P_IN/2]), .in_data_20(in_data_20[P_IN-1:P_IN/2]), .in_data_21(in_data_21[P_IN-1:P_IN/2]), .in_data_22(in_data_22[P_IN-1:P_IN/2]), .in_data_23(in_data_23[P_IN-1:P_IN/2]), .in_data_24(in_data_24[P_IN-1:P_IN/2]),
		.kernel_0(kernel_0), .kernel_1(kernel_1), .kernel_2(kernel_2), .kernel_3(kernel_3), .kernel_4(kernel_4), .kernel_5(kernel_5), .kernel_6(kernel_6), .kernel_7(kernel_7), .kernel_8(kernel_8), .kernel_9(kernel_9), .kernel_10(kernel_10), .kernel_11(kernel_11), .kernel_12(kernel_12), .kernel_13(kernel_13), .kernel_14(kernel_14), .kernel_15(kernel_15), .kernel_16(kernel_16), .kernel_17(kernel_17), .kernel_18(kernel_18), .kernel_19(kernel_19), .kernel_20(kernel_20), .kernel_21(kernel_21), .kernel_22(kernel_22), .kernel_23(kernel_23), .kernel_24(kernel_24),
		.clk(clk),
		.out_data(result_HH)
		);
		conv55_autobit_PIM  #(.P_IN(P_IN/2)) conv55_autobit_PIM_inst_HL(
		.in_data_0(in_data_0[P_IN-1:P_IN/2]), .in_data_1(in_data_1[P_IN-1:P_IN/2]), .in_data_2(in_data_2[P_IN-1:P_IN/2]), .in_data_3(in_data_3[P_IN-1:P_IN/2]), .in_data_4(in_data_4[P_IN-1:P_IN/2]), .in_data_5(in_data_5[P_IN-1:P_IN/2]), .in_data_6(in_data_6[P_IN-1:P_IN/2]), .in_data_7(in_data_7[P_IN-1:P_IN/2]), .in_data_8(in_data_8[P_IN-1:P_IN/2]), .in_data_9(in_data_9[P_IN-1:P_IN/2]), .in_data_10(in_data_10[P_IN-1:P_IN/2]), .in_data_11(in_data_11[P_IN-1:P_IN/2]), .in_data_12(in_data_12[P_IN-1:P_IN/2]), .in_data_13(in_data_13[P_IN-1:P_IN/2]), .in_data_14(in_data_14[P_IN-1:P_IN/2]), .in_data_15(in_data_15[P_IN-1:P_IN/2]), .in_data_16(in_data_16[P_IN-1:P_IN/2]), .in_data_17(in_data_17[P_IN-1:P_IN/2]), .in_data_18(in_data_18[P_IN-1:P_IN/2]), .in_data_19(in_data_19[P_IN-1:P_IN/2]), .in_data_20(in_data_20[P_IN-1:P_IN/2]), .in_data_21(in_data_21[P_IN-1:P_IN/2]), .in_data_22(in_data_22[P_IN-1:P_IN/2]), .in_data_23(in_data_23[P_IN-1:P_IN/2]), .in_data_24(in_data_24[P_IN-1:P_IN/2]),
		.kernel_0(kernel_0), .kernel_1(kernel_1), .kernel_2(kernel_2), .kernel_3(kernel_3), .kernel_4(kernel_4), .kernel_5(kernel_5), .kernel_6(kernel_6), .kernel_7(kernel_7), .kernel_8(kernel_8), .kernel_9(kernel_9), .kernel_10(kernel_10), .kernel_11(kernel_11), .kernel_12(kernel_12), .kernel_13(kernel_13), .kernel_14(kernel_14), .kernel_15(kernel_15), .kernel_16(kernel_16), .kernel_17(kernel_17), .kernel_18(kernel_18), .kernel_19(kernel_19), .kernel_20(kernel_20), .kernel_21(kernel_21), .kernel_22(kernel_22), .kernel_23(kernel_23), .kernel_24(kernel_24),
		.clk(clk),
		.out_data(result_HL)
		);
		conv55_autobit_PIM  #(.P_IN(P_IN/2)) conv55_autobit_PIM_inst_LH(
		.in_data_0(in_data_0[P_IN/2-1:0]), .in_data_1(in_data_1[P_IN/2-1:0]), .in_data_2(in_data_2[P_IN/2-1:0]), .in_data_3(in_data_3[P_IN/2-1:0]), .in_data_4(in_data_4[P_IN/2-1:0]), .in_data_5(in_data_5[P_IN/2-1:0]), .in_data_6(in_data_6[P_IN/2-1:0]), .in_data_7(in_data_7[P_IN/2-1:0]), .in_data_8(in_data_8[P_IN/2-1:0]), .in_data_9(in_data_9[P_IN/2-1:0]), .in_data_10(in_data_10[P_IN/2-1:0]), .in_data_11(in_data_11[P_IN/2-1:0]), .in_data_12(in_data_12[P_IN/2-1:0]), .in_data_13(in_data_13[P_IN/2-1:0]), .in_data_14(in_data_14[P_IN/2-1:0]), .in_data_15(in_data_15[P_IN/2-1:0]), .in_data_16(in_data_16[P_IN/2-1:0]), .in_data_17(in_data_17[P_IN/2-1:0]), .in_data_18(in_data_18[P_IN/2-1:0]), .in_data_19(in_data_19[P_IN/2-1:0]), .in_data_20(in_data_20[P_IN/2-1:0]), .in_data_21(in_data_21[P_IN/2-1:0]), .in_data_22(in_data_22[P_IN/2-1:0]), .in_data_23(in_data_23[P_IN/2-1:0]), .in_data_24(in_data_24[P_IN/2-1:0]),
		.kernel_0(kernel_0), .kernel_1(kernel_1), .kernel_2(kernel_2), .kernel_3(kernel_3), .kernel_4(kernel_4), .kernel_5(kernel_5), .kernel_6(kernel_6), .kernel_7(kernel_7), .kernel_8(kernel_8), .kernel_9(kernel_9), .kernel_10(kernel_10), .kernel_11(kernel_11), .kernel_12(kernel_12), .kernel_13(kernel_13), .kernel_14(kernel_14), .kernel_15(kernel_15), .kernel_16(kernel_16), .kernel_17(kernel_17), .kernel_18(kernel_18), .kernel_19(kernel_19), .kernel_20(kernel_20), .kernel_21(kernel_21), .kernel_22(kernel_22), .kernel_23(kernel_23), .kernel_24(kernel_24),
		.clk(clk),
		.out_data(result_LH)
		);

		conv55_autobit_PIM  #(.P_IN(P_IN/2)) conv55_autobit_PIM_inst_LL(
		.in_data_0(in_data_0[P_IN/2-1:0]), .in_data_1(in_data_1[P_IN/2-1:0]), .in_data_2(in_data_2[P_IN/2-1:0]), .in_data_3(in_data_3[P_IN/2-1:0]), .in_data_4(in_data_4[P_IN/2-1:0]), .in_data_5(in_data_5[P_IN/2-1:0]), .in_data_6(in_data_6[P_IN/2-1:0]), .in_data_7(in_data_7[P_IN/2-1:0]), .in_data_8(in_data_8[P_IN/2-1:0]), .in_data_9(in_data_9[P_IN/2-1:0]), .in_data_10(in_data_10[P_IN/2-1:0]), .in_data_11(in_data_11[P_IN/2-1:0]), .in_data_12(in_data_12[P_IN/2-1:0]), .in_data_13(in_data_13[P_IN/2-1:0]), .in_data_14(in_data_14[P_IN/2-1:0]), .in_data_15(in_data_15[P_IN/2-1:0]), .in_data_16(in_data_16[P_IN/2-1:0]), .in_data_17(in_data_17[P_IN/2-1:0]), .in_data_18(in_data_18[P_IN/2-1:0]), .in_data_19(in_data_19[P_IN/2-1:0]), .in_data_20(in_data_20[P_IN/2-1:0]), .in_data_21(in_data_21[P_IN/2-1:0]), .in_data_22(in_data_22[P_IN/2-1:0]), .in_data_23(in_data_23[P_IN/2-1:0]), .in_data_24(in_data_24[P_IN/2-1:0]),
		.kernel_0(kernel_0), .kernel_1(kernel_1), .kernel_2(kernel_2), .kernel_3(kernel_3), .kernel_4(kernel_4), .kernel_5(kernel_5), .kernel_6(kernel_6), .kernel_7(kernel_7), .kernel_8(kernel_8), .kernel_9(kernel_9), .kernel_10(kernel_10), .kernel_11(kernel_11), .kernel_12(kernel_12), .kernel_13(kernel_13), .kernel_14(kernel_14), .kernel_15(kernel_15), .kernel_16(kernel_16), .kernel_17(kernel_17), .kernel_18(kernel_18), .kernel_19(kernel_19), .kernel_20(kernel_20), .kernel_21(kernel_21), .kernel_22(kernel_22), .kernel_23(kernel_23), .kernel_24(kernel_24),
		.clk(clk),
		.out_data(result_LL)
		);
		// assign tmp_result_1 = result_HH + result_HL;
		// assign tmp_result_2 = result_LL + result_LH;
		assign out_data = result_HH[15:0] | result_HL[15:0] | result_LL[15:0] | result_LH[15:0];
	end
	else begin
		conv5x5 single_conv(
		.in_data_0(in_data_0), .in_data_1(in_data_1), .in_data_2(in_data_2), .in_data_3(in_data_3), .in_data_4(in_data_4), .in_data_5(in_data_5), .in_data_6(in_data_6), .in_data_7(in_data_7), .in_data_8(in_data_8), .in_data_9(in_data_9), .in_data_10(in_data_10), .in_data_11(in_data_11), .in_data_12(in_data_12), .in_data_13(in_data_13), .in_data_14(in_data_14), .in_data_15(in_data_15), .in_data_16(in_data_16), .in_data_17(in_data_17), .in_data_18(in_data_18), .in_data_19(in_data_19), .in_data_20(in_data_20), .in_data_21(in_data_21), .in_data_22(in_data_22), .in_data_23(in_data_23), .in_data_24(in_data_24),
		.Add_pim(4'b0000),
		.Compute_flag(1'b1),
		.clk(clk),
		.Out_data(out_data)
		);
	end

endmodule

module conv5x5 (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8, input [5:0] in_data_9, input [5:0] in_data_10, input [5:0] in_data_11, input [5:0] in_data_12, input [5:0] in_data_13, input [5:0] in_data_14, input [5:0] in_data_15, input [5:0] in_data_16, input [5:0] in_data_17, input [5:0] in_data_18, input [5:0] in_data_19, input [5:0] in_data_20, input [5:0] in_data_21, input [5:0] in_data_22, input [5:0] in_data_23, input [5:0] in_data_24, // 输入数据
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [17:0] Out_data // 输出数据
);  

	wire [5:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
	wire [17:0] tmp1, tmp2;
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

		assign tmp1 = tmp_result_HH + tmp_result_HL;
		assign tmp2 = tmp_result_LL + tmp_result_LH;
		assign Out_data = tmp1 + tmp2;

endmodule
