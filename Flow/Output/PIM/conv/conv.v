



// Parameter:
// CROSS_SIZE, crossbar size (number of input ports) (default: 64), we use 64 for 64x64 crossbar
// MAP_WIDTH, the column of crossbar we used (default: 6), we use log(64) for 64x64 crossbar
// ADC_P, ADC precision, we use 8 bits ADC
module conv #(parameter CROSS_SIZE = 64, DEPTH = 6, ADC_P = 8) (
	input clk, 
	input rst,
	input en,	// enable
	input [CROSS_SIZE-1:0] input_feature,
	input [DEPTH-1:0] address,
	output [ADC_P-1:0] Output	// size should increase to hold the sum of products
	);
	wire [CROSS_SIZE-1:0] input_pim;
	wire [CROSS_SIZE-1:0] address_pim;
	wire [ADC_P-1:0] resout;
	assign input_pim = input_feature;
	assign address_pim = address;
	bram_pim single_pim(
		.data(input_pim),
		.addr(address_pim),
		.we(en),
		.out(resout),
		.clk(clk)
	);
	assign Output = resout;

endmodule