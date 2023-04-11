module multiplier(input [5:0] a, b, output [11:0] p);
    reg [5:0] multiplier_reg;
    reg [11:0] result_reg;

    always @(*) begin
        multiplier_reg = b;
        result_reg = {6'b0, a};
        if (multiplier_reg[0]) result_reg = result_reg + {15'b0, a};
        if (multiplier_reg[1]) result_reg = result_reg + {14'b0, a} << 1;
        if (multiplier_reg[2]) result_reg = result_reg + {13'b0, a} << 2;
        if (multiplier_reg[3]) result_reg = result_reg + {12'b0, a} << 3;
        if (multiplier_reg[4]) result_reg = result_reg + {11'b0, a} << 4;
        if (multiplier_reg[5]) result_reg = result_reg + {10'b0, a} << 5;
    end

    assign p = result_reg;
endmodule

module conv3x3 (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8, // 输入数据
  input [5:0] kernel_0, input [5:0] kernel_1, input [5:0] kernel_2, input [5:0] kernel_3, input [5:0] kernel_4, input [5:0] kernel_5, input [5:0] kernel_6, input [5:0] kernel_7, input [5:0] kernel_8, // 卷积核
  input clk,
  output reg [17:0] out_data // 输出数据
);  

  wire [107:0] conv_sum;
  multiplier mult_inst9(.a(in_data_8), .b(kernel_8), .p(conv_sum[11:0]));
  multiplier mult_inst8(.a(in_data_7), .b(kernel_7), .p(conv_sum[23:12]));
  multiplier mult_inst7(.a(in_data_6), .b(kernel_6), .p(conv_sum[35:24]));
  multiplier mult_inst6(.a(in_data_5), .b(kernel_5), .p(conv_sum[47:36]));
  multiplier mult_inst5(.a(in_data_4), .b(kernel_4), .p(conv_sum[59:48]));
  multiplier mult_inst4(.a(in_data_3), .b(kernel_3), .p(conv_sum[71:60]));
  multiplier mult_inst3(.a(in_data_2), .b(kernel_2), .p(conv_sum[83:72]));
  multiplier mult_inst2(.a(in_data_1), .b(kernel_1), .p(conv_sum[95:84]));
  multiplier mult_inst1(.a(in_data_0), .b(kernel_0), .p(conv_sum[107:96]));


  parallel_adder_tree adder_inst(.a(conv_sum[11:0]), .b(conv_sum[23:12]), .c(conv_sum[35:24]), .d(conv_sum[47:36]), .e(conv_sum[59:48]), .f(conv_sum[71:60]), .g(conv_sum[83:72]), .h(conv_sum[95:84]), .i(conv_sum[107:96]), .clk(clk), .sum(out_data));
  
endmodule

module parallel_adder_tree (
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
    output reg [17:0] sum // 结果
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

assign c3 = c2[0] + c2[1] + c2[2];


always @(posedge clk) begin
    sum <= c3;
end

endmodule






