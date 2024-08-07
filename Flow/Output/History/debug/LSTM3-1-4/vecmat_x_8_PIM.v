
// function integer clogb2 (input integer bit_depth);
//     begin
//         for(clogb2 = -1; bit_depth > 0; clogb2 = clogb2+1)
//             bit_depth = bit_depth>>1;
//     end
// endfunction


// `define ARRAY_DEPTH 64      //Number of Hidden neurons
// `define INPUT_DEPTH 100	    //LSTM input vector dimensions
// `define DATA_WIDTH 8		//16 bit representation
// `define INWEIGHT_DEPTH 6400 //100x64
// `define HWEIGHT_DEPTH 4096  //64x64
// `define varraysize 1600   //100x16
// `define uarraysize 1024  //64x16





module vecmat_x_8_PIM #( parameter varraysize=1600, vectwidth=100)
(
	input clk,
	input reset,
	input [varraysize-1:0] data_x,
	input [varraysize-1:0] W_x,

	output reg [15:0] data_out_x
);

conv_top_100 conv_top_100_inst_1(
.in_data_0(data_x[7:0]), .in_data_1(data_x[23:16]), .in_data_2(data_x[39:32]), .in_data_3(data_x[55:48]), .in_data_4(data_x[71:64]), .in_data_5(data_x[87:80]), .in_data_6(data_x[103:96]), .in_data_7(data_x[119:112]), .in_data_8(data_x[135:128]), .in_data_9(data_x[151:144]), .in_data_10(data_x[167:160]), .in_data_11(data_x[183:176]), .in_data_12(data_x[199:192]), .in_data_13(data_x[215:208]), .in_data_14(data_x[231:224]), .in_data_15(data_x[247:240]), .in_data_16(data_x[263:256]), .in_data_17(data_x[279:272]), .in_data_18(data_x[295:288]), .in_data_19(data_x[311:304]), .in_data_20(data_x[327:320]), .in_data_21(data_x[343:336]), .in_data_22(data_x[359:352]), .in_data_23(data_x[375:368]), .in_data_24(data_x[391:384]), .in_data_25(data_x[407:400]), .in_data_26(data_x[423:416]), .in_data_27(data_x[439:432]), .in_data_28(data_x[455:448]), .in_data_29(data_x[471:464]), .in_data_30(data_x[487:480]), .in_data_31(data_x[503:496]), .in_data_32(data_x[519:512]), .in_data_33(data_x[535:528]), .in_data_34(data_x[551:544]), .in_data_35(data_x[567:560]), .in_data_36(data_x[583:576]), .in_data_37(data_x[599:592]), .in_data_38(data_x[615:608]), .in_data_39(data_x[631:624]), .in_data_40(data_x[647:640]), .in_data_41(data_x[663:656]), .in_data_42(data_x[679:672]), .in_data_43(data_x[695:688]), .in_data_44(data_x[711:704]), .in_data_45(data_x[727:720]), .in_data_46(data_x[743:736]), .in_data_47(data_x[759:752]), .in_data_48(data_x[775:768]), .in_data_49(data_x[791:784]), .in_data_50(data_x[807:800]), .in_data_51(data_x[823:816]), .in_data_52(data_x[839:832]), .in_data_53(data_x[855:848]), .in_data_54(data_x[871:864]), .in_data_55(data_x[887:880]), .in_data_56(data_x[903:896]), .in_data_57(data_x[919:912]), .in_data_58(data_x[935:928]), .in_data_59(data_x[951:944]), .in_data_60(data_x[967:960]), .in_data_61(data_x[983:976]), .in_data_62(data_x[999:992]), .in_data_63(data_x[1015:1008]), .in_data_64( data_x[1031:1024]), .in_data_65(data_x[1047:1040]), .in_data_66(data_x[1063:1056]), .in_data_67(data_x[1079:1072]), .in_data_68(data_x[1095:1088]), .in_data_69(data_x[1111:1104]), .in_data_70(data_x[1127:1120]), .in_data_71(data_x[1143:1136]), .in_data_72(data_x[1159:1152]), .in_data_73(data_x[1175:1168]), .in_data_74(data_x[1191:1184]), .in_data_75(data_x[1207:1200]), .in_data_76(data_x[1223:1216]), .in_data_77(data_x[1239:1232]), .in_data_78(data_x[1255:1248]), .in_data_79(data_x[1271:1264]), .in_data_80(data_x[1287:1280]), .in_data_81(data_x[1303:1296]), .in_data_82(data_x[1319:1312]), .in_data_83(data_x[1335:1328]), .in_data_84(data_x[1351:1344]), .in_data_85(data_x[1367:1360]), .in_data_86(data_x[1383:1376]), .in_data_87(data_x[1399:1392]), .in_data_88(data_x[1415:1408]), .in_data_89(data_x[1431:1424]), .in_data_90(data_x[1447:1440]), .in_data_91(data_x[1463:1456]), .in_data_92(data_x[1479:1472]), .in_data_93(data_x[1495:1488]), .in_data_94(data_x[1511:1504]), .in_data_95(data_x[1527:1520]), .in_data_96(data_x[1543:1536]), .in_data_97(data_x[1559:1552]), .in_data_98(data_x[1575:1568]), .in_data_99(data_x[1591:1584]), 
.Add_pim(4'b0000),
.Compute_flag(1'b1),
.clk(clk),
.Out_data(data_out_x)
);

endmodule


module conv_top_100 (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24, input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44, input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48, input [7:0] in_data_49, input [7:0] in_data_50, input [7:0] in_data_51, input [7:0] in_data_52, input [7:0] in_data_53, input [7:0] in_data_54, input [7:0] in_data_55, input [7:0] in_data_56, input [7:0] in_data_57, input [7:0] in_data_58, input [7:0] in_data_59, input [7:0] in_data_60, input [7:0] in_data_61, input [7:0] in_data_62, input [7:0] in_data_63, input [7:0] in_data_64, input [7:0] in_data_65, input [7:0] in_data_66, input [7:0] in_data_67, input [7:0] in_data_68, input [7:0] in_data_69, input [7:0] in_data_70, input [7:0] in_data_71, input [7:0] in_data_72, input [7:0] in_data_73, input [7:0] in_data_74, input [7:0] in_data_75, input [7:0] in_data_76, input [7:0] in_data_77, input [7:0] in_data_78, input [7:0] in_data_79, input [7:0] in_data_80, input [7:0] in_data_81, input [7:0] in_data_82, input [7:0] in_data_83, input [7:0] in_data_84, input [7:0] in_data_85, input [7:0] in_data_86, input [7:0] in_data_87, input [7:0] in_data_88, input [7:0] in_data_89, input [7:0] in_data_90, input [7:0] in_data_91, input [7:0] in_data_92, input [7:0] in_data_93, input [7:0] in_data_94, input [7:0] in_data_95, input [7:0] in_data_96, input [7:0] in_data_97, input [7:0] in_data_98, input [7:0] in_data_99,   
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [17:0] Out_data // 输出数据
);  

	wire [7:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
//  HH Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH0(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7], in_data_65[7], in_data_66[7], in_data_67[7], in_data_68[7], in_data_69[7], in_data_70[7], in_data_71[7], in_data_72[7], in_data_73[7], in_data_74[7], in_data_75[7], in_data_76[7], in_data_77[7], in_data_78[7], in_data_79[7], in_data_80[7], in_data_81[7], in_data_82[7], in_data_83[7], in_data_84[7], in_data_85[7], in_data_86[7], in_data_87[7], in_data_88[7], in_data_89[7], in_data_90[7], in_data_91[7], in_data_92[7], in_data_93[7], in_data_94[7], in_data_95[7], in_data_96[7], in_data_97[7], in_data_98[7], in_data_99[7]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL1(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7], in_data_65[7], in_data_66[7], in_data_67[7], in_data_68[7], in_data_69[7], in_data_70[7], in_data_71[7], in_data_72[7], in_data_73[7], in_data_74[7], in_data_75[7], in_data_76[7], in_data_77[7], in_data_78[7], in_data_79[7], in_data_80[7], in_data_81[7], in_data_82[7], in_data_83[7], in_data_84[7], in_data_85[7], in_data_86[7], in_data_87[7], in_data_88[7], in_data_89[7], in_data_90[7], in_data_91[7], in_data_92[7], in_data_93[7], in_data_94[7], in_data_95[7], in_data_96[7], in_data_97[7], in_data_98[7], in_data_99[7]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH2(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6], in_data_49[6], in_data_50[6], in_data_51[6], in_data_52[6], in_data_53[6], in_data_54[6], in_data_55[6], in_data_56[6], in_data_57[6], in_data_58[6], in_data_59[6], in_data_60[6], in_data_61[6], in_data_62[6], in_data_63[6], in_data_64[6], in_data_65[6], in_data_66[6], in_data_67[6], in_data_68[6], in_data_69[6], in_data_70[6], in_data_71[6], in_data_72[6], in_data_73[6], in_data_74[6], in_data_75[6], in_data_76[6], in_data_77[6], in_data_78[6], in_data_79[6], in_data_80[6], in_data_81[6], in_data_82[6], in_data_83[6], in_data_84[6], in_data_85[6], in_data_86[6], in_data_87[6], in_data_88[6], in_data_89[6], in_data_90[6], in_data_91[6], in_data_92[6], in_data_93[6], in_data_94[6], in_data_95[6], in_data_96[6], in_data_97[6], in_data_98[6], in_data_99[6]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL3(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6], in_data_49[6], in_data_50[6], in_data_51[6], in_data_52[6], in_data_53[6], in_data_54[6], in_data_55[6], in_data_56[6], in_data_57[6], in_data_58[6], in_data_59[6], in_data_60[6], in_data_61[6], in_data_62[6], in_data_63[6], in_data_64[6], in_data_65[6], in_data_66[6], in_data_67[6], in_data_68[6], in_data_69[6], in_data_70[6], in_data_71[6], in_data_72[6], in_data_73[6], in_data_74[6], in_data_75[6], in_data_76[6], in_data_77[6], in_data_78[6], in_data_79[6], in_data_80[6], in_data_81[6], in_data_82[6], in_data_83[6], in_data_84[6], in_data_85[6], in_data_86[6], in_data_87[6], in_data_88[6], in_data_89[6], in_data_90[6], in_data_91[6], in_data_92[6], in_data_93[6], in_data_94[6], in_data_95[6], in_data_96[6], in_data_97[6], in_data_98[6], in_data_99[6]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL),
		.clk(clk)
	);
	



	// assign Out_data = tmp_result_HH1 + tmp_result_HL1 + tmp_result_LH1 + tmp_result_LL1;


	wire [7:0] tmp_result_HH_1, tmp_result_HL_1, tmp_result_LH_1, tmp_result_LL_1;
//  HH Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH4(
		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5], in_data_32[5], in_data_33[5], in_data_34[5], in_data_35[5], in_data_36[5], in_data_37[5], in_data_38[5], in_data_39[5], in_data_40[5], in_data_41[5], in_data_42[5], in_data_43[5], in_data_44[5], in_data_45[5], in_data_46[5], in_data_47[5], in_data_48[5], in_data_49[5], in_data_50[5], in_data_51[5], in_data_52[5], in_data_53[5], in_data_54[5], in_data_55[5], in_data_56[5], in_data_57[5], in_data_58[5], in_data_59[5], in_data_60[5], in_data_61[5], in_data_62[5], in_data_63[5], in_data_64[5], in_data_65[5], in_data_66[5], in_data_67[5], in_data_68[5], in_data_69[5], in_data_70[5], in_data_71[5], in_data_72[5], in_data_73[5], in_data_74[5], in_data_75[5], in_data_76[5], in_data_77[5], in_data_78[5], in_data_79[5], in_data_80[5], in_data_81[5], in_data_82[5], in_data_83[5], in_data_84[5], in_data_85[5], in_data_86[5], in_data_87[5], in_data_88[5], in_data_89[5], in_data_90[5], in_data_91[5], in_data_92[5], in_data_93[5], in_data_94[5], in_data_95[5], in_data_96[5], in_data_97[5], in_data_98[5], in_data_99[5]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_1),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL5(
		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5], in_data_32[5], in_data_33[5], in_data_34[5], in_data_35[5], in_data_36[5], in_data_37[5], in_data_38[5], in_data_39[5], in_data_40[5], in_data_41[5], in_data_42[5], in_data_43[5], in_data_44[5], in_data_45[5], in_data_46[5], in_data_47[5], in_data_48[5], in_data_49[5], in_data_50[5], in_data_51[5], in_data_52[5], in_data_53[5], in_data_54[5], in_data_55[5], in_data_56[5], in_data_57[5], in_data_58[5], in_data_59[5], in_data_60[5], in_data_61[5], in_data_62[5], in_data_63[5], in_data_64[5], in_data_65[5], in_data_66[5], in_data_67[5], in_data_68[5], in_data_69[5], in_data_70[5], in_data_71[5], in_data_72[5], in_data_73[5], in_data_74[5], in_data_75[5], in_data_76[5], in_data_77[5], in_data_78[5], in_data_79[5], in_data_80[5], in_data_81[5], in_data_82[5], in_data_83[5], in_data_84[5], in_data_85[5], in_data_86[5], in_data_87[5], in_data_88[5], in_data_89[5], in_data_90[5], in_data_91[5], in_data_92[5], in_data_93[5], in_data_94[5], in_data_95[5], in_data_96[5], in_data_97[5], in_data_98[5], in_data_99[5]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_1),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH6(
		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4], in_data_32[4], in_data_33[4], in_data_34[4], in_data_35[4], in_data_36[4], in_data_37[4], in_data_38[4], in_data_39[4], in_data_40[4], in_data_41[4], in_data_42[4], in_data_43[4], in_data_44[4], in_data_45[4], in_data_46[4], in_data_47[4], in_data_48[4], in_data_49[4], in_data_50[4], in_data_51[4], in_data_52[4], in_data_53[4], in_data_54[4], in_data_55[4], in_data_56[4], in_data_57[4], in_data_58[4], in_data_59[4], in_data_60[4], in_data_61[4], in_data_62[4], in_data_63[4], in_data_64[4], in_data_65[4], in_data_66[4], in_data_67[4], in_data_68[4], in_data_69[4], in_data_70[4], in_data_71[4], in_data_72[4], in_data_73[4], in_data_74[4], in_data_75[4], in_data_76[4], in_data_77[4], in_data_78[4], in_data_79[4], in_data_80[4], in_data_81[4], in_data_82[4], in_data_83[4], in_data_84[4], in_data_85[4], in_data_86[4], in_data_87[4], in_data_88[4], in_data_89[4], in_data_90[4], in_data_91[4], in_data_92[4], in_data_93[4], in_data_94[4], in_data_95[4], in_data_96[4], in_data_97[4], in_data_98[4], in_data_99[4]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_1),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL7(
		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4], in_data_32[4], in_data_33[4], in_data_34[4], in_data_35[4], in_data_36[4], in_data_37[4], in_data_38[4], in_data_39[4], in_data_40[4], in_data_41[4], in_data_42[4], in_data_43[4], in_data_44[4], in_data_45[4], in_data_46[4], in_data_47[4], in_data_48[4], in_data_49[4], in_data_50[4], in_data_51[4], in_data_52[4], in_data_53[4], in_data_54[4], in_data_55[4], in_data_56[4], in_data_57[4], in_data_58[4], in_data_59[4], in_data_60[4], in_data_61[4], in_data_62[4], in_data_63[4], in_data_64[4], in_data_65[4], in_data_66[4], in_data_67[4], in_data_68[4], in_data_69[4], in_data_70[4], in_data_71[4], in_data_72[4], in_data_73[4], in_data_74[4], in_data_75[4], in_data_76[4], in_data_77[4], in_data_78[4], in_data_79[4], in_data_80[4], in_data_81[4], in_data_82[4], in_data_83[4], in_data_84[4], in_data_85[4], in_data_86[4], in_data_87[4], in_data_88[4], in_data_89[4], in_data_90[4], in_data_91[4], in_data_92[4], in_data_93[4], in_data_94[4], in_data_95[4], in_data_96[4], in_data_97[4], in_data_98[4], in_data_99[4]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_1),
		.clk(clk)
	);
	

	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;

	wire [7:0] tmp_result_HH_2, tmp_result_HL_2, tmp_result_LH_2, tmp_result_LL_2;
