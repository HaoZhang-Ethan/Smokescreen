module lenet5 #(parameter IMAGE_COLS = 32, IN_WIDTH = 6, OUT_WIDTH = 18) (
	input clk, rst,
	input signed[IN_WIDTH-1:0] nextPixel,
	output [30:0] out,	// the predicted digit
	output [30:0] out1,	// the predicted digit
	output [30:0] out2,	// the predicted digit
	output [30:0] out3,
	output [30:0] out4,
	output [30:0] out5,
	output [30:0] out6,
	output [30:0] out7,
	output [30:0] outres
	// output signed[HALF_WIDTH-1:0] tmp_out
);

parameter HALF_WIDTH = 17;	// fixed-16 precision

parameter C1_SIZE = 28; //10;	//28;
parameter S2_SIZE = 14; //5;	//14;
parameter C3_SIZE = 10; //1;	//10;
parameter S4_SIZE = 5; //0; //5;
parameter F6_OUT = 84;
parameter LAST_OUT = 10;	// no. outputs

parameter C1_MAPS = 6;
parameter C3_MAPS = 16;
parameter C5_MAPS = 120;

parameter CONV_SIZE = 25;	// all convolutions are 5x5 filters, bias not counted
parameter CONV_SIZE_3 = 3*CONV_SIZE;	// no. params in 5x5x3 filters, bias not counted
parameter CONV_SIZE_4 = 4*CONV_SIZE;	// no. params in 5x5x4 filters, bias not counted
parameter CONV_SIZE_6 = 6*CONV_SIZE;	// no. params in 5x5x6 filters, bias not counted
parameter CONV_SIZE_16 = 16*CONV_SIZE;	// no. params in 5x5x6 filters, bias not counted

genvar g;

wire signed[IN_WIDTH-1:0] rb_out[0:3];	// store outputs of rowbuffer

// add next pixel to buffer for C1
row4buffer #(.COLS(IMAGE_COLS), .BIT_WIDTH(IN_WIDTH)) INPUT_RB (
	.clk(clk), .rst(rst),
	.rb_in(nextPixel),
	.en(1'b1),
	.rb_out0(rb_out[0]), .rb_out1(rb_out[1]), .rb_out2(rb_out[2]), .rb_out3(rb_out[3])
);

// generate control signals for row buffers for convolution/pooling layers
wire read;
wire S2_en, C3_en, S4_en, C5_en;
control #(.COLS(IMAGE_COLS)) CTRL (	.clk(clk),
	.read(read),
	.S2_en(S2_en), .C3_en(C3_en), .S4_en(S4_en), .C5_en(C5_en)
);

// C1: 6 feature maps; convolution, stride = 1
wire signed[HALF_WIDTH-1:0] C1_convOut[0:C1_MAPS-1];	// outputs of convolution from layer C1
wire signed[HALF_WIDTH-1:0] C1_convPlusBias[0:C1_MAPS-1];	// outputs of convolution+bias for layer C1
wire signed[HALF_WIDTH-1:0] C1_relu[0:C1_MAPS-1];	// outputs of ReLU function
wire signed[IN_WIDTH*C1_MAPS*(CONV_SIZE+1)-1:0] rom_c1;	// C1 parameters stored in memory


rom_params_bram #(.BIT_WIDTH(IN_WIDTH), .SIZE((CONV_SIZE+1)*C1_MAPS)) ROM_C1 (
	.clk(clk),
	.read(read),
	.read_out(rom_c1)
);

integer i0;
reg signed [IN_WIDTH-1:0] rowsi0[0:4][0:4];
always @ (posedge clk) begin
	for (i0 = 4; i0 > 0; i0 = i0-1) begin
		rowsi0[0][i0] <= rowsi0[0][i0-1];
		rowsi0[1][i0] <= rowsi0[1][i0-1];
		rowsi0[2][i0] <= rowsi0[2][i0-1];
		rowsi0[3][i0] <= rowsi0[3][i0-1];
		rowsi0[4][i0] <= rowsi0[4][i0-1];
	end
	rowsi0[0][0] <= rb_out[3];
	rowsi0[1][0] <= rb_out[2];
	rowsi0[2][0] <= rb_out[1];
	rowsi0[3][0] <= rb_out[0];
	rowsi0[4][0] <= nextPixel;
end

integer i1;
reg signed [IN_WIDTH-1:0] rowsi1[0:4][0:4];
always @ (posedge clk) begin
	for (i1 = 4; i1 > 0; i1 = i1-1) begin
		rowsi1[0][i1] <= rowsi1[0][i1-1];
		rowsi1[1][i1] <= rowsi1[1][i1-1];
		rowsi1[2][i1] <= rowsi1[2][i1-1];
		rowsi1[3][i1] <= rowsi1[3][i1-1];
		rowsi1[4][i1] <= rowsi1[4][i1-1];
	end
	rowsi1[0][0] <= rb_out[3];
	rowsi1[1][0] <= rb_out[2];
	rowsi1[2][0] <= rb_out[1];
	rowsi1[3][0] <= rb_out[0];
	rowsi1[4][0] <= nextPixel;
end

integer i2;
reg signed [IN_WIDTH-1:0] rowsi2[0:4][0:4];
always @ (posedge clk) begin
	for (i2 = 4; i2 > 0; i2 = i2-1) begin
		rowsi2[0][i2] <= rowsi2[0][i2-1];
		rowsi2[1][i2] <= rowsi2[1][i2-1];
		rowsi2[2][i2] <= rowsi2[2][i2-1];
		rowsi2[3][i2] <= rowsi2[3][i2-1];
		rowsi2[4][i2] <= rowsi2[4][i2-1];
	end
	rowsi2[0][0] <= rb_out[3];
	rowsi2[1][0] <= rb_out[2];
	rowsi2[2][0] <= rb_out[1];
	rowsi2[3][0] <= rb_out[0];
	rowsi2[4][0] <= nextPixel;
end


integer i3;
reg signed [IN_WIDTH-1:0] rowsi3[0:4][0:4];
always @ (posedge clk) begin
	for (i3 = 4; i3 > 0; i3 = i3-1) begin
		rowsi3[0][i3] <= rowsi3[0][i3-1];
		rowsi3[1][i3] <= rowsi3[1][i3-1];
		rowsi3[2][i3] <= rowsi3[2][i3-1];
		rowsi3[3][i3] <= rowsi3[3][i3-1];
		rowsi3[4][i3] <= rowsi3[4][i3-1];
	end
	rowsi3[0][0] <= rb_out[3];
	rowsi3[1][0] <= rb_out[2];
	rowsi3[2][0] <= rb_out[1];
	rowsi3[3][0] <= rb_out[0];
	rowsi3[4][0] <= nextPixel;
end

integer i4;
reg signed [IN_WIDTH-1:0] rowsi4[0:4][0:4];
always @ (posedge clk) begin
	for (i4 = 4; i4 > 0; i4 = i4-1) begin
		rowsi4[0][i4] <= rowsi4[0][i4-1];
		rowsi4[1][i4] <= rowsi4[1][i4-1];
		rowsi4[2][i4] <= rowsi4[2][i4-1];
		rowsi4[3][i4] <= rowsi4[3][i4-1];
		rowsi4[4][i4] <= rowsi4[4][i4-1];
	end
	rowsi4[0][0] <= rb_out[3];
	rowsi4[1][0] <= rb_out[2];
	rowsi4[2][0] <= rb_out[1];
	rowsi4[3][0] <= rb_out[0];
	rowsi4[4][0] <= nextPixel;
end

integer i5;
reg signed [IN_WIDTH-1:0] rowsi5[0:4][0:4];
always @ (posedge clk) begin
	for (i5 = 4; i5 > 0; i5 = i5-1) begin
		rowsi5[0][i5] <= rowsi5[0][i5-1];
		rowsi5[1][i5] <= rowsi5[1][i5-1];
		rowsi5[2][i5] <= rowsi5[2][i5-1];
		rowsi5[3][i5] <= rowsi5[3][i5-1];
		rowsi5[4][i5] <= rowsi5[4][i5-1];
	end
	rowsi5[0][0] <= rb_out[3];
	rowsi5[1][0] <= rb_out[2];
	rowsi5[2][0] <= rb_out[1];
	rowsi5[3][0] <= rb_out[0];
	rowsi5[4][0] <= nextPixel;
end


