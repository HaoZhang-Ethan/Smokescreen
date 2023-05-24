`define INPUT_BIT 6

function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction

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

    output [7:0] result_0, // 输出结果的第一个元素
    input clk,
);


wire signed [7:0] mul_res_0;
conv #(.INPUT_SIZE(192), .DEPTH(clogb2(2)), .ADC_P(6)) single_mvm(
    .Input_feature({vector_in_0, vector_in_1, vector_in_2, vector_in_3, vector_in_4, vector_in_5, vector_in_6, vector_in_7, vector_in_8, vector_in_9, vector_in_10, vector_in_11, vector_in_12, vector_in_13, vector_in_14, vector_in_15, vector_in_16, vector_in_17, vector_in_18, vector_in_19, vector_in_20, vector_in_21, vector_in_22, vector_in_23, vector_in_24, vector_in_25, vector_in_26, vector_in_27, vector_in_28, vector_in_29, vector_in_30, vector_in_31}),
    .Address(0),
    .en(1'b1),
    .Output(mul_res_0),
    .clk(clk)
);

assign result_0 = mul_res_0;



endmodule
