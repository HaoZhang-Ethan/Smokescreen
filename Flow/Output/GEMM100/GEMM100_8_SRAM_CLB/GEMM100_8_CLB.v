module GEMM100_8_CLB (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24,   input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44,   input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48, input [7:0] in_data_49, input [7:0] in_data_50, input [7:0] in_data_51, input [7:0] in_data_52, input [7:0] in_data_53, input [7:0] in_data_54, input [7:0] in_data_55, input [7:0] in_data_56, input [7:0] in_data_57, input [7:0] in_data_58, input [7:0] in_data_59, input [7:0] in_data_60, input [7:0] in_data_61, input [7:0] in_data_62, input [7:0] in_data_63, input [7:0] in_data_64,   input [7:0] in_data_65, input [7:0] in_data_66, input [7:0] in_data_67, input [7:0] in_data_68, input [7:0] in_data_69, input [7:0] in_data_70, input [7:0] in_data_71, input [7:0] in_data_72, input [7:0] in_data_73, input [7:0] in_data_74, input [7:0] in_data_75, input [7:0] in_data_76, input [7:0] in_data_77, input [7:0] in_data_78, input [7:0] in_data_79, input [7:0] in_data_80, input [7:0] in_data_81, input [7:0] in_data_82, input [7:0] in_data_83, input [7:0] in_data_84,   input [7:0] in_data_85, input [7:0] in_data_86, input [7:0] in_data_87, input [7:0] in_data_88, input [7:0] in_data_89, input [7:0] in_data_90, input [7:0] in_data_91, input [7:0] in_data_92, input [7:0] in_data_93, input [7:0] in_data_94, input [7:0] in_data_95, input [7:0] in_data_96, input [7:0] in_data_97, input [7:0] in_data_98, input [7:0] in_data_99,
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8, input [7:0] kernel_9, input [7:0] kernel_10, input [7:0] kernel_11, input [7:0] kernel_12,   input [7:0] kernel_13, input [7:0] kernel_14, input [7:0] kernel_15, input [7:0] kernel_16, input [7:0] kernel_17, input [7:0] kernel_18, input [7:0] kernel_19, input [7:0] kernel_20, input [7:0] kernel_21, input [7:0] kernel_22, input [7:0] kernel_23, input [7:0] kernel_24,   input [7:0] kernel_25, input [7:0] kernel_26, input [7:0] kernel_27, input [7:0] kernel_28, input [7:0] kernel_29, input [7:0] kernel_30, input [7:0] kernel_31, input [7:0] kernel_32, input [7:0] kernel_33, input [7:0] kernel_34, input [7:0] kernel_35, input [7:0] kernel_36,   input [7:0] kernel_37, input [7:0] kernel_38, input [7:0] kernel_39, input [7:0] kernel_40, input [7:0] kernel_41, input [7:0] kernel_42, input [7:0] kernel_43, input [7:0] kernel_44, input [7:0] kernel_45, input [7:0] kernel_46, input [7:0] kernel_47, input [7:0] kernel_48,   input [7:0] kernel_49, input [7:0] kernel_50, input [7:0] kernel_51, input [7:0] kernel_52, input [7:0] kernel_53, input [7:0] kernel_54, input [7:0] kernel_55, input [7:0] kernel_56, input [7:0] kernel_57, input [7:0] kernel_58, input [7:0] kernel_59, input [7:0] kernel_60,   input [7:0] kernel_61, input [7:0] kernel_62, input [7:0] kernel_63, input [7:0] kernel_64, input [7:0] kernel_65, input [7:0] kernel_66, input [7:0] kernel_67, input [7:0] kernel_68, input [7:0] kernel_69, input [7:0] kernel_70, input [7:0] kernel_71, input [7:0] kernel_72,   input [7:0] kernel_73, input [7:0] kernel_74, input [7:0] kernel_75, input [7:0] kernel_76, input [7:0] kernel_77, input [7:0] kernel_78, input [7:0] kernel_79, input [7:0] kernel_80, input [7:0] kernel_81, input [7:0] kernel_82, input [7:0] kernel_83, input [7:0] kernel_84,   input [7:0] kernel_85, input [7:0] kernel_86, input [7:0] kernel_87, input [7:0] kernel_88, input [7:0] kernel_89, input [7:0] kernel_90, input [7:0] kernel_91, input [7:0] kernel_92, input [7:0] kernel_93, input [7:0] kernel_94, input [7:0] kernel_95, input [7:0] kernel_96,   input [7:0] kernel_97, input [7:0] kernel_98, input [7:0] kernel_99, 
  input clk,
  output [17:0] out_data // 输出数据
);  


    wire [15:0] conv_sum[100:0];



    multiplier8 mult_inst0(.a(in_data_0), .b(kernel_0), .p(conv_sum[0]));
    multiplier8 mult_inst1(.a(in_data_1), .b(kernel_1), .p(conv_sum[1]));
    multiplier8 mult_inst2(.a(in_data_2), .b(kernel_2), .p(conv_sum[2]));
    multiplier8 mult_inst3(.a(in_data_3), .b(kernel_3), .p(conv_sum[3]));
    multiplier8 mult_inst4(.a(in_data_4), .b(kernel_4), .p(conv_sum[4]));
    multiplier8 mult_inst5(.a(in_data_5), .b(kernel_5), .p(conv_sum[5]));
    multiplier8 mult_inst6(.a(in_data_6), .b(kernel_6), .p(conv_sum[6]));
    multiplier8 mult_inst7(.a(in_data_7), .b(kernel_7), .p(conv_sum[7]));
    multiplier8 mult_inst8(.a(in_data_8), .b(kernel_8), .p(conv_sum[8]));
    multiplier8 mult_inst9(.a(in_data_9), .b(kernel_9), .p(conv_sum[9]));
    multiplier8 mult_inst10(.a(in_data_10), .b(kernel_10), .p(conv_sum[10]));
    multiplier8 mult_inst11(.a(in_data_11), .b(kernel_11), .p(conv_sum[11]));
    multiplier8 mult_inst12(.a(in_data_12), .b(kernel_12), .p(conv_sum[12]));
    multiplier8 mult_inst13(.a(in_data_13), .b(kernel_13), .p(conv_sum[13]));
    multiplier8 mult_inst14(.a(in_data_14), .b(kernel_14), .p(conv_sum[14]));
    multiplier8 mult_inst15(.a(in_data_15), .b(kernel_15), .p(conv_sum[15]));
    multiplier8 mult_inst16(.a(in_data_16), .b(kernel_16), .p(conv_sum[16]));
    multiplier8 mult_inst17(.a(in_data_17), .b(kernel_17), .p(conv_sum[17]));
    multiplier8 mult_inst18(.a(in_data_18), .b(kernel_18), .p(conv_sum[18]));
    multiplier8 mult_inst19(.a(in_data_19), .b(kernel_19), .p(conv_sum[19]));
    multiplier8 mult_inst20(.a(in_data_20), .b(kernel_20), .p(conv_sum[20]));
    multiplier8 mult_inst21(.a(in_data_21), .b(kernel_21), .p(conv_sum[21]));
    multiplier8 mult_inst22(.a(in_data_22), .b(kernel_22), .p(conv_sum[22]));
    multiplier8 mult_inst23(.a(in_data_23), .b(kernel_23), .p(conv_sum[23]));
    multiplier8 mult_inst24(.a(in_data_24), .b(kernel_24), .p(conv_sum[24]));
    multiplier8 mult_inst25(.a(in_data_25), .b(kernel_25), .p(conv_sum[25]));
    multiplier8 mult_inst26(.a(in_data_26), .b(kernel_26), .p(conv_sum[26]));
    multiplier8 mult_inst27(.a(in_data_27), .b(kernel_27), .p(conv_sum[27]));
    multiplier8 mult_inst28(.a(in_data_28), .b(kernel_28), .p(conv_sum[28]));
    multiplier8 mult_inst29(.a(in_data_29), .b(kernel_29), .p(conv_sum[29]));
    multiplier8 mult_inst30(.a(in_data_30), .b(kernel_30), .p(conv_sum[30]));
    multiplier8 mult_inst31(.a(in_data_31), .b(kernel_31), .p(conv_sum[31]));
    multiplier8 mult_inst32(.a(in_data_32), .b(kernel_32), .p(conv_sum[32]));
    multiplier8 mult_inst33(.a(in_data_33), .b(kernel_33), .p(conv_sum[33]));
    multiplier8 mult_inst34(.a(in_data_34), .b(kernel_34), .p(conv_sum[34]));
    multiplier8 mult_inst35(.a(in_data_35), .b(kernel_35), .p(conv_sum[35]));
    multiplier8 mult_inst36(.a(in_data_36), .b(kernel_36), .p(conv_sum[36]));
    multiplier8 mult_inst37(.a(in_data_37), .b(kernel_37), .p(conv_sum[37]));
    multiplier8 mult_inst38(.a(in_data_38), .b(kernel_38), .p(conv_sum[38]));
    multiplier8 mult_inst39(.a(in_data_39), .b(kernel_39), .p(conv_sum[39]));
    multiplier8 mult_inst40(.a(in_data_40), .b(kernel_40), .p(conv_sum[40]));
    multiplier8 mult_inst41(.a(in_data_41), .b(kernel_41), .p(conv_sum[41]));
    multiplier8 mult_inst42(.a(in_data_42), .b(kernel_42), .p(conv_sum[42]));
    multiplier8 mult_inst43(.a(in_data_43), .b(kernel_43), .p(conv_sum[43]));
    multiplier8 mult_inst44(.a(in_data_44), .b(kernel_44), .p(conv_sum[44]));
    multiplier8 mult_inst45(.a(in_data_45), .b(kernel_45), .p(conv_sum[45]));
    multiplier8 mult_inst46(.a(in_data_46), .b(kernel_46), .p(conv_sum[46]));
    multiplier8 mult_inst47(.a(in_data_47), .b(kernel_47), .p(conv_sum[47]));
    multiplier8 mult_inst48(.a(in_data_48), .b(kernel_48), .p(conv_sum[48]));
    multiplier8 mult_inst49(.a(in_data_49), .b(kernel_49), .p(conv_sum[49]));
    multiplier8 mult_inst50(.a(in_data_50), .b(kernel_50), .p(conv_sum[50]));
    multiplier8 mult_inst51(.a(in_data_51), .b(kernel_51), .p(conv_sum[51]));
    multiplier8 mult_inst52(.a(in_data_52), .b(kernel_52), .p(conv_sum[52]));
    multiplier8 mult_inst53(.a(in_data_53), .b(kernel_53), .p(conv_sum[53]));
    multiplier8 mult_inst54(.a(in_data_54), .b(kernel_54), .p(conv_sum[54]));
    multiplier8 mult_inst55(.a(in_data_55), .b(kernel_55), .p(conv_sum[55]));
    multiplier8 mult_inst56(.a(in_data_56), .b(kernel_56), .p(conv_sum[56]));
    multiplier8 mult_inst57(.a(in_data_57), .b(kernel_57), .p(conv_sum[57]));
    multiplier8 mult_inst58(.a(in_data_58), .b(kernel_58), .p(conv_sum[58]));
    multiplier8 mult_inst59(.a(in_data_59), .b(kernel_59), .p(conv_sum[59]));
    multiplier8 mult_inst60(.a(in_data_60), .b(kernel_60), .p(conv_sum[60]));
    multiplier8 mult_inst61(.a(in_data_61), .b(kernel_61), .p(conv_sum[61]));
    multiplier8 mult_inst62(.a(in_data_62), .b(kernel_62), .p(conv_sum[62]));
    multiplier8 mult_inst63(.a(in_data_63), .b(kernel_63), .p(conv_sum[63]));
    multiplier8 mult_inst64(.a(in_data_64), .b(kernel_64), .p(conv_sum[64]));
    multiplier8 mult_inst65(.a(in_data_65), .b(kernel_65), .p(conv_sum[65]));
    multiplier8 mult_inst66(.a(in_data_66), .b(kernel_66), .p(conv_sum[66]));
    multiplier8 mult_inst67(.a(in_data_67), .b(kernel_67), .p(conv_sum[67]));
    multiplier8 mult_inst68(.a(in_data_68), .b(kernel_68), .p(conv_sum[68]));
    multiplier8 mult_inst69(.a(in_data_69), .b(kernel_69), .p(conv_sum[69]));
    multiplier8 mult_inst70(.a(in_data_70), .b(kernel_70), .p(conv_sum[70]));
    multiplier8 mult_inst71(.a(in_data_71), .b(kernel_71), .p(conv_sum[71]));
    multiplier8 mult_inst72(.a(in_data_72), .b(kernel_72), .p(conv_sum[72]));
    multiplier8 mult_inst73(.a(in_data_73), .b(kernel_73), .p(conv_sum[73]));
    multiplier8 mult_inst74(.a(in_data_74), .b(kernel_74), .p(conv_sum[74]));
    multiplier8 mult_inst75(.a(in_data_75), .b(kernel_75), .p(conv_sum[75]));
    multiplier8 mult_inst76(.a(in_data_76), .b(kernel_76), .p(conv_sum[76]));
    multiplier8 mult_inst77(.a(in_data_77), .b(kernel_77), .p(conv_sum[77]));
    multiplier8 mult_inst78(.a(in_data_78), .b(kernel_78), .p(conv_sum[78]));
    multiplier8 mult_inst79(.a(in_data_79), .b(kernel_79), .p(conv_sum[79]));
    multiplier8 mult_inst80(.a(in_data_80), .b(kernel_80), .p(conv_sum[80]));
    multiplier8 mult_inst81(.a(in_data_81), .b(kernel_81), .p(conv_sum[81]));
    multiplier8 mult_inst82(.a(in_data_82), .b(kernel_82), .p(conv_sum[82]));
    multiplier8 mult_inst83(.a(in_data_83), .b(kernel_83), .p(conv_sum[83]));
    multiplier8 mult_inst84(.a(in_data_84), .b(kernel_84), .p(conv_sum[84]));
    multiplier8 mult_inst85(.a(in_data_85), .b(kernel_85), .p(conv_sum[85]));
    multiplier8 mult_inst86(.a(in_data_86), .b(kernel_86), .p(conv_sum[86]));
    multiplier8 mult_inst87(.a(in_data_87), .b(kernel_87), .p(conv_sum[87]));
    multiplier8 mult_inst88(.a(in_data_88), .b(kernel_88), .p(conv_sum[88]));
    multiplier8 mult_inst89(.a(in_data_89), .b(kernel_89), .p(conv_sum[89]));
    multiplier8 mult_inst90(.a(in_data_90), .b(kernel_90), .p(conv_sum[90]));
    multiplier8 mult_inst91(.a(in_data_91), .b(kernel_91), .p(conv_sum[91]));
    multiplier8 mult_inst92(.a(in_data_92), .b(kernel_92), .p(conv_sum[92]));
    multiplier8 mult_inst93(.a(in_data_93), .b(kernel_93), .p(conv_sum[93]));
    multiplier8 mult_inst94(.a(in_data_94), .b(kernel_94), .p(conv_sum[94]));
    multiplier8 mult_inst95(.a(in_data_95), .b(kernel_95), .p(conv_sum[95]));
    multiplier8 mult_inst96(.a(in_data_96), .b(kernel_96), .p(conv_sum[96]));
    multiplier8 mult_inst97(.a(in_data_97), .b(kernel_97), .p(conv_sum[97]));
    multiplier8 mult_inst98(.a(in_data_98), .b(kernel_98), .p(conv_sum[98]));
    multiplier8 mult_inst99(.a(in_data_99), .b(kernel_99), .p(conv_sum[99]));



    parallel_adder_tree_dsp adder_tree_inst(.a0(conv_sum[0]), .a1(conv_sum[1]), .a2(conv_sum[2]), .a3(conv_sum[3]), .a4(conv_sum[4]), .a5(conv_sum[5]), .a6(conv_sum[6]), .a7(conv_sum[7]), .a8(conv_sum[8]), .a9(conv_sum[9]), .a10(conv_sum[10]), .a11(conv_sum[11]), .a12(conv_sum[12]), .a13(conv_sum[13]), .a14(conv_sum[14]), .a15(conv_sum[15]), .a16(conv_sum[16]), .a17(conv_sum[17]), .a18(conv_sum[18]), .a19(conv_sum[19]), .a20(conv_sum[20]), .a21(conv_sum[21]), .a22(conv_sum[22]), .a23(conv_sum[23]), .a24(conv_sum[24]), .a25(conv_sum[25]), .a26(conv_sum[26]), .a27(conv_sum[27]), .a28(conv_sum[28]), .a29(conv_sum[29]), .a30(conv_sum[30]), .a31(conv_sum[31]),  .a32(conv_sum[32]), .a33(conv_sum[33]), .a34(conv_sum[34]), .a35(conv_sum[35]), .a36(conv_sum[36]), .a37(conv_sum[37]), .a38(conv_sum[38]), .a39(conv_sum[39]), .a40(conv_sum[40]), .a41(conv_sum[41]), .a42(conv_sum[42]), .a43(conv_sum[43]), .a44(conv_sum[44]), .a45(conv_sum[45]), .a46(conv_sum[46]), .a47(conv_sum[47]), .a48(conv_sum[48]), .a49(conv_sum[49]), .a50(conv_sum[50]), .a51(conv_sum[51]), .a52(conv_sum[52]), .a53(conv_sum[53]), .a54(conv_sum[54]), .a55(conv_sum[55]), .a56(conv_sum[56]), .a57(conv_sum[57]), .a58(conv_sum[58]), .a59(conv_sum[59]), .a60(conv_sum[60]), .a61(conv_sum[61]), .a62(conv_sum[62]), .a63(conv_sum[63]), .a64(conv_sum[64]), .a65(conv_sum[65]), .a66(conv_sum[66]), .a67(conv_sum[67]), .a68(conv_sum[68]), .a69(conv_sum[69]), .a70(conv_sum[70]), .a71(conv_sum[71]), .a72(conv_sum[72]), .a73(conv_sum[73]), .a74(conv_sum[74]), .a75(conv_sum[75]), .a76(conv_sum[76]), .a77(conv_sum[77]), .a78(conv_sum[78]), .a79(conv_sum[79]), .a80(conv_sum[80]), .a81(conv_sum[81]), .a82(conv_sum[82]), .a83(conv_sum[83]), .a84(conv_sum[84]), .a85(conv_sum[85]), .a86(conv_sum[86]), .a87(conv_sum[87]), .a88(conv_sum[88]), .a89(conv_sum[89]), .a90(conv_sum[90]), .a91(conv_sum[91]), .a92(conv_sum[92]), .a93(conv_sum[93]), .a94(conv_sum[94]), .a95(conv_sum[95]), .a96(conv_sum[96]), .a97(conv_sum[97]), .a98(conv_sum[98]), .a99(conv_sum[99]),  .clk(clk), .sum(out_data));

