module conv33_8_BLK (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, // 输入数据
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8,  // 卷积核
  input clk,
  output [17:0] out_data // 输出数据
);  

assign out_data = in_data_0 | in_data_1 |  in_data_2 |  in_data_3 |  in_data_4 |  in_data_5 |  in_data_6 |  in_data_7 |  in_data_8 | kernel_0 |  kernel_1 |  kernel_2 |  kernel_3 |  kernel_4 |  kernel_5 |  kernel_6 |  kernel_7 |  kernel_8;

endmodule

