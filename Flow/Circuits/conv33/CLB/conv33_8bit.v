module multiplier(input [7:0] a, b, output [15:0] p);
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

module conv3x3 (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, // 输入数据
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8, // 卷积核
  input clk,
  output reg [17:0] out_data // 输出数据
);  

  wire [134:0] conv_sum;
  multiplier mult_inst1(.a(in_data_0), .b(kernel_0), .p(conv_sum[134:120]));
  multiplier mult_inst2(.a(in_data_1), .b(kernel_1), .p(conv_sum[119:105]));
  multiplier mult_inst3(.a(in_data_2), .b(kernel_2), .p(conv_sum[104:90]));
  multiplier mult_inst4(.a(in_data_3), .b(kernel_3), .p(conv_sum[89:75]));
  multiplier mult_inst5(.a(in_data_4), .b(kernel_4), .p(conv_sum[74:60]));
  multiplier mult_inst6(.a(in_data_5), .b(kernel_5), .p(conv_sum[59:45]));
  multiplier mult_inst7(.a(in_data_6), .b(kernel_6), .p(conv_sum[44:30]));
  multiplier mult_inst8(.a(in_data_7), .b(kernel_7), .p(conv_sum[29:15]));
  multiplier mult_inst9(.a(in_data_8), .b(kernel_8), .p(conv_sum[14:0]));

  parallel_adder_tree adder_inst(.a(conv_sum[14:0]), .b(conv_sum[29:15]), .c(conv_sum[44:30]), .d(conv_sum[59:45]), .e(conv_sum[74:60]), .f(conv_sum[89:75]), .g(conv_sum[104:90]), .h(conv_sum[119:105]), .i(conv_sum[134:120]), .sum(out_data), .clk(clk));
  
endmodule

module parallel_adder_tree (
    input [15:0] a,  // 9个8位数字输入
    input [15:0] b, 
    input [15:0] c,
    input [15:0] d,
    input [15:0] e,
    input [15:0] f,
    input [15:0] g,
    input [15:0] h,
    input [15:0] i,
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






