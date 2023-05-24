function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction

`define MAX_SIZE 128
module pim_conv_line_s #(parameter SIZE = 128, DEPTH = 32) (
	input clk, rst,
	input en,	// enable
	input [SIZE-1:0] input_feature,
	input [clogb2(DEPTH)-1:0] address,
	output [8:0] convValue	// size should increase to hold the sum of products
	);

	if (SIZE > `MAX_SIZE) begin
		wire signed[8:0] tmp_out_1;
		wire signed[8:0] tmp_out_2; 
		pim_conv_line_s #(.SIZE(SIZE/2),.DEPTH(DEPTH)) pim_conv_line_s_inst(
			.clk(clk),
			.rst(rst),
			.en(en),
			.input_feature(input_feature[SIZE-1:SIZE/2]),
			.address(address),
			.convValue(tmp_out_1) 
		);
		pim_conv_line_s #(.SIZE(SIZE/2),.DEPTH(DEPTH)) pim_conv_line_s_inst2(
			.clk(clk),
			.rst(rst),
			.en(en),
			.input_feature(input_feature[SIZE/2-1:0]),
			.address(address),
			.convValue(tmp_out_2)
		);
		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst(
			.a(tmp_out_1),
			.b(tmp_out_2),
			.c(convValue)
		);
	end
	else begin
	// TODO: add the actual convolution logic here
		wire signed[8:0] out_1;
		wire signed[8:0] out_2; 
		bram_pim new_ram_H(
			.data(input_feature),
			.addr(address),
			.we(en),
			.out(out_1),
			.clk(clk)
		);

		bram_pim new_ram_L(
			.data(input_feature),
			.addr(address),
			.we(en),
			.out(out_2),
			.clk(clk)
		);
		qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst(
			.a(out_1),
			.b(out_2),
			.c(convValue)
		);
	end


endmodule