endmodule

module parallel_adder_tree_dsp (
    input [15:0] a0, input [15:0] a1, input [15:0] a2, input [15:0] a3, input [15:0] a4, input [15:0] a5, input [15:0] a6, input [15:0] a7, input [15:0] a8, input [15:0] a9, input [15:0] a10, input [15:0] a11, input [15:0] a12, input [15:0] a13, input [15:0] a14, input [15:0] a15, input [15:0] a16, input [15:0] a17, input [15:0] a18, input [15:0] a19, input [15:0] a20, input [15:0] a21, input [15:0] a22, input [15:0] a23, input [15:0] a24, input [15:0] a25, input [15:0] a26, input [15:0] a27, input [15:0] a28, input [15:0] a29, input [15:0] a30, input [15:0] a31, input [15:0] a32, input [15:0] a33, input [15:0] a34, input [15:0] a35, input [15:0] a36, input [15:0] a37, input [15:0] a38, input [15:0] a39, input [15:0] a40, input [15:0] a41, input [15:0] a42, input [15:0] a43, input [15:0] a44, input [15:0] a45, input [15:0] a46, input [15:0] a47, input [15:0] a48, input [15:0] a49, input [15:0] a50, input [15:0] a51, input [15:0] a52, input [15:0] a53, input [15:0] a54, input [15:0] a55, input [15:0] a56, input [15:0] a57, input [15:0] a58, input [15:0] a59, input [15:0] a60, input [15:0] a61, input [15:0] a62, input [15:0] a63, input [15:0] a64, input [15:0] a65, input [15:0] a66, input [15:0] a67, input [15:0] a68, input [15:0] a69, input [15:0] a70, input [15:0] a71, input [15:0] a72, input [15:0] a73, input [15:0] a74, input [15:0] a75, input [15:0] a76, input [15:0] a77, input [15:0] a78, input [15:0] a79, input [15:0] a80, input [15:0] a81, input [15:0] a82, input [15:0] a83, input [15:0] a84, input [15:0] a85, input [15:0] a86, input [15:0] a87,  input [15:0] a88, input [15:0] a89, input [15:0] a90, input [15:0] a91, input [15:0] a92, input [15:0] a93, input [15:0] a94, input [15:0] a95, input [15:0] a96, input [15:0] a97, input [15:0] a98, input [15:0] a99, 
    input clk,
    output [17:0] sum // 结果
);

