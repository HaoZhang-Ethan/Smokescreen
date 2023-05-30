module GEMM100_8_DSP (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24,   input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44,   input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48, input [7:0] in_data_49, input [7:0] in_data_50, input [7:0] in_data_51, input [7:0] in_data_52, input [7:0] in_data_53, input [7:0] in_data_54, input [7:0] in_data_55, input [7:0] in_data_56, input [7:0] in_data_57, input [7:0] in_data_58, input [7:0] in_data_59, input [7:0] in_data_60, input [7:0] in_data_61, input [7:0] in_data_62, input [7:0] in_data_63, input [7:0] in_data_64,   input [7:0] in_data_65, input [7:0] in_data_66, input [7:0] in_data_67, input [7:0] in_data_68, input [7:0] in_data_69, input [7:0] in_data_70, input [7:0] in_data_71, input [7:0] in_data_72, input [7:0] in_data_73, input [7:0] in_data_74, input [7:0] in_data_75, input [7:0] in_data_76, input [7:0] in_data_77, input [7:0] in_data_78, input [7:0] in_data_79, input [7:0] in_data_80, input [7:0] in_data_81, input [7:0] in_data_82, input [7:0] in_data_83, input [7:0] in_data_84,   input [7:0] in_data_85, input [7:0] in_data_86, input [7:0] in_data_87, input [7:0] in_data_88, input [7:0] in_data_89, input [7:0] in_data_90, input [7:0] in_data_91, input [7:0] in_data_92, input [7:0] in_data_93, input [7:0] in_data_94, input [7:0] in_data_95, input [7:0] in_data_96, input [7:0] in_data_97, input [7:0] in_data_98, input [7:0] in_data_99,
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8, input [7:0] kernel_9, input [7:0] kernel_10, input [7:0] kernel_11, input [7:0] kernel_12,   input [7:0] kernel_13, input [7:0] kernel_14, input [7:0] kernel_15, input [7:0] kernel_16, input [7:0] kernel_17, input [7:0] kernel_18, input [7:0] kernel_19, input [7:0] kernel_20, input [7:0] kernel_21, input [7:0] kernel_22, input [7:0] kernel_23, input [7:0] kernel_24,   input [7:0] kernel_25, input [7:0] kernel_26, input [7:0] kernel_27, input [7:0] kernel_28, input [7:0] kernel_29, input [7:0] kernel_30, input [7:0] kernel_31, input [7:0] kernel_32, input [7:0] kernel_33, input [7:0] kernel_34, input [7:0] kernel_35, input [7:0] kernel_36,   input [7:0] kernel_37, input [7:0] kernel_38, input [7:0] kernel_39, input [7:0] kernel_40, input [7:0] kernel_41, input [7:0] kernel_42, input [7:0] kernel_43, input [7:0] kernel_44, input [7:0] kernel_45, input [7:0] kernel_46, input [7:0] kernel_47, input [7:0] kernel_48,   input [7:0] kernel_49, input [7:0] kernel_50, input [7:0] kernel_51, input [7:0] kernel_52, input [7:0] kernel_53, input [7:0] kernel_54, input [7:0] kernel_55, input [7:0] kernel_56, input [7:0] kernel_57, input [7:0] kernel_58, input [7:0] kernel_59, input [7:0] kernel_60,   input [7:0] kernel_61, input [7:0] kernel_62, input [7:0] kernel_63, input [7:0] kernel_64, input [7:0] kernel_65, input [7:0] kernel_66, input [7:0] kernel_67, input [7:0] kernel_68, input [7:0] kernel_69, input [7:0] kernel_70, input [7:0] kernel_71, input [7:0] kernel_72,   input [7:0] kernel_73, input [7:0] kernel_74, input [7:0] kernel_75, input [7:0] kernel_76, input [7:0] kernel_77, input [7:0] kernel_78, input [7:0] kernel_79, input [7:0] kernel_80, input [7:0] kernel_81, input [7:0] kernel_82, input [7:0] kernel_83, input [7:0] kernel_84,   input [7:0] kernel_85, input [7:0] kernel_86, input [7:0] kernel_87, input [7:0] kernel_88, input [7:0] kernel_89, input [7:0] kernel_90, input [7:0] kernel_91, input [7:0] kernel_92, input [7:0] kernel_93, input [7:0] kernel_94, input [7:0] kernel_95, input [7:0] kernel_96,   input [7:0] kernel_97, input [7:0] kernel_98, input [7:0] kernel_99, 
  input clk,
  output [17:0] out_data // 输出数据
);  

  parallel_adder_tree_dsp adder_tree_inst(.a0(in_data_0*kernel_0), .a1(in_data_1*kernel_1), .a2(in_data_2*kernel_2), .a3(in_data_3*kernel_3), .a4(in_data_4*kernel_4), .a5(in_data_5*kernel_5), .a6(in_data_6*kernel_6), .a7(in_data_7*kernel_7), .a8(in_data_8*kernel_8), .a9(in_data_9*kernel_9), .a10(in_data_10*kernel_10), .a11(in_data_11*kernel_11), .a12(in_data_12*kernel_12), .a13(in_data_13*kernel_13), .a14(in_data_14*kernel_14), .a15(in_data_15*kernel_15), .a16(in_data_16*kernel_16), .a17(in_data_17*kernel_17), .a18(in_data_18*kernel_18), .a19(in_data_19*kernel_19), .a20(in_data_20*kernel_20), .a21(in_data_21*kernel_21), .a22(in_data_22*kernel_22), .a23(in_data_23*kernel_23), .a24(in_data_24*kernel_24), .a25(in_data_25*kernel_25), .a26(in_data_26*kernel_26), .a27(in_data_27*kernel_27), .a28(in_data_28*kernel_28), .a29(in_data_29*kernel_29), .a30(in_data_30*kernel_30), .a31(in_data_31*kernel_31),   .a32(in_data_32*kernel_32), .a33(in_data_33*kernel_33), .a34(in_data_34*kernel_34), .a35(in_data_35*kernel_35), .a36(in_data_36*kernel_36), .a37(in_data_37*kernel_37), .a38(in_data_38*kernel_38), .a39(in_data_39*kernel_39), .a40(in_data_40*kernel_40), .a41(in_data_41*kernel_41), .a42(in_data_42*kernel_42), .a43(in_data_43*kernel_43), .a44(in_data_44*kernel_44), .a45(in_data_45*kernel_45), .a46(in_data_46*kernel_46), .a47(in_data_47*kernel_47), .a48(in_data_48*kernel_48), .a49(in_data_49*kernel_49), .a50(in_data_50*kernel_50), .a51(in_data_51*kernel_51), .a52(in_data_52*kernel_52), .a53(in_data_53*kernel_53), .a54(in_data_54*kernel_54), .a55(in_data_55*kernel_55), .a56(in_data_56*kernel_56), .a57(in_data_57*kernel_57), .a58(in_data_58*kernel_58), .a59(in_data_59*kernel_59), .a60(in_data_60*kernel_60), .a61(in_data_61*kernel_61), .a62(in_data_62*kernel_62), .a63(in_data_63*kernel_63), .a64(in_data_64*kernel_64), .a65(in_data_65*kernel_65), .a66(in_data_66*kernel_66), .a67(in_data_67*kernel_67), .a68(in_data_68*kernel_68), .a69(in_data_69*kernel_69), .a70(in_data_70*kernel_70), .a71(in_data_71*kernel_71), .a72(in_data_72*kernel_72), .a73(in_data_73*kernel_73),  .a74(in_data_74*kernel_74), .a75(in_data_75*kernel_75), .a76(in_data_76*kernel_76), .a77(in_data_77*kernel_77), .a78(in_data_78*kernel_78), .a79(in_data_79*kernel_79), .a80(in_data_80*kernel_80), .a81(in_data_81*kernel_81), .a82(in_data_82*kernel_82), .a83(in_data_83*kernel_83), .a84(in_data_84*kernel_84), .a85(in_data_85*kernel_85), .a86(in_data_86*kernel_86), .a87(in_data_87*kernel_87), .a88(in_data_88*kernel_88), .a89(in_data_89*kernel_89), .a90(in_data_90*kernel_90), .a91(in_data_91*kernel_91), .a92(in_data_92*kernel_92), .a93(in_data_93*kernel_93), .a94(in_data_94*kernel_94), .a95(in_data_95*kernel_95), .a96(in_data_96*kernel_96), .a97(in_data_97*kernel_97), .a98(in_data_98*kernel_98), .a99(in_data_99*kernel_99), .clk(clk), .sum(out_data));

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
