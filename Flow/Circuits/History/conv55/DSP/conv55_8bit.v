module conv5x5 (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24, // 输入数据
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8, input [7:0] kernel_9, input [7:0] kernel_10, input [7:0] kernel_11, input [7:0] kernel_12, input [7:0] kernel_13, input [7:0] kernel_14, input [7:0] kernel_15, input [7:0] kernel_16, input [7:0] kernel_17, input [7:0] kernel_18, input [7:0] kernel_19, input [7:0] kernel_20, input [7:0] kernel_21, input [7:0] kernel_22, input [7:0] kernel_23, input [7:0] kernel_24,// 卷积核
  input clk,
  output reg [17:0] out_data // 输出数据
);  


  parallel_adder_tree adder_tree_inst(.a({in_data_0*kernel_0, in_data_1*kernel_1, in_data_2*kernel_2, in_data_3*kernel_3, in_data_4*kernel_4, in_data_5*kernel_5, in_data_6*kernel_6, in_data_7*kernel_7, in_data_8*kernel_8, in_data_9*kernel_9, in_data_10*kernel_10, in_data_11*kernel_11, in_data_12*kernel_12, in_data_13*kernel_13, in_data_14*kernel_14, in_data_15*kernel_15, in_data_16*kernel_16, in_data_17*kernel_17, in_data_18*kernel_18, in_data_19*kernel_19, in_data_20*kernel_20, in_data_21*kernel_21, in_data_22*kernel_22, in_data_23*kernel_23, in_data_24*kernel_24} ), .clk(clk), .sum(out_data));

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



