
function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = -1; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction



module vecmat_PIM
(
	input clk,
	input reset,
	input [1023:0] vector,
	input [1023:0] matrix,

	output [15:0] data_out
);

	conv_top_64 conv_top_64_inst_1(
	.in_data_0(vector[7:0]), .in_data_1(vector[23:16]), .in_data_2(vector[39:32]), .in_data_3(vector[55:48]), .in_data_4(vector[71:64]), .in_data_5(vector[87:80]), .in_data_6(vector[103:96]), .in_data_7(vector[119:112]), .in_data_8(vector[135:128]), .in_data_9(vector[151:144]), .in_data_10(vector[167:160]), .in_data_11(vector[183:176]), .in_data_12(vector[199:192]), .in_data_13(vector[215:208]), .in_data_14(vector[231:224]), .in_data_15(vector[247:240]), .in_data_16(vector[263:256]), .in_data_17(vector[279:272]), .in_data_18(vector[295:288]), .in_data_19(vector[311:304]), .in_data_20(vector[327:320]), .in_data_21(vector[343:336]), .in_data_22(vector[359:352]), .in_data_23(vector[375:368]), .in_data_24(vector[391:384]), .in_data_25(vector[407:400]), .in_data_26(vector[423:416]), .in_data_27(vector[439:432]), .in_data_28(vector[455:448]), .in_data_29(vector[471:464]), .in_data_30(vector[487:480]), .in_data_31(vector[503:496]), .in_data_32(vector[519:512]), .in_data_33(vector[535:528]), .in_data_34(vector[551:544]), .in_data_35(vector[567:560]), .in_data_36(vector[583:576]), .in_data_37(vector[599:592]), .in_data_38(vector[615:608]), .in_data_39(vector[631:624]), .in_data_40(vector[647:640]), .in_data_41(vector[663:656]), .in_data_42(vector[679:672]), .in_data_43(vector[695:688]), .in_data_44(vector[711:704]), .in_data_45(vector[727:720]), .in_data_46(vector[743:736]), .in_data_47(vector[759:752]), .in_data_48(vector[775:768]), .in_data_49(vector[791:784]), .in_data_50(vector[807:800]), .in_data_51(vector[823:816]), .in_data_52(vector[839:832]), .in_data_53(vector[855:848]), .in_data_54(vector[871:864]), .in_data_55(vector[887:880]), .in_data_56(vector[903:896]), .in_data_57(vector[919:912]), .in_data_58(vector[935:928]), .in_data_59(vector[951:944]), .in_data_60(vector[967:960]), .in_data_61(vector[983:976]), .in_data_62(vector[999:992]), .in_data_63(vector[1015:1008]),
	.Add_pim(4'b0000),
	.Compute_flag(1'b1),
	.clk(clk),
	.Out_data(data_out)
	);
	
endmodule







module conv_top_64 (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24, input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44, input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48, input [7:0] in_data_49, input [7:0] in_data_50, input [7:0] in_data_51, input [7:0] in_data_52, input [7:0] in_data_53, input [7:0] in_data_54, input [7:0] in_data_55, input [7:0] in_data_56, input [7:0] in_data_57, input [7:0] in_data_58, input [7:0] in_data_59, input [7:0] in_data_60, input [7:0] in_data_61, input [7:0] in_data_62, input [7:0] in_data_63, 
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [17:0] Out_data // 输出数据
);  


	wire [7:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
//  HH Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH0(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7] }),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL1(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7] }),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH2(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6], in_data_49[6], in_data_50[6], in_data_51[6], in_data_52[6], in_data_53[6], in_data_54[6], in_data_55[6], in_data_56[6], in_data_57[6], in_data_58[6], in_data_59[6], in_data_60[6], in_data_61[6], in_data_62[6], in_data_63[6], in_data_64[6] }),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL3(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6], in_data_49[6], in_data_50[6], in_data_51[6], in_data_52[6], in_data_53[6], in_data_54[6], in_data_55[6], in_data_56[6], in_data_57[6], in_data_58[6], in_data_59[6], in_data_60[6], in_data_61[6], in_data_62[6], in_data_63[6], in_data_64[6]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL),
		.clk(clk)
	);
	



	// assign Out_data = tmp_result_HH1 + tmp_result_HL1 + tmp_result_LH1 + tmp_result_LL1;


	wire [7:0] tmp_result_HH_1, tmp_result_HL_1, tmp_result_LH_1, tmp_result_LL_1;
//  HH Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH4(
		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5], in_data_32[5], in_data_33[5], in_data_34[5], in_data_35[5], in_data_36[5], in_data_37[5], in_data_38[5], in_data_39[5], in_data_40[5], in_data_41[5], in_data_42[5], in_data_43[5], in_data_44[5], in_data_45[5], in_data_46[5], in_data_47[5], in_data_48[5], in_data_49[5], in_data_50[5], in_data_51[5], in_data_52[5], in_data_53[5], in_data_54[5], in_data_55[5], in_data_56[5], in_data_57[5], in_data_58[5], in_data_59[5], in_data_60[5], in_data_61[5], in_data_62[5], in_data_63[5], in_data_64[5] }),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_1),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL5(
		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5], in_data_32[5], in_data_33[5], in_data_34[5], in_data_35[5], in_data_36[5], in_data_37[5], in_data_38[5], in_data_39[5], in_data_40[5], in_data_41[5], in_data_42[5], in_data_43[5], in_data_44[5], in_data_45[5], in_data_46[5], in_data_47[5], in_data_48[5], in_data_49[5], in_data_50[5], in_data_51[5], in_data_52[5], in_data_53[5], in_data_54[5], in_data_55[5], in_data_56[5], in_data_57[5], in_data_58[5], in_data_59[5], in_data_60[5], in_data_61[5], in_data_62[5], in_data_63[5], in_data_64[5]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_1),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH6(
		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4], in_data_32[4], in_data_33[4], in_data_34[4], in_data_35[4], in_data_36[4], in_data_37[4], in_data_38[4], in_data_39[4], in_data_40[4], in_data_41[4], in_data_42[4], in_data_43[4], in_data_44[4], in_data_45[4], in_data_46[4], in_data_47[4], in_data_48[4], in_data_49[4], in_data_50[4], in_data_51[4], in_data_52[4], in_data_53[4], in_data_54[4], in_data_55[4], in_data_56[4], in_data_57[4], in_data_58[4], in_data_59[4], in_data_60[4], in_data_61[4], in_data_62[4], in_data_63[4], in_data_64[4]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_1),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL7(
		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4], in_data_32[4], in_data_33[4], in_data_34[4], in_data_35[4], in_data_36[4], in_data_37[4], in_data_38[4], in_data_39[4], in_data_40[4], in_data_41[4], in_data_42[4], in_data_43[4], in_data_44[4], in_data_45[4], in_data_46[4], in_data_47[4], in_data_48[4], in_data_49[4], in_data_50[4], in_data_51[4], in_data_52[4], in_data_53[4], in_data_54[4], in_data_55[4], in_data_56[4], in_data_57[4], in_data_58[4], in_data_59[4], in_data_60[4], in_data_61[4], in_data_62[4], in_data_63[4], in_data_64[4]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_1),
		.clk(clk)
	);
	

	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;

	wire [7:0] tmp_result_HH_2, tmp_result_HL_2, tmp_result_LH_2, tmp_result_LL_2;
