/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2023-05-26 08:40:41
 * @FilePath: /Smokescreen/Flow/Circuits/CONV77/conv77_8bit_PIM.v
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



module conv77_8bit_PIM (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24,   input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44, input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48, 
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8, input [7:0] kernel_9, input [7:0] kernel_10, input [7:0] kernel_11, input [7:0] kernel_12,   input [7:0] kernel_13, input [7:0] kernel_14, input [7:0] kernel_15, input [7:0] kernel_16, input [7:0] kernel_17, input [7:0] kernel_18, input [7:0] kernel_19, input [7:0] kernel_20, input [7:0] kernel_21, input [7:0] kernel_22, input [7:0] kernel_23, input [7:0] kernel_24,   input [7:0] kernel_25, input [7:0] kernel_26, input [7:0] kernel_27, input [7:0] kernel_28, input [7:0] kernel_29, input [7:0] kernel_30, input [7:0] kernel_31, input [7:0] kernel_32, input [7:0] kernel_33, input [7:0] kernel_34, input [7:0] kernel_35, input [7:0] kernel_36,   input [7:0] kernel_37, input [7:0] kernel_38, input [7:0] kernel_39, input [7:0] kernel_40, input [7:0] kernel_41, input [7:0] kernel_42, input [7:0] kernel_43, input [7:0] kernel_44, input [7:0] kernel_45, input [7:0] kernel_46, input [7:0] kernel_47, input [7:0] kernel_48, 
  input clk,
  output [26:0] out_data // 输出数据
);  

conv5x5 single_conv(
  .in_data_0(in_data_0), .in_data_1(in_data_1), .in_data_2(in_data_2), .in_data_3(in_data_3), .in_data_4(in_data_4), .in_data_5(in_data_5), .in_data_6(in_data_6), .in_data_7(in_data_7), .in_data_8(in_data_8), .in_data_9(in_data_9), .in_data_10(in_data_10), .in_data_11(in_data_11),   .in_data_12(in_data_12), .in_data_13(in_data_13), .in_data_14(in_data_14), .in_data_15(in_data_15), .in_data_16(in_data_16), .in_data_17(in_data_17), .in_data_18(in_data_18), .in_data_19(in_data_19), .in_data_20(in_data_20), .in_data_21(in_data_21), .in_data_22(in_data_22), .in_data_23(in_data_23), .in_data_24(in_data_24),   .in_data_25(in_data_25), .in_data_26(in_data_26), .in_data_27(in_data_27), .in_data_28(in_data_28), .in_data_29(in_data_29), .in_data_30(in_data_30), .in_data_31(in_data_31), .in_data_32(in_data_32), .in_data_33(in_data_33), .in_data_34(in_data_34), .in_data_35(in_data_35), .in_data_36(in_data_36), .in_data_37(in_data_37),   .in_data_38(in_data_38), .in_data_39(in_data_39), .in_data_40(in_data_40), .in_data_41(in_data_41), .in_data_42(in_data_42), .in_data_43(in_data_43), .in_data_44(in_data_44), .in_data_45(in_data_45), .in_data_46(in_data_46), .in_data_47(in_data_47), .in_data_48(in_data_48), 
  .Add_pim(4'b0000),
  .Compute_flag(1'b1),
  .clk(clk),
  .Out_data(out_data)
);
endmodule

module conv7x7 (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24,   input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44, input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48,
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [26:0] Out_data // 输出数据
);  


	wire [7:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
//  HH Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH0(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL1(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH2(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6]}),		
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL3(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL),
		.clk(clk)
	);
	



	// assign Out_data = tmp_result_HH1 + tmp_result_HL1 + tmp_result_LH1 + tmp_result_LL1;


	wire [7:0] tmp_result_HH_1, tmp_result_HL_1, tmp_result_LH_1, tmp_result_LL_1;
//  HH Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH4(
		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5], in_data_32[5], in_data_33[5], in_data_34[5], in_data_35[5], in_data_36[5], in_data_37[5], in_data_38[5], in_data_39[5], in_data_40[5], in_data_41[5], in_data_42[5], in_data_43[5], in_data_44[5], in_data_45[5], in_data_46[5], in_data_47[5], in_data_48[5]}),		
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_1),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL5(
		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5], in_data_32[5], in_data_33[5], in_data_34[5], in_data_35[5], in_data_36[5], in_data_37[5], in_data_38[5], in_data_39[5], in_data_40[5], in_data_41[5], in_data_42[5], in_data_43[5], in_data_44[5], in_data_45[5], in_data_46[5], in_data_47[5], in_data_48[5]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_1),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH6(
		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4], in_data_32[4], in_data_33[4], in_data_34[4], in_data_35[4], in_data_36[4], in_data_37[4], in_data_38[4], in_data_39[4], in_data_40[4], in_data_41[4], in_data_42[4], in_data_43[4], in_data_44[4], in_data_45[4], in_data_46[4], in_data_47[4], in_data_48[4]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_1),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL7(
		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4], in_data_32[4], in_data_33[4], in_data_34[4], in_data_35[4], in_data_36[4], in_data_37[4], in_data_38[4], in_data_39[4], in_data_40[4], in_data_41[4], in_data_42[4], in_data_43[4], in_data_44[4], in_data_45[4], in_data_46[4], in_data_47[4], in_data_48[4]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_1),
		.clk(clk)
	);
	

	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;

	wire [7:0] tmp_result_HH_2, tmp_result_HL_2, tmp_result_LH_2, tmp_result_LL_2;