wire [15:0] c1[50:0], c2[25:0], c3[12:0], c4[6:0], c5[3:0], c6[2:0], c7; // 中间电路
qadd2 qadd2_inst0(.a(a0), .b(a1), .c(c1[0]));
qadd2 qadd2_inst1(.a(a2), .b(a3), .c(c1[1]));
qadd2 qadd2_inst2(.a(a4), .b(a5), .c(c1[2]));
qadd2 qadd2_inst3(.a(a6), .b(a7), .c(c1[3]));
qadd2 qadd2_inst4(.a(a8), .b(a9), .c(c1[4]));
qadd2 qadd2_inst5(.a(a10), .b(a11), .c(c1[5]));
qadd2 qadd2_inst6(.a(a12), .b(a13), .c(c1[6]));
qadd2 qadd2_inst7(.a(a14), .b(a15), .c(c1[7]));
qadd2 qadd2_inst8(.a(a16), .b(a17), .c(c1[8]));
qadd2 qadd2_inst9(.a(a18), .b(a19), .c(c1[9]));
qadd2 qadd2_inst10(.a(a20), .b(a21), .c(c1[10]));
qadd2 qadd2_inst11(.a(a22), .b(a23), .c(c1[11]));
qadd2 qadd2_inst12(.a(a24), .b(a25), .c(c1[12]));
qadd2 qadd2_inst13(.a(a26), .b(a27), .c(c1[13]));
qadd2 qadd2_inst14(.a(a28), .b(a29), .c(c1[14]));
qadd2 qadd2_inst15(.a(a30), .b(a31), .c(c1[15]));
qadd2 qadd2_inst16(.a(a32), .b(a33), .c(c1[16]));
qadd2 qadd2_inst17(.a(a34), .b(a35), .c(c1[17]));
qadd2 qadd2_inst18(.a(a36), .b(a37), .c(c1[18]));
qadd2 qadd2_inst19(.a(a38), .b(a39), .c(c1[19]));
qadd2 qadd2_inst20(.a(a40), .b(a41), .c(c1[20]));
qadd2 qadd2_inst21(.a(a42), .b(a43), .c(c1[21]));
qadd2 qadd2_inst22(.a(a44), .b(a45), .c(c1[22]));
qadd2 qadd2_inst23(.a(a46), .b(a47), .c(c1[23]));
qadd2 qadd2_inst24(.a(a48), .b(a49), .c(c1[24]));
qadd2 qadd2_inst25(.a(a50), .b(a51), .c(c1[25]));
qadd2 qadd2_inst26(.a(a52), .b(a53), .c(c1[26]));
qadd2 qadd2_inst27(.a(a54), .b(a55), .c(c1[27]));
qadd2 qadd2_inst28(.a(a56), .b(a57), .c(c1[28]));
qadd2 qadd2_inst29(.a(a58), .b(a59), .c(c1[29]));
qadd2 qadd2_inst30(.a(a60), .b(a61), .c(c1[30]));
qadd2 qadd2_inst31(.a(a62), .b(a63), .c(c1[31]));
qadd2 qadd2_inst32(.a(a64), .b(a65), .c(c1[32]));
qadd2 qadd2_inst33(.a(a66), .b(a67), .c(c1[33]));
qadd2 qadd2_inst34(.a(a68), .b(a69), .c(c1[34]));
qadd2 qadd2_inst35(.a(a70), .b(a71), .c(c1[35]));
qadd2 qadd2_inst36(.a(a72), .b(a73), .c(c1[36]));
qadd2 qadd2_inst37(.a(a74), .b(a75), .c(c1[37]));
qadd2 qadd2_inst38(.a(a76), .b(a77), .c(c1[38]));
qadd2 qadd2_inst39(.a(a78), .b(a79), .c(c1[39]));
qadd2 qadd2_inst40(.a(a80), .b(a81), .c(c1[40]));
qadd2 qadd2_inst41(.a(a82), .b(a83), .c(c1[41]));
qadd2 qadd2_inst42(.a(a84), .b(a85), .c(c1[42]));
qadd2 qadd2_inst43(.a(a86), .b(a87), .c(c1[43]));
qadd2 qadd2_inst44(.a(a88), .b(a89), .c(c1[44]));
qadd2 qadd2_inst45(.a(a90), .b(a91), .c(c1[45]));
qadd2 qadd2_inst46(.a(a92), .b(a93), .c(c1[46]));
qadd2 qadd2_inst47(.a(a94), .b(a95), .c(c1[47]));
qadd2 qadd2_inst48(.a(a96), .b(a97), .c(c1[48]));
qadd2 qadd2_inst49(.a(a98), .b(a99), .c(c1[49]));



