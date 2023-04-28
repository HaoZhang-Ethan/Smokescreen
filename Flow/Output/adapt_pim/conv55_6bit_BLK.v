module conv55_6bit_BLK (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8, input [5:0] in_data_9, input [5:0] in_data_10, input [5:0] in_data_11, input [5:0] in_data_12, input [5:0] in_data_13, input [5:0] in_data_14, input [5:0] in_data_15, input [5:0] in_data_16, input [5:0] in_data_17, input [5:0] in_data_18, input [5:0] in_data_19, input [5:0] in_data_20, input [5:0] in_data_21, input [5:0] in_data_22, input [5:0] in_data_23, input [5:0] in_data_24, // 输入数据
  input [5:0] kernel_0, input [5:0] kernel_1, input [5:0] kernel_2, input [5:0] kernel_3, input [5:0] kernel_4, input [5:0] kernel_5, input [5:0] kernel_6, input [5:0] kernel_7, input [5:0] kernel_8, input [5:0] kernel_9, input [5:0] kernel_10, input [5:0] kernel_11, input [5:0] kernel_12, input [5:0] kernel_13, input [5:0] kernel_14, input [5:0] kernel_15, input [5:0] kernel_16, input [5:0] kernel_17, input [5:0] kernel_18, input [5:0] kernel_19, input [5:0] kernel_20, input [5:0] kernel_21, input [5:0] kernel_22, input [5:0] kernel_23, input [5:0] kernel_24,// 卷积核
  input clk,
  output [17:0] out_data // 输出数据
);  

assign out_data = in_data_0 |  in_data_1 |  in_data_2 |  in_data_3 |  in_data_4 |  in_data_5 |  in_data_6 |  in_data_7 |  in_data_8 |  in_data_9 |  in_data_10 |  in_data_11 |  in_data_12 |  in_data_13 |  in_data_14 |  in_data_15 |  in_data_16 |  in_data_17 |  in_data_18 |  in_data_19 |  in_data_20 |  in_data_21 |  in_data_22 |  in_data_23 |  in_data_24 |  kernel_0 |  kernel_1 |  kernel_2 |  kernel_3 |  kernel_4 |  kernel_5 |  kernel_6 |  kernel_7 |  kernel_8 |  kernel_9 |  kernel_10 |  kernel_11 |  kernel_12 |  kernel_13 |  kernel_14 |  kernel_15 |  kernel_16 |  kernel_17 |  kernel_18 |  kernel_19 |  kernel_20 |  kernel_21 |  kernel_22 |  kernel_23 |  kernel_24;
  
endmodule
