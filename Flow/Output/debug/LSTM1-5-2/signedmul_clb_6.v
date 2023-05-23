
module signedmul_clb_6(
  input clk,
  input [15:0] a,
  input [15:0] b,
  output [15:0] c
);

wire [31:0] result;
wire [15:0] a_new;
wire [15:0] b_new;

wire [5:0] a_ff;
wire [5:0] b_ff;
wire [31:0] result_ff;
wire a_sign,b_sign,a_sign_ff,b_sign_ff;

assign c = (b_sign_ff==a_sign_ff)?result_ff[26:12]:(~result_ff[26:12]+1'b1);
assign a_new = a[15]?(~a + 1'b1):a;
assign b_new = b[15]?(~b + 1'b1):b;
multiplier_6 mult1(.a(a_ff),.b(b_ff),.p(result));
// assign result = a_ff*b_ff;

// always@(posedge clk) begin
assign	a_ff = a_new[5:0];
assign	b_ff = b_new[5:0]; 

assign	a_sign = a[15];
assign	b_sign = b[15];
assign	a_sign_ff = a_sign;
assign	b_sign_ff = b_sign;
assign    result_ff = result;
    
// end
endmodule



module multiplier_6(input [5:0] a, b, output [11:0] p);
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

