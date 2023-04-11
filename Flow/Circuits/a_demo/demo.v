

module parallel_adder_tree (
    input [11:0] a,  // 9个8位数字输入
    input [11:0] b,
    input clk,
    output reg [17:0] sum // 结果
);

assign sum = a+b;

endmodule