//  HH Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH8(
		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3], in_data_32[3], in_data_33[3], in_data_34[3], in_data_35[3], in_data_36[3], in_data_37[3], in_data_38[3], in_data_39[3], in_data_40[3], in_data_41[3], in_data_42[3], in_data_43[3], in_data_44[3], in_data_45[3], in_data_46[3], in_data_47[3], in_data_48[3], in_data_49[3], in_data_50[3], in_data_51[3], in_data_52[3], in_data_53[3], in_data_54[3], in_data_55[3], in_data_56[3], in_data_57[3], in_data_58[3], in_data_59[3], in_data_60[3], in_data_61[3], in_data_62[3], in_data_63[3], in_data_64[3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_2),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL9(
		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3], in_data_32[3], in_data_33[3], in_data_34[3], in_data_35[3], in_data_36[3], in_data_37[3], in_data_38[3], in_data_39[3], in_data_40[3], in_data_41[3], in_data_42[3], in_data_43[3], in_data_44[3], in_data_45[3], in_data_46[3], in_data_47[3], in_data_48[3], in_data_49[3], in_data_50[3], in_data_51[3], in_data_52[3], in_data_53[3], in_data_54[3], in_data_55[3], in_data_56[3], in_data_57[3], in_data_58[3], in_data_59[3], in_data_60[3], in_data_61[3], in_data_62[3], in_data_63[3], in_data_64[3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_2),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH10(
		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2], in_data_32[2], in_data_33[2], in_data_34[2], in_data_35[2], in_data_36[2], in_data_37[2], in_data_38[2], in_data_39[2], in_data_40[2], in_data_41[2], in_data_42[2], in_data_43[2], in_data_44[2], in_data_45[2], in_data_46[2], in_data_47[2], in_data_48[2], in_data_49[2], in_data_50[2], in_data_51[2], in_data_52[2], in_data_53[2], in_data_54[2], in_data_55[2], in_data_56[2], in_data_57[2], in_data_58[2], in_data_59[2], in_data_60[2], in_data_61[2], in_data_62[2], in_data_63[2], in_data_64[2]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_2),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL11(
		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2], in_data_32[2], in_data_33[2], in_data_34[2], in_data_35[2], in_data_36[2], in_data_37[2], in_data_38[2], in_data_39[2], in_data_40[2], in_data_41[2], in_data_42[2], in_data_43[2], in_data_44[2], in_data_45[2], in_data_46[2], in_data_47[2], in_data_48[2], in_data_49[2], in_data_50[2], in_data_51[2], in_data_52[2], in_data_53[2], in_data_54[2], in_data_55[2], in_data_56[2], in_data_57[2], in_data_58[2], in_data_59[2], in_data_60[2], in_data_61[2], in_data_62[2], in_data_63[2], in_data_64[2]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_2),
		.clk(clk)
	);
	
	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;




	wire [7:0] tmp_result_HH_3, tmp_result_HL_3, tmp_result_LH_3, tmp_result_LL_3;
