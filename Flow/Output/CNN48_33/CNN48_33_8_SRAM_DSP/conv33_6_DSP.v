module conv33_6_DSP (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8, // 输入数据
  input [5:0] kernel_0, input [5:0] kernel_1, input [5:0] kernel_2, input [5:0] kernel_3, input [5:0] kernel_4, input [5:0] kernel_5, input [5:0] kernel_6, input [5:0] kernel_7, input [5:0] kernel_8,// 卷积核
  input clk,
  output [17:0] out_data // 输出数据
);  


  parallel_adder_tree_dsp_33 adder_inst(.a(in_data_0 * kernel_0), .b(in_data_1 * kernel_1), .c(in_data_2 * kernel_2), .d(in_data_3 * kernel_3), .e(in_data_4 * kernel_4), .f(in_data_5 * kernel_5), .g(in_data_6 * kernel_6), .h(in_data_7 * kernel_7), .i(in_data_8 * kernel_8), .clk(clk), .sum(out_data)); // 并行加法树

endmodule

module parallel_adder_tree_dsp_33 (
    input [11:0] a,  // 9个8位数字输入
    input [11:0] b, 
    input [11:0] c,
    input [11:0] d,
    input [11:0] e,
    input [11:0] f,
    input [11:0] g,
    input [11:0] h,
    input [11:0] i,
    input clk,
    output [17:0] sum // 结果
);

wire [17:0] c1[4:0], c2[2:0], c3; // 中间电路


qadd2c qadd2c_inst0(.a(a), .b(b), .c(c1[0]));
qadd2c qadd2c_inst1(.a(c), .b(d), .c(c1[1]));
qadd2c qadd2c_inst2(.a(e), .b(f), .c(c1[2]));
qadd2c qadd2c_inst3(.a(g), .b(h), .c(c1[3]));

qadd2c qadd2c_inst4(.a(c1[0]), .b(c1[1]), .c(c2[0]));
qadd2c qadd2c_inst5(.a(c1[2]), .b(c1[3]), .c(c2[1]));

qadd2c qadd2c_inst6(.a(c2[0]), .b(c2[1]), .c(c2[2]));

qadd2c qadd2c_inst7(.a(c2[2]), .b(i), .c(sum));

endmodule


module qadd2c(
 input [17:0] a,
 input [17:0] b,
 output [17:0] c
    );
    
assign c = a + b;


endmodule
