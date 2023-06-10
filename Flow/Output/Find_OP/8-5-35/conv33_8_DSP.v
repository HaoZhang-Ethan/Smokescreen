module conv33_8_DSP (
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

wire [16:0] c1[4:0], c2[2:0], c3; // 中间电路
assign c1[0] = a + b;
assign c1[1] = c + d;
assign c1[2] = e + f;
assign c1[3] = g + h;
assign c1[4] = i;

assign c2[0] = c1[0] + c1[1];
assign c2[1] = c1[2] + c1[3];
assign c2[2] = c1[4];

assign sum = c2[0] + c2[1] + c2[2];


endmodule


