module gemm(
    input signed [15:0] vector_in_0, // 输入向量的第一个元素
    input signed [15:0] vector_in_1,
    input signed [15:0] vector_in_2,
    input signed [15:0] vector_in_3,
    input signed [15:0] vector_in_4,
    input signed [15:0] vector_in_5,
    input signed [15:0] vector_in_6,
    input signed [15:0] vector_in_7,
    input signed [15:0] vector_in_8,
    input signed [15:0] vector_in_9,
    input signed [15:0] vector_in_10,
    input signed [15:0] vector_in_11,
    input signed [15:0] vector_in_12,
    input signed [15:0] vector_in_13,
    input signed [15:0] vector_in_14,
    input signed [15:0] vector_in_15,
    input signed [15:0] vector_in_16,
    input signed [15:0] vector_in_17,
    input signed [15:0] vector_in_18,
    input signed [15:0] vector_in_19,
    input signed [15:0] vector_in_20,
    input signed [15:0] vector_in_21,
    input signed [15:0] vector_in_22,
    input signed [15:0] vector_in_23,
    input signed [15:0] vector_in_24,
    input signed [15:0] vector_in_25,
    input signed [15:0] vector_in_26,
    input signed [15:0] vector_in_27,
    input signed [15:0] vector_in_28,
    input signed [15:0] vector_in_29,
    input signed [15:0] vector_in_30,
    input signed [15:0] vector_in_31,   
    input signed [15:0] matrix_in_00, // 输入矩阵的第一个元素
    input signed [15:0] matrix_in_01,
    input signed [15:0] matrix_in_02,
    input signed [15:0] matrix_in_03,
    input signed [15:0] matrix_in_04,
    input signed [15:0] matrix_in_05,
    input signed [15:0] matrix_in_06,
    input signed [15:0] matrix_in_07,
    input signed [15:0] matrix_in_08,
    input signed [15:0] matrix_in_09,
    input signed [15:0] matrix_in_10,
    input signed [15:0] matrix_in_11,
    input signed [15:0] matrix_in_12,
    input signed [15:0] matrix_in_13,
    input signed [15:0] matrix_in_14,
    input signed [15:0] matrix_in_15,
    input signed [15:0] matrix_in_16,
    input signed [15:0] matrix_in_17,
    input signed [15:0] matrix_in_18,
    input signed [15:0] matrix_in_19,
    input signed [15:0] matrix_in_20,
    input signed [15:0] matrix_in_21,
    input signed [15:0] matrix_in_22,
    input signed [15:0] matrix_in_23,
    input signed [15:0] matrix_in_24,
    input signed [15:0] matrix_in_25,
    input signed [15:0] matrix_in_26,
    input signed [15:0] matrix_in_27,
    input signed [15:0] matrix_in_28,
    input signed [15:0] matrix_in_29,
    input signed [15:0] matrix_in_30,
    input signed [15:0] matrix_in_31,

    output [80:0] result_0, // 输出结果的第一个元素

);

wire signed [31:0] mul_00, mul_01, mul_02, mul_03, mul_04, mul_05, mul_06, mul_07, mul_08, mul_09, mul_10, mul_11, mul_12, mul_13, mul_14, mul_15, mul_16, mul_17, mul_18, mul_19, mul_20, mul_21, mul_22, mul_23, mul_24, mul_25, mul_26, mul_27, mul_28, mul_29, mul_30, mul_31;
wire signed [80:0] mul_res_0;

assign mul_00 = vector_in_0 * matrix_in_00;
assign mul_01 = vector_in_1 * matrix_in_01;
assign mul_02 = vector_in_2 * matrix_in_02;
assign mul_03 = vector_in_3 * matrix_in_03;
assign mul_04 = vector_in_4 * matrix_in_04;
assign mul_05 = vector_in_5 * matrix_in_05;
assign mul_06 = vector_in_6 * matrix_in_06;
assign mul_07 = vector_in_7 * matrix_in_07;
assign mul_08 = vector_in_8 * matrix_in_08;
assign mul_09 = vector_in_9 * matrix_in_09;
assign mul_10 = vector_in_10 * matrix_in_10;
assign mul_11 = vector_in_11 * matrix_in_11;
assign mul_12 = vector_in_12 * matrix_in_12;
assign mul_13 = vector_in_13 * matrix_in_13;
assign mul_14 = vector_in_14 * matrix_in_14;
assign mul_15 = vector_in_15 * matrix_in_15;
assign mul_16 = vector_in_16 * matrix_in_16;
assign mul_17 = vector_in_17 * matrix_in_17;
assign mul_18 = vector_in_18 * matrix_in_18;
assign mul_19 = vector_in_19 * matrix_in_19;
assign mul_20 = vector_in_20 * matrix_in_20;
assign mul_21 = vector_in_21 * matrix_in_21;
assign mul_22 = vector_in_22 * matrix_in_22;
assign mul_23 = vector_in_23 * matrix_in_23;
assign mul_24 = vector_in_24 * matrix_in_24;
assign mul_25 = vector_in_25 * matrix_in_25;
assign mul_26 = vector_in_26 * matrix_in_26;
assign mul_27 = vector_in_27 * matrix_in_27;
assign mul_28 = vector_in_28 * matrix_in_28;
assign mul_29 = vector_in_29 * matrix_in_29;
assign mul_30 = vector_in_30 * matrix_in_30;
assign mul_31 = vector_in_31 * matrix_in_31;


assign mul_res_0 = mul_00 + mul_01 + mul_02 + mul_03 + mul_04 + mul_05 + mul_06 + mul_07 + mul_08 + mul_09 + mul_10 + mul_11 + mul_12 + mul_13 + mul_14 + mul_15 + mul_16 + mul_17 + mul_18 + mul_19 + mul_20 + mul_21 + mul_22 + mul_23 + mul_24 + mul_25 + mul_26 + mul_27 + mul_28 + mul_29 + mul_30 + mul_31;
assign result_0 = mul_res_0;



endmodule