//  HH Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH8(
		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3], in_data_32[3], in_data_33[3], in_data_34[3], in_data_35[3], in_data_36[3], in_data_37[3], in_data_38[3], in_data_39[3], in_data_40[3], in_data_41[3], in_data_42[3], in_data_43[3], in_data_44[3], in_data_45[3], in_data_46[3], in_data_47[3], in_data_48[3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_2),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL9(
		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3], in_data_32[3], in_data_33[3], in_data_34[3], in_data_35[3], in_data_36[3], in_data_37[3], in_data_38[3], in_data_39[3], in_data_40[3], in_data_41[3], in_data_42[3], in_data_43[3], in_data_44[3], in_data_45[3], in_data_46[3], in_data_47[3], in_data_48[3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_2),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH10(
		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2], in_data_32[2], in_data_33[2], in_data_34[2], in_data_35[2], in_data_36[2], in_data_37[2], in_data_38[2], in_data_39[2], in_data_40[2], in_data_41[2], in_data_42[2], in_data_43[2], in_data_44[2], in_data_45[2], in_data_46[2], in_data_47[2], in_data_48[2]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_2),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL11(
		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2], in_data_32[2], in_data_33[2], in_data_34[2], in_data_35[2], in_data_36[2], in_data_37[2], in_data_38[2], in_data_39[2], in_data_40[2], in_data_41[2], in_data_42[2], in_data_43[2], in_data_44[2], in_data_45[2], in_data_46[2], in_data_47[2], in_data_48[2]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_2),
		.clk(clk)
	);
	
	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;




	wire [7:0] tmp_result_HH_3, tmp_result_HL_3, tmp_result_LH_3, tmp_result_LL_3;
