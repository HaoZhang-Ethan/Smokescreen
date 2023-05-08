module Inception (
  input [5:0] in_channels,
  input clk;
  input en;
  output done;
  output [5:0] out_channels
);



// 1x1 conv
conv11_6bit_DSP CONV_11_01 (
    .in_data_0(in_channels),
    .kernel_0(1),
    .out_data(out_channels[0])
);





endmodule

