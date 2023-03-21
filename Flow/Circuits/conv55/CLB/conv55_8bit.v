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

module conv5x5 (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24, // 输入数据
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8, input [7:0] kernel_9, input [7:0] kernel_10, input [7:0] kernel_11, input [7:0] kernel_12, input [7:0] kernel_13, input [7:0] kernel_14, input [7:0] kernel_15, input [7:0] kernel_16, input [7:0] kernel_17, input [7:0] kernel_18, input [7:0] kernel_19, input [7:0] kernel_20, input [7:0] kernel_21, input [7:0] kernel_22, input [7:0] kernel_23, input [7:0] kernel_24,// 卷积核
  input clk,
  output reg [17:0] out_data // 输出数据
);  

  wire [399:0] conv_sum;


  multiplier mult_inst25(.a(in_data_24), .b(kernel_24), .p(conv_sum[15:0]));
  multiplier mult_inst24(.a(in_data_23), .b(kernel_23), .p(conv_sum[31:16]));
  multiplier mult_inst23(.a(in_data_22), .b(kernel_22), .p(conv_sum[47:32]));
  multiplier mult_inst22(.a(in_data_21), .b(kernel_21), .p(conv_sum[63:48]));
  multiplier mult_inst21(.a(in_data_20), .b(kernel_20), .p(conv_sum[79:64]));
  multiplier mult_inst20(.a(in_data_19), .b(kernel_19), .p(conv_sum[95:80]));
  multiplier mult_inst19(.a(in_data_18), .b(kernel_18), .p(conv_sum[111:96]));
  multiplier mult_inst18(.a(in_data_17), .b(kernel_17), .p(conv_sum[127:112]));
  multiplier mult_inst17(.a(in_data_16), .b(kernel_16), .p(conv_sum[143:128]));
  multiplier mult_inst16(.a(in_data_15), .b(kernel_15), .p(conv_sum[159:144]));
  multiplier mult_inst15(.a(in_data_14), .b(kernel_14), .p(conv_sum[175:160]));
  multiplier mult_inst14(.a(in_data_13), .b(kernel_13), .p(conv_sum[191:176]));
  multiplier mult_inst13(.a(in_data_12), .b(kernel_12), .p(conv_sum[207:192]));
  multiplier mult_inst12(.a(in_data_11), .b(kernel_11), .p(conv_sum[223:208]));
  multiplier mult_inst11(.a(in_data_10), .b(kernel_10), .p(conv_sum[239:224])); 
  multiplier mult_inst10(.a(in_data_9), .b(kernel_9), .p(conv_sum[255:240]));
  multiplier mult_inst9(.a(in_data_8), .b(kernel_8), .p(conv_sum[271:256]));
  multiplier mult_inst8(.a(in_data_7), .b(kernel_7), .p(conv_sum[287:272]));
  multiplier mult_inst7(.a(in_data_6), .b(kernel_6), .p(conv_sum[303:288]));
  multiplier mult_inst6(.a(in_data_5), .b(kernel_5), .p(conv_sum[319:304]));
  multiplier mult_inst5(.a(in_data_4), .b(kernel_4), .p(conv_sum[335:320]));
  multiplier mult_inst4(.a(in_data_3), .b(kernel_3), .p(conv_sum[351:336]));
  multiplier mult_inst3(.a(in_data_2), .b(kernel_2), .p(conv_sum[367:352]));
  multiplier mult_inst2(.a(in_data_1), .b(kernel_1), .p(conv_sum[383:368]));
  multiplier mult_inst1(.a(in_data_0), .b(kernel_0), .p(conv_sum[399:384]));

  parallel_adder_tree adder_tree_inst(.a(conv_sum), .clk(clk), .sum(out_data));


endmodule

module parallel_adder_tree (
    input [399:0] a,  // 25个16位数字输入
    input clk,
    output reg [17:0] sum // 结果
);

wire [17:0] c1[24:0], c2[6:0], c3[3:0], c4[2:0]; // 中间电路
assign c1[0] = a[15:0] + a[31:16];
assign c1[1] = a[47:32] + a[63:48];
assign c1[2] = a[79:64] + a[95:80];
assign c1[3] = a[111:96] + a[127:112];
assign c1[4] = a[143:128] + a[159:144];
assign c1[5] = a[175:160] + a[191:176];
assign c1[6] = a[207:192] + a[223:208];
assign c1[7] = a[239:224] + a[255:240];
assign c1[8] = a[271:256] + a[287:272];
assign c1[9] = a[303:288] + a[319:304];
assign c1[10] = a[335:320] + a[351:336];
assign c1[11] = a[367:352] + a[383:368];
assign c1[12] = a[399:384];

assign c2[0] = c1[0] + c1[1];
assign c2[1] = c1[2] + c1[3];
assign c2[2] = c1[4] + c1[5];
assign c2[3] = c1[6] + c1[7];
assign c2[4] = c1[8] + c1[9];
assign c2[5] = c1[10] + c1[11];
assign c2[6] = c1[12];

assign c3[0] = c2[0] + c2[1];
assign c3[1] = c2[2] + c2[3];
assign c3[2] = c2[4] + c2[5];
assign c3[3] = c2[6];

assign c4[0] = c3[0] + c3[1];
assign c4[1] = c3[2] + c3[3];



always @(posedge clk) begin
    sum <= c4[0] + c4[1];
end

endmodule





