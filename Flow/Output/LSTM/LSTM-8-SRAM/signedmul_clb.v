
module signedmul_clb(
  input clk,
  input [15:0] a,
  input [15:0] b,
  output [15:0] c
);

wire [31:0] result;
wire [15:0] a_new;
wire [15:0] b_new;

wire [7:0] a_ff;
wire [7:0] b_ff;
wire [31:0] result_ff;
wire a_sign,b_sign,a_sign_ff,b_sign_ff;

assign c = (b_sign_ff==a_sign_ff)?result_ff[26:12]:(~result_ff[26:12]+1'b1);
assign a_new = a[15]?(~a + 1'b1):a;
assign b_new = b[15]?(~b + 1'b1):b;
multiplier mult1(.a(a_ff),.b(b_ff),.p(result));
// assign result = a_ff*b_ff;

// always@(posedge clk) begin
assign	a_ff = a_new;
assign	b_ff = b_new; 

assign	a_sign = a[15];
assign	b_sign = b[15];
assign	a_sign_ff = a_sign;
assign	b_sign_ff = b_sign;
assign    result_ff = result;
    
// end
endmodule