localparam SIZE = CONV_SIZE + 1;	// 5x5 filter + 1 bias
conv33_6bit_PIM CONV_33_DSP_0 (.in_data_0(rowsi0[4][0]), .in_data_1(rowsi0[4][1]), .in_data_2(rowsi0[4][2]), .in_data_3(rowsi0[4][3]), .in_data_4(rowsi0[4][4]), .in_data_5(rowsi0[3][0]), .in_data_6(rowsi0[3][1]), .in_data_7(rowsi0[3][2]), .in_data_8(rowsi0[3][3]), .kernel_0(rom_c1[IN_WIDTH*(0*SIZE) + 1 * IN_WIDTH -1 : IN_WIDTH*(0*SIZE) + 0 * IN_WIDTH]), .kernel_1(rom_c1[IN_WIDTH*(0*SIZE) + 2 * IN_WIDTH -1 : IN_WIDTH*(0*SIZE) + 1 * IN_WIDTH]), .kernel_2(rom_c1[IN_WIDTH*(0*SIZE) + 3 * IN_WIDTH -1 : IN_WIDTH*(0*SIZE) + 2 * IN_WIDTH]), .kernel_3(rom_c1[IN_WIDTH*(0*SIZE) + 4 * IN_WIDTH -1 : IN_WIDTH*(0*SIZE) + 3 * IN_WIDTH]), .kernel_4(rom_c1[IN_WIDTH*(0*SIZE) + 5 * IN_WIDTH -1 : IN_WIDTH*(0*SIZE) + 4 * IN_WIDTH]), .kernel_5(rom_c1[IN_WIDTH*(0*SIZE) + 6 * IN_WIDTH -1 : IN_WIDTH*(0*SIZE) + 5 * IN_WIDTH]), .kernel_6(rom_c1[IN_WIDTH*(0*SIZE) + 7 * IN_WIDTH -1 : IN_WIDTH*(0*SIZE) + 6 * IN_WIDTH]), .kernel_7(rom_c1[IN_WIDTH*(0*SIZE) + 8 * IN_WIDTH -1 : IN_WIDTH*(0*SIZE) + 7 * IN_WIDTH]), .kernel_8(rom_c1[IN_WIDTH*(0*SIZE) + 9 * IN_WIDTH -1 : IN_WIDTH*(0*SIZE) + 8 * IN_WIDTH]), .clk(clk), .out_data(C1_convOut[0]));
conv33_6bit_CLB CONV_33_DSP_1 (.in_data_0(rowsi1[4][0]), .in_data_1(rowsi1[4][1]), .in_data_2(rowsi1[4][2]), .in_data_3(rowsi1[4][3]), .in_data_4(rowsi1[4][4]), .in_data_5(rowsi1[3][0]), .in_data_6(rowsi1[3][1]), .in_data_7(rowsi1[3][2]), .in_data_8(rowsi1[3][3]), .kernel_0(rom_c1[IN_WIDTH*(1*SIZE) + 1 * IN_WIDTH -1 : IN_WIDTH*(1*SIZE) + 0 * IN_WIDTH ]), .kernel_1(rom_c1[IN_WIDTH*(1*SIZE) + 2 * IN_WIDTH -1 : IN_WIDTH*(1*SIZE) + 1 * IN_WIDTH]), .kernel_2(rom_c1[IN_WIDTH*(1*SIZE) + 3 * IN_WIDTH -1 : IN_WIDTH*(1*SIZE) + 2 * IN_WIDTH]), .kernel_3(rom_c1[IN_WIDTH*(1*SIZE) + 4 * IN_WIDTH -1 : IN_WIDTH*(1*SIZE) + 3 * IN_WIDTH]), .kernel_4(rom_c1[IN_WIDTH*(1*SIZE) + 5 * IN_WIDTH -1 : IN_WIDTH*(1*SIZE) + 4 * IN_WIDTH]), .kernel_5(rom_c1[IN_WIDTH*(1*SIZE) + 6 * IN_WIDTH -1 : IN_WIDTH*(1*SIZE) + 5 * IN_WIDTH]), .kernel_6(rom_c1[IN_WIDTH*(1*SIZE) + 7 * IN_WIDTH -1 : IN_WIDTH*(1*SIZE) + 6 * IN_WIDTH]), .kernel_7(rom_c1[IN_WIDTH*(1*SIZE) + 8 * IN_WIDTH -1 : IN_WIDTH*(1*SIZE) + 7 * IN_WIDTH]), .kernel_8(rom_c1[IN_WIDTH*(1*SIZE) + 9 * IN_WIDTH -1 : IN_WIDTH*(1*SIZE) + 8 * IN_WIDTH]), .clk(clk), .out_data(C1_convOut[1]));
conv33_6bit_PIM CONV_33_DSP_2 (.in_data_0(rowsi2[4][0]), .in_data_1(rowsi2[4][1]), .in_data_2(rowsi2[4][2]), .in_data_3(rowsi2[4][3]), .in_data_4(rowsi2[4][4]), .in_data_5(rowsi2[3][0]), .in_data_6(rowsi2[3][1]), .in_data_7(rowsi2[3][2]), .in_data_8(rowsi2[3][3]), .kernel_0(rom_c1[IN_WIDTH*(2*SIZE) + 1 * IN_WIDTH -1 : IN_WIDTH*(2*SIZE) + 0 * IN_WIDTH ]), .kernel_1(rom_c1[IN_WIDTH*(2*SIZE) + 2 * IN_WIDTH -1 : IN_WIDTH*(2*SIZE) + 1 * IN_WIDTH]), .kernel_2(rom_c1[IN_WIDTH*(2*SIZE) + 3 * IN_WIDTH -1 : IN_WIDTH*(2*SIZE) + 2 * IN_WIDTH]), .kernel_3(rom_c1[IN_WIDTH*(2*SIZE) + 4 * IN_WIDTH -1 : IN_WIDTH*(2*SIZE) + 3 * IN_WIDTH]), .kernel_4(rom_c1[IN_WIDTH*(2*SIZE) + 5 * IN_WIDTH -1 : IN_WIDTH*(2*SIZE) + 4 * IN_WIDTH]), .kernel_5(rom_c1[IN_WIDTH*(2*SIZE) + 6 * IN_WIDTH -1 : IN_WIDTH*(2*SIZE) + 5 * IN_WIDTH]), .kernel_6(rom_c1[IN_WIDTH*(2*SIZE) + 7 * IN_WIDTH -1 : IN_WIDTH*(2*SIZE) + 6 * IN_WIDTH]), .kernel_7(rom_c1[IN_WIDTH*(2*SIZE) + 8 * IN_WIDTH -1 : IN_WIDTH*(2*SIZE) + 7 * IN_WIDTH]), .kernel_8(rom_c1[IN_WIDTH*(2*SIZE) + 9 * IN_WIDTH -1 : IN_WIDTH*(2*SIZE) + 8 * IN_WIDTH]), .clk(clk), .out_data(C1_convOut[2]));
conv33_6bit_PIM CONV_33_DSP_3 (.in_data_0(rowsi3[4][0]), .in_data_1(rowsi3[4][1]), .in_data_2(rowsi3[4][2]), .in_data_3(rowsi3[4][3]), .in_data_4(rowsi3[4][4]), .in_data_5(rowsi3[3][0]), .in_data_6(rowsi3[3][1]), .in_data_7(rowsi3[3][2]), .in_data_8(rowsi3[3][3]), .kernel_0(rom_c1[IN_WIDTH*(3*SIZE) + 1 * IN_WIDTH -1 : IN_WIDTH*(3*SIZE) + 0 * IN_WIDTH ]), .kernel_1(rom_c1[IN_WIDTH*(3*SIZE) + 2 * IN_WIDTH -1 : IN_WIDTH*(3*SIZE) + 1 * IN_WIDTH]), .kernel_2(rom_c1[IN_WIDTH*(3*SIZE) + 3 * IN_WIDTH -1 : IN_WIDTH*(3*SIZE) + 2 * IN_WIDTH]), .kernel_3(rom_c1[IN_WIDTH*(3*SIZE) + 4 * IN_WIDTH -1 : IN_WIDTH*(3*SIZE) + 3 * IN_WIDTH]), .kernel_4(rom_c1[IN_WIDTH*(3*SIZE) + 5 * IN_WIDTH -1 : IN_WIDTH*(3*SIZE) + 4 * IN_WIDTH]), .kernel_5(rom_c1[IN_WIDTH*(3*SIZE) + 6 * IN_WIDTH -1 : IN_WIDTH*(3*SIZE) + 5 * IN_WIDTH]), .kernel_6(rom_c1[IN_WIDTH*(3*SIZE) + 7 * IN_WIDTH -1 : IN_WIDTH*(3*SIZE) + 6 * IN_WIDTH]), .kernel_7(rom_c1[IN_WIDTH*(3*SIZE) + 8 * IN_WIDTH -1 : IN_WIDTH*(3*SIZE) + 7 * IN_WIDTH]), .kernel_8(rom_c1[IN_WIDTH*(3*SIZE) + 9 * IN_WIDTH -1 : IN_WIDTH*(3*SIZE) + 8 * IN_WIDTH]), .clk(clk), .out_data(C1_convOut[3]));
conv33_6bit_PIM CONV_33_DSP_4 (.in_data_0(rowsi4[4][0]), .in_data_1(rowsi4[4][1]), .in_data_2(rowsi4[4][2]), .in_data_3(rowsi4[4][3]), .in_data_4(rowsi4[4][4]), .in_data_5(rowsi4[3][0]), .in_data_6(rowsi4[3][1]), .in_data_7(rowsi4[3][2]), .in_data_8(rowsi4[3][3]), .kernel_0(rom_c1[IN_WIDTH*(4*SIZE) + 1 * IN_WIDTH -1 : IN_WIDTH*(4*SIZE) + 0 * IN_WIDTH ]), .kernel_1(rom_c1[IN_WIDTH*(4*SIZE) + 2 * IN_WIDTH -1 : IN_WIDTH*(4*SIZE) + 1 * IN_WIDTH]), .kernel_2(rom_c1[IN_WIDTH*(4*SIZE) + 3 * IN_WIDTH -1 : IN_WIDTH*(4*SIZE) + 2 * IN_WIDTH]), .kernel_3(rom_c1[IN_WIDTH*(4*SIZE) + 4 * IN_WIDTH -1 : IN_WIDTH*(4*SIZE) + 3 * IN_WIDTH]), .kernel_4(rom_c1[IN_WIDTH*(4*SIZE) + 5 * IN_WIDTH -1 : IN_WIDTH*(4*SIZE) + 4 * IN_WIDTH]), .kernel_5(rom_c1[IN_WIDTH*(4*SIZE) + 6 * IN_WIDTH -1 : IN_WIDTH*(4*SIZE) + 5 * IN_WIDTH]), .kernel_6(rom_c1[IN_WIDTH*(4*SIZE) + 7 * IN_WIDTH -1 : IN_WIDTH*(4*SIZE) + 6 * IN_WIDTH]), .kernel_7(rom_c1[IN_WIDTH*(4*SIZE) + 8 * IN_WIDTH -1 : IN_WIDTH*(4*SIZE) + 7 * IN_WIDTH]), .kernel_8(rom_c1[IN_WIDTH*(4*SIZE) + 9 * IN_WIDTH -1 : IN_WIDTH*(4*SIZE) + 8 * IN_WIDTH]), .clk(clk), .out_data(C1_convOut[4]));
conv33_6bit_PIM CONV_33_DSP_5 (.in_data_0(rowsi5[4][0]), .in_data_1(rowsi5[4][1]), .in_data_2(rowsi5[4][2]), .in_data_3(rowsi5[4][3]), .in_data_4(rowsi5[4][4]), .in_data_5(rowsi5[3][0]), .in_data_6(rowsi5[3][1]), .in_data_7(rowsi5[3][2]), .in_data_8(rowsi5[3][3]), .kernel_0(rom_c1[IN_WIDTH*(5*SIZE) + 1 * IN_WIDTH -1 : IN_WIDTH*(5*SIZE) + 0 * IN_WIDTH ]), .kernel_1(rom_c1[IN_WIDTH*(5*SIZE) + 2 * IN_WIDTH -1 : IN_WIDTH*(5*SIZE) + 1 * IN_WIDTH]), .kernel_2(rom_c1[IN_WIDTH*(5*SIZE) + 3 * IN_WIDTH -1 : IN_WIDTH*(5*SIZE) + 2 * IN_WIDTH]), .kernel_3(rom_c1[IN_WIDTH*(5*SIZE) + 4 * IN_WIDTH -1 : IN_WIDTH*(5*SIZE) + 3 * IN_WIDTH]), .kernel_4(rom_c1[IN_WIDTH*(5*SIZE) + 5 * IN_WIDTH -1 : IN_WIDTH*(5*SIZE) + 4 * IN_WIDTH]), .kernel_5(rom_c1[IN_WIDTH*(5*SIZE) + 6 * IN_WIDTH -1 : IN_WIDTH*(5*SIZE) + 5 * IN_WIDTH]), .kernel_6(rom_c1[IN_WIDTH*(5*SIZE) + 7 * IN_WIDTH -1 : IN_WIDTH*(5*SIZE) + 6 * IN_WIDTH]), .kernel_7(rom_c1[IN_WIDTH*(5*SIZE) + 8 * IN_WIDTH -1 : IN_WIDTH*(5*SIZE) + 7 * IN_WIDTH]), .kernel_8(rom_c1[IN_WIDTH*(5*SIZE) + 9 * IN_WIDTH -1 : IN_WIDTH*(5*SIZE) + 8 * IN_WIDTH]), .clk(clk), .out_data(C1_convOut[5]));

