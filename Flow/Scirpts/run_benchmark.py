#!/usr/bin/env python3
'''
Author: haozhang haozhang@mail.sdu.edu.cn
Date: 2023-05-28 17:05:34
LastEditors: haozhang haozhang@mail.sdu.edu.cn
LastEditTime: 2023-05-28 18:45:09
FilePath: /Smokescreen/Flow/Scirpts/run_benchmark.py
Description: 

Copyright (c) 2023 by $[git_name_email], All Rights Reserved. 
'''


# run benchmark for flow
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
Group1_Strategy = ["CBRAM", "NVM", "SRAM"]
Group2_Strategy = ["CLB", "PIM", "DSP", "OP", "AREA"]

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



# Group 1
for benchmark in Group1:
    for precision in Precision:
        for strategy in Group1_Strategy:
            # check if the result dir exists
            if os.path.exists(PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy]):
                os.system("rm -rf " + PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy])
            # copy the lib file
            # os.makedirs(PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy])
            os.system("cp -rf " + PATH_CIRCUITS + benchmark + " " + PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy] )
            # run the flow
            cmd = VTR_FLOW + " " + PATH_SOLUTION_DIR + ADD_NAME_DICT[strategy] + "_SETS/" + benchmark + "_" + precision + "_" +  ADD_NAME_DICT[strategy] + ".v" + " "  + PATH_ARCH_DICT[strategy] + " -temp_dir " +  PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy] + " -start yosys  --timing_report_detail detailed --route_chan_width 150 &"
            os.system(cmd)
            print(cmd+" is running" + "\n")
            time.sleep(2)
# Group 2
for benchmark in Group2:
    for precision in Precision:
        for strategy in Group2_Strategy:
            # check if the result dir exists
            if os.path.exists(PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy]):
                os.system("rm -rf " + PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy])
            # copy the lib file
            # os.makedirs(PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy])
            os.system("cp -rf " + PATH_CIRCUITS + benchmark + " " + PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy] )
            # run the flow
            cmd = VTR_FLOW + " " + PATH_SOLUTION_DIR + ADD_NAME_DICT[strategy] + "_SETS/" + benchmark + "_" + precision + "_" +  ADD_NAME_DICT[strategy] + ".v" + " "  + PATH_ARCH_DICT[strategy] + " -temp_dir " +  PATH_RES_DIR + benchmark + "/" + benchmark + "_" + precision + "_" + strategy + "_" + ADD_NAME_DICT[strategy] + " -start yosys  --timing_report_detail detailed --route_chan_width 150 &"
            os.system(cmd)
            print(cmd+" is running" + "\n")
            time.sleep(2)
            # print(cmd + "\n")
