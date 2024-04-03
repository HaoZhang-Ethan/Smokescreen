module GEMM32_8_DSP (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24,   input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, 
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8, input [7:0] kernel_9, input [7:0] kernel_10, input [7:0] kernel_11, input [7:0] kernel_12,   input [7:0] kernel_13, input [7:0] kernel_14, input [7:0] kernel_15, input [7:0] kernel_16, input [7:0] kernel_17, input [7:0] kernel_18, input [7:0] kernel_19, input [7:0] kernel_20, input [7:0] kernel_21, input [7:0] kernel_22, input [7:0] kernel_23, input [7:0] kernel_24,   input [7:0] kernel_25, input [7:0] kernel_26, input [7:0] kernel_27, input [7:0] kernel_28, input [7:0] kernel_29, input [7:0] kernel_30, input [7:0] kernel_31, input [7:0] kernel_32, 
  input clk,
  output [15:0] out_data // 输出数据
);  

  parallel_adder_tree_dsp adder_tree_inst(.a0(in_data_0*kernel_0), .a1(in_data_1*kernel_1), .a2(in_data_2*kernel_2), .a3(in_data_3*kernel_3), .a4(in_data_4*kernel_4), .a5(in_data_5*kernel_5), .a6(in_data_6*kernel_6), .a7(in_data_7*kernel_7), .a8(in_data_8*kernel_8), .a9(in_data_9*kernel_9), .a10(in_data_10*kernel_10), .a11(in_data_11*kernel_11), .a12(in_data_12*kernel_12), .a13(in_data_13*kernel_13), .a14(in_data_14*kernel_14), .a15(in_data_15*kernel_15), .a16(in_data_16*kernel_16), .a17(in_data_17*kernel_17), .a18(in_data_18*kernel_18), .a19(in_data_19*kernel_19), .a20(in_data_20*kernel_20), .a21(in_data_21*kernel_21), .a22(in_data_22*kernel_22), .a23(in_data_23*kernel_23), .a24(in_data_24*kernel_24), .a25(in_data_25*kernel_25), .a26(in_data_26*kernel_26), .a27(in_data_27*kernel_27), .a28(in_data_28*kernel_28), .a29(in_data_29*kernel_29), .a30(in_data_30*kernel_30), .a31(in_data_31*kernel_31), .clk(clk), .sum(out_data));

endmodule

module parallel_adder_tree_dsp (
    input [15:0] a0, input [15:0] a1, input [15:0] a2, input [15:0] a3, input [15:0] a4, input [15:0] a5, input [15:0] a6, input [15:0] a7, input [15:0] a8, input [15:0] a9, input [15:0] a10, input [15:0] a11, input [15:0] a12, input [15:0] a13, input [15:0] a14, input [15:0] a15, input [15:0] a16, input [15:0] a17, input [15:0] a18, input [15:0] a19, input [15:0] a20, input [15:0] a21, input [15:0] a22, input [15:0] a23, input [15:0] a24, input [15:0] a25, input [15:0] a26, input [15:0] a27, input [15:0] a28, input [15:0] a29, input [15:0] a30, input [15:0] a31, input [15:0] a32,
    input clk,
    output [15:0] sum // 结果
);

wire [15:0] c1[24:0], c2[15:0], c3[8:0], c4[2:0], c5[5:0], c6[3:0]; // 中间电路
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


qadd2 qadd2_inst25(.a(c1[0]), .b(c1[1]), .c(c2[0]));
qadd2 qadd2_inst26(.a(c1[2]), .b(c1[3]), .c(c2[1]));
qadd2 qadd2_inst27(.a(c1[4]), .b(c1[5]), .c(c2[2]));
qadd2 qadd2_inst28(.a(c1[6]), .b(c1[7]), .c(c2[3]));
qadd2 qadd2_inst29(.a(c1[8]), .b(c1[9]), .c(c2[4]));
qadd2 qadd2_inst30(.a(c1[10]), .b(c1[11]), .c(c2[5]));
qadd2 qadd2_inst31(.a(c1[12]), .b(c1[13]), .c(c2[6]));
qadd2 qadd2_inst32(.a(c1[14]), .b(c1[15]), .c(c2[7]));


qadd2 qadd2_inst38(.a(c2[0]), .b(c2[1]), .c(c3[0]));
qadd2 qadd2_inst39(.a(c2[2]), .b(c2[3]), .c(c3[1]));
qadd2 qadd2_inst40(.a(c2[4]), .b(c2[5]), .c(c3[2]));
qadd2 qadd2_inst41(.a(c2[6]), .b(c2[7]), .c(c3[3]));

qadd2 qadd2_inst45(.a(c3[0]), .b(c3[1]), .c(c4[0]));
qadd2 qadd2_inst46(.a(c3[2]), .b(c3[3]), .c(c4[1]));

qadd2 qadd2_inst54(.a(c4[0]), .b(c4[1]), .c(sum));

endmodule


module qadd2(
 input [15:0] a,
 input [15:0] b,
 output [15:0] c
    );
    
assign c = a + b;


endmodule