assign C1_convPlusBias[0] = C1_convOut[0] + rom_c1[IN_WIDTH*((0+1)*SIZE)-1 : IN_WIDTH*((0+1)*SIZE-1)];
assign C1_convPlusBias[1] = C1_convOut[1] + rom_c1[IN_WIDTH*((1+1)*SIZE)-1 : IN_WIDTH*((1+1)*SIZE-1)];
assign C1_convPlusBias[2] = C1_convOut[2] + rom_c1[IN_WIDTH*((2+1)*SIZE)-1 : IN_WIDTH*((2+1)*SIZE-1)];
assign C1_convPlusBias[3] = C1_convOut[3] + rom_c1[IN_WIDTH*((3+1)*SIZE)-1 : IN_WIDTH*((3+1)*SIZE-1)];
assign C1_convPlusBias[4] = C1_convOut[4] + rom_c1[IN_WIDTH*((4+1)*SIZE)-1 : IN_WIDTH*((4+1)*SIZE-1)];
assign C1_convPlusBias[5] = C1_convOut[5] + rom_c1[IN_WIDTH*((5+1)*SIZE)-1 : IN_WIDTH*((5+1)*SIZE-1)];

relu #(.BIT_WIDTH(HALF_WIDTH)) C1_RELU_0 (.in(C1_convPlusBias[0]), .out(C1_relu[0]));
relu #(.BIT_WIDTH(HALF_WIDTH)) C1_RELU_1 (.in(C1_convPlusBias[1]), .out(C1_relu[1]));
relu #(.BIT_WIDTH(HALF_WIDTH)) C1_RELU_2 (.in(C1_convPlusBias[2]), .out(C1_relu[2]));
relu #(.BIT_WIDTH(HALF_WIDTH)) C1_RELU_3 (.in(C1_convPlusBias[3]), .out(C1_relu[3]));
relu #(.BIT_WIDTH(HALF_WIDTH)) C1_RELU_4 (.in(C1_convPlusBias[4]), .out(C1_relu[4]));
relu #(.BIT_WIDTH(HALF_WIDTH)) C1_RELU_5 (.in(C1_convPlusBias[5]), .out(C1_relu[5]));

assign out1 = C1_relu[0] | 		// 6 outputs of C1
	C1_relu[1] |
	C1_relu[2] |
	C1_relu[3] |
	C1_relu[4] |
	C1_relu[5];

// holds output of rowbuffer for C1 -> S2
wire signed[HALF_WIDTH-1:0] rb_C1S2[0:C1_MAPS-1];	// 6 maps * 1 row - 1 = 5

// C1 feature map; next pixel to buffer for S2
generate
	for (g = 0; g < C1_MAPS; g = g+1) begin : C1_rb	// 6 feature maps
		rowbuffer #(.COLS(C1_SIZE), .BIT_WIDTH(HALF_WIDTH)) C1_RB (
			.clk(clk), .rst(rst),
			.rb_in(C1_relu[g]),
			.en(S2_en),
			.rb_out(rb_C1S2[g])
		);
	end
endgenerate


// S2: 6 feature maps; max pooling, stride = 2
wire signed[HALF_WIDTH-1:0] S2_poolOut[0:C1_MAPS-1];	// outputs of pooling

