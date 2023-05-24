
module vecmat_x_6_PIM #( parameter varraysize=1600, vectwidth=100)
(
	input clk,
	input reset,
	input [varraysize-1:0] data_x,
	input [varraysize-1:0] W_x,

	output reg [15:0] data_out_x
);

conv_top_100_6 conv_top_100_inst_1(
.in_data_0(data_x[7:0]), .in_data_1(data_x[23:16]), .in_data_2(data_x[39:32]), .in_data_3(data_x[55:48]), .in_data_4(data_x[71:64]), .in_data_5(data_x[87:80]), .in_data_6(data_x[103:96]), .in_data_7(data_x[119:112]), .in_data_8(data_x[135:128]), .in_data_9(data_x[151:144]), .in_data_10(data_x[167:160]), .in_data_11(data_x[183:176]), .in_data_12(data_x[199:192]), .in_data_13(data_x[215:208]), .in_data_14(data_x[231:224]), .in_data_15(data_x[247:240]), .in_data_16(data_x[263:256]), .in_data_17(data_x[279:272]), .in_data_18(data_x[295:288]), .in_data_19(data_x[311:304]), .in_data_20(data_x[327:320]), .in_data_21(data_x[343:336]), .in_data_22(data_x[359:352]), .in_data_23(data_x[375:368]), .in_data_24(data_x[391:384]), .in_data_25(data_x[407:400]), .in_data_26(data_x[423:416]), .in_data_27(data_x[439:432]), .in_data_28(data_x[455:448]), .in_data_29(data_x[471:464]), .in_data_30(data_x[487:480]), .in_data_31(data_x[503:496]), .in_data_32(data_x[519:512]), .in_data_33(data_x[535:528]), .in_data_34(data_x[551:544]), .in_data_35(data_x[567:560]), .in_data_36(data_x[583:576]), .in_data_37(data_x[599:592]), .in_data_38(data_x[615:608]), .in_data_39(data_x[631:624]), .in_data_40(data_x[647:640]), .in_data_41(data_x[663:656]), .in_data_42(data_x[679:672]), .in_data_43(data_x[695:688]), .in_data_44(data_x[711:704]), .in_data_45(data_x[727:720]), .in_data_46(data_x[743:736]), .in_data_47(data_x[759:752]), .in_data_48(data_x[775:768]), .in_data_49(data_x[791:784]), .in_data_50(data_x[807:800]), .in_data_51(data_x[823:816]), .in_data_52(data_x[839:832]), .in_data_53(data_x[855:848]), .in_data_54(data_x[871:864]), .in_data_55(data_x[887:880]), .in_data_56(data_x[903:896]), .in_data_57(data_x[919:912]), .in_data_58(data_x[935:928]), .in_data_59(data_x[951:944]), .in_data_60(data_x[967:960]), .in_data_61(data_x[983:976]), .in_data_62(data_x[999:992]), .in_data_63(data_x[1015:1008]), .in_data_64( data_x[1031:1024]), .in_data_65(data_x[1047:1040]), .in_data_66(data_x[1063:1056]), .in_data_67(data_x[1079:1072]), .in_data_68(data_x[1095:1088]), .in_data_69(data_x[1111:1104]), .in_data_70(data_x[1127:1120]), .in_data_71(data_x[1143:1136]), .in_data_72(data_x[1159:1152]), .in_data_73(data_x[1175:1168]), .in_data_74(data_x[1191:1184]), .in_data_75(data_x[1207:1200]), .in_data_76(data_x[1223:1216]), .in_data_77(data_x[1239:1232]), .in_data_78(data_x[1255:1248]), .in_data_79(data_x[1271:1264]), .in_data_80(data_x[1287:1280]), .in_data_81(data_x[1303:1296]), .in_data_82(data_x[1319:1312]), .in_data_83(data_x[1335:1328]), .in_data_84(data_x[1351:1344]), .in_data_85(data_x[1367:1360]), .in_data_86(data_x[1383:1376]), .in_data_87(data_x[1399:1392]), .in_data_88(data_x[1415:1408]), .in_data_89(data_x[1431:1424]), .in_data_90(data_x[1447:1440]), .in_data_91(data_x[1463:1456]), .in_data_92(data_x[1479:1472]), .in_data_93(data_x[1495:1488]), .in_data_94(data_x[1511:1504]), .in_data_95(data_x[1527:1520]), .in_data_96(data_x[1543:1536]), .in_data_97(data_x[1559:1552]), .in_data_98(data_x[1575:1568]), .in_data_99(data_x[1591:1584]), 
.Add_pim(4'b0000),
.Compute_flag(1'b1),
.clk(clk),
.Out_data(data_out_x)
);

endmodule




module conv_top_100_6 (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24, input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44, input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48, input [7:0] in_data_49, input [7:0] in_data_50, input [7:0] in_data_51, input [7:0] in_data_52, input [7:0] in_data_53, input [7:0] in_data_54, input [7:0] in_data_55, input [7:0] in_data_56, input [7:0] in_data_57, input [7:0] in_data_58, input [7:0] in_data_59, input [7:0] in_data_60, input [7:0] in_data_61, input [7:0] in_data_62, input [7:0] in_data_63, input [7:0] in_data_64, input [7:0] in_data_65, input [7:0] in_data_66, input [7:0] in_data_67, input [7:0] in_data_68, input [7:0] in_data_69, input [7:0] in_data_70, input [7:0] in_data_71, input [7:0] in_data_72, input [7:0] in_data_73, input [7:0] in_data_74, input [7:0] in_data_75, input [7:0] in_data_76, input [7:0] in_data_77, input [7:0] in_data_78, input [7:0] in_data_79, input [7:0] in_data_80, input [7:0] in_data_81, input [7:0] in_data_82, input [7:0] in_data_83, input [7:0] in_data_84, input [7:0] in_data_85, input [7:0] in_data_86, input [7:0] in_data_87, input [7:0] in_data_88, input [7:0] in_data_89, input [7:0] in_data_90, input [7:0] in_data_91, input [7:0] in_data_92, input [7:0] in_data_93, input [7:0] in_data_94, input [7:0] in_data_95, input [7:0] in_data_96, input [7:0] in_data_97, input [7:0] in_data_98, input [7:0] in_data_99,   
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [17:0] Out_data // 输出数据
);  

	wire [7:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
//  HH Unit
	conv6 #(.INPUT_SIZE(300), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH0(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7], in_data_65[7], in_data_66[7], in_data_67[7], in_data_68[7], in_data_69[7], in_data_70[7], in_data_71[7], in_data_72[7], in_data_73[7], in_data_74[7], in_data_75[7], in_data_76[7], in_data_77[7], in_data_78[7], in_data_79[7], in_data_80[7], in_data_81[7], in_data_82[7], in_data_83[7], in_data_84[7], in_data_85[7], in_data_86[7], in_data_87[7], in_data_88[7], in_data_89[7], in_data_90[7], in_data_91[7], in_data_92[7], in_data_93[7], in_data_94[7], in_data_95[7], in_data_96[7], in_data_97[7], in_data_98[7], in_data_99[7]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv6 #(.INPUT_SIZE(300), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL1(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7], in_data_65[7], in_data_66[7], in_data_67[7], in_data_68[7], in_data_69[7], in_data_70[7], in_data_71[7], in_data_72[7], in_data_73[7], in_data_74[7], in_data_75[7], in_data_76[7], in_data_77[7], in_data_78[7], in_data_79[7], in_data_80[7], in_data_81[7], in_data_82[7], in_data_83[7], in_data_84[7], in_data_85[7], in_data_86[7], in_data_87[7], in_data_88[7], in_data_89[7], in_data_90[7], in_data_91[7], in_data_92[7], in_data_93[7], in_data_94[7], in_data_95[7], in_data_96[7], in_data_97[7], in_data_98[7], in_data_99[7]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);

//  LH Unit
	conv6 #(.INPUT_SIZE(300), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH2(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6], in_data_49[6], in_data_50[6], in_data_51[6], in_data_52[6], in_data_53[6], in_data_54[6], in_data_55[6], in_data_56[6], in_data_57[6], in_data_58[6], in_data_59[6], in_data_60[6], in_data_61[6], in_data_62[6], in_data_63[6], in_data_64[6], in_data_65[6], in_data_66[6], in_data_67[6], in_data_68[6], in_data_69[6], in_data_70[6], in_data_71[6], in_data_72[6], in_data_73[6], in_data_74[6], in_data_75[6], in_data_76[6], in_data_77[6], in_data_78[6], in_data_79[6], in_data_80[6], in_data_81[6], in_data_82[6], in_data_83[6], in_data_84[6], in_data_85[6], in_data_86[6], in_data_87[6], in_data_88[6], in_data_89[6], in_data_90[6], in_data_91[6], in_data_92[6], in_data_93[6], in_data_94[6], in_data_95[6], in_data_96[6], in_data_97[6], in_data_98[6], in_data_99[6]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH),
		.clk(clk)
	);

//  LL Unit
	conv6 #(.INPUT_SIZE(300), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL3(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6], in_data_49[6], in_data_50[6], in_data_51[6], in_data_52[6], in_data_53[6], in_data_54[6], in_data_55[6], in_data_56[6], in_data_57[6], in_data_58[6], in_data_59[6], in_data_60[6], in_data_61[6], in_data_62[6], in_data_63[6], in_data_64[6], in_data_65[6], in_data_66[6], in_data_67[6], in_data_68[6], in_data_69[6], in_data_70[6], in_data_71[6], in_data_72[6], in_data_73[6], in_data_74[6], in_data_75[6], in_data_76[6], in_data_77[6], in_data_78[6], in_data_79[6], in_data_80[6], in_data_81[6], in_data_82[6], in_data_83[6], in_data_84[6], in_data_85[6], in_data_86[6], in_data_87[6], in_data_88[6], in_data_89[6], in_data_90[6], in_data_91[6], in_data_92[6], in_data_93[6], in_data_94[6], in_data_95[6], in_data_96[6], in_data_97[6], in_data_98[6], in_data_99[6]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL),
		.clk(clk)
	);
	
	
	wire [17:0] tmp_res[3];
    qadd_in qadd_in_0(.a(tmp_result_HH), .b(tmp_result_HL), .sum(tmp_res[0]));
    qadd_in qadd_in_1(.a(tmp_result_LH), .b(tmp_result_LL), .sum(tmp_res[1]));
    qadd_in qadd_in_8(.a(tmp_res[0]), .b(tmp_res[1]), .sum(tmp_res[2]));

    assign Out_data = tmp_res[2];

endmodule
