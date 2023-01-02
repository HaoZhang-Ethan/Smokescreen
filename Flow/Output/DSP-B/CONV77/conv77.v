module conv55 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 8) (
		input clk, //rst,
		input en,	// whether to latch or not
		input signed[BIT_WIDTH*7-1:0] in1, in2, in3, in4, in5, in6, in7,
		input signed[(BIT_WIDTH*49)-1:0] filter,	// 5x5 filter
		//input [BIT_WIDTH-1:0] bias,
		output signed[OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);

reg signed [BIT_WIDTH-1:0] rows[0:6][0:6];
integer i;

always @ (posedge clk) begin
	if (en) begin
		for (i = 6; i > 0; i = i-1) begin
			rows[0][i] <= rows[0][i-1];
			rows[1][i] <= rows[1][i-1];
			rows[2][i] <= rows[2][i-1];
			rows[3][i] <= rows[3][i-1];
			rows[4][i] <= rows[4][i-1];
			rows[5][i] <= rows[5][i-1];
			rows[6][i] <= rows[6][i-1];
		end
		rows[0][0] <= in1;
		rows[1][0] <= in2;
		rows[2][0] <= in3;
		rows[3][0] <= in4;
		rows[4][0] <= in5;
		rows[5][0] <= in6;
		rows[6][0] <= in7;
	end
end

// multiply & accumulate in 1 clock cycle
wire signed[OUT_WIDTH-1:0] mult77[0:49];
genvar x, y;

// multiplication
generate
	for (x = 0; x < 7; x = x+1) begin : sum_rows	// each row
		for (y = 0; y < 7; y = y+1) begin : sum_columns	// each item in a row
			assign mult77[7*x+y] = rows[x][6-y] * filter[BIT_WIDTH*(7*x+y+1)-1 : BIT_WIDTH*(7*x+y)];
		end
	end
endgenerate

// adder tree
wire signed[OUT_WIDTH-1:0] sums[0:49];	// 25-2 intermediate sums
generate
	for (x = 0; x < 24; x = x+1) begin : addertree_nodes0
		qadd news0(mult77[x*2], mult77[x*2+1], sums[x]);
	end
	for (x = 0; x < 12; x = x+1) begin : addertree_nodes1
		qadd news1(sums[x*2], sums[x*2+1], sums[x+25]);
	end
	for (x = 0; x < 6; x = x+1) begin : addertree_nodes2
		qadd news2(sums[x*2+25], sums[x*2+1+25], sums[x+37]);
	end
	for (x = 0; x < 3; x = x+1) begin : addertree_nodes3
		qadd news3(sums[x*2+37], sums[x*2+1+37], sums[x+43]);
	end

endgenerate

	qadd news4(sums[43], sums[44], sums[46]);
	qadd news5(mult77[48], sums[45], sums[47]);
	qadd news6(sums[46], sums[47], convValue);


endmodule

