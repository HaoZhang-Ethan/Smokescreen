'''
Author: haozhang haozhang@mail.sdu.edu.cn
Date: 2023-04-14 14:35:18
LastEditors: haozhang haozhang@mail.sdu.edu.cn
LastEditTime: 2023-04-20 02:49:32
FilePath: /Smokescreen/Flow/Scirpts/gen_conv55.py
Description: 

Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
'''
# generate many 5x5 convolutional layers
import os


Base_Num = 1026
# write the code to a file
Path = "/root/Project/Smokescreen/Flow/Scirpts/tmp.v"
with open(Path, 'w') as f:
    for C_i in range(0, 60):
        f.write("\n \n // "+ str(C_i) + "\n")
        tmp = "wire signed[OUT_WIDTH-1:0] conv_c5_1_x_0, conv_c5_1_x_1, conv_c5_1_x_2, conv_c5_1_x_3, conv_c5_1_x_4, conv_c5_1_x_5, conv_c5_1_x_6, conv_c5_1_x_7, conv_c5_1_x_8, conv_c5_1_x_9, conv_c5_1_x_10, conv_c5_1_x_11, conv_c5_1_x_12, conv_c5_1_x_13, conv_c5_1_x_14, conv_c5_1_x_15;"
        tmp = tmp.replace("_x_", "_" + str(C_i) + "_")
        f.write(tmp + "\n")
        tmp = "wire signed[OUT_WIDTH-1:0] conv_Value_c5_1_x;"
        tmp = tmp.replace("_x", "_" + str(C_i))
        f.write(tmp + "\n")
        for C_j in range(1, 17):
            tmp = "conv55_6bit CONV_55_DSP_130 (.in_data_0(rowsc5_0[4][0][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_1(rowsc5_0[4][1][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_2(rowsc5_0[4][2][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_3(rowsc5_0[4][3][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_4(rowsc5_0[4][4][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_5(rowsc5_0[3][0][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_6(rowsc5_0[3][1][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_7(rowsc5_0[3][2][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_8(rowsc5_0[3][3][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_9(rowsc5_0[3][4][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_10(rowsc5_0[2][0][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_11(rowsc5_0[2][1][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_12(rowsc5_0[2][2][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_13(rowsc5_0[2][3][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_14(rowsc5_0[2][4][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_15(rowsc5_0[1][0][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_16(rowsc5_0[1][1][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_17(rowsc5_0[1][2][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_18(rowsc5_0[1][3][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_19(rowsc5_0[1][4][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_20(rowsc5_0[0][0][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_21(rowsc5_0[0][1][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_22(rowsc5_0[0][2][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_23(rowsc5_0[0][3][1*IN_WIDTH : 0*IN_WIDTH]), .in_data_24(rowsc5_0[0][4][1*IN_WIDTH : 0*IN_WIDTH]), .kernel_0(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*1 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*0]), .kernel_1(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*2 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*1]), .kernel_2(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*3 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*2]), .kernel_3(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*4 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*3]), .kernel_4(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*5 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*4]), .kernel_5(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*6 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*5]), .kernel_6(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*7 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*6]), .kernel_7(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*8 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*7]), .kernel_8(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*9 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*8]), .kernel_9(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*10 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*9]), .kernel_10(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*11 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*10]), .kernel_11(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*12 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*11]), .kernel_12(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*13 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*12]), .kernel_13(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*14 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*13]), .kernel_14(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*15 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*14]), .kernel_15(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*16 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*15]), .kernel_16(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*17 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*16]), .kernel_17(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*18 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*17]), .kernel_18(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*19 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*18]), .kernel_19(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*20 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*19]), .kernel_20(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*21 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*20]), .kernel_21(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*22 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*21]), .kernel_22(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*23 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*22]), .kernel_23(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*24 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*23]), .kernel_24(rom_c5_0[IN_WIDTH*((4*16+0)*CONVSIZE) + IN_WIDTH*25 : IN_WIDTH*((4*16+0)*CONVSIZE)+IN_WIDTH*24]), .clk(clk), .out_data(conv_c5_1_x_0));"
            tmp = tmp.replace("_x_0", "_" + str(C_i) + "_" + str(C_j-1)).replace("1*I",str(C_j)+"*I").replace("DSP_130","DSP_"+str(Base_Num))
            tmp = tmp.replace("0*I",str(C_j-1)+"*I").replace("(4*16+0","("+str(C_i)+"*16+"+str(C_j-1))
            f.write(tmp + "\n")
            Base_Num += 1

        tmp = "assign conv_Value_c5_1_x = conv_c5_1_x_0 + conv_c5_1_x_1 + conv_c5_1_x_2 + conv_c5_1_x_3 + conv_c5_1_x_4 + conv_c5_1_x_5 + conv_c5_1_x_6 + conv_c5_1_x_7 + conv_c5_1_x_8 + conv_c5_1_x_9 + conv_c5_1_x_10 + conv_c5_1_x_11 + conv_c5_1_x_12 + conv_c5_1_x_13 + conv_c5_1_x_14 + conv_c5_1_x_15 + rom_c5_0[IN_WIDTH*((4*16+15)*CONVSIZE) + IN_WIDTH*25 : IN_WIDTH*((4*16+15)*CONVSIZE)+IN_WIDTH*24];"
        tmp = tmp.replace("_x", "_" + str(C_i))
        f.write(tmp + "\n")

    f.write("assign out6 = ")
    for C_i in range(0, 60):
        tmp = "conv_Value_c5_1_x"
        tmp = tmp.replace("_x", "_" + str(C_i))
        f.write(tmp + " | ")

    for C_i in range(0, 60):
        tmp = "relu #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU_2_X (.in(conv_Value_c5_1_X), .out(C5_relu[_Y]));"
        tmp = tmp.replace("_X", "_" + str(C_i)).replace("_Y",str(60+C_i))
        f.write(tmp + "\n")

