/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2023-05-26 02:35:09
 * @FilePath: /Smokescreen/Flow/Circuits/CONV33/conv33_8bit_PIM.v
 * @Description: the basic component of PIM conv. It can caculate the output for every address.
 * 
 * Copyright (c) 2022 by haozhang-hoge haozhang@mail.sdu.edu.cn, All Rights Reserved. 
 */



function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = -1; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction



module conv33_8bit_PIM (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, // 输入数据
  input [7:0] kernel_0, input [7:0] kernel_1, input [7:0] kernel_2, input [7:0] kernel_3, input [7:0] kernel_4, input [7:0] kernel_5, input [7:0] kernel_6, input [7:0] kernel_7, input [7:0] kernel_8, // 卷积核
  input clk,
  output [17:0] out_data // 输出数据
);  

conv3x3 single_conv(
  .in_data_0(in_data_0), .in_data_1(in_data_1), .in_data_2(in_data_2), .in_data_3(in_data_3), .in_data_4(in_data_4), .in_data_5(in_data_5), .in_data_6(in_data_6), .in_data_7(in_data_7), .in_data_8(in_data_8), 
  .Add_pim(4'b0000),
  .Compute_flag(1'b1),
  .clk(clk),
  .Out_data(out_data)
);
endmodule

module conv3x3 (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8,  // 输入数据
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [17:0] Out_data // 输出数据
);  


	wire [7:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
//  HH Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH0(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL1(
		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH2(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL3(
		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL),
		.clk(clk)
	);
	



	// assign Out_data = tmp_result_HH1 + tmp_result_HL1 + tmp_result_LH1 + tmp_result_LL1;


	wire [7:0] tmp_result_HH_1, tmp_result_HL_1, tmp_result_LH_1, tmp_result_LL_1;
//  HH Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH4(
		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_1),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL5(
		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_1),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH6(
		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_1),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL7(
		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_1),
		.clk(clk)
	);
	

	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;

	wire [7:0] tmp_result_HH_2, tmp_result_HL_2, tmp_result_LH_2, tmp_result_LL_2;
//  HH Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH8(
		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_2),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL9(
		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_2),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH10(
		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_2),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL11(
		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_2),
		.clk(clk)
	);
	
	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;




	wire [7:0] tmp_result_HH_3, tmp_result_HL_3, tmp_result_LH_3, tmp_result_LL_3;
//  HH Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH12(
		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH_3),
		.clk(clk)
	);

//  HL Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL13(
		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL_3),
		.clk(clk)
	);

//  LH Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH14(
		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH_3),
		.clk(clk)
	);

//  LL Unit
	conv #(.INPUT_SIZE(9), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL15(
		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL_3),
		.clk(clk)
	);
	
	wire [17:0] tmp_res[14];
	assign tmp_res[0] = tmp_result_HH + tmp_result_HL;
	assign tmp_res[1] = tmp_result_LH + tmp_result_LL;
	assign tmp_res[2] = tmp_result_HH_1 + tmp_result_HL_1;
	assign tmp_res[3] = tmp_result_LH_1 + tmp_result_LL_1;
	assign tmp_res[4] = tmp_result_HH_2 + tmp_result_HL_2;
	assign tmp_res[5] = tmp_result_LH_2 + tmp_result_LL_2;
	assign tmp_res[6] = tmp_result_HH_3 + tmp_result_HL_3;
	assign tmp_res[7] = tmp_result_LH_3 + tmp_result_LL_3;
	assign tmp_res[8] = tmp_res[0] + tmp_res[1];
	assign tmp_res[9] = tmp_res[2] + tmp_res[3];
	assign tmp_res[10] = tmp_res[4] + tmp_res[5];
	assign tmp_res[11] = tmp_res[6] + tmp_res[7];
	assign tmp_res[12] = tmp_res[8] + tmp_res[9];
	assign tmp_res[13] = tmp_res[10] + tmp_res[11];
	assign Out_data = tmp_res[12] + tmp_res[13];



endmodule