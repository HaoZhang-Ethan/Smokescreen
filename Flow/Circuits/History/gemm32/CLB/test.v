module vector_multiplier(
    input [15:0] a, b, c,
    output reg [23:0] p, q, r
);

    reg signed [5:0] a0, a1, a2, b0, b1, b2, c0, c1, c2;

    // 拆分输入
    assign {a2, a1, a0} = a >> 6;
    assign {b2, b1, b0} = b >> 6;
    assign {c2, c1, c0} = c >> 6;

    // 计算乘积并相加
    always @(*) begin
        p = a0 * b0 + a1 * c0 + a2 * c0;
        q = a0 * b1 + a1 * c1 + a2 * c1;
        r = a0 * b2 + a1 * c2 + a2 * c2;
    end

endmodule
