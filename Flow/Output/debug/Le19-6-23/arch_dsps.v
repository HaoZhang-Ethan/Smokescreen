/*********************************************************************************************************/
/*                                                                                                       */
/*   This is a machine-generated Verilog code, including the black box declaration of                    */
/*   complex blocks defined in the following architecture file:                                          */
/*                                                                                                       */
/*             k6FracN10LB_mem20K_complexDSP_customSB_22nm_pim_ald_n.xml                                 */
/*                                                                                                       */
/*********************************************************************************************************/

module fp32_mult_then_add(
	input	[31:0]	chainin,
	input	[31:0]	fp32_in,
	input	[31:0]	b,
	input	[31:0]	a,
	input	[10:0]	mode_sigs,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[31:0]	chainout,
	output	[31:0]	result,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module fp32_mult_add(
	input	[31:0]	chainin,
	input	[31:0]	fp32_in,
	input	[31:0]	b,
	input	[31:0]	a,
	input	[10:0]	mode_sigs,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[31:0]	chainout,
	output	[31:0]	result,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module fp16_mult_fp32_accum(
	input	[31:0]	fp32_in,
	input	[15:0]	bot_b,
	input	[15:0]	bot_a,
	input	[15:0]	top_b,
	input	[15:0]	top_a,
	input	[10:0]	mode_sigs,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[31:0]	chainout,
	output	[31:0]	result,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module fp16_mult_fp32_add(
	input	[31:0]	chainin,
	input	[31:0]	fp32_in,
	input	[15:0]	bot_b,
	input	[15:0]	bot_a,
	input	[15:0]	top_b,
	input	[15:0]	top_a,
	input	[10:0]	mode_sigs,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[31:0]	chainout,
	output	[31:0]	result,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module fp16_sop2_accum(
	input	[15:0]	bot_b,
	input	[15:0]	bot_a,
	input	[15:0]	top_b,
	input	[15:0]	top_a,
	input	[0:0]	reset,
	input	[10:0]	mode_sigs,
	input	[0:0]	clk,
	output	[31:0]	chainout,
	output	[31:0]	result,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module fp16_sop2_mult(
	input	[31:0]	chainin,
	input	[31:0]	fp32_in,
	input	[15:0]	bot_b,
	input	[15:0]	bot_a,
	input	[15:0]	top_b,
	input	[15:0]	top_a,
	input	[10:0]	mode_sigs,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[31:0]	chainout,
	output	[31:0]	result,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module fp16_mult_add(
	input	[31:0]	fp32_in,
	input	[15:0]	bot_b,
	input	[15:0]	bot_a,
	input	[15:0]	top_b,
	input	[15:0]	top_a,
	input	[10:0]	mode_sigs,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[31:0]	chainout,
	output	[31:0]	result,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module mac_int(
	input	[26:0]	b,
	input	[26:0]	a,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[53:0]	out,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module mac_fp(
	input	[31:0]	b,
	input	[31:0]	a,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[31:0]	out,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module int_sop_accum_4(
	input	[63:0]	chainin,
	input	[8:0]	dy,
	input	[8:0]	dx,
	input	[8:0]	cy,
	input	[8:0]	cx,
	input	[8:0]	by,
	input	[8:0]	bx,
	input	[8:0]	ay,
	input	[8:0]	ax,
	input	[10:0]	mode_sigs,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[63:0]	chainout,
	output	[63:0]	resulta,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module int_sop_4(
	input	[63:0]	chainin,
	input	[8:0]	dy,
	input	[8:0]	dx,
	input	[8:0]	cy,
	input	[8:0]	cx,
	input	[8:0]	by,
	input	[8:0]	bx,
	input	[8:0]	ay,
	input	[8:0]	ax,
	input	[10:0]	mode_sigs,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[63:0]	chainout,
	output	[63:0]	resulta,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module mult_add_int(
	input	[63:0]	chainin,
	input	[35:0]	bx,
	input	[26:0]	ay,
	input	[26:0]	ax,
	input	[10:0]	mode_sigs,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[63:0]	chainout,
	output	[63:0]	resulta,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module int_sop_2(
	input	[36:0]	chainin,
	input	[18:0]	by,
	input	[17:0]	bx,
	input	[18:0]	ay,
	input	[17:0]	ax,
	input	[10:0]	mode_sigs,
	input	[0:0]	reset,
	input	[0:0]	clk,
	output	[36:0]	chainout,
	output	[36:0]	resulta,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module adder_fp_clk(
	input	[31:0]	b,
	input	[31:0]	a,
	input	[0:0]	clk,
	output	[31:0]	out,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module adder_fp(
	input	[31:0]	b,
	input	[31:0]	a,
	output	[31:0]	out,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module multiply_fp_clk(
	input	[31:0]	b,
	input	[31:0]	a,
	input	[0:0]	clk,
	output	[31:0]	out,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module multiply_fp(
	input	[31:0]	b,
	input	[31:0]	a,
	output	[31:0]	out,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

module bram_pim(
	input	[0:0]	clk,
	input	[95:0]	data,
	input	[8:0]	addr,
	input	[0:0]	we,
	output	[7:0]	out,
);
/* the body of the complex block module is empty since it should be seen as a black box */
endmodule

