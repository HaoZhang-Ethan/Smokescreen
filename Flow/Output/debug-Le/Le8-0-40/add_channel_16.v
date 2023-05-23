module add_channel_16 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 8) (
    input [16*BIT_WIDTH-1:0] conv,
    output [OUT_WIDTH-1:0] convValue
);
    wire signed[OUT_WIDTH-1:0] sums[0:13];	// 16-2 intermediate sums
    genvar x;
    generate
        // sums[0] to sums[7]
        for (x = 0; x < 8; x = x+1) begin : addertree_nodes0
            qadd #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) ADD0(conv[(((x*2)+1)*BIT_WIDTH)-1:((x*2)*BIT_WIDTH)], conv[((((x*2)+1)+1)*BIT_WIDTH)-1:(((x*2)+1)*BIT_WIDTH)], sums[x]);
            // assign sums[x] = conv[x*2] + conv[x*2+1];
        end
        // sums[8] to sums[11]
        for (x = 0; x < 4; x = x+1) begin : addertree_nodes1
            qadd #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) ADD1(sums[x*2], sums[x*2+1], sums[x+8]);
            // assign sums[x+8] = sums[x*2] + sums[x*2+1];
        end
        // sums[12] to sums[13]
        for (x = 0; x < 2; x = x+1) begin : addertree_nodes2
            qadd #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) ADD2(sums[x*2+8], sums[x*2+9], sums[x+12]);
            // assign sums[x+12] = sums[x*2+8] + sums[x*2+9];
        end
    endgenerate

    qadd #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) ADD3(sums[12], sums[13], convValue);

endmodule
