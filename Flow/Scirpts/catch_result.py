#!/usr/bin/env python3
'''
Author: haozhang haozhang@mail.sdu.edu.cn
Date: 2023-05-28 17:05:34
LastEditors: haozhang haozhang@mail.sdu.edu.cn
LastEditTime: 2023-05-29 07:46:29
FilePath: /Smokescreen/Flow/Scirpts/catch_result.py
Description: 

Copyright (c) 2023 by $[git_name_email], All Rights Reserved. 
'''


# get the result from the output
# *******************************************************************************

import os
import time


VTR_FLOW = "/root/Project/Smokescreen/Tools/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_flow.py"
PATH_CIRCUITS = "/root/Project/Smokescreen/Flow/Circuits/"
PATH_ARCH_CBRAM = "/root/Project/Smokescreen/Flow/Arch/k6FracN10LB_mem20K_complexDSP_customSB_22nm_cbram.dsp_heavy.xml"
PATH_ARCH_NVM = "/root/Project/Smokescreen/Flow/Arch/k6FracN10LB_mem20K_complexDSP_customSB_22nm_nvm.dsp_heavy.xml"
PATH_ARCH_SRAM = "/root/Project/Smokescreen/Flow/Arch/k6FracN10LB_mem20K_complexDSP_customSB_22nm_sram.dsp_heavy.xml"
PATH_RES_DIR = "/root/Project/Smokescreen/Flow/Output/"
PATH_SOLUTION_DIR = "/root/Project/Smokescreen/Flow/Scirpts/Solution/"

Group1 = ["LSTM", "LeNet5", "Attention"] #,  "CONV33", "CONV55", "CONV77", "GEMM32", "CONV64"
Group2 = ["LSTM", "LeNet5", "Attention",  "CNN48_55", "CNN48_33", "CNN48_M"] # 
Group1_Strategy = ["SRAM", "NVM",  "CBRAM"]
Group2_Strategy = ["CLB", "DSP", "PIM", "AREA", "OP"]

Precision = ["6", "8"]

PATH_ARCH_DICT = {}
PATH_ARCH_DICT["CBRAM"] = PATH_ARCH_CBRAM
PATH_ARCH_DICT["NVM"] = PATH_ARCH_NVM
PATH_ARCH_DICT["SRAM"] = PATH_ARCH_SRAM
PATH_ARCH_DICT["CLB"] = PATH_ARCH_CBRAM
PATH_ARCH_DICT["PIM"] = PATH_ARCH_CBRAM
PATH_ARCH_DICT["DSP"] = PATH_ARCH_CBRAM
PATH_ARCH_DICT["OP"] = PATH_ARCH_CBRAM
PATH_ARCH_DICT["AREA"] = PATH_ARCH_CBRAM

ADD_NAME_DICT = {}
ADD_NAME_DICT["CBRAM"] = "PIM"
ADD_NAME_DICT["NVM"] = "DSP"
ADD_NAME_DICT["SRAM"] = "DSP"
ADD_NAME_DICT["CLB"] = "CLB"
ADD_NAME_DICT["PIM"] = "PIM"
ADD_NAME_DICT["DSP"] = "DSP"
ADD_NAME_DICT["OP"] = "OP"
ADD_NAME_DICT["AREA"] = "AREA"


Log_Area_dict = {}
Phy_Area_dict = {}
Rout_Area_dict = {}
Total_Area_dict = {}
Freq_dict = {}


# # Group 1
# for benchmark in Group1:
#     for precision in Precision:
#         for strategy in Group1_Strategy:
#             # check if the result dir exists
#             # cmd = PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy]+"/"+benchmark + "_" + precision  + "_" + ADD_NAME_DICT[strategy] + ".route"
#             if os.path.exists(PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy]+"/"+benchmark + "_" + precision  + "_" + ADD_NAME_DICT[strategy] + ".route"):
#                 with open(PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy]+"/vpr_stdout.log", 'r') as f:
#                     for line in f:
#                         if line.find("Total logic block area") != -1:
#                             tmp_area = line.split()
#                             T_area = float(tmp_area[len(tmp_area)-1])
#                         if line.find("Total used logic block area:") != -1:
#                             tmp_area = line.split()
#                             L_area = float(tmp_area[len(tmp_area)-1])
#                         if line.find("Total routing area:") != -1:
#                             tmp_area = line.split()
#                             R_area = float(tmp_area[3].replace(",",""))
#                         if line.find("Final critical path delay ") != -1:
#                             tmp_area = line.split()
#                             CP = float(tmp_area[len(tmp_area)-2])
#                     Log_Area_dict[benchmark + "_" + precision + "_" + strategy] = str(L_area)
#                     Phy_Area_dict[benchmark + "_" + precision + "_" + strategy] = str(T_area)
#                     Rout_Area_dict[benchmark + "_" + precision + "_" + strategy] = str(R_area)
#                     Total_Area_dict[benchmark + "_" + precision + "_" + strategy] = str(T_area + R_area)
#                     Freq_dict[benchmark + "_" + precision + "_" + strategy] = str(CP)

