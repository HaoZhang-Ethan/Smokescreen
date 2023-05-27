/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2023-05-26 12:44:01
 * @FilePath: /Smokescreen/Flow/Circuits/CONV77/conv77_6bit_PIM.v
 * @Description: the basic component of PIM conv6. It can caculate the output for every address.
 * 
 * Copyright (c) 2022 by haozhang-hoge haozhang@mail.sdu.edu.cn, All Rights Reserved. 
 */



function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = -1; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction



module conv77_6bit_PIM (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8, input [5:0] in_data_9, input [5:0] in_data_10, input [5:0] in_data_11, input [5:0] in_data_12, input [5:0] in_data_13, input [5:0] in_data_14, input [5:0] in_data_15, input [5:0] in_data_16, input [5:0] in_data_17, input [5:0] in_data_18, input [5:0] in_data_19, input [5:0] in_data_20, input [5:0] in_data_21, input [5:0] in_data_22, input [5:0] in_data_23, input [5:0] in_data_24,   input [5:0] in_data_25, input [5:0] in_data_26, input [5:0] in_data_27, input [5:0] in_data_28, input [5:0] in_data_29, input [5:0] in_data_30, input [5:0] in_data_31, input [5:0] in_data_32, input [5:0] in_data_33, input [5:0] in_data_34, input [5:0] in_data_35, input [5:0] in_data_36, input [5:0] in_data_37, input [5:0] in_data_38, input [5:0] in_data_39, input [5:0] in_data_40, input [5:0] in_data_41, input [5:0] in_data_42, input [5:0] in_data_43, input [5:0] in_data_44, input [5:0] in_data_45, input [5:0] in_data_46, input [5:0] in_data_47, input [5:0] in_data_48, 
  input [5:0] kernel_0, input [5:0] kernel_1, input [5:0] kernel_2, input [5:0] kernel_3, input [5:0] kernel_4, input [5:0] kernel_5, input [5:0] kernel_6, input [5:0] kernel_7, input [5:0] kernel_8, input [5:0] kernel_9, input [5:0] kernel_10, input [5:0] kernel_11, input [5:0] kernel_12,   input [5:0] kernel_13, input [5:0] kernel_14, input [5:0] kernel_15, input [5:0] kernel_16, input [5:0] kernel_17, input [5:0] kernel_18, input [5:0] kernel_19, input [5:0] kernel_20, input [5:0] kernel_21, input [5:0] kernel_22, input [5:0] kernel_23, input [5:0] kernel_24,   input [5:0] kernel_25, input [5:0] kernel_26, input [5:0] kernel_27, input [5:0] kernel_28, input [5:0] kernel_29, input [5:0] kernel_30, input [5:0] kernel_31, input [5:0] kernel_32, input [5:0] kernel_33, input [5:0] kernel_34, input [5:0] kernel_35, input [5:0] kernel_36,   input [5:0] kernel_37, input [5:0] kernel_38, input [5:0] kernel_39, input [5:0] kernel_40, input [5:0] kernel_41, input [5:0] kernel_42, input [5:0] kernel_43, input [5:0] kernel_44, input [5:0] kernel_45, input [5:0] kernel_46, input [5:0] kernel_47, input [5:0] kernel_48, 
  input clk,
  output [15:0] out_data // 输出数据
);  

