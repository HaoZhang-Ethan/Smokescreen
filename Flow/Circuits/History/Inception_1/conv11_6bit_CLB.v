module multiplier_11(input [5:0] a, b, output [11:0] p);
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


module conv11_6bit_CLB (
  input [5:0] in_data_0, // 输入数据
  input [5:0] kernel_0,  // 卷积核
  input clk,
  output [11:0] out_data // 输出数据
);  



  multiplier_11 mult_inst1(.a(in_data_0), .b(kernel_0), .p(out_data));



endmodule






