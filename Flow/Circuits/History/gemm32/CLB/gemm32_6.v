`define INPUT_BIT 6

module gemm(
    input signed [`INPUT_BIT-1:0] vector_in_0, // 输入向量的第一个元素
    input signed [`INPUT_BIT-1:0] vector_in_1,
    input signed [`INPUT_BIT-1:0] vector_in_2,
    input signed [`INPUT_BIT-1:0] vector_in_3,
    input signed [`INPUT_BIT-1:0] vector_in_4,
    input signed [`INPUT_BIT-1:0] vector_in_5,
    input signed [`INPUT_BIT-1:0] vector_in_6,
    input signed [`INPUT_BIT-1:0] vector_in_7,
    input signed [`INPUT_BIT-1:0] vector_in_8,
    input signed [`INPUT_BIT-1:0] vector_in_9,
    input signed [`INPUT_BIT-1:0] vector_in_10,
    input signed [`INPUT_BIT-1:0] vector_in_11,
    input signed [`INPUT_BIT-1:0] vector_in_12,
    input signed [`INPUT_BIT-1:0] vector_in_13,
    input signed [`INPUT_BIT-1:0] vector_in_14,
    input signed [`INPUT_BIT-1:0] vector_in_15,
    input signed [`INPUT_BIT-1:0] vector_in_16,
    input signed [`INPUT_BIT-1:0] vector_in_17,
    input signed [`INPUT_BIT-1:0] vector_in_18,
    input signed [`INPUT_BIT-1:0] vector_in_19,
    input signed [`INPUT_BIT-1:0] vector_in_20,
    input signed [`INPUT_BIT-1:0] vector_in_21,
    input signed [`INPUT_BIT-1:0] vector_in_22,
    input signed [`INPUT_BIT-1:0] vector_in_23,
    input signed [`INPUT_BIT-1:0] vector_in_24,
    input signed [`INPUT_BIT-1:0] vector_in_25,
    input signed [`INPUT_BIT-1:0] vector_in_26,
    input signed [`INPUT_BIT-1:0] vector_in_27,
    input signed [`INPUT_BIT-1:0] vector_in_28,
    input signed [`INPUT_BIT-1:0] vector_in_29,
    input signed [`INPUT_BIT-1:0] vector_in_30,
    input signed [`INPUT_BIT-1:0] vector_in_31,   
    input signed [`INPUT_BIT-1:0] matrix_in_00, // 输入矩阵的第一个元素
    input signed [`INPUT_BIT-1:0] matrix_in_01,
    input signed [`INPUT_BIT-1:0] matrix_in_02,
    input signed [`INPUT_BIT-1:0] matrix_in_03,
    input signed [`INPUT_BIT-1:0] matrix_in_04,
    input signed [`INPUT_BIT-1:0] matrix_in_05,
    input signed [`INPUT_BIT-1:0] matrix_in_06,
    input signed [`INPUT_BIT-1:0] matrix_in_07,
    input signed [`INPUT_BIT-1:0] matrix_in_08,
    input signed [`INPUT_BIT-1:0] matrix_in_09,
    input signed [`INPUT_BIT-1:0] matrix_in_10,
    input signed [`INPUT_BIT-1:0] matrix_in_11,
    input signed [`INPUT_BIT-1:0] matrix_in_12,
    input signed [`INPUT_BIT-1:0] matrix_in_13,
    input signed [`INPUT_BIT-1:0] matrix_in_14,
    input signed [`INPUT_BIT-1:0] matrix_in_15,
    input signed [`INPUT_BIT-1:0] matrix_in_16,
    input signed [`INPUT_BIT-1:0] matrix_in_17,
    input signed [`INPUT_BIT-1:0] matrix_in_18,
    input signed [`INPUT_BIT-1:0] matrix_in_19,
    input signed [`INPUT_BIT-1:0] matrix_in_20,
    input signed [`INPUT_BIT-1:0] matrix_in_21,
    input signed [`INPUT_BIT-1:0] matrix_in_22,
    input signed [`INPUT_BIT-1:0] matrix_in_23,
    input signed [`INPUT_BIT-1:0] matrix_in_24,
    input signed [`INPUT_BIT-1:0] matrix_in_25,
    input signed [`INPUT_BIT-1:0] matrix_in_26,
    input signed [`INPUT_BIT-1:0] matrix_in_27,
    input signed [`INPUT_BIT-1:0] matrix_in_28,
    input signed [`INPUT_BIT-1:0] matrix_in_29,
    input signed [`INPUT_BIT-1:0] matrix_in_30,
    input signed [`INPUT_BIT-1:0] matrix_in_31,

    output [100:0] result_0, // 输出结果的第一个元素

);

wire signed [8:0] mul_00, mul_01, mul_02, mul_03, mul_04, mul_05, mul_06, mul_07, mul_08, mul_09, mul_10, mul_11, mul_12, mul_13, mul_14, mul_15, mul_16, mul_17, mul_18, mul_19, mul_20, mul_21, mul_22, mul_23, mul_24, mul_25, mul_26, mul_27, mul_28, mul_29, mul_30, mul_31;
wire signed [100:0] mul_res_0;


multiplier inst_mul_00 (.a(vector_in_0), .b(matrix_in_00), .p(mul_00));
multiplier inst_mul_01 (.a(vector_in_1), .b(matrix_in_01), .p(mul_01));
multiplier inst_mul_02 (.a(vector_in_2), .b(matrix_in_02), .p(mul_02));
multiplier inst_mul_03 (.a(vector_in_3), .b(matrix_in_03), .p(mul_03));
multiplier inst_mul_04 (.a(vector_in_4), .b(matrix_in_04), .p(mul_04));
multiplier inst_mul_05 (.a(vector_in_5), .b(matrix_in_05), .p(mul_05));
multiplier inst_mul_06 (.a(vector_in_6), .b(matrix_in_06), .p(mul_06));
multiplier inst_mul_07 (.a(vector_in_7), .b(matrix_in_07), .p(mul_07));
multiplier inst_mul_08 (.a(vector_in_8), .b(matrix_in_08), .p(mul_08));
multiplier inst_mul_09 (.a(vector_in_9), .b(matrix_in_09), .p(mul_09));
multiplier inst_mul_10 (.a(vector_in_10), .b(matrix_in_10), .p(mul_10));
multiplier inst_mul_11 (.a(vector_in_11), .b(matrix_in_11), .p(mul_11));
multiplier inst_mul_12 (.a(vector_in_12), .b(matrix_in_12), .p(mul_12));
multiplier inst_mul_13 (.a(vector_in_13), .b(matrix_in_13), .p(mul_13));
multiplier inst_mul_14 (.a(vector_in_14), .b(matrix_in_14), .p(mul_14));
multiplier inst_mul_15 (.a(vector_in_15), .b(matrix_in_15), .p(mul_15));
multiplier inst_mul_16 (.a(vector_in_16), .b(matrix_in_16), .p(mul_16));
multiplier inst_mul_17 (.a(vector_in_17), .b(matrix_in_17), .p(mul_17));
multiplier inst_mul_18 (.a(vector_in_18), .b(matrix_in_18), .p(mul_18));
multiplier inst_mul_19 (.a(vector_in_19), .b(matrix_in_19), .p(mul_19));
multiplier inst_mul_20 (.a(vector_in_20), .b(matrix_in_20), .p(mul_20));
multiplier inst_mul_21 (.a(vector_in_21), .b(matrix_in_21), .p(mul_21));
multiplier inst_mul_22 (.a(vector_in_22), .b(matrix_in_22), .p(mul_22));
multiplier inst_mul_23 (.a(vector_in_23), .b(matrix_in_23), .p(mul_23));
multiplier inst_mul_24 (.a(vector_in_24), .b(matrix_in_24), .p(mul_24));
multiplier inst_mul_25 (.a(vector_in_25), .b(matrix_in_25), .p(mul_25));
multiplier inst_mul_26 (.a(vector_in_26), .b(matrix_in_26), .p(mul_26));
multiplier inst_mul_27 (.a(vector_in_27), .b(matrix_in_27), .p(mul_27));
multiplier inst_mul_28 (.a(vector_in_28), .b(matrix_in_28), .p(mul_28));
multiplier inst_mul_29 (.a(vector_in_29), .b(matrix_in_29), .p(mul_29));
multiplier inst_mul_30 (.a(vector_in_30), .b(matrix_in_30), .p(mul_30));
multiplier inst_mul_31 (.a(vector_in_31), .b(matrix_in_31), .p(mul_31));


assign mul_res_0 = mul_00 + mul_01 + mul_02 + mul_03 + mul_04 + mul_05 + mul_06 + mul_07 + mul_08 + mul_09 + mul_10 + mul_11 + mul_12 + mul_13 + mul_14 + mul_15 + mul_16 + mul_17 + mul_18 + mul_19 + mul_20 + mul_21 + mul_22 + mul_23 + mul_24 + mul_25 + mul_26 + mul_27 + mul_28 + mul_29 + mul_30 + mul_31;
assign result_0 = mul_res_0;



endmodule


module multiplier(input [5:0] a, b, output [11:0] p);
    reg [5:0] multiplier_reg;
    reg [11:0] result_reg;

    always @(*) begin
        multiplier_reg = b;
        result_reg = {6'b0, a};
        if (multiplier_reg[0]) result_reg = result_reg + {11'b0, a};
        if (multiplier_reg[1]) result_reg = result_reg + {10'b0, a} << 1;
        if (multiplier_reg[2]) result_reg = result_reg + {9'b0, a} << 2;
        if (multiplier_reg[3]) result_reg = result_reg + {8'b0, a} << 3;
        if (multiplier_reg[4]) result_reg = result_reg + {7'b0, a} << 4;
        if (multiplier_reg[5]) result_reg = result_reg + {6'b0, a} << 5;
    end

    assign p = result_reg;
endmodule