//  HH Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH8(
		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3], in_data_32[3], in_data_33[3], in_data_34[3], in_data_35[3], in_data_36[3], in_data_37[3], in_data_38[3], in_data_39[3], in_data_40[3], in_data_41[3], in_data_42[3], in_data_43[3], in_data_44[3], in_data_45[3], in_data_46[3], in_data_47[3], in_data_48[3], in_data_49[3], in_data_50[3], in_data_51[3], in_data_52[3], in_data_53[3], in_data_54[3], in_data_55[3], in_data_56[3], in_data_57[3], in_data_58[3], in_data_59[3], in_data_60[3], in_data_61[3], in_data_62[3], in_data_63[3], in_data_64[3], in_data_65[3], in_data_66[3], in_data_67[3], in_data_68[3], in_data_69[3], in_data_70[3], in_data_71[3], in_data_72[3], in_data_73[3], in_data_74[3], in_data_75[3], in_data_76[3], in_data_77[3], in_data_78[3], in_data_79[3], in_data_80[3], in_data_81[3], in_data_82[3], in_data_83[3], in_data_84[3], in_data_85[3], in_data_86[3], in_data_87[3], in_data_88[3], in_data_89[3], in_data_90[3], in_data_91[3], in_data_92[3], in_data_93[3], in_data_94[3], in_data_95[3], in_data_96[3], in_data_97[3], in_data_98[3], in_data_99[3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_2),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL9(
		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3], in_data_32[3], in_data_33[3], in_data_34[3], in_data_35[3], in_data_36[3], in_data_37[3], in_data_38[3], in_data_39[3], in_data_40[3], in_data_41[3], in_data_42[3], in_data_43[3], in_data_44[3], in_data_45[3], in_data_46[3], in_data_47[3], in_data_48[3], in_data_49[3], in_data_50[3], in_data_51[3], in_data_52[3], in_data_53[3], in_data_54[3], in_data_55[3], in_data_56[3], in_data_57[3], in_data_58[3], in_data_59[3], in_data_60[3], in_data_61[3], in_data_62[3], in_data_63[3], in_data_64[3], in_data_65[3], in_data_66[3], in_data_67[3], in_data_68[3], in_data_69[3], in_data_70[3], in_data_71[3], in_data_72[3], in_data_73[3], in_data_74[3], in_data_75[3], in_data_76[3], in_data_77[3], in_data_78[3], in_data_79[3], in_data_80[3], in_data_81[3], in_data_82[3], in_data_83[3], in_data_84[3], in_data_85[3], in_data_86[3], in_data_87[3], in_data_88[3], in_data_89[3], in_data_90[3], in_data_91[3], in_data_92[3], in_data_93[3], in_data_94[3], in_data_95[3], in_data_96[3], in_data_97[3], in_data_98[3], in_data_99[3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_2),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH10(
		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2], in_data_32[2], in_data_33[2], in_data_34[2], in_data_35[2], in_data_36[2], in_data_37[2], in_data_38[2], in_data_39[2], in_data_40[2], in_data_41[2], in_data_42[2], in_data_43[2], in_data_44[2], in_data_45[2], in_data_46[2], in_data_47[2], in_data_48[2], in_data_49[2], in_data_50[2], in_data_51[2], in_data_52[2], in_data_53[2], in_data_54[2], in_data_55[2], in_data_56[2], in_data_57[2], in_data_58[2], in_data_59[2], in_data_60[2], in_data_61[2], in_data_62[2], in_data_63[2], in_data_64[2], in_data_65[2], in_data_66[2], in_data_67[2], in_data_68[2], in_data_69[2], in_data_70[2], in_data_71[2], in_data_72[2], in_data_73[2], in_data_74[2], in_data_75[2], in_data_76[2], in_data_77[2], in_data_78[2], in_data_79[2], in_data_80[2], in_data_81[2], in_data_82[2], in_data_83[2], in_data_84[2], in_data_85[2], in_data_86[2], in_data_87[2], in_data_88[2], in_data_89[2], in_data_90[2], in_data_91[2], in_data_92[2], in_data_93[2], in_data_94[2], in_data_95[2], in_data_96[2], in_data_97[2], in_data_98[2], in_data_99[2]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_2),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL11(
		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2], in_data_32[2], in_data_33[2], in_data_34[2], in_data_35[2], in_data_36[2], in_data_37[2], in_data_38[2], in_data_39[2], in_data_40[2], in_data_41[2], in_data_42[2], in_data_43[2], in_data_44[2], in_data_45[2], in_data_46[2], in_data_47[2], in_data_48[2], in_data_49[2], in_data_50[2], in_data_51[2], in_data_52[2], in_data_53[2], in_data_54[2], in_data_55[2], in_data_56[2], in_data_57[2], in_data_58[2], in_data_59[2], in_data_60[2], in_data_61[2], in_data_62[2], in_data_63[2], in_data_64[2], in_data_65[2], in_data_66[2], in_data_67[2], in_data_68[2], in_data_69[2], in_data_70[2], in_data_71[2], in_data_72[2], in_data_73[2], in_data_74[2], in_data_75[2], in_data_76[2], in_data_77[2], in_data_78[2], in_data_79[2], in_data_80[2], in_data_81[2], in_data_82[2], in_data_83[2], in_data_84[2], in_data_85[2], in_data_86[2], in_data_87[2], in_data_88[2], in_data_89[2], in_data_90[2], in_data_91[2], in_data_92[2], in_data_93[2], in_data_94[2], in_data_95[2], in_data_96[2], in_data_97[2], in_data_98[2], in_data_99[2]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_2),
		.clk(clk)
	);
	
	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;




	wire [7:0] tmp_result_HH_3, tmp_result_HL_3, tmp_result_LH_3, tmp_result_LL_3;
