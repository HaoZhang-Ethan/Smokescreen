/*/------------------ SOME MOUDLE  ------------------/*/
module rom_params_bram #(parameter BIT_WIDTH = 8, SIZE = 26) (
	input clk,
    input [clogb2(SIZE)-1:0] addr,
	output [BIT_WIDTH*SIZE-1:0] out
);
    defparam weight_single_port_ram.ADDR_WIDTH = clogb2(SIZE);
    defparam weight_single_port_ram.DATA_WIDTH = BIT_WIDTH*SIZE;
    single_port_ram weight_single_port_ram(
    .addr(addr),
    .we(1'b0),
    .data(BIT_WIDTH*SIZE'b0),
    .out(out),
    .clk(clk)
    );
endmodule