qadd2 qadd2_inst50(.a(c1[0]), .b(c1[1]), .c(c2[0]));
qadd2 qadd2_inst51(.a(c1[2]), .b(c1[3]), .c(c2[1]));
qadd2 qadd2_inst52(.a(c1[4]), .b(c1[5]), .c(c2[2]));
qadd2 qadd2_inst53(.a(c1[6]), .b(c1[7]), .c(c2[3]));
qadd2 qadd2_inst54(.a(c1[8]), .b(c1[9]), .c(c2[4]));
qadd2 qadd2_inst55(.a(c1[10]), .b(c1[11]), .c(c2[5]));
qadd2 qadd2_inst56(.a(c1[12]), .b(c1[13]), .c(c2[6]));
qadd2 qadd2_inst57(.a(c1[14]), .b(c1[15]), .c(c2[7]));
qadd2 qadd2_inst58(.a(c1[16]), .b(c1[17]), .c(c2[8]));
qadd2 qadd2_inst59(.a(c1[18]), .b(c1[19]), .c(c2[9]));
qadd2 qadd2_inst60(.a(c1[20]), .b(c1[21]), .c(c2[10]));
qadd2 qadd2_inst61(.a(c1[22]), .b(c1[23]), .c(c2[11]));
qadd2 qadd2_inst62(.a(c1[24]), .b(c1[25]), .c(c2[12]));
qadd2 qadd2_inst63(.a(c1[26]), .b(c1[27]), .c(c2[13]));
qadd2 qadd2_inst64(.a(c1[28]), .b(c1[29]), .c(c2[14]));
qadd2 qadd2_inst65(.a(c1[30]), .b(c1[31]), .c(c2[15]));
qadd2 qadd2_inst66(.a(c1[32]), .b(c1[33]), .c(c2[16]));
qadd2 qadd2_inst67(.a(c1[34]), .b(c1[35]), .c(c2[17]));
qadd2 qadd2_inst68(.a(c1[36]), .b(c1[37]), .c(c2[18]));
qadd2 qadd2_inst69(.a(c1[38]), .b(c1[39]), .c(c2[19]));
qadd2 qadd2_inst70(.a(c1[40]), .b(c1[41]), .c(c2[20]));
qadd2 qadd2_inst71(.a(c1[42]), .b(c1[43]), .c(c2[21]));
qadd2 qadd2_inst72(.a(c1[44]), .b(c1[45]), .c(c2[22]));
qadd2 qadd2_inst73(.a(c1[46]), .b(c1[47]), .c(c2[23]));
qadd2 qadd2_inst74(.a(c1[48]), .b(c1[49]), .c(c2[24]));


