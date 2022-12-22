function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction
/*/------------------ SOME MOUDLE  ------------------/*/
module rom_params_bram #(parameter BIT_WIDTH = 8, SIZE = 26) (
	input clk,
    input read,
    // input [clogb2(SIZE)-1:0] addr,
	output [BIT_WIDTH*SIZE-1:0] out
);


	reg done_flag;
	reg [clogb2(SIZE)-1:0] add_counter;
	always @ (posedge clk) begin
		if (!rst) begin
			add_counter <= 0;
			done_flag <= 1'b0;
		end else if (add_counter > SIZE) begin
			add_counter <= 0;
			done_flag <= 1'b1;
		end else if (add_counter < SIZE) begin
			add_counter <= add_counter + 1'b1;
		end
	end


    defparam weight_single_port_ram.ADDR_WIDTH = clogb2(SIZE);
    defparam weight_single_port_ram.DATA_WIDTH = BIT_WIDTH*SIZE;
    single_port_ram weight_single_port_ram(
    .addr(add_counter),
    .we(!read),
    .data(BIT_WIDTH*SIZE),
    .out(out),
    .clk(clk)
    );
endmodule