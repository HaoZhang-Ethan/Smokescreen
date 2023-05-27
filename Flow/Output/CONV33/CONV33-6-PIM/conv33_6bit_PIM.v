/*
 * @Author: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @Date: 2022-11-29 10:08:30
 * @LastEditors: haozhang haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2023-05-26 02:52:13
 * @FilePath: /Smokescreen/Flow/Circuits/CONV33/conv633_6bit_PIM.v
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



module conv633_6bit_PIM (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8, // 输入数据
  input [5:0] kernel_0, input [5:0] kernel_1, input [5:0] kernel_2, input [5:0] kernel_3, input [5:0] kernel_4, input [5:0] kernel_5, input [5:0] kernel_6, input [5:0] kernel_7, input [5:0] kernel_8, // 卷积核
  input clk,
  output [17:0] out_data // 输出数据
);  

conv63x3 single_conv6(
  .in_data_0(in_data_0), .in_data_1(in_data_1), .in_data_2(in_data_2), .in_data_3(in_data_3), .in_data_4(in_data_4), .in_data_5(in_data_5), .in_data_6(in_data_6), .in_data_7(in_data_7), .in_data_8(in_data_8),
  .Add_pim(4'b0000),
  .Compute_flag(1'b1),
  .clk(clk),
  .Out_data(out_data)
);

endmodule

module conv63x3 (
  input [5:0] in_data_0, input [5:0] in_data_1, input [5:0] in_data_2, input [5:0] in_data_3, input [5:0] in_data_4, input [5:0] in_data_5, input [5:0] in_data_6, input [5:0] in_data_7, input [5:0] in_data_8, input [5:0] in_data_9, // 输入数据
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [17:0] Out_data // 输出数据
);  

	wire [5:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
//  HH Unit
	conv6 #(.INPUT_SIZE(25), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv6_HH(
		.Input_feature({in_data_0[5:3], in_data_1[5:3], in_data_2[5:3], in_data_3[5:3], in_data_4[5:3], in_data_5[5:3], in_data_6[5:3], in_data_7[5:3], in_data_8[5:3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv6 #(.INPUT_SIZE(25), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv6_HL(
		.Input_feature({in_data_0[5:3], in_data_1[5:3], in_data_2[5:3], in_data_3[5:3], in_data_4[5:3], in_data_5[5:3], in_data_6[5:3], in_data_7[5:3], in_data_8[5:3]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);

//  LH Unit
	conv6 #(.INPUT_SIZE(25), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv6_LH(
		.Input_feature({in_data_0[3:0], in_data_1[3:0], in_data_2[3:0], in_data_3[3:0], in_data_4[3:0], in_data_5[3:0], in_data_6[3:0], in_data_7[3:0], in_data_8[3:0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH),
		.clk(clk)
	);

//  LL Unit
	conv6 #(.INPUT_SIZE(25), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv6_LL(
		.Input_feature({in_data_0[3:0], in_data_1[3:0], in_data_2[3:0], in_data_3[3:0], in_data_4[3:0], in_data_5[3:0], in_data_6[3:0], in_data_7[3:0], in_data_8[3:0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL),
		.clk(clk)
	);

	assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;
endmodule