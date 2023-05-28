
module lenet5 #(parameter IMAGE_COLS = 32, IN_WIDTH = 6, OUT_WIDTH = 18) (
	input clk, rst,
	input signed[IN_WIDTH-1:0] nextPixel,
	output [17:0] out,	// the predicted digit
	// output signed[HALF_WIDTH-1:0] tmp_out
);



reg signed [6-1:0] rowsi1[0:4][0:4];
conv55_6bit CONV_55_DSP_1 (
    .in_data_0(rowsi1[4][0]), 
    .in_data_1(rowsi1[4][1]), 
    .in_data_2(rowsi1[4][2]), 
    .in_data_3(rowsi1[4][3]), 
    .in_data_4(rowsi1[4][4]), 
    .in_data_5(rowsi1[3][0]), 
    .in_data_6(rowsi1[3][1]), 
    .in_data_7(rowsi1[3][2]), 
    .in_data_8(rowsi1[3][3]), 
    .in_data_9(rowsi1[3][4]), 
    .in_data_10(rowsi1[2][0]), 
    .in_data_11(rowsi1[2][1]), 
    .in_data_12(rowsi1[2][2]), 
    .in_data_13(rowsi1[2][3]), 
    .in_data_14(rowsi1[2][4]), 
    .in_data_15(rowsi1[1][0]), 
    .in_data_16(rowsi1[1][1]), 
    .in_data_17(rowsi1[1][2]), 
    .in_data_18(rowsi1[1][3]), 
    .in_data_19(rowsi1[1][4]), 
    .in_data_20(rowsi1[0][0]), 
    .in_data_21(rowsi1[0][1]), 
    .in_data_22(rowsi1[0][2]), 
    .in_data_23(rowsi1[0][3]), 
    .in_data_24(rowsi1[0][4]), 
    .kernel_0(rowsi1[0][4]), 
    .kernel_1(rowsi1[0][3]),
    .kernel_2(rowsi1[0][2]),
    .kernel_3(rowsi1[0][1]),
    .kernel_4(rowsi1[0][0]),
    .kernel_5(rowsi1[1][4]),
    .kernel_6(rowsi1[1][3]),
    .kernel_7(rowsi1[1][2]),
    .kernel_8(rowsi1[1][1]),
    .kernel_9(rowsi1[1][0]),
    .kernel_10(rowsi1[2][4]),
    .kernel_11(rowsi1[2][3]),
    .kernel_12(rowsi1[2][2]),
    .kernel_13(rowsi1[2][1]),
    .kernel_14(rowsi1[2][0]),
    .kernel_15(rowsi1[3][4]),
    .kernel_16(rowsi1[3][3]),
    .kernel_17(rowsi1[3][2]),
    .kernel_18(rowsi1[3][1]),
    .kernel_19(rowsi1[3][0]),
    .kernel_20(rowsi1[4][4]),
    .kernel_21(rowsi1[4][3]),
    .kernel_22(rowsi1[4][2]),
    .kernel_23(rowsi1[4][1]),
    .kernel_24(rowsi1[4][0]),
    .clk(clk), 
    .out_data(out)
    );

endmodule