//  HH Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH12(
		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1], in_data_32[1], in_data_33[1], in_data_34[1], in_data_35[1], in_data_36[1], in_data_37[1], in_data_38[1], in_data_39[1], in_data_40[1], in_data_41[1], in_data_42[1], in_data_43[1], in_data_44[1], in_data_45[1], in_data_46[1], in_data_47[1], in_data_48[1], in_data_49[1], in_data_50[1], in_data_51[1], in_data_52[1], in_data_53[1], in_data_54[1], in_data_55[1], in_data_56[1], in_data_57[1], in_data_58[1], in_data_59[1], in_data_60[1], in_data_61[1], in_data_62[1], in_data_63[1], in_data_64[1], in_data_65[1], in_data_66[1], in_data_67[1], in_data_68[1], in_data_69[1], in_data_70[1], in_data_71[1], in_data_72[1], in_data_73[1], in_data_74[1], in_data_75[1], in_data_76[1], in_data_77[1], in_data_78[1], in_data_79[1], in_data_80[1], in_data_81[1], in_data_82[1], in_data_83[1], in_data_84[1], in_data_85[1], in_data_86[1], in_data_87[1], in_data_88[1], in_data_89[1], in_data_90[1], in_data_91[1], in_data_92[1], in_data_93[1], in_data_94[1], in_data_95[1], in_data_96[1], in_data_97[1], in_data_98[1], in_data_99[1]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_3),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL13(
		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1], in_data_32[1], in_data_33[1], in_data_34[1], in_data_35[1], in_data_36[1], in_data_37[1], in_data_38[1], in_data_39[1], in_data_40[1], in_data_41[1], in_data_42[1], in_data_43[1], in_data_44[1], in_data_45[1], in_data_46[1], in_data_47[1], in_data_48[1], in_data_49[1], in_data_50[1], in_data_51[1], in_data_52[1], in_data_53[1], in_data_54[1], in_data_55[1], in_data_56[1], in_data_57[1], in_data_58[1], in_data_59[1], in_data_60[1], in_data_61[1], in_data_62[1], in_data_63[1], in_data_64[1], in_data_65[1], in_data_66[1], in_data_67[1], in_data_68[1], in_data_69[1], in_data_70[1], in_data_71[1], in_data_72[1], in_data_73[1], in_data_74[1], in_data_75[1], in_data_76[1], in_data_77[1], in_data_78[1], in_data_79[1], in_data_80[1], in_data_81[1], in_data_82[1], in_data_83[1], in_data_84[1], in_data_85[1], in_data_86[1], in_data_87[1], in_data_88[1], in_data_89[1], in_data_90[1], in_data_91[1], in_data_92[1], in_data_93[1], in_data_94[1], in_data_95[1], in_data_96[1], in_data_97[1], in_data_98[1], in_data_99[1]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_3),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH14(
		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0], in_data_32[0], in_data_33[0], in_data_34[0], in_data_35[0], in_data_36[0], in_data_37[0], in_data_38[0], in_data_39[0], in_data_40[0], in_data_41[0], in_data_42[0], in_data_43[0], in_data_44[0], in_data_45[0], in_data_46[0], in_data_47[0], in_data_48[0], in_data_49[0], in_data_50[0], in_data_51[0], in_data_52[0], in_data_53[0], in_data_54[0], in_data_55[0], in_data_56[0], in_data_57[0], in_data_58[0], in_data_59[0], in_data_60[0], in_data_61[0], in_data_62[0], in_data_63[0], in_data_64[0], in_data_65[0], in_data_66[0], in_data_67[0], in_data_68[0], in_data_69[0], in_data_70[0], in_data_71[0], in_data_72[0], in_data_73[0], in_data_74[0], in_data_75[0], in_data_76[0], in_data_77[0], in_data_78[0], in_data_79[0], in_data_80[0], in_data_81[0], in_data_82[0], in_data_83[0], in_data_84[0], in_data_85[0], in_data_86[0], in_data_87[0], in_data_88[0], in_data_89[0], in_data_90[0], in_data_91[0], in_data_92[0], in_data_93[0], in_data_94[0], in_data_95[0], in_data_96[0], in_data_97[0], in_data_98[0], in_data_99[0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_3),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL15(
		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0], in_data_32[0], in_data_33[0], in_data_34[0], in_data_35[0], in_data_36[0], in_data_37[0], in_data_38[0], in_data_39[0], in_data_40[0], in_data_41[0], in_data_42[0], in_data_43[0], in_data_44[0], in_data_45[0], in_data_46[0], in_data_47[0], in_data_48[0], in_data_49[0], in_data_50[0], in_data_51[0], in_data_52[0], in_data_53[0], in_data_54[0], in_data_55[0], in_data_56[0], in_data_57[0], in_data_58[0], in_data_59[0], in_data_60[0], in_data_61[0], in_data_62[0], in_data_63[0], in_data_64[0], in_data_65[0], in_data_66[0], in_data_67[0], in_data_68[0], in_data_69[0], in_data_70[0], in_data_71[0], in_data_72[0], in_data_73[0], in_data_74[0], in_data_75[0], in_data_76[0], in_data_77[0], in_data_78[0], in_data_79[0], in_data_80[0], in_data_81[0], in_data_82[0], in_data_83[0], in_data_84[0], in_data_85[0], in_data_86[0], in_data_87[0], in_data_88[0], in_data_89[0], in_data_90[0], in_data_91[0], in_data_92[0], in_data_93[0], in_data_94[0], in_data_95[0], in_data_96[0], in_data_97[0], in_data_98[0], in_data_99[0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_3),
		.clk(clk)
	);
	
	// wire [17:0] tmp_res[15];
	// assign tmp_res[0] = tmp_result_HH | tmp_result_HL;
	// assign tmp_res[1] = tmp_result_LH | tmp_result_LL;
	// assign tmp_res[2] = tmp_result_HH_1 | tmp_result_HL_1;
	// assign tmp_res[3] = tmp_result_LH_1 | tmp_result_LL_1;
	// assign tmp_res[4] = tmp_result_HH_2 | tmp_result_HL_2;
	// assign tmp_res[5] = tmp_result_LH_2 | tmp_result_LL_2;
	// assign tmp_res[6] = tmp_result_HH_3 | tmp_result_HL_3;
	// assign tmp_res[7] = tmp_result_LH_3 | tmp_result_LL_3;
	// assign tmp_res[8] = tmp_res[0] | tmp_res[1];
	// assign tmp_res[9] = tmp_res[2] | tmp_res[3];
	// assign tmp_res[10] = tmp_res[4] | tmp_res[5];
	// assign tmp_res[11] = tmp_res[6] | tmp_res[7];
	// assign tmp_res[12] = tmp_res[8] | tmp_res[9];
	// assign tmp_res[13] = tmp_res[10] | tmp_res[11];
	// assign tmp_res[14] = tmp_res[12] | tmp_res[13];



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
    qadd_in qadd_in_14(.a(tmp_res[12]), .b(tmp_res[13]), .sum(Out_data));
    // assign Out_data = tmp_res[14];

endmodule
