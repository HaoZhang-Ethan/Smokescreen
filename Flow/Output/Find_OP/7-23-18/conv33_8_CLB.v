module multiplier338 (input [7:0] a, b, output [15:0] p);
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

module conv33_8_CLB (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, // 输入数据
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8,  // 卷积核
  input clk,
  output [17:0] out_data // 输出数据
);  

  wire [143:0] conv_sum;



  multiplier338 mult_inst1(.a(in_data_0), .b(kernel_0), .p(conv_sum[15:0]));
  multiplier338 mult_inst2(.a(in_data_1), .b(kernel_1), .p(conv_sum[31:16]));
  multiplier338 mult_inst3(.a(in_data_2), .b(kernel_2), .p(conv_sum[47:32]));
  multiplier338 mult_inst4(.a(in_data_3), .b(kernel_3), .p(conv_sum[63:48]));
  multiplier338 mult_inst5(.a(in_data_4), .b(kernel_4), .p(conv_sum[79:64]));
  multiplier338 mult_inst6(.a(in_data_5), .b(kernel_5), .p(conv_sum[95:80]));
  multiplier338 mult_inst7(.a(in_data_6), .b(kernel_6), .p(conv_sum[111:96]));
  multiplier338 mult_inst8(.a(in_data_7), .b(kernel_7), .p(conv_sum[127:112]));
  multiplier338 mult_inst9(.a(in_data_8), .b(kernel_8), .p(conv_sum[143:128]));




  parallel_adder_tree_clb_33 adder_tree_inst(.a(conv_sum), .clk(clk), .sum(out_data));


endmodule

module parallel_adder_tree_clb_33 (
    input [143:0] a,  // 25个16位数字输入
    input clk,
    output [17:0] sum // 结果
);

wire [17:0] c1[24:0], c2[6:0], c3[3:0], c4[2:0]; // 中间电路
assign c1[0] = a[15:0] + a[31:16];
assign c1[1] = a[47:32] + a[63:48];
assign c1[2] = a[79:64] + a[95:80];
assign c1[3] = a[111:96] + a[127:112];
// assign c1[4] = a[143:128]

assign c2[0] = c1[0] + c1[1];
assign c2[1] = c1[2] + c1[3];


assign c3[0] = c2[0] + c2[1];


assign sum = c3[0] + a[143:128];


// assign sum = c4[0] + c4[1];


endmodule




