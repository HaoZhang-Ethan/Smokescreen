
module multiplier(input [7:0] a, b, output [15:0] p);
    reg [7:0] multiplier_reg;
    reg [15:0] result_reg;

    always @(*) begin
        multiplier_reg = b;
        result_reg = {8'b0, a};
        if (multiplier_reg[0]) result_reg = result_reg + {15'b0, a};
        if (multiplier_reg[1]) result_reg = result_reg + {14'b0, a} << 1;
        if (multiplier_reg[2]) result_reg = result_reg + {13'b0, a} << 2;
        if (multiplier_reg[3]) result_reg = result_reg + {12'b0, a} << 3;
        if (multiplier_reg[4]) result_reg = result_reg + {11'b0, a} << 4;
        if (multiplier_reg[5]) result_reg = result_reg + {10'b0, a} << 5;
        if (multiplier_reg[6]) result_reg = result_reg + {9'b0, a} << 6;
        if (multiplier_reg[7]) result_reg = result_reg + {8'b0, a} << 7;
    end

    assign p = result_reg;
endmodule
