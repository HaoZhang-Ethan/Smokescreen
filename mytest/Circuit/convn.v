module convn #(parameter BIT_WIDTH = 8, OUT_WIDTH = 8, KERNEL_SIZE = 5, CHANNEL = 3, DEPTH = 8) (
		// input clk, //rst,
		// input en,	// whether to latch or not
		input [(BIT_WIDTH*KERNEL_SIZE*KERNEL_SIZE*CHANNEL)-1:0] input_feature,
        input [(BIT_WIDTH*KERNEL_SIZE*KERNEL_SIZE*CHANNEL)-1:0] filter,	// 5x5x3 filter
        output [OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);


    wire [OUT_WIDTH-1:0] conv[CHANNEL];
    parameter SIZE = 25;	// 5x5 filter

    wire [CHANNEL*OUT_WIDTH-1:0] mout;


    genvar i;
    generate
        for (i = 0; i < CHANNEL; i = i+1) begin : gen_conv
            conv55_dsp #( .BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) CONV(
            .feature(input_feature[(BIT_WIDTH*(i+1)*KERNEL_SIZE*KERNEL_SIZE)-1: (BIT_WIDTH*i*KERNEL_SIZE*KERNEL_SIZE)]),
            .filter(filter[(BIT_WIDTH*(i+1)*KERNEL_SIZE*KERNEL_SIZE)-1: (BIT_WIDTH*i*KERNEL_SIZE*KERNEL_SIZE)]),
            .convValue(convValue)
            );
        end
    endgenerate
    if (CHANNEL == 1) begin
        assign convValue = conv[0];
    end else if (CHANNEL == 6) begin
    add_channel_6 ADD6 ({conv[5],conv[4],conv[3],conv[4],conv[1],conv[0]},convValue);
    end else if (CHANNEL == 4) begin
    add_channel_4 ADD4 ({conv[3],conv[4],conv[1],conv[0]},convValue);
    end else if (CHANNEL == 3) begin
    add_channel_3 ADD3 ({conv[4],conv[1],conv[0]},convValue);
    end else if (CHANNEL == 16) begin
    add_channel_16 ADD16 ({conv[15],conv[14],conv[13],conv[12],conv[11],conv[10],conv[9],conv[8],conv[7],conv[6],conv[5],conv[4],conv[3],conv[4],conv[1],conv[0]},convValue);
    end


endmodule



















