module add_channel_3 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 8) (
    input [3*BIT_WIDTH-1:0] conv,
    output [OUT_WIDTH-1:0] convValue
);
    wire signed[OUT_WIDTH-1:0] sum00;


    qadd #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) add1(conv[((0+1)*BIT_WIDTH)-1:((0)*BIT_WIDTH)], conv[((1+1)*BIT_WIDTH)-1:((1)*BIT_WIDTH)], sum00);
    qadd #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) add2(conv[((2+1)*BIT_WIDTH)-1:((2)*BIT_WIDTH)], sum00, convValue);

endmodule
