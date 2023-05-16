module Inception (
  input [5:0] in_channels,
  input [5:0] kernel_1_0, kernel_1_1, kernel_1_2, kernel_1_3,
  input [5:0] kernel_3_0, kernel_3_1, kernel_3_2, kernel_3_3, kernel_3_4, kernel_3_5, kernel_3_6, kernel_3_7, kernel_3_8, 
  input [5:0] kernel_5_0, kernel_5_1, kernel_5_2, kernel_5_3, kernel_5_4, kernel_5_5, kernel_5_6, kernel_5_7, kernel_5_8, kernel_5_9, kernel_5_10, kernel_5_11, kernel_5_12, kernel_5_13, kernel_5_14, kernel_5_15, kernel_5_16, kernel_5_17, kernel_5_18, kernel_5_19, kernel_5_20, kernel_5_21, kernel_5_22, kernel_5_23, kernel_5_24,
  input clk,
  input en,
  input [5:0] in1, in2, in3,
  output done,
  output [5:0] out_channels
);



// 1x1 conv
conv11_6bit_DSP CONV_11_00 (
    .in_data_0(in_channels),
    .kernel_0(kernel_1_0),
    .clk(clk),
    .out_data(out_channels)
);

// // 1x1 conv
// conv11_6bit_DSP CONV_11_01 (
//     .in_data_0(in_channels),
//     .kernel_0(kernel_1_1),
//     .clk(clk),
//     .out_data(out_channels)
// );


// // 1x1 conv
// conv11_6bit_DSP CONV_11_02 (
//     .in_data_0(in_channels),
//     .kernel_0(kernel_1_2),
//     .clk(clk),
//     .out_data(out_channels)
// );


// // 1x1 conv
// conv11_6bit_DSP CONV_11_03 (
//     .in_data_0(in_channels),
//     .kernel_0(kernel_1_3),
//     .clk(clk),
//     .out_data(out_channels)
// );


// // 3x3 conv
// conv33_6bit_DSP CONV_33_00 (
//     .in_data_0(in_channels),
//     .kernel_0(kernel_3_0),
//     .clk(clk),
//     .out_data(out_channels)
// );

// row5buffer #(.COLS(5), .BIT_WIDTH(6)) S4_RB (
//     .clk(clk), .rst(rst),
//     .rb_in(S4_poolOut[g]),
//     .en(C5_en),
//     .rb_out0(rb_S4C5_r0[g]), .rb_out1(rb_S4C5_r1[g]), .rb_out2(rb_S4C5_r2[g]), .rb_out3(rb_S4C5_r3[g])
// );


// // 1x1 conv
// conv11_6bit_DSP CONV_11_01 (
//     .in_data_0(in_channels),
//     .kernel_0(1),
//     .out_data()
// );

// // 1x1 conv
// conv11_6bit_DSP CONV_11_01 (
//     .in_data_0(in_channels),
//     .kernel_0(1),
//     .out_data()
// );

// maxpool22 #(.BIT_WIDTH(OUT_WIDTH)) S4_POOL (
//     .clk(clk), //.rst(rst),
//     .en(en),
//     .in1(rb_C3S4[g]), .in2(C3_relu[g]),
//     .maxOut(S4_poolOut[g])
// );



endmodule

