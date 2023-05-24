module maxpool33 #(parameter BIT_WIDTH = 32) (
	input clk, //rst,
	input en,	// whether to latch or not
	input signed[BIT_WIDTH-1:0] in1, in2, in3,
	output signed[BIT_WIDTH-1:0] maxOut
);

parameter SIZE = 3;	// 2x2 max pool

reg signed[BIT_WIDTH-1:0] row1[0:1];	// 1st row of layer
reg signed[BIT_WIDTH-1:0] row2[0:1];	// 2nd row of layer
reg signed[BIT_WIDTH-1:0] row3[0:1];	// 3rd row of layer
integer i;

always @ (posedge clk) begin
	if (en) begin
		for (i = SIZE-1; i > 0; i = i-1) begin
			row1[i] <= row1[i-1];
			row2[i] <= row2[i-1];
			row3[i] <= row3[i-1];
		end
		row1[0] <= in1;
		row2[0] <= in2;
		row3[0] <= in3;
	end
end

// find max
wire signed[BIT_WIDTH-1:0] tmpR1, tmpR2, tmpR3, tmp4;
wire signed[BIT_WIDTH-1:0] maxR1, maxR2, maxR3;
max #(.BIT_WIDTH(BIT_WIDTH)) M1 (
	.in1(row1[0]), .in2(row1[1]),
	.max(tmpR1)
);

max #(.BIT_WIDTH(BIT_WIDTH)) M2 (
	.in1(tmpR1), .in2(row1[2]),
	.max(maxR1)
);


max #(.BIT_WIDTH(BIT_WIDTH)) M3 (
	.in1(row2[0]), .in2(row2[1]),
	.max(tmpR2)
);

max #(.BIT_WIDTH(BIT_WIDTH)) M4 (
	.in1(tmpR2), .in2(row2[2]),
	.max(maxR2)
);


max #(.BIT_WIDTH(BIT_WIDTH)) M5 (
	.in1(row3[0]), .in2(row3[1]),
	.max(tmpR3)
);

max #(.BIT_WIDTH(BIT_WIDTH)) M6 (
	.in1(tmpR3), .in2(row3[2]),
	.max(maxR3)
);


max #(.BIT_WIDTH(BIT_WIDTH)) M7 (
	.in1(maxR1), .in2(maxR2),
	.max(tmp4)
);

max #(.BIT_WIDTH(BIT_WIDTH)) M8 (
	.in1(tmp4), .in2(maxR3),
	.max(maxOut)
);

endmodule