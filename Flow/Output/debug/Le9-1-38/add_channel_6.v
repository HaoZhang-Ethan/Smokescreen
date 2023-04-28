module add_channel_6 #(parameter BIT_WIDTH = 8, OUT_WIDTH = 8) (
    input [6*BIT_WIDTH-1:0] conv,
    output [OUT_WIDTH-1:0] convValue
);
    wire signed[OUT_WIDTH-1:0] sum00, sum01, sum02, sum10;


    qadd #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) add1(conv[((0+1)*BIT_WIDTH)-1:((0)*BIT_WIDTH)], conv[((1+1)*BIT_WIDTH)-1:((1)*BIT_WIDTH)], sum00);
    qadd #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) add2(conv[((2+1)*BIT_WIDTH)-1:((2)*BIT_WIDTH)], conv[((3+1)*BIT_WIDTH)-1:((3)*BIT_WIDTH)], sum01);
    qadd #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) add3(conv[((4+1)*BIT_WIDTH)-1:((4)*BIT_WIDTH)], conv[((5+1)*BIT_WIDTH)-1:((5)*BIT_WIDTH)], sum02);

    qadd #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) add4(sum00, sum01, sum10);
    qadd #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) add5(sum02, sum10, convValue);

endmodule