//  HH Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH12(
		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1], in_data_32[1], in_data_33[1], in_data_34[1], in_data_35[1], in_data_36[1], in_data_37[1], in_data_38[1], in_data_39[1], in_data_40[1], in_data_41[1], in_data_42[1], in_data_43[1], in_data_44[1], in_data_45[1], in_data_46[1], in_data_47[1], in_data_48[1], in_data_49[1], in_data_50[1], in_data_51[1], in_data_52[1], in_data_53[1], in_data_54[1], in_data_55[1], in_data_56[1], in_data_57[1], in_data_58[1], in_data_59[1], in_data_60[1], in_data_61[1], in_data_62[1], in_data_63[1], in_data_64[1]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_3),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL13(
		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1], in_data_32[1], in_data_33[1], in_data_34[1], in_data_35[1], in_data_36[1], in_data_37[1], in_data_38[1], in_data_39[1], in_data_40[1], in_data_41[1], in_data_42[1], in_data_43[1], in_data_44[1], in_data_45[1], in_data_46[1], in_data_47[1], in_data_48[1], in_data_49[1], in_data_50[1], in_data_51[1], in_data_52[1], in_data_53[1], in_data_54[1], in_data_55[1], in_data_56[1], in_data_57[1], in_data_58[1], in_data_59[1], in_data_60[1], in_data_61[1], in_data_62[1], in_data_63[1], in_data_64[1]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_3),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH14(
		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0], in_data_32[0], in_data_33[0], in_data_34[0], in_data_35[0], in_data_36[0], in_data_37[0], in_data_38[0], in_data_39[0], in_data_40[0], in_data_41[0], in_data_42[0], in_data_43[0], in_data_44[0], in_data_45[0], in_data_46[0], in_data_47[0], in_data_48[0], in_data_49[0], in_data_50[0], in_data_51[0], in_data_52[0], in_data_53[0], in_data_54[0], in_data_55[0], in_data_56[0], in_data_57[0], in_data_58[0], in_data_59[0], in_data_60[0], in_data_61[0], in_data_62[0], in_data_63[0], in_data_64[0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_3),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL15(
		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0], in_data_32[0], in_data_33[0], in_data_34[0], in_data_35[0], in_data_36[0], in_data_37[0], in_data_38[0], in_data_39[0], in_data_40[0], in_data_41[0], in_data_42[0], in_data_43[0], in_data_44[0], in_data_45[0], in_data_46[0], in_data_47[0], in_data_48[0], in_data_49[0], in_data_50[0], in_data_51[0], in_data_52[0], in_data_53[0], in_data_54[0], in_data_55[0], in_data_56[0], in_data_57[0], in_data_58[0], in_data_59[0], in_data_60[0], in_data_61[0], in_data_62[0], in_data_63[0], in_data_64[0]}),
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

