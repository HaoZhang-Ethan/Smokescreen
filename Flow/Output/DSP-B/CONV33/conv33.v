module conv55 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 8) (
		input clk, //rst,
		input en,	// whether to latch or not
		input signed[BIT_WIDTH*3-1:0] in1, in2, in3,
		input signed[(BIT_WIDTH*9)-1:0] filter,	// 5x5 filter
		//input [BIT_WIDTH-1:0] bias,
		output signed[OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);

reg signed [BIT_WIDTH-1:0] rows[0:2][0:2];
integer i;

always @ (posedge clk) begin
	if (en) begin
		for (i = 4; i > 0; i = i-1) begin
			rows[0][i] <= rows[0][i-1];
			rows[1][i] <= rows[1][i-1];
			rows[2][i] <= rows[2][i-1];
		end
		rows[0][0] <= in1;
		rows[1][0] <= in2;
		rows[2][0] <= in3;
	end
end

// multiply & accumulate in 1 clock cycle
wire signed[OUT_WIDTH-1:0] mult33[0:8];
genvar x, y;

// multiplication
generate
	for (x = 0; x < 3; x = x+1) begin : sum_rows	// each row
		for (y = 0; y < 3; y = y+1) begin : sum_columns	// each item in a row
			assign mult33[3*x+y] = rows[x][2-y] * filter[BIT_WIDTH*(3*x+y+1)-1 : BIT_WIDTH*(3*x+y)];
		end
	end
endgenerate

// adder tree
wire signed[OUT_WIDTH-1:0] sums[0:6];	// 25-2 intermediate sums
generate
	for (x = 0; x < 4; x = x+1) begin : addertree_nodes0
		qadd news(mult33[x*2],mult33[x*2+1],sums[x]);
	end
	for (x = 0; x < 2; x = x+1) begin : addertree_nodes1
		qadd news1(sums[x*2], sums[x*2+1], sums[x+4]);
	end
	qadd news3(sums[4], sums[5], sums[6]);
endgenerate

qadd new(sums[6],mult33[8],convValue);


endmodule

