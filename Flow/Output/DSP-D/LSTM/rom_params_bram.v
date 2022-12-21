/*/------------------ SOME MOUDLE  ------------------/*/
module rom_params_bram #(parameter BIT_WIDTH = 8, SIZE = 26) (
	input clk,
    input read,
    // input [clogb2(SIZE)-1:0] addr,
	output [BIT_WIDTH*SIZE-1:0] out
);
    defparam weight_single_port_ram.ADDR_WIDTH = clogb2(SIZE);
    defparam weight_single_port_ram.DATA_WIDTH = BIT_WIDTH*SIZE;

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

    single_port_ram weight_single_port_ram(
    .addr(add_counter),
    .we(!read),
    .data(BIT_WIDTH*SIZE'b0),
    .out(out),
    .clk(clk)
    );
endmodule