#!/usr/bin/env python3

'''
Author: haozhang haozhang@mail.sdu.edu.cn
Date: 2023-01-02 16:11:04
LastEditors: haozhang haozhang@mail.sdu.edu.cn
LastEditTime: 2023-01-18 18:07:03
FilePath: /Smokescreen/Flow/Scirpts/run_benchmark.py
Description: 

Copyright (c) 2023 by haozhang haozhang@mail.sdu.edu.cn, All Rights Reserved. 
'''
import os
import sys

# Circuits path
circuits_path = "~/Project/Smokescreen/Flow/Circuits/"
arch_path = "~/Project/Smokescreen/Flow/Arch/"
result_path = "~/Project/Smokescreen/Flow/Output/"
vtr_script_path = "~/Project/Smokescreen/Tools/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_flow.py"

# Benchmark name list

benchmarks = [ "lenet5_bram", "conv33", "conv55", "conv77","lstm",  "gemm10", "gemm100"] # 
benchmarks_vtr = [ "LU8PEEng",  "LU32PEEng", "mcml", "mkDelayWorker32B", "mkPktMerge", "mkSMAdapter4B" ] # "lenet5_bram","conv33", "conv55", "conv77",

# arch = ["k6FracN10LB_mem20K_complexDSP_customSB_22nm.dsp_heavy", "k6FracN10LB_mem20K_complexDSP_customSB_22nm_nvm.dsp_heavy", "k6FracN10LB_mem20K_complexDSP_customSB_22nm_pim_ald" ]
arch = ["k6FracN10LB_mem20K_complexDSP_customSB_22nm", "k6FracN10LB_mem20K_complexDSP_customSB_22nm.dsp_heavy", "k6FracN10LB_mem20K_complexDSP_customSB_22nm_nvm.dsp_heavy", "k6FracN10LB_mem20K_complexDSP_customSB_22nm_pim_ald", "k6FracN10LB_mem20K_complexDSP_customSB_22nm_pim_ald" ]
mode = ["base","baseh","nvm","pim","pimnvm"] # , "nvm", "pim" ,  "base","baseh","nvm","pim","pimnvm"
channel_width = {"lenet5_bram":"158", "lstm":"134", "conv33":"62", "conv55":"66", "conv77":"64", "gemm10":"78", "gemm100":"112"}

for mode_ in mode:
    if mode_ == "base":
        tmp_arch_path = arch[0] + ".xml"
        tmp_circuit_path_folder = "DSP"
        tmp_benchmarks = benchmarks + benchmarks_vtr
    elif mode_ == "baseh":
        tmp_arch_path = arch[1] + ".xml"
        tmp_circuit_path_folder = "DSP"
        tmp_benchmarks = benchmarks + benchmarks_vtr
    elif mode_ == "nvm":
        tmp_arch_path = arch[2] + ".xml"
        tmp_circuit_path_folder = "DSP"
        tmp_benchmarks = benchmarks + benchmarks_vtr
    elif mode_ == "pimnvm":
        tmp_arch_path = arch[3] + ".xml"
        tmp_circuit_path_folder = "DSP"
        tmp_benchmarks = benchmarks + benchmarks_vtr
    elif mode_ == "pim":
        tmp_arch_path = arch[4] + ".xml"
        tmp_circuit_path_folder = "PIM"
        tmp_benchmarks = benchmarks

    for benchmark in tmp_benchmarks:
        circuits_path_tmp = ""
        arch_path_tmp = ""
        result_path_tmp = ""
        channel_width_tmp = ""
        circuits_path_tmp = circuits_path + benchmark + "/" + tmp_circuit_path_folder + "/" + benchmark + ".v"
        arch_path_tmp = arch_path + tmp_arch_path
        result_path_tmp = result_path + mode_ + "/" + benchmark + "/"
        # channel_width_tmp = " --route_chan_width  " + channel_width[benchmark]
        # channel_width_tmp = " --route_chan_width  " + channel_width[benchmark]
        # Run benchmark
        cmd = vtr_script_path + " " + circuits_path_tmp + " " + arch_path_tmp + " -temp_dir " + result_path_tmp + " -start yosys" + " &"
        os.system(cmd)