// max pooling modules
generate
	for (g = 0; g < 6; g = g+1) begin : S2_op
		maxpool22 #(.BIT_WIDTH(HALF_WIDTH)) S2_POOL (
			.clk(clk), //.rst(rst),
			.en(S2_en),
			.in1(rb_C1S2[g]), .in2(C1_relu[g]),
			.maxOut(S2_poolOut[g])
		);
	end
endgenerate


// use S2_en for end-of-S2 rowbuffer as well as max pooling modules

// holds output of rowbuffer for S2 -> C3
wire signed[HALF_WIDTH-1:0] rb_S2C3[0:C1_MAPS*4-1];	// 6 maps * 4 rows - 1 = 23
generate
	for (g = 0; g < C1_MAPS; g = g+1) begin : S2_rb	// 6 feature maps
		row4buffer #(.COLS(S2_SIZE), .BIT_WIDTH(HALF_WIDTH)) S2_RB (
			.clk(clk), .rst(rst),
			.rb_in(S2_poolOut[g]),
			.en(C3_en),
			.rb_out0(rb_S2C3[g*4]), .rb_out1(rb_S2C3[g*4+1]), .rb_out2(rb_S2C3[g*4+2]), .rb_out3(rb_S2C3[g*4+3])
		);
	end
endgenerate


// C3: 16 feature maps; convolution, stride = 1
wire signed[OUT_WIDTH-1:0] C3_convOut[0:C3_MAPS-1];	// 16 outputs of convolution from layer C1
wire signed[OUT_WIDTH-1:0] C3_relu[0:C3_MAPS-1];	// 16 outputs of ReLU function

wire signed[HALF_WIDTH*6*(CONV_SIZE_3+1)-1:0] rom_c3_x3;	// 6 C3 maps' parameters stored in memory for 5x5x3 conv
wire signed[HALF_WIDTH*9*(CONV_SIZE_4+1)-1:0] rom_c3_x4;	// 9 C3 maps' parameters stored in memory for 5x5x4 conv
wire signed[HALF_WIDTH*(CONV_SIZE_6+1)-1:0] rom_c3_x6;	// 1 C3 map's parameters stored in memory for 5x5x6 conv


rom_params_bram #(.BIT_WIDTH(HALF_WIDTH), .SIZE(6*(CONV_SIZE_3+1))) ROM_C3_X3 (
	.clk(clk),
	.read(read),
	.read_out(rom_c3_x3)
);

rom_params_bram #(.BIT_WIDTH(HALF_WIDTH), .SIZE(9*(CONV_SIZE_4+1))) ROM_C3_X4 (
	.clk(clk),
	.read(read),
	.read_out(rom_c3_x4)
);


 rom_params_bram #(.BIT_WIDTH(HALF_WIDTH), .SIZE(CONV_SIZE_6+1)) ROM_C3_X6 (
	.clk(clk),
	.read(read),
	.read_out(rom_c3_x6)
);