//  HH Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH12(
		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1], in_data_32[1], in_data_33[1], in_data_34[1], in_data_35[1], in_data_36[1], in_data_37[1], in_data_38[1], in_data_39[1], in_data_40[1], in_data_41[1], in_data_42[1], in_data_43[1], in_data_44[1], in_data_45[1], in_data_46[1], in_data_47[1], in_data_48[1]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_3),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL13(
		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1], in_data_32[1], in_data_33[1], in_data_34[1], in_data_35[1], in_data_36[1], in_data_37[1], in_data_38[1], in_data_39[1], in_data_40[1], in_data_41[1], in_data_42[1], in_data_43[1], in_data_44[1], in_data_45[1], in_data_46[1], in_data_47[1], in_data_48[1]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_3),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH14(
		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0], in_data_32[0], in_data_33[0], in_data_34[0], in_data_35[0], in_data_36[0], in_data_37[0], in_data_38[0], in_data_39[0], in_data_40[0], in_data_41[0], in_data_42[0], in_data_43[0], in_data_44[0], in_data_45[0], in_data_46[0], in_data_47[0], in_data_48[0]}),		
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_3),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(49), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL15(
		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0], in_data_32[0], in_data_33[0], in_data_34[0], in_data_35[0], in_data_36[0], in_data_37[0], in_data_38[0], in_data_39[0], in_data_40[0], in_data_41[0], in_data_42[0], in_data_43[0], in_data_44[0], in_data_45[0], in_data_46[0], in_data_47[0], in_data_48[0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_3),
		.clk(clk)
	);
	
	wire [17:0] tmp_res[14];
	qadd2 qadd2_0(.a(tmp_result_HH), .b(tmp_result_HL),	.c(tmp_res[0]));
	qadd2 qadd2_1(.a(tmp_result_LH), .b(tmp_result_LL),	.c(tmp_res[1]));
	qadd2 qadd2_2(.a(tmp_result_HH_1), .b(tmp_result_HL_1),	.c(tmp_res[2]));
	qadd2 qadd2_3(.a(tmp_result_LH_1), .b(tmp_result_LL_1),	.c(tmp_res[3]));
	qadd2 qadd2_4(.a(tmp_result_HH_2), .b(tmp_result_HL_2),	.c(tmp_res[4]));
	qadd2 qadd2_5(.a(tmp_result_LH_2), .b(tmp_result_LL_2),	.c(tmp_res[5]));
	qadd2 qadd2_6(.a(tmp_result_HH_3), .b(tmp_result_HL_3),	.c(tmp_res[6]));
	qadd2 qadd2_7(.a(tmp_result_LH_3), .b(tmp_result_LL_3),	.c(tmp_res[7]));
	qadd2 qadd2_8(.a(tmp_res[0]), .b(tmp_res[1]),	.c(tmp_res[8]));
	qadd2 qadd2_9(.a(tmp_res[2]), .b(tmp_res[3]),	.c(tmp_res[9]));
	qadd2 qadd2_10(.a(tmp_res[4]), .b(tmp_res[5]),	.c(tmp_res[10]));
	qadd2 qadd2_11(.a(tmp_res[6]), .b(tmp_res[7]),	.c(tmp_res[11]));
	qadd2 qadd2_12(.a(tmp_res[8]), .b(tmp_res[9]),	.c(tmp_res[12]));
	qadd2 qadd2_13(.a(tmp_res[10]), .b(tmp_res[11]),	.c(tmp_res[13]));
	qadd2 qadd2_14(.a(tmp_res[12]), .b(tmp_res[13]),	.c(Out_data));

	// assign tmp_res[0] = tmp_result_HH + tmp_result_HL;
	// assign tmp_res[1] = tmp_result_LH + tmp_result_LL;
	// assign tmp_res[2] = tmp_result_HH_1 + tmp_result_HL_1;
	// assign tmp_res[3] = tmp_result_LH_1 + tmp_result_LL_1;
	// assign tmp_res[4] = tmp_result_HH_2 + tmp_result_HL_2;
	// assign tmp_res[5] = tmp_result_LH_2 + tmp_result_LL_2;
	// assign tmp_res[6] = tmp_result_HH_3 + tmp_result_HL_3;
	// assign tmp_res[7] = tmp_result_LH_3 + tmp_result_LL_3;
	// assign tmp_res[8] = tmp_res[0] + tmp_res[1];
	// assign tmp_res[9] = tmp_res[2] + tmp_res[3];
	// assign tmp_res[10] = tmp_res[4] + tmp_res[5];
	// assign tmp_res[11] = tmp_res[6] + tmp_res[7];
	// assign tmp_res[12] = tmp_res[8] + tmp_res[9];
	// assign tmp_res[13] = tmp_res[10] + tmp_res[11];
	// assign Out_data = tmp_res[12] + tmp_res[13];



endmodule


module qadd2(
 input [15:0] a,
 input [15:0] b,
 output [15:0] c
    );
    
assign c = a + b;


endmodule
