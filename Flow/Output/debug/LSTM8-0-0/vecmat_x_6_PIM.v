`define ARRAY_DEPTH 64      //Number of Hidden neurons
`define INPUT_DEPTH 100	    //LSTM input vector dimensions
`define DATA_WIDTH 8		//16 bit representation
`define INWEIGHT_DEPTH 6400 //100x64
`define HWEIGHT_DEPTH 4096  //64x64
`define varraysize 1600   //100x16
`define uarraysize 1024  //64x16



function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = -1; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction


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
		.Input_feature({in_data_0[5:3], in_data_1[5:3], in_data_2[5:3], in_data_3[5:3], in_data_4[5:3], in_data_5[5:3], in_data_6[5:3], in_data_7[5:3], in_data_8[5:3], in_data_9[5:3], in_data_10[5:3], in_data_11[5:3], in_data_12[5:3], in_data_13[5:3], in_data_14[5:3], in_data_15[5:3], in_data_16[5:3], in_data_17[5:3], in_data_18[5:3], in_data_19[5:3], in_data_20[5:3], in_data_21[5:3], in_data_22[5:3], in_data_23[5:3], in_data_24[5:3], in_data_25[5:3], in_data_26[5:3], in_data_27[5:3], in_data_28[5:3], in_data_29[5:3], in_data_30[5:3], in_data_31[5:3], in_data_32[5:3], in_data_33[5:3], in_data_34[5:3], in_data_35[5:3], in_data_36[5:3], in_data_37[5:3], in_data_38[5:3], in_data_39[5:3], in_data_40[5:3], in_data_41[5:3], in_data_42[5:3], in_data_43[5:3], in_data_44[5:3], in_data_45[5:3], in_data_46[5:3], in_data_47[5:3], in_data_48[5:3], in_data_49[5:3], in_data_50[5:3], in_data_51[5:3], in_data_52[5:3], in_data_53[5:3], in_data_54[5:3], in_data_55[5:3], in_data_56[5:3], in_data_57[5:3], in_data_58[5:3], in_data_59[5:3], in_data_60[5:3], in_data_61[5:3], in_data_62[5:3], in_data_63[5:3], in_data_64[5:3], in_data_65[5:3], in_data_66[5:3], in_data_67[5:3], in_data_68[5:3], in_data_69[5:3], in_data_70[5:3], in_data_71[5:3], in_data_72[5:3], in_data_73[5:3], in_data_74[5:3], in_data_75[5:3], in_data_76[5:3], in_data_77[5:3], in_data_78[5:3], in_data_79[5:3], in_data_80[5:3], in_data_81[5:3], in_data_82[5:3], in_data_83[5:3], in_data_84[5:3], in_data_85[5:3], in_data_86[5:3], in_data_87[5:3], in_data_88[5:3], in_data_89[5:3], in_data_90[5:3], in_data_91[5:3], in_data_92[5:3], in_data_93[5:3], in_data_94[5:3], in_data_95[5:3], in_data_96[5:3], in_data_97[5:3], in_data_98[5:3], in_data_99[5:3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv6 #(.INPUT_SIZE(300), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL1(
		.Input_feature({in_data_0[5:3], in_data_1[5:3], in_data_2[5:3], in_data_3[5:3], in_data_4[5:3], in_data_5[5:3], in_data_6[5:3], in_data_7[5:3], in_data_8[5:3], in_data_9[5:3], in_data_10[5:3], in_data_11[5:3], in_data_12[5:3], in_data_13[5:3], in_data_14[5:3], in_data_15[5:3], in_data_16[5:3], in_data_17[5:3], in_data_18[5:3], in_data_19[5:3], in_data_20[5:3], in_data_21[5:3], in_data_22[5:3], in_data_23[5:3], in_data_24[5:3], in_data_25[5:3], in_data_26[5:3], in_data_27[5:3], in_data_28[5:3], in_data_29[5:3], in_data_30[5:3], in_data_31[5:3], in_data_32[5:3], in_data_33[5:3], in_data_34[5:3], in_data_35[5:3], in_data_36[5:3], in_data_37[5:3], in_data_38[5:3], in_data_39[5:3], in_data_40[5:3], in_data_41[5:3], in_data_42[5:3], in_data_43[5:3], in_data_44[5:3], in_data_45[5:3], in_data_46[5:3], in_data_47[5:3], in_data_48[5:3], in_data_49[5:3], in_data_50[5:3], in_data_51[5:3], in_data_52[5:3], in_data_53[5:3], in_data_54[5:3], in_data_55[5:3], in_data_56[5:3], in_data_57[5:3], in_data_58[5:3], in_data_59[5:3], in_data_60[5:3], in_data_61[5:3], in_data_62[5:3], in_data_63[5:3], in_data_64[5:3], in_data_65[5:3], in_data_66[5:3], in_data_67[5:3], in_data_68[5:3], in_data_69[5:3], in_data_70[5:3], in_data_71[5:3], in_data_72[5:3], in_data_73[5:3], in_data_74[5:3], in_data_75[5:3], in_data_76[5:3], in_data_77[5:3], in_data_78[5:3], in_data_79[5:3], in_data_80[5:3], in_data_81[5:3], in_data_82[5:3], in_data_83[5:3], in_data_84[5:3], in_data_85[5:3], in_data_86[5:3], in_data_87[5:3], in_data_88[5:3], in_data_89[5:3], in_data_90[5:3], in_data_91[5:3], in_data_92[5:3], in_data_93[5:3], in_data_94[5:3], in_data_95[5:3], in_data_96[5:3], in_data_97[5:3], in_data_98[5:3], in_data_99[5:3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);


//  LH Unit
	conv6 #(.INPUT_SIZE(300), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH2(
		.Input_feature({in_data_0[2:0], in_data_1[2:0], in_data_2[2:0], in_data_3[2:0], in_data_4[2:0], in_data_5[2:0], in_data_6[2:0], in_data_7[2:0], in_data_8[2:0], in_data_9[2:0], in_data_10[2:0], in_data_11[2:0], in_data_12[2:0], in_data_13[2:0], in_data_14[2:0], in_data_15[2:0], in_data_16[2:0], in_data_17[2:0], in_data_18[2:0], in_data_19[2:0], in_data_20[2:0], in_data_21[2:0], in_data_22[2:0], in_data_23[2:0], in_data_24[2:0], in_data_25[2:0], in_data_26[2:0], in_data_27[2:0], in_data_28[2:0], in_data_29[2:0], in_data_30[2:0], in_data_31[2:0], in_data_32[2:0], in_data_33[2:0], in_data_34[2:0], in_data_35[2:0], in_data_36[2:0], in_data_37[2:0], in_data_38[2:0], in_data_39[2:0], in_data_40[2:0], in_data_41[2:0], in_data_42[2:0], in_data_43[2:0], in_data_44[2:0], in_data_45[2:0], in_data_46[2:0], in_data_47[2:0], in_data_48[2:0], in_data_49[2:0], in_data_50[2:0], in_data_51[2:0], in_data_52[2:0], in_data_53[2:0], in_data_54[2:0], in_data_55[2:0], in_data_56[2:0], in_data_57[2:0], in_data_58[2:0], in_data_59[2:0], in_data_60[2:0], in_data_61[2:0], in_data_62[2:0], in_data_63[2:0], in_data_64[2:0], in_data_65[2:0], in_data_66[2:0], in_data_67[2:0], in_data_68[2:0], in_data_69[2:0], in_data_70[2:0], in_data_71[2:0], in_data_72[2:0], in_data_73[2:0], in_data_74[2:0], in_data_75[2:0], in_data_76[2:0], in_data_77[2:0], in_data_78[2:0], in_data_79[2:0], in_data_80[2:0], in_data_81[2:0], in_data_82[2:0], in_data_83[2:0], in_data_84[2:0], in_data_85[2:0], in_data_86[2:0], in_data_87[2:0], in_data_88[2:0], in_data_89[2:0], in_data_90[2:0], in_data_91[2:0], in_data_92[2:0], in_data_93[2:0], in_data_94[2:0], in_data_95[2:0], in_data_96[2:0], in_data_97[2:0], in_data_98[2:0], in_data_99[2:0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH),
		.clk(clk)
	);

//  LL Unit
	conv6 #(.INPUT_SIZE(300), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL3(
		.Input_feature({in_data_0[2:0], in_data_1[2:0], in_data_2[2:0], in_data_3[2:0], in_data_4[2:0], in_data_5[2:0], in_data_6[2:0], in_data_7[2:0], in_data_8[2:0], in_data_9[2:0], in_data_10[2:0], in_data_11[2:0], in_data_12[2:0], in_data_13[2:0], in_data_14[2:0], in_data_15[2:0], in_data_16[2:0], in_data_17[2:0], in_data_18[2:0], in_data_19[2:0], in_data_20[2:0], in_data_21[2:0], in_data_22[2:0], in_data_23[2:0], in_data_24[2:0], in_data_25[2:0], in_data_26[2:0], in_data_27[2:0], in_data_28[2:0], in_data_29[2:0], in_data_30[2:0], in_data_31[2:0], in_data_32[2:0], in_data_33[2:0], in_data_34[2:0], in_data_35[2:0], in_data_36[2:0], in_data_37[2:0], in_data_38[2:0], in_data_39[2:0], in_data_40[2:0], in_data_41[2:0], in_data_42[2:0], in_data_43[2:0], in_data_44[2:0], in_data_45[2:0], in_data_46[2:0], in_data_47[2:0], in_data_48[2:0], in_data_49[2:0], in_data_50[2:0], in_data_51[2:0], in_data_52[2:0], in_data_53[2:0], in_data_54[2:0], in_data_55[2:0], in_data_56[2:0], in_data_57[2:0], in_data_58[2:0], in_data_59[2:0], in_data_60[2:0], in_data_61[2:0], in_data_62[2:0], in_data_63[2:0], in_data_64[2:0], in_data_65[2:0], in_data_66[2:0], in_data_67[2:0], in_data_68[2:0], in_data_69[2:0], in_data_70[2:0], in_data_71[2:0], in_data_72[2:0], in_data_73[2:0], in_data_74[2:0], in_data_75[2:0], in_data_76[2:0], in_data_77[2:0], in_data_78[2:0], in_data_79[2:0], in_data_80[2:0], in_data_81[2:0], in_data_82[2:0], in_data_83[2:0], in_data_84[2:0], in_data_85[2:0], in_data_86[2:0], in_data_87[2:0], in_data_88[2:0], in_data_89[2:0], in_data_90[2:0], in_data_91[2:0], in_data_92[2:0], in_data_93[2:0], in_data_94[2:0], in_data_95[2:0], in_data_96[2:0], in_data_97[2:0], in_data_98[2:0], in_data_99[2:0]}),
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