# # print the result in the txt file
# with open("/root/Project/Smokescreen/Flow/Scirpts/Res_G1.txt", 'w') as f:
#     for benchmark in Group1:
#         for precision in Precision:
#             for strategy in Group1_Strategy:
#                     f.write(precision  + "\t" + strategy + "\t" + benchmark + "\t")
#                     # check if the result dict exists
#                     if benchmark + "_" + precision + "_" + strategy in Log_Area_dict.keys():
#                         # print("find")
#                         f.write(Log_Area_dict[benchmark + "_" + precision + "_" + strategy] + "\t" + Phy_Area_dict[benchmark + "_" + precision + "_" + strategy] + "\t" + Rout_Area_dict[benchmark + "_" + precision + "_" + strategy] + "\t" + Total_Area_dict[benchmark + "_" + precision + "_" + strategy] + "\t" + Freq_dict[benchmark + "_" + precision + "_" + strategy] + "\n")
#                         # f.write("\n")
#                     else:
#                         # print("not find")
#                         f.write("0\t0\t0\t0\t0\n")
#                         # f.write("\n")



# Group 2
for benchmark in Group2:
    for precision in Precision:
        for strategy in Group2_Strategy:
            # check if the result dir exists
            if os.path.exists(PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy]+"/"+benchmark + "_" + precision  + "_" + ADD_NAME_DICT[strategy] + ".route"):
                with open(PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy]+"/vpr_stdout.log", 'r') as f:
                    for line in f:
                        if line.find("Total logic block area") != -1:
                            tmp_area = line.split()
                            T_area = float(tmp_area[len(tmp_area)-1])
                        if line.find("Total used logic block area:") != -1:
                            tmp_area = line.split()
                            L_area = float(tmp_area[len(tmp_area)-1])
                        if line.find("Total routing area:") != -1:
                            tmp_area = line.split()
                            R_area = float(tmp_area[3].replace(",",""))
                        if line.find("Final critical path delay ") != -1:
                            tmp_area = line.split()
                            CP = float(tmp_area[len(tmp_area)-2])
                    Log_Area_dict[benchmark + "_" + precision + "_" + strategy] = str(L_area)
                    Phy_Area_dict[benchmark + "_" + precision + "_" + strategy] = str(T_area)
                    Rout_Area_dict[benchmark + "_" + precision + "_" + strategy] = str(R_area)
                    Total_Area_dict[benchmark + "_" + precision + "_" + strategy] = str(T_area + R_area)
                    Freq_dict[benchmark + "_" + precision + "_" + strategy] = str(CP)

# print the result in the txt file
with open("/root/Project/Smokescreen/Flow/Scirpts/Res_G2.txt", 'w') as f:
    for benchmark in Group2:
        for precision in Precision:
            for strategy in Group2_Strategy:
                    f.write(precision  + "\t" + strategy + "\t" + benchmark + "\t")
                    # check if the result dict exists
                    if benchmark + "_" + precision + "_" + strategy in Log_Area_dict.keys():
                        # print("find")
                        f.write(Log_Area_dict[benchmark + "_" + precision + "_" + strategy] + "\t" + Phy_Area_dict[benchmark + "_" + precision + "_" + strategy] + "\t" + Rout_Area_dict[benchmark + "_" + precision + "_" + strategy] + "\t" + Total_Area_dict[benchmark + "_" + precision + "_" + strategy] + "\t" + Freq_dict[benchmark + "_" + precision + "_" + strategy] + "\n")
                        # f.write("\n")
                    else:
                        # print("not find")
                        f.write("0\t0\t0\t0\t0\n")
                        # f.write("\n")