integer i;
reg signed [IN_WIDTH-1:0] rows01[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows01[0][i] <= rows01[0][i-1];
			rows01[1][i] <= rows01[1][i-1];
			rows01[2][i] <= rows01[2][i-1];
			rows01[3][i] <= rows01[3][i-1];
			rows01[4][i] <= rows01[4][i-1];
		end
		rows01[0][0] <= rb_S2C3[0*4+3];
		rows01[1][0] <= rb_S2C3[0*4+2];
		rows01[2][0] <= rb_S2C3[0*4+1];
		rows01[3][0] <= rb_S2C3[0*4+0];
		rows01[4][0] <= S2_poolOut[0];
end

reg signed [IN_WIDTH-1:0] rows02[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows02[0][i] <= rows02[0][i-1];
			rows02[1][i] <= rows02[1][i-1];
			rows02[2][i] <= rows02[2][i-1];
			rows02[3][i] <= rows02[3][i-1];
			rows02[4][i] <= rows02[4][i-1];
		end
		rows02[0][0] <= rb_S2C3[1*4+3];
		rows02[1][0] <= rb_S2C3[1*4+2];
		rows02[2][0] <= rb_S2C3[1*4+1];
		rows02[3][0] <= rb_S2C3[1*4+0];
		rows02[4][0] <= S2_poolOut[1];
end

reg signed [IN_WIDTH-1:0] rows03[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows03[0][i] <= rows03[0][i-1];
			rows03[1][i] <= rows03[1][i-1];
			rows03[2][i] <= rows03[2][i-1];
			rows03[3][i] <= rows03[3][i-1];
			rows03[4][i] <= rows03[4][i-1];
		end
		rows03[0][0] <= rb_S2C3[2*4+3];
		rows03[1][0] <= rb_S2C3[2*4+2];
		rows03[2][0] <= rb_S2C3[2*4+1];
		rows03[3][0] <= rb_S2C3[2*4+0];
		rows03[4][0] <= S2_poolOut[2];
end


reg signed [IN_WIDTH-1:0] rows04[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows04[0][i] <= rows04[0][i-1];
			rows04[1][i] <= rows04[1][i-1];
			rows04[2][i] <= rows04[2][i-1];
			rows04[3][i] <= rows04[3][i-1];
			rows04[4][i] <= rows04[4][i-1];
		end
		rows04[0][0] <= rb_S2C3[3*4+3];
		rows04[1][0] <= rb_S2C3[3*4+2];
		rows04[2][0] <= rb_S2C3[3*4+1];
		rows04[3][0] <= rb_S2C3[3*4+0];
		rows04[4][0] <= S2_poolOut[3];
end

reg signed [IN_WIDTH-1:0] rows05[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows05[0][i] <= rows05[0][i-1];
			rows05[1][i] <= rows05[1][i-1];
			rows05[2][i] <= rows05[2][i-1];
			rows05[3][i] <= rows05[3][i-1];
			rows05[4][i] <= rows05[4][i-1];
		end
		rows05[0][0] <= rb_S2C3[4*4+3];
		rows05[1][0] <= rb_S2C3[4*4+2];
		rows05[2][0] <= rb_S2C3[4*4+1];
		rows05[3][0] <= rb_S2C3[4*4+0];
		rows05[4][0] <= S2_poolOut[4];
end

reg signed [IN_WIDTH-1:0] rows06[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows06[0][i] <= rows06[0][i-1];
			rows06[1][i] <= rows06[1][i-1];
			rows06[2][i] <= rows06[2][i-1];
			rows06[3][i] <= rows06[3][i-1];
			rows06[4][i] <= rows06[4][i-1];
		end
		rows06[0][0] <= rb_S2C3[5*4+3];
		rows06[1][0] <= rb_S2C3[5*4+2];
		rows06[2][0] <= rb_S2C3[5*4+1];
		rows06[3][0] <= rb_S2C3[5*4+0];
		rows06[4][0] <= S2_poolOut[5];
end



reg signed [IN_WIDTH-1:0] rows11[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows11[0][i] <= rows11[0][i-1];
			rows11[1][i] <= rows11[1][i-1];
			rows11[2][i] <= rows11[2][i-1];
			rows11[3][i] <= rows11[3][i-1];
			rows11[4][i] <= rows11[4][i-1];
		end
		rows11[0][0] <= rb_S2C3[1*4+3];
		rows11[1][0] <= rb_S2C3[1*4+2];
		rows11[2][0] <= rb_S2C3[1*4+1];
		rows11[3][0] <= rb_S2C3[1*4+0];
		rows11[4][0] <= S2_poolOut[0];
end

reg signed [IN_WIDTH-1:0] rows12[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows12[0][i] <= rows12[0][i-1];
			rows12[1][i] <= rows12[1][i-1];
			rows12[2][i] <= rows12[2][i-1];
			rows12[3][i] <= rows12[3][i-1];
			rows12[4][i] <= rows12[4][i-1];
		end
		rows12[0][0] <= rb_S2C3[2*4+3];
		rows12[1][0] <= rb_S2C3[2*4+2];
		rows12[2][0] <= rb_S2C3[2*4+1];
		rows12[3][0] <= rb_S2C3[2*4+0];
		rows12[4][0] <= S2_poolOut[1];
end

reg signed [IN_WIDTH-1:0] rows13[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows13[0][i] <= rows13[0][i-1];
			rows13[1][i] <= rows13[1][i-1];
			rows13[2][i] <= rows13[2][i-1];
			rows13[3][i] <= rows13[3][i-1];
			rows13[4][i] <= rows13[4][i-1];
		end
		rows13[0][0] <= rb_S2C3[3*4+3];
		rows13[1][0] <= rb_S2C3[3*4+2];
		rows13[2][0] <= rb_S2C3[3*4+1];
		rows13[3][0] <= rb_S2C3[3*4+0];
		rows13[4][0] <= S2_poolOut[3];
end


reg signed [IN_WIDTH-1:0] rows14[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows14[0][i] <= rows14[0][i-1];
			rows14[1][i] <= rows14[1][i-1];
			rows14[2][i] <= rows14[2][i-1];
			rows14[3][i] <= rows14[3][i-1];
			rows14[4][i] <= rows14[4][i-1];
		end
		rows14[0][0] <= rb_S2C3[4*4+3];
		rows14[1][0] <= rb_S2C3[4*4+2];
		rows14[2][0] <= rb_S2C3[4*4+1];
		rows14[3][0] <= rb_S2C3[4*4+0];
		rows14[4][0] <= S2_poolOut[4];
end

reg signed [IN_WIDTH-1:0] rows15[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows15[0][i] <= rows15[0][i-1];
			rows15[1][i] <= rows15[1][i-1];
			rows15[2][i] <= rows15[2][i-1];
			rows15[3][i] <= rows15[3][i-1];
			rows15[4][i] <= rows15[4][i-1];
		end
		rows15[0][0] <= rb_S2C3[5*4+3];
		rows15[1][0] <= rb_S2C3[5*4+2];
		rows15[2][0] <= rb_S2C3[5*4+1];
		rows15[3][0] <= rb_S2C3[5*4+0];
		rows15[4][0] <= S2_poolOut[5];
end

reg signed [IN_WIDTH-1:0] rows16[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows16[0][i] <= rows16[0][i-1];
			rows16[1][i] <= rows16[1][i-1];
			rows16[2][i] <= rows16[2][i-1];
			rows16[3][i] <= rows16[3][i-1];
			rows16[4][i] <= rows16[4][i-1];
		end
		rows16[0][0] <= rb_S2C3[0*4+3];
		rows16[1][0] <= rb_S2C3[0*4+2];
		rows16[2][0] <= rb_S2C3[0*4+1];
		rows16[3][0] <= rb_S2C3[0*4+0];
		rows16[4][0] <= S2_poolOut[0];
end




reg signed [IN_WIDTH-1:0] rows21[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows21[0][i] <= rows21[0][i-1];
			rows21[1][i] <= rows21[1][i-1];
			rows21[2][i] <= rows21[2][i-1];
			rows21[3][i] <= rows21[3][i-1];
			rows21[4][i] <= rows21[4][i-1];
		end
		rows21[0][0] <= rb_S2C3[2*4+3];
		rows21[1][0] <= rb_S2C3[2*4+2];
		rows21[2][0] <= rb_S2C3[2*4+1];
		rows21[3][0] <= rb_S2C3[2*4+0];
		rows21[4][0] <= S2_poolOut[2];
end

reg signed [IN_WIDTH-1:0] rows22[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows22[0][i] <= rows22[0][i-1];
			rows22[1][i] <= rows22[1][i-1];
			rows22[2][i] <= rows22[2][i-1];
			rows22[3][i] <= rows22[3][i-1];
			rows22[4][i] <= rows22[4][i-1];
		end
		rows22[0][0] <= rb_S2C3[3*4+3];
		rows22[1][0] <= rb_S2C3[3*4+2];
		rows22[2][0] <= rb_S2C3[3*4+1];
		rows22[3][0] <= rb_S2C3[3*4+0];
		rows22[4][0] <= S2_poolOut[3];
end

reg signed [IN_WIDTH-1:0] rows23[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows23[0][i] <= rows23[0][i-1];
			rows23[1][i] <= rows23[1][i-1];
			rows23[2][i] <= rows23[2][i-1];
			rows23[3][i] <= rows23[3][i-1];
			rows23[4][i] <= rows23[4][i-1];
		end
		rows23[0][0] <= rb_S2C3[4*4+3];
		rows23[1][0] <= rb_S2C3[4*4+2];
		rows23[2][0] <= rb_S2C3[4*4+1];
		rows23[3][0] <= rb_S2C3[4*4+0];
		rows23[4][0] <= S2_poolOut[4];
end


reg signed [IN_WIDTH-1:0] rows24[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows24[0][i] <= rows24[0][i-1];
			rows24[1][i] <= rows24[1][i-1];
			rows24[2][i] <= rows24[2][i-1];
			rows24[3][i] <= rows24[3][i-1];
			rows24[4][i] <= rows24[4][i-1];
		end
		rows24[0][0] <= rb_S2C3[5*4+3];
		rows24[1][0] <= rb_S2C3[5*4+2];
		rows24[2][0] <= rb_S2C3[5*4+1];
		rows24[3][0] <= rb_S2C3[5*4+0];
		rows24[4][0] <= S2_poolOut[5];
end

reg signed [IN_WIDTH-1:0] rows25[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows25[0][i] <= rows25[0][i-1];
			rows25[1][i] <= rows25[1][i-1];
			rows25[2][i] <= rows25[2][i-1];
			rows25[3][i] <= rows25[3][i-1];
			rows25[4][i] <= rows25[4][i-1];
		end
		rows25[0][0] <= rb_S2C3[0*4+3];
		rows25[1][0] <= rb_S2C3[0*4+2];
		rows25[2][0] <= rb_S2C3[0*4+1];
		rows25[3][0] <= rb_S2C3[0*4+0];
		rows25[4][0] <= S2_poolOut[0];
end

reg signed [IN_WIDTH-1:0] rows26[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows26[0][i] <= rows26[0][i-1];
			rows26[1][i] <= rows26[1][i-1];
			rows26[2][i] <= rows26[2][i-1];
			rows26[3][i] <= rows26[3][i-1];
			rows26[4][i] <= rows26[4][i-1];
		end
		rows26[0][0] <= rb_S2C3[1*4+3];
		rows26[1][0] <= rb_S2C3[1*4+2];
		rows26[2][0] <= rb_S2C3[1*4+1];
		rows26[3][0] <= rb_S2C3[1*4+0];
		rows26[4][0] <= S2_poolOut[1];
end


localparam CONVSIZE = 25;
wire signed[OUT_WIDTH-1:0] conv00, conv01, conv02, conv10, conv11, conv12, conv20, conv21, conv22, conv30, conv31, conv32, conv40, conv41, conv42, conv50, conv51, conv52;
wire signed[OUT_WIDTH-1:0] sum00, sum01, sum10, sum11, sum20, sum21, sum30, sum31, sum40, sum41, sum50, sum51;  
wire signed[OUT_WIDTH-1:0] convValue0, convValue1, convValue2, convValue3, convValue4, convValue5;

conv33_6bit_PIM CONV_33_DSP_6 (.in_data_0(rows01[4][0]), .in_data_1(rows01[4][1]), .in_data_2(rows01[4][2]), .in_data_3(rows01[4][3]), .in_data_4(rows01[4][4]), .in_data_5(rows01[3][0]), .in_data_6(rows01[3][1]), .in_data_7(rows01[3][2]), .in_data_8(rows01[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv00));
conv33_6bit_DSP CONV_33_DSP_7 (.in_data_0(rows11[4][0]), .in_data_1(rows11[4][1]), .in_data_2(rows11[4][2]), .in_data_3(rows11[4][3]), .in_data_4(rows11[4][4]), .in_data_5(rows11[3][0]), .in_data_6(rows11[3][1]), .in_data_7(rows11[3][2]), .in_data_8(rows11[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv01));
conv33_6bit_DSP CONV_33_DSP_8 (.in_data_0(rows21[4][0]), .in_data_1(rows21[4][1]), .in_data_2(rows21[4][2]), .in_data_3(rows21[4][3]), .in_data_4(rows21[4][4]), .in_data_5(rows21[3][0]), .in_data_6(rows21[3][1]), .in_data_7(rows21[3][2]), .in_data_8(rows21[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(0*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv02));
assign sum00 = conv00 + conv01;
assign sum01 = conv02 + rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE) + 1*IN_WIDTH: IN_WIDTH*(3*3*CONVSIZE)];
assign convValue0 = sum00 + sum01;

conv33_6bit_DSP CONV_33_DSP_9 (.in_data_0(rows02[4][0]), .in_data_1(rows02[4][1]), .in_data_2(rows02[4][2]), .in_data_3(rows02[4][3]), .in_data_4(rows02[4][4]), .in_data_5(rows02[3][0]), .in_data_6(rows02[3][1]), .in_data_7(rows02[3][2]), .in_data_8(rows02[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv10));
conv33_6bit_PIM CONV_33_DSP_10 (.in_data_0(rows12[4][0]), .in_data_1(rows12[4][1]), .in_data_2(rows12[4][2]), .in_data_3(rows12[4][3]), .in_data_4(rows12[4][4]), .in_data_5(rows12[3][0]), .in_data_6(rows12[3][1]), .in_data_7(rows12[3][2]), .in_data_8(rows12[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv11));
conv33_6bit_PIM CONV_33_DSP_11 (.in_data_0(rows22[4][0]), .in_data_1(rows22[4][1]), .in_data_2(rows22[4][2]), .in_data_3(rows22[4][3]), .in_data_4(rows22[4][4]), .in_data_5(rows22[3][0]), .in_data_6(rows22[3][1]), .in_data_7(rows22[3][2]), .in_data_8(rows22[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(1*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv12));
assign sum10 = conv10 + conv11;
assign sum11 = conv12 + rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE) + 2*IN_WIDTH: IN_WIDTH*(3*3*CONVSIZE)+1*IN_WIDTH];
assign convValue1 = sum10 + sum11;


conv33_6bit_DSP CONV_33_DSP_12 (.in_data_0(rows03[4][0]), .in_data_1(rows03[4][1]), .in_data_2(rows03[4][2]), .in_data_3(rows03[4][3]), .in_data_4(rows03[4][4]), .in_data_5(rows03[3][0]), .in_data_6(rows03[3][1]), .in_data_7(rows03[3][2]), .in_data_8(rows03[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv20));
conv33_6bit_PIM CONV_33_DSP_13 (.in_data_0(rows13[4][0]), .in_data_1(rows13[4][1]), .in_data_2(rows13[4][2]), .in_data_3(rows13[4][3]), .in_data_4(rows13[4][4]), .in_data_5(rows13[3][0]), .in_data_6(rows13[3][1]), .in_data_7(rows13[3][2]), .in_data_8(rows13[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv21));
conv33_6bit_PIM CONV_33_DSP_14 (.in_data_0(rows23[4][0]), .in_data_1(rows23[4][1]), .in_data_2(rows23[4][2]), .in_data_3(rows23[4][3]), .in_data_4(rows23[4][4]), .in_data_5(rows23[3][0]), .in_data_6(rows23[3][1]), .in_data_7(rows23[3][2]), .in_data_8(rows23[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(2*3*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv22));
assign sum20 = conv20 + conv21;
assign sum21 = conv22 + rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE) + 3*IN_WIDTH: IN_WIDTH*(3*3*CONVSIZE)+2*IN_WIDTH];
assign convValue2 = sum20 + sum21;

conv33_6bit_DSP CONV_33_DSP_15 (.in_data_0(rows04[4][0]), .in_data_1(rows04[4][1]), .in_data_2(rows04[4][2]), .in_data_3(rows04[4][3]), .in_data_4(rows04[4][4]), .in_data_5(rows04[3][0]), .in_data_6(rows04[3][1]), .in_data_7(rows04[3][2]), .in_data_8(rows04[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv30));
conv33_6bit_PIM CONV_33_DSP_16 (.in_data_0(rows14[4][0]), .in_data_1(rows14[4][1]), .in_data_2(rows14[4][2]), .in_data_3(rows14[4][3]), .in_data_4(rows14[4][4]), .in_data_5(rows14[3][0]), .in_data_6(rows14[3][1]), .in_data_7(rows14[3][2]), .in_data_8(rows14[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv31));
conv33_6bit_PIM CONV_33_DSP_17 (.in_data_0(rows24[4][0]), .in_data_1(rows24[4][1]), .in_data_2(rows24[4][2]), .in_data_3(rows24[4][3]), .in_data_4(rows24[4][4]), .in_data_5(rows24[3][0]), .in_data_6(rows24[3][1]), .in_data_7(rows24[3][2]), .in_data_8(rows24[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(3*3*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv32));
assign sum30 = conv30 + conv31;
assign sum31 = conv32 + rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE) + 4*IN_WIDTH: IN_WIDTH*(3*3*CONVSIZE)+3*IN_WIDTH];
assign convValue3 = sum30 + sum31;

conv33_6bit_DSP CONV_33_DSP_18 (.in_data_0(rows05[4][0]), .in_data_1(rows05[4][1]), .in_data_2(rows05[4][2]), .in_data_3(rows05[4][3]), .in_data_4(rows05[4][4]), .in_data_5(rows05[3][0]), .in_data_6(rows05[3][1]), .in_data_7(rows05[3][2]), .in_data_8(rows05[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv40));
conv33_6bit_PIM CONV_33_DSP_19 (.in_data_0(rows15[4][0]), .in_data_1(rows15[4][1]), .in_data_2(rows15[4][2]), .in_data_3(rows15[4][3]), .in_data_4(rows15[4][4]), .in_data_5(rows15[3][0]), .in_data_6(rows15[3][1]), .in_data_7(rows15[3][2]), .in_data_8(rows15[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv41));
conv33_6bit_PIM CONV_33_DSP_20 (.in_data_0(rows25[4][0]), .in_data_1(rows25[4][1]), .in_data_2(rows25[4][2]), .in_data_3(rows25[4][3]), .in_data_4(rows25[4][4]), .in_data_5(rows25[3][0]), .in_data_6(rows25[3][1]), .in_data_7(rows25[3][2]), .in_data_8(rows25[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(4*3*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv42));
assign sum40 = conv40 + conv41;
assign sum41 = conv42 + rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE) + 5*IN_WIDTH: IN_WIDTH*(3*3*CONVSIZE)+4*IN_WIDTH];
assign convValue4 = sum40 + sum41;

conv33_6bit_DSP CONV_33_DSP_21 (.in_data_0(rows06[4][0]), .in_data_1(rows06[4][1]), .in_data_2(rows06[4][2]), .in_data_3(rows06[4][3]), .in_data_4(rows06[4][4]), .in_data_5(rows06[3][0]), .in_data_6(rows06[3][1]), .in_data_7(rows06[3][2]), .in_data_8(rows06[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv50));
conv33_6bit_PIM CONV_33_DSP_22 (.in_data_0(rows16[4][0]), .in_data_1(rows16[4][1]), .in_data_2(rows16[4][2]), .in_data_3(rows16[4][3]), .in_data_4(rows16[4][4]), .in_data_5(rows16[3][0]), .in_data_6(rows16[3][1]), .in_data_7(rows16[3][2]), .in_data_8(rows16[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv51));
conv33_6bit_DSP CONV_33_DSP_23 (.in_data_0(rows26[4][0]), .in_data_1(rows26[4][1]), .in_data_2(rows26[4][2]), .in_data_3(rows26[4][3]), .in_data_4(rows26[4][4]), .in_data_5(rows26[3][0]), .in_data_6(rows26[3][1]), .in_data_7(rows26[3][2]), .in_data_8(rows26[3][3]), .kernel_0(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x3[IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(5*3*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv52));
assign sum50 = conv50 + conv51;
assign sum51 = conv52 + rom_c3_x3[IN_WIDTH*(3*3*CONVSIZE) + 6*IN_WIDTH: IN_WIDTH*(3*3*CONVSIZE)+5*IN_WIDTH];
assign convValue5 = sum50 + sum51;




relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_1 (.in(convValue0), .out(C3_relu[0]));
relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_2 (.in(convValue1), .out(C3_relu[1]));
relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_3 (.in(convValue2), .out(C3_relu[2]));
relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_4 (.in(convValue3), .out(C3_relu[3]));
relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_5 (.in(convValue4), .out(C3_relu[4]));
relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_6 (.in(convValue5), .out(C3_relu[5]));

assign out = C3_relu[0] | C3_relu[1] | C3_relu[2] | C3_relu[3] | C3_relu[4] | C3_relu[5] | C3_relu[6];


reg signed [IN_WIDTH-1:0] rows31[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows31[0][i] <= rows31[0][i-1];
			rows31[1][i] <= rows31[1][i-1];
			rows31[2][i] <= rows31[2][i-1];
			rows31[3][i] <= rows31[3][i-1];
			rows31[4][i] <= rows31[4][i-1];
		end
		rows31[0][0] <= rb_S2C3[0*4+3];
		rows31[1][0] <= rb_S2C3[0*4+2];
		rows31[2][0] <= rb_S2C3[0*4+1];
		rows31[3][0] <= rb_S2C3[0*4+0];
		rows31[4][0] <= S2_poolOut[0];
end

reg signed [IN_WIDTH-1:0] rows32[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows32[0][i] <= rows32[0][i-1];
			rows32[1][i] <= rows32[1][i-1];
			rows32[2][i] <= rows32[2][i-1];
			rows32[3][i] <= rows32[3][i-1];
			rows32[4][i] <= rows32[4][i-1];
		end
		rows32[0][0] <= rb_S2C3[1*4+3];
		rows32[1][0] <= rb_S2C3[1*4+2];
		rows32[2][0] <= rb_S2C3[1*4+1];
		rows32[3][0] <= rb_S2C3[1*4+0];
		rows32[4][0] <= S2_poolOut[1];
end

reg signed [IN_WIDTH-1:0] rows33[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows33[0][i] <= rows33[0][i-1];
			rows33[1][i] <= rows33[1][i-1];
			rows33[2][i] <= rows33[2][i-1];
			rows33[3][i] <= rows33[3][i-1];
			rows33[4][i] <= rows33[4][i-1];
		end
		rows33[0][0] <= rb_S2C3[2*4+3];
		rows33[1][0] <= rb_S2C3[2*4+2];
		rows33[2][0] <= rb_S2C3[2*4+1];
		rows33[3][0] <= rb_S2C3[2*4+0];
		rows33[4][0] <= S2_poolOut[2];
end


reg signed [IN_WIDTH-1:0] rows34[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows34[0][i] <= rows34[0][i-1];
			rows34[1][i] <= rows34[1][i-1];
			rows34[2][i] <= rows34[2][i-1];
			rows34[3][i] <= rows34[3][i-1];
			rows34[4][i] <= rows34[4][i-1];
		end
		rows34[0][0] <= rb_S2C3[0*4+3];
		rows34[1][0] <= rb_S2C3[0*4+2];
		rows34[2][0] <= rb_S2C3[0*4+1];
		rows34[3][0] <= rb_S2C3[0*4+0];
		rows34[4][0] <= S2_poolOut[3];
end

reg signed [IN_WIDTH-1:0] rows35[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows35[0][i] <= rows35[0][i-1];
			rows35[1][i] <= rows35[1][i-1];
			rows35[2][i] <= rows35[2][i-1];
			rows35[3][i] <= rows35[3][i-1];
			rows35[4][i] <= rows35[4][i-1];
		end
		rows35[0][0] <= rb_S2C3[1*4+3];
		rows35[1][0] <= rb_S2C3[1*4+2];
		rows35[2][0] <= rb_S2C3[1*4+1];
		rows35[3][0] <= rb_S2C3[1*4+0];
		rows35[4][0] <= S2_poolOut[4];
end

reg signed [IN_WIDTH-1:0] rows36[0:4][0:4];
always @ (posedge clk) begin
		for (i = 4; i > 0; i = i-1) begin
			rows36[0][i] <= rows36[0][i-1];
			rows36[1][i] <= rows36[1][i-1];
			rows36[2][i] <= rows36[2][i-1];
			rows36[3][i] <= rows36[3][i-1];
			rows36[4][i] <= rows36[4][i-1];
		end
		rows36[0][0] <= rb_S2C3[2*4+3];
		rows36[1][0] <= rb_S2C3[2*4+2];
		rows36[2][0] <= rb_S2C3[2*4+1];
		rows36[3][0] <= rb_S2C3[2*4+0];
		rows36[4][0] <= S2_poolOut[5];
end




wire signed[OUT_WIDTH-1:0] conv_00, conv_01, conv_02, conv_03, conv_10, conv_11, conv_12, conv_13, conv_20, conv_21, conv_22, conv_23, conv_30, conv_31, conv_32, conv_33, conv_40, conv_41, conv_42, conv_43, conv_50, conv_51, conv_52, conv_53;
wire signed[OUT_WIDTH-1:0] sum_00, sum_01, sum_10, sum_11, sum_20, sum_21, sum_30, sum_31, sum_40, sum_41, sum_50, sum_51;  
wire signed[OUT_WIDTH-1:0] conv_Value_0, conv_Value_1, conv_Value_2, conv_Value_3, conv_Value_4, conv_Value_5;


conv33_6bit_DSP CONV_33_DSP_24 (.in_data_0(rows01[4][0]), .in_data_1(rows01[4][1]), .in_data_2(rows01[4][2]), .in_data_3(rows01[4][3]), .in_data_4(rows01[4][4]), .in_data_5(rows01[3][0]), .in_data_6(rows01[3][1]), .in_data_7(rows01[3][2]), .in_data_8(rows01[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(0*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_00));
conv33_6bit_PIM CONV_33_DSP_25 (.in_data_0(rows11[4][0]), .in_data_1(rows11[4][1]), .in_data_2(rows11[4][2]), .in_data_3(rows11[4][3]), .in_data_4(rows11[4][4]), .in_data_5(rows11[3][0]), .in_data_6(rows11[3][1]), .in_data_7(rows11[3][2]), .in_data_8(rows11[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_01));
conv33_6bit_DSP CONV_33_DSP_26 (.in_data_0(rows21[4][0]), .in_data_1(rows21[4][1]), .in_data_2(rows21[4][2]), .in_data_3(rows21[4][3]), .in_data_4(rows21[4][4]), .in_data_5(rows21[3][0]), .in_data_6(rows21[3][1]), .in_data_7(rows21[3][2]), .in_data_8(rows21[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_02));
conv33_6bit_DSP CONV_33_DSP_27 (.in_data_0(rows31[4][0]), .in_data_1(rows31[4][1]), .in_data_2(rows31[4][2]), .in_data_3(rows31[4][3]), .in_data_4(rows31[4][4]), .in_data_5(rows31[3][0]), .in_data_6(rows31[3][1]), .in_data_7(rows31[3][2]), .in_data_8(rows31[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(0*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_03));

assign sum_00 = conv_00 + conv_01 + conv_03;
assign sum_01 = conv_02 + rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE) + 1*IN_WIDTH: IN_WIDTH*(3*4*CONVSIZE)];
assign conv_Value_0 = sum_00 + sum_01;




conv33_6bit_DSP CONV_33_DSP_28 (.in_data_0(rows02[4][0]), .in_data_1(rows02[4][1]), .in_data_2(rows02[4][2]), .in_data_3(rows02[4][3]), .in_data_4(rows02[4][4]), .in_data_5(rows02[3][0]), .in_data_6(rows02[3][1]), .in_data_7(rows02[3][2]), .in_data_8(rows02[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_10));
conv33_6bit_DSP CONV_33_DSP_29 (.in_data_0(rows12[4][0]), .in_data_1(rows12[4][1]), .in_data_2(rows12[4][2]), .in_data_3(rows12[4][3]), .in_data_4(rows12[4][4]), .in_data_5(rows12[3][0]), .in_data_6(rows12[3][1]), .in_data_7(rows12[3][2]), .in_data_8(rows12[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(1*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_11));
conv33_6bit_CLB CONV_33_DSP_30 (.in_data_0(rows22[4][0]), .in_data_1(rows22[4][1]), .in_data_2(rows22[4][2]), .in_data_3(rows22[4][3]), .in_data_4(rows22[4][4]), .in_data_5(rows22[3][0]), .in_data_6(rows22[3][1]), .in_data_7(rows22[3][2]), .in_data_8(rows22[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_12));
conv33_6bit_DSP CONV_33_DSP_31 (.in_data_0(rows32[4][0]), .in_data_1(rows32[4][1]), .in_data_2(rows32[4][2]), .in_data_3(rows32[4][3]), .in_data_4(rows32[4][4]), .in_data_5(rows32[3][0]), .in_data_6(rows32[3][1]), .in_data_7(rows32[3][2]), .in_data_8(rows32[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(1*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_13));

assign sum_10 = conv_10 + conv_11 + conv_13;
assign sum_11 = conv_12 + rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE) + 2*IN_WIDTH: IN_WIDTH*(3*4*CONVSIZE)+1*IN_WIDTH];
assign conv_Value_1 = sum_10 + sum_11;

conv33_6bit_DSP CONV_33_DSP_32 (.in_data_0(rows03[4][0]), .in_data_1(rows03[4][1]), .in_data_2(rows03[4][2]), .in_data_3(rows03[4][3]), .in_data_4(rows03[4][4]), .in_data_5(rows03[3][0]), .in_data_6(rows03[3][1]), .in_data_7(rows03[3][2]), .in_data_8(rows03[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_20));
conv33_6bit_CLB CONV_33_DSP_33 (.in_data_0(rows13[4][0]), .in_data_1(rows13[4][1]), .in_data_2(rows13[4][2]), .in_data_3(rows13[4][3]), .in_data_4(rows13[4][4]), .in_data_5(rows13[3][0]), .in_data_6(rows13[3][1]), .in_data_7(rows13[3][2]), .in_data_8(rows13[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_21));
conv33_6bit_PIM CONV_33_DSP_34 (.in_data_0(rows23[4][0]), .in_data_1(rows23[4][1]), .in_data_2(rows23[4][2]), .in_data_3(rows23[4][3]), .in_data_4(rows23[4][4]), .in_data_5(rows23[3][0]), .in_data_6(rows23[3][1]), .in_data_7(rows23[3][2]), .in_data_8(rows23[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_22));
conv33_6bit_DSP CONV_33_DSP_35 (.in_data_0(rows33[4][0]), .in_data_1(rows33[4][1]), .in_data_2(rows33[4][2]), .in_data_3(rows33[4][3]), .in_data_4(rows33[4][4]), .in_data_5(rows33[3][0]), .in_data_6(rows33[3][1]), .in_data_7(rows33[3][2]), .in_data_8(rows33[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(2*4*CONVSIZE)+IN_WIDTH*(2*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_23));

assign sum_20 = conv_20 + conv_21 + conv_23;
assign sum_21 = conv_22 + rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE) + 3*IN_WIDTH: IN_WIDTH*(3*4*CONVSIZE)+2*IN_WIDTH];
assign conv_Value_2 = sum_20 + sum_21;

conv33_6bit_DSP CONV_33_DSP_36 (.in_data_0(rows04[4][0]), .in_data_1(rows04[4][1]), .in_data_2(rows04[4][2]), .in_data_3(rows04[4][3]), .in_data_4(rows04[4][4]), .in_data_5(rows04[3][0]), .in_data_6(rows04[3][1]), .in_data_7(rows04[3][2]), .in_data_8(rows04[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_30));
conv33_6bit_PIM CONV_33_DSP_37 (.in_data_0(rows14[4][0]), .in_data_1(rows14[4][1]), .in_data_2(rows14[4][2]), .in_data_3(rows14[4][3]), .in_data_4(rows14[4][4]), .in_data_5(rows14[3][0]), .in_data_6(rows14[3][1]), .in_data_7(rows14[3][2]), .in_data_8(rows14[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_31));
conv33_6bit_PIM CONV_33_DSP_38 (.in_data_0(rows24[4][0]), .in_data_1(rows24[4][1]), .in_data_2(rows24[4][2]), .in_data_3(rows24[4][3]), .in_data_4(rows24[4][4]), .in_data_5(rows24[3][0]), .in_data_6(rows24[3][1]), .in_data_7(rows24[3][2]), .in_data_8(rows24[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_32));
conv33_6bit_PIM CONV_33_DSP_39 (.in_data_0(rows34[4][0]), .in_data_1(rows34[4][1]), .in_data_2(rows34[4][2]), .in_data_3(rows34[4][3]), .in_data_4(rows34[4][4]), .in_data_5(rows34[3][0]), .in_data_6(rows34[3][1]), .in_data_7(rows34[3][2]), .in_data_8(rows34[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(3*4*CONVSIZE)+IN_WIDTH*(3*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_33));

assign sum_30 = conv_30 + conv_31 + conv_33;
assign sum_31 = conv_32 + rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE) + 4*IN_WIDTH: IN_WIDTH*(3*4*CONVSIZE)+3*IN_WIDTH];
assign conv_Value_3 = sum_30 + sum_31;

conv33_6bit_PIM CONV_33_DSP_40 (.in_data_0(rows05[4][0]), .in_data_1(rows05[4][1]), .in_data_2(rows05[4][2]), .in_data_3(rows05[4][3]), .in_data_4(rows05[4][4]), .in_data_5(rows05[3][0]), .in_data_6(rows05[3][1]), .in_data_7(rows05[3][2]), .in_data_8(rows05[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_40));
conv33_6bit_DSP CONV_33_DSP_41 (.in_data_0(rows15[4][0]), .in_data_1(rows15[4][1]), .in_data_2(rows15[4][2]), .in_data_3(rows15[4][3]), .in_data_4(rows15[4][4]), .in_data_5(rows15[3][0]), .in_data_6(rows15[3][1]), .in_data_7(rows15[3][2]), .in_data_8(rows15[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_41));
conv33_6bit_PIM CONV_33_DSP_42 (.in_data_0(rows25[4][0]), .in_data_1(rows25[4][1]), .in_data_2(rows25[4][2]), .in_data_3(rows25[4][3]), .in_data_4(rows25[4][4]), .in_data_5(rows25[3][0]), .in_data_6(rows25[3][1]), .in_data_7(rows25[3][2]), .in_data_8(rows25[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_42));
conv33_6bit_PIM CONV_33_DSP_43 (.in_data_0(rows35[4][0]), .in_data_1(rows35[4][1]), .in_data_2(rows35[4][2]), .in_data_3(rows35[4][3]), .in_data_4(rows35[4][4]), .in_data_5(rows35[3][0]), .in_data_6(rows35[3][1]), .in_data_7(rows35[3][2]), .in_data_8(rows35[3][3]), .kernel_0(rom_c3_x5[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x5[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x5[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x5[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x5[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x5[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x5[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x5[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x5[IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(4*4*CONVSIZE)+IN_WIDTH*(4*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_43));

assign sum_40 = conv_40 + conv_41 + conv_43;
assign sum_41 = conv_42 + rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE) + 5*IN_WIDTH: IN_WIDTH*(3*4*CONVSIZE)+4*IN_WIDTH];
assign conv_Value_4 = sum_40 + sum_41;

conv33_6bit_DSP CONV_33_DSP_44 (.in_data_0(rows06[4][0]), .in_data_1(rows06[4][1]), .in_data_2(rows06[4][2]), .in_data_3(rows06[4][3]), .in_data_4(rows06[4][4]), .in_data_5(rows06[3][0]), .in_data_6(rows06[3][1]), .in_data_7(rows06[3][2]), .in_data_8(rows06[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_50));
conv33_6bit_PIM CONV_33_DSP_45 (.in_data_0(rows16[4][0]), .in_data_1(rows16[4][1]), .in_data_2(rows16[4][2]), .in_data_3(rows16[4][3]), .in_data_4(rows16[4][4]), .in_data_5(rows16[3][0]), .in_data_6(rows16[3][1]), .in_data_7(rows16[3][2]), .in_data_8(rows16[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_51));
conv33_6bit_DSP CONV_33_DSP_46 (.in_data_0(rows26[4][0]), .in_data_1(rows26[4][1]), .in_data_2(rows26[4][2]), .in_data_3(rows26[4][3]), .in_data_4(rows26[4][4]), .in_data_5(rows26[3][0]), .in_data_6(rows26[3][1]), .in_data_7(rows26[3][2]), .in_data_8(rows26[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_52));
conv33_6bit_PIM CONV_33_DSP_47 (.in_data_0(rows36[4][0]), .in_data_1(rows36[4][1]), .in_data_2(rows36[4][2]), .in_data_3(rows36[4][3]), .in_data_4(rows36[4][4]), .in_data_5(rows36[3][0]), .in_data_6(rows36[3][1]), .in_data_7(rows36[3][2]), .in_data_8(rows36[3][3]), .kernel_0(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c3_x4[IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*(5*4*CONVSIZE)+IN_WIDTH*(5*CONVSIZE)+IN_WIDTH*8]), .clk(clk), .out_data(conv_53));

assign sum_50 = conv_50 + conv_51 + conv_53;
assign sum_51 = conv_52 + rom_c3_x4[IN_WIDTH*(3*4*CONVSIZE) + 6*IN_WIDTH: IN_WIDTH*(3*4*CONVSIZE)+5*IN_WIDTH];
assign conv_Value_5 = sum_50 + sum_51;



relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_7 (.in(conv_Value_0), .out(C3_relu[6]));
relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_8 (.in(conv_Value_1), .out(C3_relu[7]));
relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_9 (.in(conv_Value_2), .out(C3_relu[8]));
relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_10 (.in(conv_Value_3), .out(C3_relu[9]));
relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_11 (.in(conv_Value_4), .out(C3_relu[10]));
relu #(.BIT_WIDTH(OUT_WIDTH)) C3_RELU_12 (.in(conv_Value_5), .out(C3_relu[11]));

assign out2 = C3_relu[6] | C3_relu[7]  | C3_relu[8] | C3_relu[9] | C3_relu[10] | C3_relu[11];


endmodule