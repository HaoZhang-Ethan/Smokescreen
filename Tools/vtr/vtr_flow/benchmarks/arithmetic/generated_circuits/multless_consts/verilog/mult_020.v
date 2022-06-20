/*------------------------------------------------------------------------------
 * This code was generated by Spiral Multiplier Block Generator, www.spiral.net
 * Copyright (c) 2006, Carnegie Mellon University
 * All rights reserved.
 * The code is distributed under a BSD style license
 * (see http://www.opensource.org/licenses/bsd-license.php)
 *------------------------------------------------------------------------------ */
/* ./multBlockGen.pl 16054 -fractionalBits 0*/
module multiplier_block (
    i_data0,
    o_data0
);

  // Port mode declarations:
  input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  //Multipliers:

  wire [31:0]
    w1,
    w4,
    w5,
    w8192,
    w8187,
    w160,
    w8027,
    w16054;

  assign w1 = i_data0;
  assign w160 = w5 << 5;
  assign w16054 = w8027 << 1;
  assign w4 = w1 << 2;
  assign w5 = w1 + w4;
  assign w8027 = w8187 - w160;
  assign w8187 = w8192 - w5;
  assign w8192 = w1 << 13;

  assign o_data0 = w16054;

  //multiplier_block area estimate = 5272.34396680147;
endmodule //multiplier_block

module surround_with_regs(
	i_data0,
	o_data0,
	clk
);

	// Port mode declarations:
	input   [31:0] i_data0;
	output  [31:0] o_data0;
	reg  [31:0] o_data0;
	input clk;

	reg [31:0] i_data0_reg;
	wire [30:0] o_data0_from_mult;

	always @(posedge clk) begin
		i_data0_reg <= i_data0;
		o_data0 <= o_data0_from_mult;
	end

	multiplier_block mult_blk(
		.i_data0(i_data0_reg),
		.o_data0(o_data0_from_mult)
	);

endmodule
