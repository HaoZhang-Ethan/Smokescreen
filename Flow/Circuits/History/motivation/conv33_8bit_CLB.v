module multiplier_33(input [7:0] a, b, output [15:0] p);
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


module conv33_8bit_CLB (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8,  // 输入数据
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8,   // 卷积核
  input clk,
  output [17:0] out_data // 输出数据
);  

  wire [143:0] conv_sum;




  multiplier_33 mult_inst1(.a(in_data_0), .b(kernel_0), .p(conv_sum[15:0]));
  multiplier_33 mult_inst2(.a(in_data_1), .b(kernel_1), .p(conv_sum[30:16]));
  multiplier_33 mult_inst3(.a(in_data_2), .b(kernel_2), .p(conv_sum[46:31]));
  multiplier_33 mult_inst4(.a(in_data_3), .b(kernel_3), .p(conv_sum[62:47]));
  multiplier_33 mult_inst5(.a(in_data_4), .b(kernel_4), .p(conv_sum[79:63]));
  multiplier_33 mult_inst6(.a(in_data_5), .b(kernel_5), .p(conv_sum[95:80]));
  multiplier_33 mult_inst7(.a(in_data_6), .b(kernel_6), .p(conv_sum[111:96]));
  multiplier_33 mult_inst8(.a(in_data_7), .b(kernel_7), .p(conv_sum[127:112]));
  multiplier_33 mult_inst9(.a(in_data_8), .b(kernel_8), .p(conv_sum[143:128]));



  


  parallel_adder_tree_clb_33 adder_tree_inst(.a(conv_sum[15:0]), .b(conv_sum[30:16]), .c(conv_sum[46:31]), .d(conv_sum[62:47]), .e(conv_sum[79:63]), .f(conv_sum[95:80]), .g(conv_sum[111:96]), .h(conv_sum[127:112]), .i(conv_sum[143:128]), .clk(clk), .sum(out_data));
  


endmodule


module parallel_adder_tree_clb_33 (
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

assign sum = c2[0] + c2[1] + c2[2];



endmodule





