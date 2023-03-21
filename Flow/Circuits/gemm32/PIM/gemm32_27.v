`define INPUT_BIT 6

function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction

module gemm(
    input signed [`INPUT_BIT-1:0] vector_in_0_0, vector_in_0_1, vector_in_0_2, vector_in_0_3, vector_in_0_4, 
    input signed [`INPUT_BIT-1:0] vector_in_1_0, vector_in_1_1, vector_in_1_2, vector_in_1_3, vector_in_1_4,
    input signed [`INPUT_BIT-1:0] vector_in_2_0, vector_in_2_1, vector_in_2_2, vector_in_2_3, vector_in_2_4,
    input signed [`INPUT_BIT-1:0] vector_in_3_0, vector_in_3_1, vector_in_3_2, vector_in_3_3, vector_in_3_4,
    input signed [`INPUT_BIT-1:0] vector_in_4_0, vector_in_4_1, vector_in_4_2, vector_in_4_3, vector_in_4_4,
    input signed [`INPUT_BIT-1:0] vector_in_5_0, vector_in_5_1, vector_in_5_2, vector_in_5_3, vector_in_5_4,
    input signed [`INPUT_BIT-1:0] vector_in_6_0, vector_in_6_1, vector_in_6_2, vector_in_6_3, vector_in_6_4,
    input signed [`INPUT_BIT-1:0] vector_in_7_0, vector_in_7_1, vector_in_7_2, vector_in_7_3, vector_in_7_4,
    input signed [`INPUT_BIT-1:0] vector_in_8_0, vector_in_8_1, vector_in_8_2, vector_in_8_3, vector_in_8_4,
    input signed [`INPUT_BIT-1:0] vector_in_9_0, vector_in_9_1, vector_in_9_2, vector_in_9_3, vector_in_9_4,
    input signed [`INPUT_BIT-1:0] vector_in_10_0, vector_in_10_1, vector_in_10_2, vector_in_10_3, vector_in_10_4,
    input signed [`INPUT_BIT-1:0] vector_in_11_0, vector_in_11_1, vector_in_11_2, vector_in_11_3, vector_in_11_4,
    input signed [`INPUT_BIT-1:0] vector_in_12_0, vector_in_12_1, vector_in_12_2, vector_in_12_3, vector_in_12_4,
    input signed [`INPUT_BIT-1:0] vector_in_13_0, vector_in_13_1, vector_in_13_2, vector_in_13_3, vector_in_13_4,
    input signed [`INPUT_BIT-1:0] vector_in_14_0, vector_in_14_1, vector_in_14_2, vector_in_14_3, vector_in_14_4,
    input signed [`INPUT_BIT-1:0] vector_in_15_0, vector_in_15_1, vector_in_15_2, vector_in_15_3, vector_in_15_4,
    input signed [`INPUT_BIT-1:0] vector_in_16_0, vector_in_16_1, vector_in_16_2, vector_in_16_3, vector_in_16_4,
    input signed [`INPUT_BIT-1:0] vector_in_17_0, vector_in_17_1, vector_in_17_2, vector_in_17_3, vector_in_17_4,
    input signed [`INPUT_BIT-1:0] vector_in_18_0, vector_in_18_1, vector_in_18_2, vector_in_18_3, vector_in_18_4,
    input signed [`INPUT_BIT-1:0] vector_in_19_0, vector_in_19_1, vector_in_19_2, vector_in_19_3, vector_in_19_4,
    input signed [`INPUT_BIT-1:0] vector_in_20_0, vector_in_20_1, vector_in_20_2, vector_in_20_3, vector_in_20_4,
    input signed [`INPUT_BIT-1:0] vector_in_21_0, vector_in_21_1, vector_in_21_2, vector_in_21_3, vector_in_21_4,
    input signed [`INPUT_BIT-1:0] vector_in_22_0, vector_in_22_1, vector_in_22_2, vector_in_22_3, vector_in_22_4,
    input signed [`INPUT_BIT-1:0] vector_in_23_0, vector_in_23_1, vector_in_23_2, vector_in_23_3, vector_in_23_4,
    input signed [`INPUT_BIT-1:0] vector_in_24_0, vector_in_24_1, vector_in_24_2, vector_in_24_3, vector_in_24_4, 
    input signed [`INPUT_BIT-1:0] vector_in_25_0, vector_in_25_1, vector_in_25_2, vector_in_25_3, vector_in_25_4,
    input signed [`INPUT_BIT-1:0] vector_in_26_0, vector_in_26_1, vector_in_26_2, vector_in_26_3, vector_in_26_4,
    input signed [`INPUT_BIT-1:0] vector_in_27_0, vector_in_27_1, vector_in_27_2, vector_in_27_3, vector_in_27_4,
    input signed [`INPUT_BIT-1:0] vector_in_28_0, vector_in_28_1, vector_in_28_2, vector_in_28_3, vector_in_28_4,
    input signed [`INPUT_BIT-1:0] vector_in_29_0, vector_in_29_1, vector_in_29_2, vector_in_29_3, vector_in_29_4,
    input signed [`INPUT_BIT-1:0] vector_in_30_0, vector_in_30_1, vector_in_30_2, vector_in_30_3, vector_in_30_4,
    input signed [`INPUT_BIT-1:0] vector_in_31_0, vector_in_31_1, vector_in_31_2, vector_in_31_3, vector_in_31_4,
    input signed [`INPUT_BIT-1:0] matrix_in_00_0, matrix_in_00_1, matrix_in_00_2, matrix_in_00_3, matrix_in_00_4,
    input signed [`INPUT_BIT-1:0] matrix_in_01_0, matrix_in_01_1, matrix_in_01_2, matrix_in_01_3, matrix_in_01_4,
    input signed [`INPUT_BIT-1:0] matrix_in_02_0, matrix_in_02_1, matrix_in_02_2, matrix_in_02_3, matrix_in_02_4,
    input signed [`INPUT_BIT-1:0] matrix_in_03_0, matrix_in_03_1, matrix_in_03_2, matrix_in_03_3, matrix_in_03_4,
    input signed [`INPUT_BIT-1:0] matrix_in_04_0, matrix_in_04_1, matrix_in_04_2, matrix_in_04_3, matrix_in_04_4,
    input signed [`INPUT_BIT-1:0] matrix_in_05_0, matrix_in_05_1, matrix_in_05_2, matrix_in_05_3, matrix_in_05_4,
    input signed [`INPUT_BIT-1:0] matrix_in_06_0, matrix_in_06_1, matrix_in_06_2, matrix_in_06_3, matrix_in_06_4,
    input signed [`INPUT_BIT-1:0] matrix_in_07_0, matrix_in_07_1, matrix_in_07_2, matrix_in_07_3, matrix_in_07_4,
    input signed [`INPUT_BIT-1:0] matrix_in_08_0, matrix_in_08_1, matrix_in_08_2, matrix_in_08_3, matrix_in_08_4,
    input signed [`INPUT_BIT-1:0] matrix_in_09_0, matrix_in_09_1, matrix_in_09_2, matrix_in_09_3, matrix_in_09_4,
    input signed [`INPUT_BIT-1:0] matrix_in_10_0, matrix_in_10_1, matrix_in_10_2, matrix_in_10_3, matrix_in_10_4,
    input signed [`INPUT_BIT-1:0] matrix_in_11_0, matrix_in_11_1, matrix_in_11_2, matrix_in_11_3, matrix_in_11_4,
    input signed [`INPUT_BIT-1:0] matrix_in_12_0, matrix_in_12_1, matrix_in_12_2, matrix_in_12_3, matrix_in_12_4,
    input signed [`INPUT_BIT-1:0] matrix_in_13_0, matrix_in_13_1, matrix_in_13_2, matrix_in_13_3, matrix_in_13_4,
    input signed [`INPUT_BIT-1:0] matrix_in_14_0, matrix_in_14_1, matrix_in_14_2, matrix_in_14_3, matrix_in_14_4,
    input signed [`INPUT_BIT-1:0] matrix_in_15_0, matrix_in_15_1, matrix_in_15_2, matrix_in_15_3, matrix_in_15_4,
    input signed [`INPUT_BIT-1:0] matrix_in_16_0, matrix_in_16_1, matrix_in_16_2, matrix_in_16_3, matrix_in_16_4,
    input signed [`INPUT_BIT-1:0] matrix_in_17_0, matrix_in_17_1, matrix_in_17_2, matrix_in_17_3, matrix_in_17_4,
    input signed [`INPUT_BIT-1:0] matrix_in_18_0, matrix_in_18_1, matrix_in_18_2, matrix_in_18_3, matrix_in_18_4,
    input signed [`INPUT_BIT-1:0] matrix_in_19_0, matrix_in_19_1, matrix_in_19_2, matrix_in_19_3, matrix_in_19_4,
    input signed [`INPUT_BIT-1:0] matrix_in_20_0, matrix_in_20_1, matrix_in_20_2, matrix_in_20_3, matrix_in_20_4,
    input signed [`INPUT_BIT-1:0] matrix_in_21_0, matrix_in_21_1, matrix_in_21_2, matrix_in_21_3, matrix_in_21_4,
    input signed [`INPUT_BIT-1:0] matrix_in_22_0, matrix_in_22_1, matrix_in_22_2, matrix_in_22_3, matrix_in_22_4,
    input signed [`INPUT_BIT-1:0] matrix_in_23_0, matrix_in_23_1, matrix_in_23_2, matrix_in_23_3, matrix_in_23_4,
    input signed [`INPUT_BIT-1:0] matrix_in_24_0, matrix_in_24_1, matrix_in_24_2, matrix_in_24_3, matrix_in_24_4,
    input signed [`INPUT_BIT-1:0] matrix_in_25_0, matrix_in_25_1, matrix_in_25_2, matrix_in_25_3, matrix_in_25_4,
    input signed [`INPUT_BIT-1:0] matrix_in_26_0, matrix_in_26_1, matrix_in_26_2, matrix_in_26_3, matrix_in_26_4,
    input signed [`INPUT_BIT-1:0] matrix_in_27_0, matrix_in_27_1, matrix_in_27_2, matrix_in_27_3, matrix_in_27_4,
    input signed [`INPUT_BIT-1:0] matrix_in_28_0, matrix_in_28_1, matrix_in_28_2, matrix_in_28_3, matrix_in_28_4,
    input signed [`INPUT_BIT-1:0] matrix_in_29_0, matrix_in_29_1, matrix_in_29_2, matrix_in_29_3, matrix_in_29_4,
    input signed [`INPUT_BIT-1:0] matrix_in_30_0, matrix_in_30_1, matrix_in_30_2, matrix_in_30_3, matrix_in_30_4,
    input signed [`INPUT_BIT-1:0] matrix_in_31_0, matrix_in_31_1, matrix_in_31_2, matrix_in_31_3, matrix_in_31_4,

    output [39:0] result_0, // 输出结果的第一个元素
    input clk,
);

   

    // assign {a2, a1, a0} = a >> 6;

wire signed [7:0] mul_res_0, mul_res_1, mul_res_2, mul_res_4, mul_res_5;
conv #(.INPUT_SIZE(192), .DEPTH(clogb2(2)), .ADC_P(6)) single_mvm_1(
    .Input_feature({vector_in_0_0, vector_in_1_0, vector_in_2_0, vector_in_3_0, vector_in_4_0, vector_in_5_0, vector_in_6_0, vector_in_7_0, vector_in_8_0, vector_in_9_0, vector_in_10_0, vector_in_11_0, vector_in_12_0, vector_in_13_0, vector_in_14_0, vector_in_15_0, vector_in_16_0, vector_in_17_0, vector_in_18_0, vector_in_19_0, vector_in_20_0, vector_in_21_0, vector_in_22_0, vector_in_23_0, vector_in_24_0, vector_in_25_0, vector_in_26_0, vector_in_27_0, vector_in_28_0, vector_in_29_0, vector_in_30_0, vector_in_31_0}),
    .Address(0),
    .en(1'b1),
    .Output(mul_res_0),
    .clk(clk)
);

conv #(.INPUT_SIZE(192), .DEPTH(clogb2(2)), .ADC_P(6)) single_mvm_2(
    .Input_feature({vector_in_0_1, vector_in_1_1, vector_in_2_1, vector_in_3_1, vector_in_4_1, vector_in_5_1, vector_in_6_1, vector_in_7_1, vector_in_8_1, vector_in_9_1, vector_in_10_1, vector_in_11_1, vector_in_12_1, vector_in_13_1, vector_in_14_1, vector_in_15_1, vector_in_16_1, vector_in_17_1, vector_in_18_1, vector_in_19_1, vector_in_20_1, vector_in_21_1, vector_in_22_1, vector_in_23_1, vector_in_24_1, vector_in_25_1, vector_in_26_1, vector_in_27_1, vector_in_28_1, vector_in_29_1, vector_in_30_1, vector_in_31_1}),
    .Address(0),
    .en(1'b1),
    .Output(mul_res_1),
    .clk(clk)
);

conv #(.INPUT_SIZE(192), .DEPTH(clogb2(2)), .ADC_P(6)) single_mvm_3(
    .Input_feature({vector_in_0_2, vector_in_1_2, vector_in_2_3, vector_in_3_2, vector_in_4_2, vector_in_5_2, vector_in_6_2, vector_in_7_2, vector_in_8_2, vector_in_9_2, vector_in_10_2, vector_in_11_2, vector_in_12_2, vector_in_13_2, vector_in_14_2, vector_in_15_2, vector_in_16_2, vector_in_17_2, vector_in_18_2, vector_in_19_2, vector_in_20_2, vector_in_21_2, vector_in_22_2, vector_in_23_2, vector_in_24_2, vector_in_25_2, vector_in_26_2, vector_in_27_2, vector_in_28_2, vector_in_29_2, vector_in_30_2, vector_in_31_2}),
    .Address(0),
    .en(1'b1),
    .Output(mul_res_2),
    .clk(clk)
);

conv #(.INPUT_SIZE(192), .DEPTH(clogb2(2)), .ADC_P(6)) single_mvm_4(
    .Input_feature({vector_in_0_3, vector_in_1_3, vector_in_2_3, vector_in_3_3, vector_in_4_3, vector_in_5_3, vector_in_6_3, vector_in_7_3, vector_in_8_3, vector_in_9_3, vector_in_10_3, vector_in_11_3, vector_in_12_3, vector_in_13_3, vector_in_14_3, vector_in_15_3, vector_in_16_3, vector_in_17_3, vector_in_18_3, vector_in_19_3, vector_in_20_3, vector_in_21_3, vector_in_22_3, vector_in_23_3, vector_in_24_3, vector_in_25_3, vector_in_26_3, vector_in_27_3, vector_in_28_3, vector_in_29_3, vector_in_30_3, vector_in_31_3}),
    .Address(0),
    .en(1'b1),
    .Output(mul_res_3),
    .clk(clk)
);

conv #(.INPUT_SIZE(192), .DEPTH(clogb2(2)), .ADC_P(6)) single_mvm_5(
    .Input_feature({vector_in_0_4, vector_in_1_4, vector_in_2_4, vector_in_3_4, vector_in_4_4, vector_in_5_4, vector_in_6_4, vector_in_7_4, vector_in_8_4, vector_in_9_4, vector_in_10_4, vector_in_11_4, vector_in_12_4, vector_in_13_4, vector_in_14_4, vector_in_15_4, vector_in_16_4, vector_in_17_4, vector_in_18_4, vector_in_19_4, vector_in_20_4, vector_in_21_4, vector_in_22_4, vector_in_23_4, vector_in_24_4, vector_in_25_4, vector_in_26_4, vector_in_27_4, vector_in_28_4, vector_in_29_4, vector_in_30_4, vector_in_31_4}),
    .Address(0),
    .en(1'b1),
    .Output(mul_res_4),
    .clk(clk)
);

assign result_0 = {mul_res_0, mul_res_1, mul_res_2, mul_res_3, mul_res_4};



endmodule
