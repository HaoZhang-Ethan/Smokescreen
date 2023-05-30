module GEMM32_8_CLB (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24,   input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, 
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8, input [7:0] kernel_9, input [7:0] kernel_10, input [7:0] kernel_11, input [7:0] kernel_12,   input [7:0] kernel_13, input [7:0] kernel_14, input [7:0] kernel_15, input [7:0] kernel_16, input [7:0] kernel_17, input [7:0] kernel_18, input [7:0] kernel_19, input [7:0] kernel_20, input [7:0] kernel_21, input [7:0] kernel_22, input [7:0] kernel_23, input [7:0] kernel_24,   input [7:0] kernel_25, input [7:0] kernel_26, input [7:0] kernel_27, input [7:0] kernel_28, input [7:0] kernel_29, input [7:0] kernel_30, input [7:0] kernel_31, input [7:0] kernel_32, 
  input clk,
  output [17:0] out_data // 输出数据
);  


    wire [15:0] conv_sum[31:0];



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

    parallel_adder_tree_dsp adder_tree_inst(.a0(conv_sum[0]), .a1(conv_sum[1]), .a2(conv_sum[2]), .a3(conv_sum[3]), .a4(conv_sum[4]), .a5(conv_sum[5]), .a6(conv_sum[6]), .a7(conv_sum[7]), .a8(conv_sum[8]), .a9(conv_sum[9]), .a10(conv_sum[10]), .a11(conv_sum[11]), .a12(conv_sum[12]), .a13(conv_sum[13]), .a14(conv_sum[14]), .a15(conv_sum[15]), .a16(conv_sum[16]), .a17(conv_sum[17]), .a18(conv_sum[18]), .a19(conv_sum[19]), .a20(conv_sum[20]), .a21(conv_sum[21]), .a22(conv_sum[22]), .a23(conv_sum[23]), .a24(conv_sum[24]), .a25(conv_sum[25]), .a26(conv_sum[26]), .a27(conv_sum[27]), .a28(conv_sum[28]), .a29(conv_sum[29]), .a30(conv_sum[30]), .a31(conv_sum[31]), .clk(clk), .sum(out_data));

endmodule

module parallel_adder_tree_dsp (
    input [15:0] a0, input [15:0] a1, input [15:0] a2, input [15:0] a3, input [15:0] a4, input [15:0] a5, input [15:0] a6, input [15:0] a7, input [15:0] a8, input [15:0] a9, input [15:0] a10, input [15:0] a11, input [15:0] a12, input [15:0] a13, input [15:0] a14, input [15:0] a15, input [15:0] a16, input [15:0] a17, input [15:0] a18, input [15:0] a19, input [15:0] a20, input [15:0] a21, input [15:0] a22, input [15:0] a23, input [15:0] a24, input [15:0] a25, input [15:0] a26, input [15:0] a27, input [15:0] a28, input [15:0] a29, input [15:0] a30, input [15:0] a31, input [15:0] a32,
    input clk,
    output [17:0] sum // 结果
);

wire [17:0] c1[24:0], c2[15:0], c3[8:0], c4[2:0], c5[5:0], c6[3:0]; // 中间电路
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