conv7x7 single_conv(
  .in_data_0(in_data_0), .in_data_1(in_data_1), .in_data_2(in_data_2), .in_data_3(in_data_3), .in_data_4(in_data_4), .in_data_5(in_data_5), .in_data_6(in_data_6), .in_data_7(in_data_7), .in_data_8(in_data_8), .in_data_9(in_data_9), .in_data_10(in_data_10), .in_data_11(in_data_11), .in_data_12(in_data_12), .in_data_13(in_data_13), .in_data_14(in_data_14), .in_data_15(in_data_15), .in_data_16(in_data_16), .in_data_17(in_data_17), .in_data_18(in_data_18), .in_data_19(in_data_19), .in_data_20(in_data_20), .in_data_21(in_data_21), .in_data_22(in_data_22), .in_data_23(in_data_23), .in_data_24(in_data_24),
  .Add_pim(4'b0000),
  .Compute_flag(1'b1),
  .clk(clk),
  .Out_data(out_data)
);

endmodule

module conv7x7 (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8, input [5:0] in_data_9, input [5:0] in_data_10, input [5:0] in_data_11, input [5:0] in_data_12, input [5:0] in_data_13, input [5:0] in_data_14, input [5:0] in_data_15, input [5:0] in_data_16, input [5:0] in_data_17, input [5:0] in_data_18, input [5:0] in_data_19, input [5:0] in_data_20, input [5:0] in_data_21, input [5:0] in_data_22, input [5:0] in_data_23, input [5:0] in_data_24, // 输入数据
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [15:0] Out_data // 输出数据
);  

	wire [5:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
//  HH Unit
	conv6 #(.INPUT_SIZE(147), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH(
		.Input_feature({in_data_0[5:3], in_data_1[5:3], in_data_2[5:3], in_data_3[5:3], in_data_4[5:3], in_data_5[5:3], in_data_6[5:3], in_data_7[5:3], in_data_8[5:3], in_data_9[5:3], in_data_10[5:3], in_data_11[5:3], in_data_12[5:3], in_data_13[5:3], in_data_14[5:3], in_data_15[5:3], in_data_16[5:3], in_data_17[5:3], in_data_18[5:3], in_data_19[5:3], in_data_20[5:3], in_data_21[5:3], in_data_22[5:3], in_data_23[5:3], in_data_24[5:3], in_data_26[5:3], in_data_27[5:3], in_data_28[5:3], in_data_29[5:3], in_data_30[5:3], in_data_31[5:3], in_data_32[5:3], in_data_33[5:3], in_data_34[5:3], in_data_35[5:3], in_data_36[5:3], in_data_37[5:3], in_data_38[5:3], in_data_39[5:3], in_data_40[5:3], in_data_41[5:3], in_data_42[5:3], in_data_43[5:3], in_data_44[5:3], in_data_45[5:3], in_data_46[5:3], in_data_47[5:3], in_data_48[5:3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv6 #(.INPUT_SIZE(147), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL(
		.Input_feature({in_data_0[5:3], in_data_1[5:3], in_data_2[5:3], in_data_3[5:3], in_data_4[5:3], in_data_5[5:3], in_data_6[5:3], in_data_7[5:3], in_data_8[5:3], in_data_9[5:3], in_data_10[5:3], in_data_11[5:3], in_data_12[5:3], in_data_13[5:3], in_data_14[5:3], in_data_15[5:3], in_data_16[5:3], in_data_17[5:3], in_data_18[5:3], in_data_19[5:3], in_data_20[5:3], in_data_21[5:3], in_data_22[5:3], in_data_23[5:3], in_data_24[5:3], in_data_26[5:3], in_data_27[5:3], in_data_28[5:3], in_data_29[5:3], in_data_30[5:3], in_data_31[5:3], in_data_32[5:3], in_data_33[5:3], in_data_34[5:3], in_data_35[5:3], in_data_36[5:3], in_data_37[5:3], in_data_38[5:3], in_data_39[5:3], in_data_40[5:3], in_data_41[5:3], in_data_42[5:3], in_data_43[5:3], in_data_44[5:3], in_data_45[5:3], in_data_46[5:3], in_data_47[5:3], in_data_48[5:3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);

//  LH Unit
	conv6 #(.INPUT_SIZE(147), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH(
		.Input_feature({in_data_0[2:0], in_data_1[2:0], in_data_2[2:0], in_data_3[2:0], in_data_4[2:0], in_data_5[2:0], in_data_6[2:0], in_data_7[2:0], in_data_8[2:0], in_data_9[2:0], in_data_10[2:0], in_data_11[2:0], in_data_12[2:0], in_data_13[2:0], in_data_14[2:0], in_data_15[2:0], in_data_16[2:0], in_data_17[2:0], in_data_18[2:0], in_data_19[2:0], in_data_20[2:0], in_data_21[2:0], in_data_22[2:0], in_data_23[2:0], in_data_24[2:0], in_data_26[2:0], in_data_27[2:0], in_data_28[2:0], in_data_29[2:0], in_data_30[2:0], in_data_31[2:0], in_data_32[2:0], in_data_33[2:0], in_data_34[2:0], in_data_35[2:0], in_data_36[2:0], in_data_37[2:0], in_data_38[2:0], in_data_39[2:0], in_data_40[2:0], in_data_41[2:0], in_data_42[2:0], in_data_43[2:0], in_data_44[2:0], in_data_45[2:0], in_data_46[2:0], in_data_47[2:0], in_data_48[2:0], in_data_49[2:0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH),
		.clk(clk)
	);

//  LL Unit
	conv6 #(.INPUT_SIZE(147), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL(
		.Input_feature({in_data_0[2:0], in_data_1[2:0], in_data_2[2:0], in_data_3[2:0], in_data_4[2:0], in_data_5[2:0], in_data_6[2:0], in_data_7[2:0], in_data_8[2:0], in_data_9[2:0], in_data_10[2:0], in_data_11[2:0], in_data_12[2:0], in_data_13[2:0], in_data_14[2:0], in_data_15[2:0], in_data_16[2:0], in_data_17[2:0], in_data_18[2:0], in_data_19[2:0], in_data_20[2:0], in_data_21[2:0], in_data_22[2:0], in_data_23[2:0], in_data_24[2:0], in_data_26[2:0], in_data_27[2:0], in_data_28[2:0], in_data_29[2:0], in_data_30[2:0], in_data_31[2:0], in_data_32[2:0], in_data_33[2:0], in_data_34[2:0], in_data_35[2:0], in_data_36[2:0], in_data_37[2:0], in_data_38[2:0], in_data_39[2:0], in_data_40[2:0], in_data_41[2:0], in_data_42[2:0], in_data_43[2:0], in_data_44[2:0], in_data_45[2:0], in_data_46[2:0], in_data_47[2:0], in_data_48[2:0], in_data_49[2:0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL),
		.clk(clk)
	);

	wire [17:0] tmp_res[3];
	qadd2 qadd2_0(.a(tmp_result_HH), .b(tmp_result_HL),	.c(tmp_res[0]));
	qadd2 qadd2_1(.a(tmp_result_LH), .b(tmp_result_LL),	.c(tmp_res[1]));
	qadd2 qadd2_2(.a(tmp_res[0]), .b(tmp_res[1]),	.c(Out_data));
	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;
endmodule


module qadd2(
 input [15:0] a,
 input [15:0] b,
 output [15:0] c
    );
    
assign c = a + b;


endmodule