qadd2 qadd2_inst75(.a(c2[0]), .b(c2[1]), .c(c3[0]));
qadd2 qadd2_inst76(.a(c2[2]), .b(c2[3]), .c(c3[1]));
qadd2 qadd2_inst77(.a(c2[4]), .b(c2[5]), .c(c3[2]));
qadd2 qadd2_inst78(.a(c2[6]), .b(c2[7]), .c(c3[3]));
qadd2 qadd2_inst79(.a(c2[8]), .b(c2[9]), .c(c3[4]));
qadd2 qadd2_inst80(.a(c2[10]), .b(c2[11]), .c(c3[5]));
qadd2 qadd2_inst81(.a(c2[12]), .b(c2[13]), .c(c3[6]));
qadd2 qadd2_inst82(.a(c2[14]), .b(c2[15]), .c(c3[7]));
qadd2 qadd2_inst83(.a(c2[16]), .b(c2[17]), .c(c3[8]));
qadd2 qadd2_inst84(.a(c2[18]), .b(c2[19]), .c(c3[9]));
qadd2 qadd2_inst85(.a(c2[20]), .b(c2[21]), .c(c3[10]));
qadd2 qadd2_inst86(.a(c2[22]), .b(c2[23]), .c(c3[11]));


qadd2 qadd2_inst87(.a(c3[0]), .b(c3[1]), .c(c4[0]));
qadd2 qadd2_inst88(.a(c3[2]), .b(c3[3]), .c(c4[1]));
qadd2 qadd2_inst89(.a(c3[4]), .b(c3[5]), .c(c4[2]));
qadd2 qadd2_inst90(.a(c3[6]), .b(c3[7]), .c(c4[3]));
qadd2 qadd2_inst91(.a(c3[8]), .b(c3[9]), .c(c4[4]));
qadd2 qadd2_inst92(.a(c3[10]), .b(c3[11]), .c(c4[5]));

