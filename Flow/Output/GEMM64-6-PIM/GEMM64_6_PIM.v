`define ARRAY_DEPTH 64      //Number of Hidden neurons
`define INPUT_DEPTH 100	    //LSTM input vector dimensions
`define DATA_WIDTH 8		//16 bit representation
`define INWEIGHT_DEPTH 6400 //100x64
`define HWEIGHT_DEPTH 4096  //64x64
`define varraysize 1600   //100x16
`define uarraysize 1024  //64x16


function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = -1; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction


module GEMM64_6_PIM #( parameter uarraysize=1024, vectwidth=64)
(
	input clk,
	input reset,
	input [uarraysize-1:0] data_h,
	input [uarraysize-1:0] W_h,

	output reg [15:0] data_out_h
);

conv_top_64_6 conv_top_64_inst_1(
.in_data_0(data_h[7:0]), .in_data_1(data_h[23:16]), .in_data_2(data_h[39:32]), .in_data_3(data_h[55:48]), .in_data_4(data_h[71:64]), .in_data_5(data_h[87:80]), .in_data_6(data_h[103:96]), .in_data_7(data_h[119:112]), .in_data_8(data_h[135:128]), .in_data_9(data_h[151:144]), .in_data_10(data_h[167:160]), .in_data_11(data_h[183:176]), .in_data_12(data_h[199:192]), .in_data_13(data_h[215:208]), .in_data_14(data_h[231:224]), .in_data_15(data_h[247:240]), .in_data_16(data_h[263:256]), .in_data_17(data_h[279:272]), .in_data_18(data_h[295:288]), .in_data_19(data_h[311:304]), .in_data_20(data_h[327:320]), .in_data_21(data_h[343:336]), .in_data_22(data_h[359:352]), .in_data_23(data_h[375:368]), .in_data_24(data_h[391:384]), .in_data_25(data_h[407:400]), .in_data_26(data_h[423:416]), .in_data_27(data_h[439:432]), .in_data_28(data_h[455:448]), .in_data_29(data_h[471:464]), .in_data_30(data_h[487:480]), .in_data_31(data_h[503:496]), .in_data_32(data_h[519:512]), .in_data_33(data_h[535:528]), .in_data_34(data_h[551:544]), .in_data_35(data_h[567:560]), .in_data_36(data_h[583:576]), .in_data_37(data_h[599:592]), .in_data_38(data_h[615:608]), .in_data_39(data_h[631:624]), .in_data_40(data_h[647:640]), .in_data_41(data_h[663:656]), .in_data_42(data_h[679:672]), .in_data_43(data_h[695:688]), .in_data_44(data_h[711:704]), .in_data_45(data_h[727:720]), .in_data_46(data_h[743:736]), .in_data_47(data_h[759:752]), .in_data_48(data_h[775:768]), .in_data_49(data_h[791:784]), .in_data_50(data_h[807:800]), .in_data_51(data_h[823:816]), .in_data_52(data_h[839:832]), .in_data_53(data_h[855:848]), .in_data_54(data_h[871:864]), .in_data_55(data_h[887:880]), .in_data_56(data_h[903:896]), .in_data_57(data_h[919:912]), .in_data_58(data_h[935:928]), .in_data_59(data_h[951:944]), .in_data_60(data_h[967:960]), .in_data_61(data_h[983:976]), .in_data_62(data_h[999:992]), .in_data_63(data_h[1015:1008]),
.Add_pim(4'b0000),
.Compute_flag(1'b1),
.clk(clk),
.Out_data(data_out_h)
);
	
endmodule



module conv_top_64_6 (
  input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24, input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44, input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48, input [7:0] in_data_49, input [7:0] in_data_50, input [7:0] in_data_51, input [7:0] in_data_52, input [7:0] in_data_53, input [7:0] in_data_54, input [7:0] in_data_55, input [7:0] in_data_56, input [7:0] in_data_57, input [7:0] in_data_58, input [7:0] in_data_59, input [7:0] in_data_60, input [7:0] in_data_61, input [7:0] in_data_62, input [7:0] in_data_63, 
  input [4:0] Add_pim, // 地址
  input Compute_flag, // 计算标志
  input clk,
  output [17:0] Out_data // 输出数据
);  



	wire [7:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
//  HH Unit
	conv6 #(.INPUT_SIZE(192), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH0(
		.Input_feature({in_data_0[5:3], in_data_1[5:3], in_data_2[5:3], in_data_3[5:3], in_data_4[5:3], in_data_5[5:3], in_data_6[5:3], in_data_7[5:3], in_data_8[5:3], in_data_9[5:3], in_data_10[5:3], in_data_11[5:3], in_data_12[5:3], in_data_13[5:3], in_data_14[5:3], in_data_15[5:3], in_data_16[5:3], in_data_17[5:3], in_data_18[5:3], in_data_19[5:3], in_data_20[5:3], in_data_21[5:3], in_data_22[5:3], in_data_23[5:3], in_data_24[5:3], in_data_25[5:3], in_data_26[5:3], in_data_27[5:3], in_data_28[5:3], in_data_29[5:3], in_data_30[5:3], in_data_31[5:3], in_data_32[5:3], in_data_33[5:3], in_data_34[5:3], in_data_35[5:3], in_data_36[5:3], in_data_37[5:3], in_data_38[5:3], in_data_39[5:3], in_data_40[5:3], in_data_41[5:3], in_data_42[5:3], in_data_43[5:3], in_data_44[5:3], in_data_45[5:3], in_data_46[5:3], in_data_47[5:3], in_data_48[5:3], in_data_49[5:3], in_data_50[5:3], in_data_51[5:3], in_data_52[5:3], in_data_53[5:3], in_data_54[5:3], in_data_55[5:3], in_data_56[5:3], in_data_57[5:3], in_data_58[5:3], in_data_59[5:3], in_data_60[5:3], in_data_61[5:3], in_data_62[5:3], in_data_63[5:3], in_data_64[5:3] }),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HH),
		.clk(clk)
	);

//  HL Unit
	conv6 #(.INPUT_SIZE(192), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL1(
		.Input_feature({in_data_0[5:3], in_data_1[5:3], in_data_2[5:3], in_data_3[5:3], in_data_4[5:3], in_data_5[5:3], in_data_6[5:3], in_data_7[5:3], in_data_8[5:3], in_data_9[5:3], in_data_10[5:3], in_data_11[5:3], in_data_12[5:3], in_data_13[5:3], in_data_14[5:3], in_data_15[5:3], in_data_16[5:3], in_data_17[5:3], in_data_18[5:3], in_data_19[5:3], in_data_20[5:3], in_data_21[5:3], in_data_22[5:3], in_data_23[5:3], in_data_24[5:3], in_data_25[5:3], in_data_26[5:3], in_data_27[5:3], in_data_28[5:3], in_data_29[5:3], in_data_30[5:3], in_data_31[5:3], in_data_32[5:3], in_data_33[5:3], in_data_34[5:3], in_data_35[5:3], in_data_36[5:3], in_data_37[5:3], in_data_38[5:3], in_data_39[5:3], in_data_40[5:3], in_data_41[5:3], in_data_42[5:3], in_data_43[5:3], in_data_44[5:3], in_data_45[5:3], in_data_46[5:3], in_data_47[5:3], in_data_48[5:3], in_data_49[5:3], in_data_50[5:3], in_data_51[5:3], in_data_52[5:3], in_data_53[5:3], in_data_54[5:3], in_data_55[5:3], in_data_56[5:3], in_data_57[5:3], in_data_58[5:3], in_data_59[5:3], in_data_60[5:3], in_data_61[5:3], in_data_62[5:3], in_data_63[5:3], in_data_64[5:3] }),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_HL),
		.clk(clk)
	);

//  LH Unit
	conv6 #(.INPUT_SIZE(192), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH2(
		.Input_feature({in_data_0[2:0], in_data_1[2:0], in_data_2[2:0], in_data_3[2:0], in_data_4[2:0], in_data_5[2:0], in_data_6[2:0], in_data_7[2:0], in_data_8[2:0], in_data_9[2:0], in_data_10[2:0], in_data_11[2:0], in_data_12[2:0], in_data_13[2:0], in_data_14[2:0], in_data_15[2:0], in_data_16[2:0], in_data_17[2:0], in_data_18[2:0], in_data_19[2:0], in_data_20[2:0], in_data_21[2:0], in_data_22[2:0], in_data_23[2:0], in_data_24[2:0], in_data_25[2:0], in_data_26[2:0], in_data_27[2:0], in_data_28[2:0], in_data_29[2:0], in_data_30[2:0], in_data_31[2:0], in_data_32[2:0], in_data_33[2:0], in_data_34[2:0], in_data_35[2:0], in_data_36[2:0], in_data_37[2:0], in_data_38[2:0], in_data_39[2:0], in_data_40[2:0], in_data_41[2:0], in_data_42[2:0], in_data_43[2:0], in_data_44[2:0], in_data_45[2:0], in_data_46[2:0], in_data_47[2:0], in_data_48[2:0], in_data_49[2:0], in_data_50[2:0], in_data_51[2:0], in_data_52[2:0], in_data_53[2:0], in_data_54[2:0], in_data_55[2:0], in_data_56[2:0], in_data_57[2:0], in_data_58[2:0], in_data_59[2:0], in_data_60[2:0], in_data_61[2:0], in_data_62[2:0], in_data_63[2:0], in_data_64[2:0] }),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LH),
		.clk(clk)
	);

//  LL Unit
	conv6 #(.INPUT_SIZE(192), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL3(
		.Input_feature({in_data_0[2:0], in_data_1[2:0], in_data_2[2:0], in_data_3[2:0], in_data_4[2:0], in_data_5[2:0], in_data_6[2:0], in_data_7[2:0], in_data_8[2:0], in_data_9[2:0], in_data_10[2:0], in_data_11[2:0], in_data_12[2:0], in_data_13[2:0], in_data_14[2:0], in_data_15[2:0], in_data_16[2:0], in_data_17[2:0], in_data_18[2:0], in_data_19[2:0], in_data_20[2:0], in_data_21[2:0], in_data_22[2:0], in_data_23[2:0], in_data_24[2:0], in_data_25[2:0], in_data_26[2:0], in_data_27[2:0], in_data_28[2:0], in_data_29[2:0], in_data_30[2:0], in_data_31[2:0], in_data_32[2:0], in_data_33[2:0], in_data_34[2:0], in_data_35[2:0], in_data_36[2:0], in_data_37[2:0], in_data_38[2:0], in_data_39[2:0], in_data_40[2:0], in_data_41[2:0], in_data_42[2:0], in_data_43[2:0], in_data_44[2:0], in_data_45[2:0], in_data_46[2:0], in_data_47[2:0], in_data_48[2:0], in_data_49[2:0], in_data_50[2:0], in_data_51[2:0], in_data_52[2:0], in_data_53[2:0], in_data_54[2:0], in_data_55[2:0], in_data_56[2:0], in_data_57[2:0], in_data_58[2:0], in_data_59[2:0], in_data_60[2:0], in_data_61[2:0], in_data_62[2:0], in_data_63[2:0], in_data_64[2:0]}),
		.Address(Add_pim),
		.en(Compute_flag),
		.Output(tmp_result_LL),
		.clk(clk)
	);



	wire [17:0] tmp_res[3];
    qadd2 qadd_in_0(.a(tmp_result_HH), .b(tmp_result_HL), .c(tmp_res[0]));
    qadd2 qadd_in_1(.a(tmp_result_LH), .b(tmp_result_LL), .c(tmp_res[1]));
    qadd2 qadd_in_8(.a(tmp_res[0]), .b(tmp_res[1]), .c(tmp_res[2]));

    assign Out_data = tmp_res[2];


endmodule

module qadd2(
 input [15:0] a,
 input [15:0] b,
 output [15:0] c
    );
    
assign c = a + b;


endmodule
