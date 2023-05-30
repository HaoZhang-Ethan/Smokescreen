
function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = -1; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction


`define ARRAY_DEPTH 64      //Number of Hidden neurons
`define INPUT_DEPTH 100	    //LSTM input vector dimensions
`define DATA_WIDTH 8		//16 bit representation
`define INWEIGHT_DEPTH 6400 //100x64
`define HWEIGHT_DEPTH 4096  //64x64
`define varraysize 1600   //100x16
`define uarraysize 1024  //64x16



module GEMM100_8_PIM
(
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24,   input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44,   input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48, input [7:0] in_data_49, input [7:0] in_data_50, input [7:0] in_data_51, input [7:0] in_data_52, input [7:0] in_data_53, input [7:0] in_data_54, input [7:0] in_data_55, input [7:0] in_data_56, input [7:0] in_data_57, input [7:0] in_data_58, input [7:0] in_data_59, input [7:0] in_data_60, input [7:0] in_data_61, input [7:0] in_data_62, input [7:0] in_data_63, input [7:0] in_data_64,   input [7:0] in_data_65, input [7:0] in_data_66, input [7:0] in_data_67, input [7:0] in_data_68, input [7:0] in_data_69, input [7:0] in_data_70, input [7:0] in_data_71, input [7:0] in_data_72, input [7:0] in_data_73, input [7:0] in_data_74, input [7:0] in_data_75, input [7:0] in_data_76, input [7:0] in_data_77, input [7:0] in_data_78, input [7:0] in_data_79, input [7:0] in_data_80, input [7:0] in_data_81, input [7:0] in_data_82, input [7:0] in_data_83, input [7:0] in_data_84,   input [7:0] in_data_85, input [7:0] in_data_86, input [7:0] in_data_87, input [7:0] in_data_88, input [7:0] in_data_89, input [7:0] in_data_90, input [7:0] in_data_91, input [7:0] in_data_92, input [7:0] in_data_93, input [7:0] in_data_94, input [7:0] in_data_95, input [7:0] in_data_96, input [7:0] in_data_97, input [7:0] in_data_98, input [7:0] in_data_99,
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8, input [7:0] kernel_9, input [7:0] kernel_10, input [7:0] kernel_11, input [7:0] kernel_12,   input [7:0] kernel_13, input [7:0] kernel_14, input [7:0] kernel_15, input [7:0] kernel_16, input [7:0] kernel_17, input [7:0] kernel_18, input [7:0] kernel_19, input [7:0] kernel_20, input [7:0] kernel_21, input [7:0] kernel_22, input [7:0] kernel_23, input [7:0] kernel_24,   input [7:0] kernel_25, input [7:0] kernel_26, input [7:0] kernel_27, input [7:0] kernel_28, input [7:0] kernel_29, input [7:0] kernel_30, input [7:0] kernel_31, input [7:0] kernel_32, input [7:0] kernel_33, input [7:0] kernel_34, input [7:0] kernel_35, input [7:0] kernel_36,   input [7:0] kernel_37, input [7:0] kernel_38, input [7:0] kernel_39, input [7:0] kernel_40, input [7:0] kernel_41, input [7:0] kernel_42, input [7:0] kernel_43, input [7:0] kernel_44, input [7:0] kernel_45, input [7:0] kernel_46, input [7:0] kernel_47, input [7:0] kernel_48,   input [7:0] kernel_49, input [7:0] kernel_50, input [7:0] kernel_51, input [7:0] kernel_52, input [7:0] kernel_53, input [7:0] kernel_54, input [7:0] kernel_55, input [7:0] kernel_56, input [7:0] kernel_57, input [7:0] kernel_58, input [7:0] kernel_59, input [7:0] kernel_60,   input [7:0] kernel_61, input [7:0] kernel_62, input [7:0] kernel_63, input [7:0] kernel_64, input [7:0] kernel_65, input [7:0] kernel_66, input [7:0] kernel_67, input [7:0] kernel_68, input [7:0] kernel_69, input [7:0] kernel_70, input [7:0] kernel_71, input [7:0] kernel_72,   input [7:0] kernel_73, input [7:0] kernel_74, input [7:0] kernel_75, input [7:0] kernel_76, input [7:0] kernel_77, input [7:0] kernel_78, input [7:0] kernel_79, input [7:0] kernel_80, input [7:0] kernel_81, input [7:0] kernel_82, input [7:0] kernel_83, input [7:0] kernel_84,   input [7:0] kernel_85, input [7:0] kernel_86, input [7:0] kernel_87, input [7:0] kernel_88, input [7:0] kernel_89, input [7:0] kernel_90, input [7:0] kernel_91, input [7:0] kernel_92, input [7:0] kernel_93, input [7:0] kernel_94, input [7:0] kernel_95, input [7:0] kernel_96,   input [7:0] kernel_97, input [7:0] kernel_98, input [7:0] kernel_99, 
  input clk,
  output [17:0] out_data // 输出数据
);  

conv_top_100 conv_top_100_inst_1(
.in_data_0(in_data_0), .in_data_1(in_data_1), .in_data_2(in_data_2), .in_data_3(in_data_3), .in_data_4(in_data_4), .in_data_5(in_data_5), .in_data_6(in_data_6), .in_data_7(in_data_7), .in_data_8(in_data_8), .in_data_9(in_data_9), .in_data_10(in_data_10), .in_data_11(in_data_11), .in_data_12(in_data_12), .in_data_13(in_data_13), .in_data_14(in_data_14), .in_data_15(in_data_15), .in_data_16(in_data_16), .in_data_17(in_data_17), .in_data_18(in_data_18), .in_data_19(in_data_19), .in_data_20(in_data_20), .in_data_21(in_data_21), .in_data_22(in_data_22), .in_data_23(in_data_23), .in_data_24(in_data_24), .in_data_25(in_data_25), .in_data_26(in_data_26), .in_data_27(in_data_27), .in_data_28(in_data_28), .in_data_29(in_data_29), .in_data_30(in_data_30), .in_data_31(in_data_31), .in_data_32(in_data_32), .in_data_33(in_data_33), .in_data_34(in_data_34), .in_data_35(in_data_35), .in_data_36(in_data_36), .in_data_37(in_data_37), .in_data_38(in_data_38), .in_data_39(in_data_39), .in_data_40(in_data_40), .in_data_41(in_data_41), .in_data_42(in_data_42), .in_data_43(in_data_43), .in_data_44(in_data_44), .in_data_45(in_data_45), .in_data_46(in_data_46), .in_data_47(in_data_47), .in_data_48(in_data_48), .in_data_49(in_data_49), .in_data_50(in_data_50), .in_data_51(in_data_51), .in_data_52(in_data_52), .in_data_53(in_data_53), .in_data_54(in_data_54), .in_data_55(in_data_55), .in_data_56(in_data_56), .in_data_57(in_data_57), .in_data_58(in_data_58), .in_data_59(in_data_59), .in_data_60(in_data_60), .in_data_61(in_data_61), .in_data_62(in_data_62), .in_data_63(in_data_63), .in_data_64(in_data_64), .in_data_65(in_data_65), .in_data_66(in_data_66), .in_data_67(in_data_67), .in_data_68(in_data_68), .in_data_69(in_data_69), .in_data_70(in_data_70), .in_data_71(in_data_71), .in_data_72(in_data_72), .in_data_73(in_data_73), .in_data_74(in_data_74), .in_data_75(in_data_75), .in_data_76(in_data_76), .in_data_77(in_data_77), .in_data_78(in_data_78), .in_data_79(in_data_79), .in_data_80(in_data_80), .in_data_81(in_data_81), .in_data_82(in_data_82), .in_data_83(in_data_83), .in_data_84(in_data_84), .in_data_85(in_data_85), .in_data_86(in_data_86), .in_data_87(in_data_87), .in_data_88(in_data_88), .in_data_89(in_data_89), .in_data_90(in_data_90), .in_data_91(in_data_91), .in_data_92(in_data_92), .in_data_93(in_data_93), .in_data_94(in_data_94), .in_data_95(in_data_95), .in_data_96(in_data_96), .in_data_97(in_data_97), .in_data_98(in_data_98), .in_data_99(in_data_99),
.Add_pim(4'b0000),
.Compute_flag(1'b1),
.clk(clk),
.Out_data(out_data)
);



	
endmodule


module conv_top_100 (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24,   input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44,   input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48, input [7:0] in_data_49, input [7:0] in_data_50, input [7:0] in_data_51, input [7:0] in_data_52, input [7:0] in_data_53, input [7:0] in_data_54, input [7:0] in_data_55, input [7:0] in_data_56, input [7:0] in_data_57, input [7:0] in_data_58, input [7:0] in_data_59, input [7:0] in_data_60, input [7:0] in_data_61, input [7:0] in_data_62, input [7:0] in_data_63, input [7:0] in_data_64,   input [7:0] in_data_65, input [7:0] in_data_66, input [7:0] in_data_67, input [7:0] in_data_68, input [7:0] in_data_69, input [7:0] in_data_70, input [7:0] in_data_71, input [7:0] in_data_72, input [7:0] in_data_73, input [7:0] in_data_74, input [7:0] in_data_75, input [7:0] in_data_76, input [7:0] in_data_77, input [7:0] in_data_78, input [7:0] in_data_79, input [7:0] in_data_80, input [7:0] in_data_81, input [7:0] in_data_82, input [7:0] in_data_83, input [7:0] in_data_84,   input [7:0] in_data_85, input [7:0] in_data_86, input [7:0] in_data_87, input [7:0] in_data_88, input [7:0] in_data_89, input [7:0] in_data_90, input [7:0] in_data_91, input [7:0] in_data_92, input [7:0] in_data_93, input [7:0] in_data_94, input [7:0] in_data_95, input [7:0] in_data_96, input [7:0] in_data_97, input [7:0] in_data_98, input [7:0] in_data_99,
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [17:0] Out_data // 输出数据
);  


	wire [7:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
//  HH Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH0(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7], in_data_65[7], in_data_66[7], in_data_67[7], in_data_68[7], in_data_69[7], in_data_70[7], in_data_71[7], in_data_72[7], in_data_73[7], in_data_74[7], in_data_75[7], in_data_76[7], in_data_77[7], in_data_78[7], in_data_79[7], in_data_80[7], in_data_81[7], in_data_82[7], in_data_83[7], in_data_84[7], in_data_85[7], in_data_86[7], in_data_87[7], in_data_88[7], in_data_89[7], in_data_90[7], in_data_91[7], in_data_92[7], in_data_93[7], in_data_94[7], in_data_95[7], in_data_96[7], in_data_97[7], in_data_98[7], in_data_99[7] }),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL1(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7], in_data_65[7], in_data_66[7], in_data_67[7], in_data_68[7], in_data_69[7], in_data_70[7], in_data_71[7], in_data_72[7], in_data_73[7], in_data_74[7], in_data_75[7], in_data_76[7], in_data_77[7], in_data_78[7], in_data_79[7], in_data_80[7], in_data_81[7], in_data_82[7], in_data_83[7], in_data_84[7], in_data_85[7], in_data_86[7], in_data_87[7], in_data_88[7], in_data_89[7], in_data_90[7], in_data_91[7], in_data_92[7], in_data_93[7], in_data_94[7], in_data_95[7], in_data_96[7], in_data_97[7], in_data_98[7], in_data_99[7] }),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH2(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6], in_data_49[6], in_data_50[6], in_data_51[6], in_data_52[6], in_data_53[6], in_data_54[6], in_data_55[6], in_data_56[6], in_data_57[6], in_data_58[6], in_data_59[6], in_data_60[6], in_data_61[6], in_data_62[6], in_data_63[6], in_data_64[6], in_data_65[6], in_data_66[6], in_data_67[6], in_data_68[6], in_data_69[6], in_data_70[6], in_data_71[6], in_data_72[6], in_data_73[6], in_data_74[6], in_data_75[6], in_data_76[6], in_data_77[6], in_data_78[6], in_data_79[6], in_data_80[6], in_data_81[6], in_data_82[6], in_data_83[6], in_data_84[6], in_data_85[6], in_data_86[6], in_data_87[6], in_data_88[6], in_data_89[6], in_data_90[6], in_data_91[6], in_data_92[6], in_data_93[6], in_data_94[6], in_data_95[6], in_data_96[6], in_data_97[6], in_data_98[6], in_data_99[6] }),
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
	

	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL + tmp_result_HH_1 + tmp_result_HL_1 + tmp_result_LH_1;// | tmp_result_LL_1 | tmp_result_HH_2 | tmp_result_HL_2 | tmp_result_LH_2 | tmp_result_LL_2 | tmp_result_HH_3 | tmp_result_HL_3 | tmp_result_LH_3 | tmp_result_LL_3;

	wire [17:0] tmp_res[15];
	assign tmp_res[0] = tmp_result_HH + tmp_result_HL;
	assign tmp_res[1] = tmp_result_LH + tmp_result_LL;
	assign tmp_res[2] = tmp_result_HH_1 + tmp_result_HL_1;
	assign tmp_res[3] = tmp_result_LH_1 + tmp_result_LL_1;
	assign tmp_res[4] = tmp_result_HH_2 + tmp_result_HL_2;
	assign tmp_res[5] = tmp_result_LH_2 + tmp_result_LL_2;
	assign tmp_res[6] = tmp_result_HH_3 + tmp_result_HL_3;
	assign tmp_res[7] = tmp_result_LH_3 + tmp_result_LL_3;
	assign tmp_res[8] = tmp_res[0] + tmp_res[1];
	assign tmp_res[9] = tmp_res[2] + tmp_res[3];
	assign tmp_res[10] = tmp_res[4] + tmp_res[5];
	assign tmp_res[11] = tmp_res[6] + tmp_res[7];
	assign tmp_res[12] = tmp_res[8] + tmp_res[9];
	assign tmp_res[13] = tmp_res[10] + tmp_res[11];
	assign tmp_res[14] = tmp_res[12] + tmp_res[13];
	assign Out_data = tmp_res[14];



endmodule