qadd2 qadd2_inst93(.a(c4[0]), .b(c4[1]), .c(c5[0]));
qadd2 qadd2_inst94(.a(c4[2]), .b(c4[3]), .c(c5[1]));
qadd2 qadd2_inst95(.a(c4[4]), .b(c4[5]), .c(c5[2]));

qadd2 qadd2_inst96(.a(c5[0]), .b(c5[1]), .c(c6[0]));
qadd2 qadd2_inst97(.a(c5[2]), .b(c5[3]), .c(c6[1]));

qadd2 qadd2_inst98(.a(c6[0]), .b(c6[1]), .c(c7));

qadd2 qadd2_inst99(.a(c7), .b(c2[24]), .c(sum));


endmodule


module qadd2(
 input [17:0] a,
 input [17:0] b,
 output [17:0] c
    );
    
assign c = a + b;


endmodule


module multiplier8 (input [7:0] a, b, output [15:0] p);
    reg [7:0] multiplier_reg;
    reg [15:0] result_reg;

    always @(*) begin
        multiplier_reg = b;
        result_reg = {8'b0, a};
        if (multiplier_reg[0]) result_reg = result_reg + {15'b0, a};
        if (multiplier_reg[1]) result_reg = result_reg + {14'b0, a} << 1;
        if (multiplier_reg[2]) result_reg = result_reg + {13'b0, a} << 2;
        if (multiplier_reg[3]) result_reg = result_reg + {12'b0, a} << 3;
        if (multiplier_reg[4]) result_reg = result_reg + {11'b0, a} << 4;
        if (multiplier_reg[5]) result_reg = result_reg + {10'b0, a} << 5;
        if (multiplier_reg[6]) result_reg = result_reg + {9'b0, a} << 6;
        if (multiplier_reg[7]) result_reg = result_reg + {8'b0, a} << 7;
    end

    assign p = result_reg;
endmodule