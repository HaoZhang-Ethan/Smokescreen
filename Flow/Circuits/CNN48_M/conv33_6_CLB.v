module multiplier336 (input [5:0] a, b, output [11:0] p);
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


module conv33_6_CLB (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8,  // 输入数据
  input [5:0] kernel_0, input [5:0] kernel_1, input [5:0] kernel_2, input [5:0] kernel_3, input [5:0] kernel_4, input [5:0] kernel_5, input [5:0] kernel_6, input [5:0] kernel_7, input [5:0] kernel_8, input [5:0] kernel_9, // 卷积核
  input clk,
  output [17:0] out_data // 输出数据
);  

  wire [107:0] conv_sum;



  multiplier336 mult_inst1(.a(in_data_0), .b(kernel_0), .p(conv_sum[11:0]));
  multiplier336 mult_inst2(.a(in_data_1), .b(kernel_1), .p(conv_sum[23:12]));
  multiplier336 mult_inst3(.a(in_data_2), .b(kernel_2), .p(conv_sum[35:24]));
  multiplier336 mult_inst4(.a(in_data_3), .b(kernel_3), .p(conv_sum[47:36]));
  multiplier336 mult_inst5(.a(in_data_4), .b(kernel_4), .p(conv_sum[59:48]));
  multiplier336 mult_inst6(.a(in_data_5), .b(kernel_5), .p(conv_sum[71:60]));
  multiplier336 mult_inst7(.a(in_data_6), .b(kernel_6), .p(conv_sum[83:72]));
  multiplier336 mult_inst8(.a(in_data_7), .b(kernel_7), .p(conv_sum[95:84]));
  multiplier336 mult_inst9(.a(in_data_8), .b(kernel_8), .p(conv_sum[107:96]));


  wire [15:0] c1[4:0], c2[6:0], c3[3:0], c4[2:0]; // 中间电路
  qadd_33 add_inst1(.a(conv_sum[23:12]), .b(conv_sum[11:0]), .c(c1[0]));
  qadd_33 add_inst2(.a(conv_sum[47:36]), .b(conv_sum[35:24]), .c(c1[1]));
  qadd_33 add_inst3(.a(conv_sum[71:60]), .b(conv_sum[59:48]), .c(c1[2]));
  qadd_33 add_inst4(.a(conv_sum[95:84]), .b(conv_sum[83:72]), .c(c1[3]));
  // qadd_33 add_inst5(.a(conv_sum[107:96]), .b(conv_sum[95:84]), .c(c1[4]));

  qadd_33 add_inst6(.a(c1[0]), .b(c1[1]), .c(c2[0]));
  qadd_33 add_inst7(.a(c1[2]), .b(c1[3]), .c(c2[1]));

  qadd_33 add_inst8(.a(c2[0]), .b(c2[1]), .c(c3[0]));

  qadd_33 add_inst9(.a(c3[0]), .b(conv_sum[107:96]), .c(out_data));


endmodule



module qadd_33(
 input [15:0] a,
 input [15:0] b,
 output [15:0] c
    );
    
assign c = a + b;


endmodule


