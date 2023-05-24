#!/usr/bin/env python3

'''
Author: haozhang haozhang@mail.sdu.edu.cn
Date: 2023-01-02 16:11:04
LastEditors: haozhang haozhang@mail.sdu.edu.cn
LastEditTime: 2023-01-20 06:08:51
FilePath: /Smokescreen/Flow/Scirpts/get_res.py
Description: 

Copyright (c) 2023 by haozhang haozhang@mail.sdu.edu.cn, All Rights Reserved. 
'''
import os
import sys

# Circuits path
circuits_path = "/root/Project/Smokescreen/Flow/Circuits/"
arch_path = "/root/Project/Smokescreen/Flow/Arch/"
result_path = "/root/Project/Smokescreen/Flow/Output/"
vtr_script_path = "/root/Project/Smokescreen/Tools/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_flow.py"

# Benchmark name list

benchmarks = [ "lenet5_bram", "conv33", "conv55", "conv77","lstm",  "gemm10", "gemm100"] # 
benchmarks_vtr = [ "LU8PEEng",  "LU32PEEng", "mcml", "mkDelayWorker32B", "mkPktMerge", "mkSMAdapter4B" ] # "lenet5_bram","conv33", "conv55", "conv77",

mode = ["base","baseh","nvm","pim","pimnvm"] # , "nvm", "pim" ,  "base","baseh","nvm","pim","pimnvm"

Per_dict = {}
Log_Area_dict = {}
Rout_Area_dict = {}

# /root/Project/Smokescreen/Flow/Output/base/lenet5_bram/vpr.out
benchmarks = benchmarks + benchmarks_vtr
for benchmark in benchmarks:
    for mode_ in mode:
        # Get the result
        Log_Area_dict[benchmark + "_" + mode_] = "0"
        Rout_Area_dict[benchmark + "_" + mode_] = "0"
        Per_dict[benchmark + "_" + mode_] = "0"
        result_file = result_path + mode_ + "/" + benchmark + "/vpr.out"
        if not os.path.exists(result_file):
            print("The result file is not exist!")
        else:
            with open(result_file, 'r') as f:
                lines = f.readlines()
                for line in lines:
                    if "Total logic block area" in line:        
                        tmp_list = line.split(" ")
                        Log_Area_dict[benchmark + "_" + mode_] = str(tmp_list[len(tmp_list)-1].replace("\n", ""))
                        print(tmp_list[len(tmp_list)-1])
                    if "Total routing area" in line:
                        tmp_list = line.split(" ")
                        Rout_Area_dict[benchmark + "_" + mode_] = str(tmp_list[3].replace(",", "").replace("\n", ""))
                        print(Rout_Area_dict[benchmark + "_" + mode_])
                    # if "Final critical path delay" in line:
                    #     Per_dict[benchmark + "_" + mode_] = str(line.split("Fmax:")[1].strip().split()[0].replace("\n", ""))
                    #     print(Per_dict[benchmark + "_" + mode_])
                    if "Final critical path delay" in line:
                        Per_dict[benchmark + "_" + mode_] = str(line.split("slack):")[1].strip().split()[0].replace("\n", ""))
                        print(Per_dict[benchmark + "_" + mode_])


# print the result in the txt file
with open(result_path + "result.txt", 'w') as f:
    for benchmark in benchmarks:
        # f.write(benchmark  + " ")
        for mode_ in mode:
            f.write(benchmark  + "\t")
            f.write(mode_ + "\t")
            f.write(Log_Area_dict[benchmark + "_" + mode_] + "\t" + Rout_Area_dict[benchmark + "_" + mode_] + "\t" + Per_dict[benchmark + "_" + mode_])
            f.write("\n")


