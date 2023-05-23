

module vecmat32_PIM
(
	input clk,
	input reset,
	input [511:0] vector,
	input [511:0] matrix,

	output [15:0] data_out
);

	conv_top_32 conv_top_32_inst_1(
	.in_data_0(vector[7:0]), .in_data_1(vector[23:16]), .in_data_2(vector[39:32]), .in_data_3(vector[55:48]), .in_data_4(vector[71:64]), .in_data_5(vector[87:80]), .in_data_6(vector[103:96]), .in_data_7(vector[119:112]), .in_data_8(vector[135:128]), .in_data_9(vector[151:144]), .in_data_10(vector[167:160]), .in_data_11(vector[183:176]), .in_data_12(vector[199:192]), .in_data_13(vector[215:208]), .in_data_14(vector[231:224]), .in_data_15(vector[247:240]), .in_data_16(vector[263:256]), .in_data_17(vector[279:272]), .in_data_18(vector[295:288]), .in_data_19(vector[311:304]), .in_data_20(vector[327:320]), .in_data_21(vector[343:336]), .in_data_22(vector[359:352]), .in_data_23(vector[375:368]), .in_data_24(vector[391:384]), .in_data_25(vector[407:400]), .in_data_26(vector[423:416]), .in_data_27(vector[439:432]), .in_data_28(vector[455:448]), .in_data_29(vector[471:464]), .in_data_30(vector[487:480]), .in_data_31(vector[503:496]),
	.Add_pim(4'b0000),
	.Compute_flag(1'b1),
	.clk(clk),
	.Out_data(data_out)
	);
	
endmodule





module conv_top_32 (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24, input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31,
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [17:0] Out_data // 输出数据
);  


	wire [7:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
//  HH Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH0(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL1(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH2(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL3(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL),
		.clk(clk)
	);
	



	// assign Out_data = tmp_result_HH1 + tmp_result_HL1 + tmp_result_LH1 + tmp_result_LL1;


	wire [7:0] tmp_result_HH_1, tmp_result_HL_1, tmp_result_LH_1, tmp_result_LL_1;
//  HH Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH4(
		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_1),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL5(
		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_1),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH6(
		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_1),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL7(
		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_1),
		.clk(clk)
	);
	

	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;

	wire [7:0] tmp_result_HH_2, tmp_result_HL_2, tmp_result_LH_2, tmp_result_LL_2;
//  HH Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH8(
		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_2),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL9(
		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_2),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH10(
		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_2),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL11(
		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_2),
		.clk(clk)
	);
	
	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;




	wire [7:0] tmp_result_HH_3, tmp_result_HL_3, tmp_result_LH_3, tmp_result_LL_3;
//  HH Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH12(
		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_3),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL13(
		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_3),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH14(
		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_3),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(32), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL15(
		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_3),
		.clk(clk)
	);
	
	wire [17:0] tmp_res[15];
    qadd_in qadd_in_0(.a(tmp_result_HH), .b(tmp_result_HL), .sum(tmp_res[0]));
    qadd_in qadd_in_1(.a(tmp_result_LH), .b(tmp_result_LL), .sum(tmp_res[1]));
    qadd_in qadd_in_2(.a(tmp_result_HH_1), .b(tmp_result_HL_1), .sum(tmp_res[2]));
    qadd_in qadd_in_3(.a(tmp_result_LH_1), .b(tmp_result_LL_1), .sum(tmp_res[3]));
    qadd_in qadd_in_4(.a(tmp_result_HH_2), .b(tmp_result_HL_2), .sum(tmp_res[4]));
    qadd_in qadd_in_5(.a(tmp_result_LH_2), .b(tmp_result_LL_2), .sum(tmp_res[5]));
    qadd_in qadd_in_6(.a(tmp_result_HH_3), .b(tmp_result_HL_3), .sum(tmp_res[6]));
    qadd_in qadd_in_7(.a(tmp_result_LH_3), .b(tmp_result_LL_3), .sum(tmp_res[7]));
    qadd_in qadd_in_8(.a(tmp_res[0]), .b(tmp_res[1]), .sum(tmp_res[8]));
    qadd_in qadd_in_9(.a(tmp_res[2]), .b(tmp_res[3]), .sum(tmp_res[9]));
    qadd_in qadd_in_10(.a(tmp_res[4]), .b(tmp_res[5]), .sum(tmp_res[10]));
    qadd_in qadd_in_11(.a(tmp_res[6]), .b(tmp_res[7]), .sum(tmp_res[11]));
    qadd_in qadd_in_12(.a(tmp_res[8]), .b(tmp_res[9]), .sum(tmp_res[12]));
    qadd_in qadd_in_13(.a(tmp_res[10]), .b(tmp_res[11]), .sum(tmp_res[13]));
    qadd_in qadd_in_14(.a(tmp_res[12]), .b(tmp_res[13]), .sum(tmp_res[14]));
	assign Out_data = tmp_res[14];


endmodule

