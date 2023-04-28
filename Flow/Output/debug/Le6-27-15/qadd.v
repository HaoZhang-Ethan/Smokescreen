module qadd #(parameter BIT_WIDTH = 8, OUT_WIDTH = 32)(a,b,c);
input [BIT_WIDTH-1:0] a;
input [BIT_WIDTH-1:0] b;
output [BIT_WIDTH-1:0] c;

assign c = a + b;
//DW01_add #(`DWIDTH) u_add(.A(a), .B(b), .CI(1'b0), .SUM(c), .CO());
endmodule