module conv55_input_reg #(parameter BIT_WIDTH = 8, OUT_WIDTH = 32) (
		input clk, //rst,
		input en,	// whether to latch or not
		input [BIT_WIDTH*5-1:0] in1, in2, in3, in4, in5,
		output [BIT_WIDTH*25-1:0] res	// size should increase to hold the sum of products
);

reg [BIT_WIDTH-1:0] rows[0:4][0:4];
integer i;
always @ (posedge clk) begin
	if (en) begin
		for (i = 4; i > 0; i = i-1) begin
			rows[0][i] <= rows[0][i-1];
			rows[1][i] <= rows[1][i-1];
			rows[2][i] <= rows[2][i-1];
			rows[3][i] <= rows[3][i-1];
			rows[4][i] <= rows[4][i-1];
		end
		rows[0][0] <= in1;
		rows[1][0] <= in2;
		rows[2][0] <= in3;
		rows[3][0] <= in4;
		rows[4][0] <= in5;
	end
end

assign res = {rows[0][4], rows[1][4], rows[2][4], rows[3][4], rows[4][4],
					rows[0][3], rows[1][3], rows[2][3], rows[3][3], rows[4][3],
					rows[0][2], rows[1][2], rows[2][2], rows[3][2], rows[4][2],
					rows[0][1], rows[1][1], rows[2][1], rows[3][1], rows[4][1],
					rows[0][0], rows[1][0], rows[2][0], rows[3][0], rows[4][0]};


endmodule

