module conv11_6bit_BLK (
  input [5:0] in_data_0, // 输入数据
  input [5:0] kernel_0, // 卷积核
  input clk,
  output [11:0] out_data // 输出数据
);  

assign out_data = in_data_0 |  kernel_0 ;
  
endmodule
