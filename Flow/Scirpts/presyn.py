#!/usr/bin/env python3

'''
Author: haozhang haozhang@mail.sdu.edu.cn
Date: 2023-04-02 03:13:45
LastEditors: haozhang haozhang@mail.sdu.edu.cn
LastEditTime: 2023-05-02 07:08:02
FilePath: /Smokescreen/Flow/Scirpts/presyn.py
Description: 

Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
'''
# 读取一个verilog文件，找到其中的所有包含某关键词的instances，然后将这些instances的名字和对应的module名字写入到一个文件中
# 用法：python main.py -i input.v -o output.txt -k keyword1,keyword2,keyword3
import argparse
import math
import random
import copy
import os
import time
import psutil



# Debug Flag
Get_BLK = 0
AUTO_EXE = 0
FIND_OP = 0
GET_FIND_OP_RES = 0
SA_RUN = 1

# Parse the command line arguments
parser = argparse.ArgumentParser(description='Find instances in a Verilog file containing certain keywords and write their names and corresponding module names to a file.')
parser.add_argument('-i', '--input', type=str, required=True, help='Input Verilog file')
parser.add_argument('-o', '--output', type=str, required=True, help='Output file')
# parser.add_argument('-k', '--keywords', type=str, required=True, help='Comma-separated list of keywords to search for')
args = parser.parse_args()

# Function
# calculate the FPGA size
def calu_FPGA_SIZE(size, INST):
    if (DICT_FPGA_SIZE[size-1][0] <= INST.NUM_BASE_CLB or DICT_FPGA_SIZE[size-1][1] <= INST.NUM_BASE_DSP or DICT_FPGA_SIZE[size-1][2] <= INST.NUM_BASE_BRAM ) and (DICT_FPGA_SIZE[size][0] >= INST.NUM_BASE_CLB and DICT_FPGA_SIZE[size][1] >= INST.NUM_BASE_DSP and DICT_FPGA_SIZE[size][2] >= INST.NUM_BASE_BRAM):
        return size
    elif (DICT_FPGA_SIZE[size][0] < INST.NUM_BASE_CLB or DICT_FPGA_SIZE[size][1] < INST.NUM_BASE_DSP or DICT_FPGA_SIZE[size][2] < INST.NUM_BASE_BRAM):
        return calu_FPGA_SIZE(size+1, INST)
    elif (DICT_FPGA_SIZE[size-1][0] > INST.NUM_BASE_CLB and DICT_FPGA_SIZE[size-1][1] > INST.NUM_BASE_DSP and DICT_FPGA_SIZE[size-1][2] > INST.NUM_BASE_BRAM):
        return calu_FPGA_SIZE(size-1, INST)


# global parameters
PATH_FPGA_SIZE_LIB = "/root/Project/Smokescreen/Flow/Scirpts/Lib/FPGA_SIZE.lib"

KIND_OP_CHIP = 0 # the kind of OP that can be supported by the chip

DICT_FPGA_SIZE = {} # the FPGA size and the corresponding CLB, DSP, BRAM number

# read FPGA SIZE from the lib file
with open(PATH_FPGA_SIZE_LIB, 'r') as f:
    next(f)
    # 遍历文件中每一行
    for line in f:
        # 按空格分割每一行，生成一个列表
        values = line.strip().split('\t')
        # 将第一个元素作为 key，其余元素作为 value 组成一个列表
        DICT_FPGA_SIZE[int(values[0])] = [int(values[1]), int(values[2]), int(values[3])]

# define the class of the OP
class OP:
    def __init__(self, op_name, op_key, op_dsp, op_clb, op_pim, op_blk ):
        self.OP_name = op_name   # the OP name
        self.OP_key = op_key    # the keyword of OP, such as "conv55_6bit" How to find the OP in the Verilog file?
        self.OP_DSP = op_dsp    # the DSP module name
        self.OP_CLB = op_clb    # the CLB module name
        self.OP_PIM = op_pim    # the PIM module name
        self.OP_BLK = op_blk    # the blackbox module name

# define the class of the CIRCUIT
class CIRCUIT:
    def __init__(self ):
        self.BASE_FPGA_SIZE = 0   # the base FPGA size
        self.NUM_BASE_FPGA_CLB = 0
        self.NUM_BASE_FPGA_DSP = 0
        self.NUM_BASE_FPGA_BRAM = 0
        self.NUM_BASE_CLB = 0
        self.NUM_BASE_DSP = 0
        self.NUM_BASE_BRAM = 0
        self.NUM_OP_VERILOG = 0    # the number of OP in the Verilog file
        self.DICT_OP = {}
        self.NET = 0
        self.DENSITY = 0

# initialize the OP
OP_SET = []
OP_DICT = {}
OP_AREA_DICT = {}
OP_NET_DICT = {}
# TODO: if you add a new type op, you should add the following code
OP_SET.append(OP("conv55_6bit", "conv55_6bit", "conv55_6bit_DSP", "conv55_6bit_CLB", "conv55_6bit_PIM", "conv55_6bit_BLK"))
OP_DICT["conv55_6bit"] = ["conv55_6bit_DSP", "conv55_6bit_CLB", "conv55_6bit_PIM"]
OP_AREA_DICT["conv55_6bit_DSP"] = [25, 24, 0]
OP_AREA_DICT["conv55_6bit_CLB"] = [150, 0, 0]
OP_AREA_DICT["conv55_6bit_PIM"] = [15, 90, 94]
OP_NET_DICT["conv55_6bit_DSP"] = 1097
OP_NET_DICT["conv55_6bit_CLB"] = 4841
OP_NET_DICT["conv55_6bit_PIM"] = 20499
# OP_AREA_DICT["conv55_6bit_DSP"] = [14, 0, 3]
# OP_AREA_DICT["conv55_6bit_CLB"] = [14, 0, 3]
# OP_AREA_DICT["conv55_6bit_PIM"] = [14, 0, 3]
KIND_OP_CHIP = len(OP_SET)
# initialize the CIRCUIT
CIRCUIT_inst = CIRCUIT()
# read the Verilog file and replace the instances with the blackboxes module
# Read the Verilog file
tmp_verilog_buffer = []
with open(args.input, 'r') as f:
    for line in f:
        for OP_ in OP_SET:
            line = line.replace(OP_.OP_key , OP_.OP_BLK)
            CIRCUIT_inst.NUM_OP_VERILOG = CIRCUIT_inst.NUM_OP_VERILOG + line.count(OP_.OP_key)
            if line.count(OP_.OP_key) != 0:
                CIRCUIT_inst.DICT_OP[line.split()[1]] =  [OP_.OP_key, OP_.OP_BLK]
            tmp_verilog_buffer.append(line)
# write the blackboxes Verilog file
f.close()
with open(args.output, 'w') as f:
    for tmp_verilog_ in tmp_verilog_buffer:
        f.write(tmp_verilog_)
f.close()
if Get_BLK == 1:
    cmd =  "/root/Project/Smokescreen/Tools/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_flow.py /root/Project/Smokescreen/Flow/Scirpts/out.v  /root/Project/Smokescreen/Flow/Arch/k6FracN10LB_mem20K_complexDSP_customSB_22nm_pim_ald_n.xml  -temp_dir /root/Project/Smokescreen/Flow/Scirpts/tmp -start yosys  --timing_report_detail detailed --route_chan_width 150"
    os.system(cmd)
    while(1):
        if os.path.exists("/root/Project/Smokescreen/Flow/Scirpts/tmp/out.route"):
            cmd = "cp /root/Project/Smokescreen/Flow/Scirpts/tmp/vpr_stdout.log " + args.input.replace(".v","") + "_BLK_vpr.out"
            os.system(cmd)
            break
        time.sleep(5)


# catch the base information from blackboxes synthesis result
#   Read the synthesis result
tmp_flag_res_find = 0
with open(args.input.replace(".v","") + "_BLK_vpr.out", 'r') as f:
    for line in f:
        if line.find("Resource usage") != -1:
            tmp_flag_res_find = 6
        if tmp_flag_res_find > 0:
            if tmp_flag_res_find == 6 and line.find("clb") != -1 :
                tmp_flag_res_find = tmp_flag_res_find -1
                CIRCUIT_inst.NUM_BASE_CLB = int(line.split()[0])
            elif tmp_flag_res_find == 5 and line.find("clb") != -1 :
                tmp_flag_res_find = tmp_flag_res_find -1
                CIRCUIT_inst.NUM_BASE_FPGA_CLB = int(line.split()[0])
            elif tmp_flag_res_find == 4 and line.find("dsp_top") != -1 :
                tmp_flag_res_find = tmp_flag_res_find -1
                CIRCUIT_inst.NUM_BASE_DSP = int(line.split()[0])
            elif tmp_flag_res_find == 3 and line.find("dsp_top") != -1 :
                tmp_flag_res_find = tmp_flag_res_find -1
                CIRCUIT_inst.NUM_BASE_FPGA_DSP = int(line.split()[0])
            elif tmp_flag_res_find == 2 and line.find("memory") != -1 :
                tmp_flag_res_find = tmp_flag_res_find -1
                CIRCUIT_inst.NUM_BASE_BRAM = int(line.split()[0])
            elif tmp_flag_res_find == 1 and line.find("memory") != -1 :
                tmp_flag_res_find = tmp_flag_res_find -1
                CIRCUIT_inst.NUM_BASE_FPGA_BRAM = int(line.split()[0])   
        if line.find("FPGA sized to") != -1: 
            CIRCUIT_inst.BASE_FPGA_SIZE = int(line.split()[3])

# generate a initial solution
# traverse the DICT_OP of CIRCUIT_inst and randomly assign the OP to the OP_M
for key, value in CIRCUIT_inst.DICT_OP.items():
    CIRCUIT_inst.DICT_OP[key][1] =  random.choice(OP_DICT[CIRCUIT_inst.DICT_OP[key][0]]) # OP_DICT[CIRCUIT_inst.DICT_OP[key][0]][2] #
    CIRCUIT_inst.NUM_BASE_CLB = CIRCUIT_inst.NUM_BASE_CLB + OP_AREA_DICT[CIRCUIT_inst.DICT_OP[key][1]][0]
    CIRCUIT_inst.NUM_BASE_DSP = CIRCUIT_inst.NUM_BASE_DSP + OP_AREA_DICT[CIRCUIT_inst.DICT_OP[key][1]][1]
    CIRCUIT_inst.NUM_BASE_BRAM = CIRCUIT_inst.NUM_BASE_BRAM + OP_AREA_DICT[CIRCUIT_inst.DICT_OP[key][1]][2]
    CIRCUIT_inst.BASE_FPGA_SIZE = calu_FPGA_SIZE(CIRCUIT_inst.BASE_FPGA_SIZE, CIRCUIT_inst)
    CIRCUIT_inst.NET = CIRCUIT_inst.NET + OP_NET_DICT[CIRCUIT_inst.DICT_OP[key][1]]
    CIRCUIT_inst.DENSITY = CIRCUIT_inst.NET/CIRCUIT_inst.BASE_FPGA_SIZE

def simulated_annealing(cost_function, initial_solution, temperature, cooling_rate, stopping_temperature):
    NUM_SA_TRY = 0
    current_solution = initial_solution
    current_A_cost, current_P_cost = cost_function(current_solution)
    best_solution = current_solution
    best_cost = current_A_cost
    print(best_cost)
    # some flag to accelerate the SA
    failed_try = 0
    while temperature > stopping_temperature:
        NUM_SA_TRY = NUM_SA_TRY + 1
        candidate_solution = generate_neighbor(current_solution)
        candidate_A_cost, candidate_P_cost = cost_function(candidate_solution)
        delta_A = candidate_A_cost - current_A_cost
        delta_P = candidate_P_cost - current_P_cost
        if  delta_P <= 0 or  math.exp(-delta_P / temperature) > random.uniform(0, 1):
        # if delta_A < 0 or (math.exp(-delta_A / temperature) > random.uniform(0, 1)):
        #     # print(delta_P)
        #     if math.exp(-delta_P / temperature) > random.uniform(0, 1):
                print(delta_A, delta_P)
                print("A-", current_A_cost, current_P_cost, "CLB: ", current_solution.NUM_BASE_CLB, "DSP: ", current_solution.NUM_BASE_DSP, "BRAM: ", current_solution.NUM_BASE_BRAM, "FPGA_SIZE: ", current_solution.BASE_FPGA_SIZE, "NET: ", current_solution.NET, "NUM_SA_TRY: ", NUM_SA_TRY, "temperature: ", temperature, "failed_try: ", failed_try)
                print("B-", candidate_A_cost, candidate_P_cost, "CLB: ", candidate_solution.NUM_BASE_CLB, "DSP: ", candidate_solution.NUM_BASE_DSP, "BRAM: ", candidate_solution.NUM_BASE_BRAM, "FPGA_SIZE: ", candidate_solution.BASE_FPGA_SIZE, "NET: ", candidate_solution.NET, "NUM_SA_TRY: ", NUM_SA_TRY, "temperature: ", temperature, "failed_try: ", failed_try)
                current_solution = copy.deepcopy(candidate_solution)
                current_A_cost = candidate_A_cost  
                current_P_cost = candidate_P_cost  
                # if delta_A > 0 and delta_P > 0:
                #     failed_try = failed_try + 1
                #     if failed_try > math.ceil(math.sqrt(temperature)):
                #         current_solution = copy.deepcopy(best_solution)
                #         failed_try = 0
            # if current_A_cost < best_cost:
                best_solution = copy.deepcopy(current_solution)
                best_cost = current_A_cost
                print("best_cost" + str(best_cost) +  "\t temperature" + str(temperature))
                print(best_solution.NUM_BASE_CLB/DICT_FPGA_SIZE[best_solution.BASE_FPGA_SIZE][0], best_solution.NUM_BASE_DSP/DICT_FPGA_SIZE[best_solution.BASE_FPGA_SIZE][1], best_solution.NUM_BASE_BRAM/DICT_FPGA_SIZE[best_solution.BASE_FPGA_SIZE][2])
        temperature *= cooling_rate
    print("try swap " + str(NUM_SA_TRY) + "\n")
    print(best_cost)
    return best_solution, best_cost

def generate_neighbor(solution):
    tmp_solution = copy.deepcopy(solution)
    random_key = random.choice(list(tmp_solution.DICT_OP)) 
    tmp_solution.NUM_BASE_CLB = tmp_solution.NUM_BASE_CLB - OP_AREA_DICT[tmp_solution.DICT_OP[random_key][1]][0]
    tmp_solution.NUM_BASE_DSP = tmp_solution.NUM_BASE_DSP - OP_AREA_DICT[tmp_solution.DICT_OP[random_key][1]][1]
    tmp_solution.NUM_BASE_BRAM = tmp_solution.NUM_BASE_BRAM - OP_AREA_DICT[tmp_solution.DICT_OP[random_key][1]][2]
    tmp_solution.NET = tmp_solution.NET - OP_NET_DICT[tmp_solution.DICT_OP[random_key][1]]
    tmp_solution.DICT_OP[random_key][1] =  OP_DICT[tmp_solution.DICT_OP[random_key][0]][rand_sele(tmp_solution)] # random.choice(OP_DICT[tmp_solution.DICT_OP[random_key][0]]) # 
    # print(tmp_solution.DICT_OP[random_key][1])
    tmp_solution.NUM_BASE_CLB = tmp_solution.NUM_BASE_CLB + OP_AREA_DICT[tmp_solution.DICT_OP[random_key][1]][0]
    tmp_solution.NUM_BASE_DSP = tmp_solution.NUM_BASE_DSP + OP_AREA_DICT[tmp_solution.DICT_OP[random_key][1]][1]
    tmp_solution.NUM_BASE_BRAM = tmp_solution.NUM_BASE_BRAM + OP_AREA_DICT[tmp_solution.DICT_OP[random_key][1]][2]
    tmp_solution.BASE_FPGA_SIZE = calu_FPGA_SIZE(tmp_solution.BASE_FPGA_SIZE, tmp_solution)
    tmp_solution.NET = tmp_solution.NET + OP_NET_DICT[tmp_solution.DICT_OP[random_key][1]]
    tmp_solution.DENSITY = tmp_solution.NET/tmp_solution.BASE_FPGA_SIZE
    return tmp_solution

def rand_sele(solution):
    # print(str(round(solution.NUM_BASE_CLB/DICT_FPGA_SIZE[solution.BASE_FPGA_SIZE+1][0],3))+"-"+str(round(solution.NUM_BASE_DSP/DICT_FPGA_SIZE[solution.BASE_FPGA_SIZE+1][1],3))+"-"+str(round(solution.NUM_BASE_BRAM/DICT_FPGA_SIZE[solution.BASE_FPGA_SIZE+1][2],3)))
    CLB_R = random.uniform(0, round(1-solution.NUM_BASE_CLB/DICT_FPGA_SIZE[solution.BASE_FPGA_SIZE+1][0],3))
    DSP_R = random.uniform(0, round(1-solution.NUM_BASE_DSP/DICT_FPGA_SIZE[solution.BASE_FPGA_SIZE+1][1],3))
    BRAM_R = random.uniform(0, round(1-solution.NUM_BASE_BRAM/DICT_FPGA_SIZE[solution.BASE_FPGA_SIZE+1][2],3))
    tmp = [DSP_R, CLB_R, BRAM_R]
    return tmp.index(max(tmp))

def cost_function(solution):
    max_num = max(solution.NUM_BASE_CLB/DICT_FPGA_SIZE[solution.BASE_FPGA_SIZE][0], solution.NUM_BASE_DSP/DICT_FPGA_SIZE[solution.BASE_FPGA_SIZE][1], solution.NUM_BASE_BRAM/DICT_FPGA_SIZE[solution.BASE_FPGA_SIZE][2])
    A_Cost = solution.BASE_FPGA_SIZE # + max_num + 
    P_Cost = (solution.NET) # /(solution.BASE_FPGA_SIZE*solution.BASE_FPGA_SIZE)
    return A_Cost, P_Cost

if SA_RUN == 1:    
    best_solution, best_cost = simulated_annealing(cost_function, CIRCUIT_inst, temperature = 1000, cooling_rate = 0.9999, stopping_temperature = 0.0001)

    # read the Verilog file and replace the instances with the blackboxes module
    # Read the Verilog file
    tmp_verilog_buffer = []
    with open(args.input, 'r') as f:
        for line in f:
            for OP_ in OP_SET:
                if line.count(OP_.OP_key) != 0:
                    line = line.replace(OP_.OP_key ,best_solution.DICT_OP[line.split()[1]][1])
                tmp_verilog_buffer.append(line)
    # write the blackboxes Verilog file
    with open(args.input.replace(".v","_myop.v"), 'w') as f:
        for tmp_verilog_ in tmp_verilog_buffer:
            f.write(tmp_verilog_)
    print("ok")






if FIND_OP == 1:
    # execute synthesis
    # generate folder
    for tmp_num_dsp in range(0,len(CIRCUIT_inst.DICT_OP)+1):
        for tmp_num_clb in range(0,len(CIRCUIT_inst.DICT_OP)+1):
            for tmp_num_pim in range(0,1): # len(CIRCUIT_inst.DICT_OP)+1
                if (tmp_num_dsp + tmp_num_clb + tmp_num_pim) == len(CIRCUIT_inst.DICT_OP):
                    tmp_vector = [0] * len(CIRCUIT_inst.DICT_OP)
                    for tmp_j in range(0,tmp_num_dsp):
                        tmp_vector[tmp_j] = 0
                    for tmp_j in range(tmp_num_dsp, tmp_num_dsp + tmp_num_clb):
                        tmp_vector[tmp_j] = 1
                    for tmp_j in range(tmp_num_dsp + tmp_num_clb, tmp_num_dsp + tmp_num_clb + tmp_num_pim):
                        tmp_vector[tmp_j] = 2
                    random.shuffle(tmp_vector)
                    path = "/root/Project/Smokescreen/Flow/Output/debug/Le" + str(tmp_num_dsp) + "-" + str(tmp_num_clb) + "-" + str(tmp_num_pim) + "/"
                    if os.path.exists(path):
                        cmd = "cp -f " + "/root/Project/Smokescreen/Flow/Circuits/lenet5/Adapt/*.v" + " " + path
                        os.system(cmd)
                    else:
                        cmd = "mkdir " + path 
                        os.system(cmd)
                        cmd = "cp " + "/root/Project/Smokescreen/Flow/Circuits/lenet5/Adapt/*.v" + " " + path
                        os.system(cmd)
                    time.sleep(0.5)
                    tmp_verilog_buffer = []
                    tmp_CIRCUIT_inst = copy.deepcopy(CIRCUIT_inst)
                    tmp_j = 0
                    for key, value in tmp_CIRCUIT_inst.DICT_OP.items():
                        tmp_CIRCUIT_inst.DICT_OP[key][1] =  OP_DICT[tmp_CIRCUIT_inst.DICT_OP[key][0]][tmp_vector[tmp_j]]
                        tmp_j = tmp_j + 1
                    # read the Verilog file and replace the instances with the blackboxes module
                    # Read the Verilog file
                    tmp_verilog_buffer = []
                    with open(args.input, 'r') as f:
                        for line in f:
                            for OP_ in OP_SET:
                                if line.count(OP_.OP_key) != 0:
                                    line = line.replace(OP_.OP_key ,tmp_CIRCUIT_inst.DICT_OP[line.split()[1]][1])
                                tmp_verilog_buffer.append(line)
                    # write the blackboxes Verilog file
                    with open(args.input.replace(".v","_op.v"), 'w') as f:
                        for tmp_verilog_ in tmp_verilog_buffer:
                            f.write(tmp_verilog_)
                    print("ok")
                    # execute synthesis
                    cmd = "/root/Project/Smokescreen/Tools/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_flow.py /root/Project/Smokescreen/Flow/Scirpts/test_op.v /root/Project/Smokescreen/Flow/Arch/k6FracN10LB_mem20K_complexDSP_customSB_22nm_pim_ald_n.xml  -temp_dir " + path + " -start yosys  --timing_report_detail detailed --route_chan_width 80 &"
                    while True:
                        # if cpu usage is less than 95%, then execute the command
                        if psutil.cpu_percent() < 95:
                            if os.path.exists(path + "test_op.route"):
                                break
                            os.system(cmd)
                            break
                        else:
                            time.sleep(10)

if GET_FIND_OP_RES == 1:
    # write the report
    re_f = open("/root/Project/Smokescreen/Flow/Scirpts/test_op.res", 'w')

    # read the report
    for tmp_num_dsp in range(0,len(CIRCUIT_inst.DICT_OP)+1):
            for tmp_num_clb in range(0, 1): #len(CIRCUIT_inst.DICT_OP)+1):
                for tmp_num_pim in range(0, len(CIRCUIT_inst.DICT_OP)+1): # 1):
                    if (tmp_num_dsp + tmp_num_clb + tmp_num_pim) == len(CIRCUIT_inst.DICT_OP):
                        path = "/root/Project/Smokescreen/Flow/Output/debug/Le" + str(tmp_num_dsp) + "-" + str(tmp_num_clb) + "-" + str(tmp_num_pim) + "/"
                        if os.path.exists(path):
                            if os.path.exists(path + "test_op.route"):
                                # read the report
                                T_area = 0
                                L_area = 0
                                R_area = 0
                                CP = 0
                                with open(path + "vpr_stdout.log", 'r') as f:
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
                                if CP != 0:
                                    re_f.write(str(tmp_num_dsp) + "-" + str(tmp_num_clb) + "-" + str(tmp_num_pim) + "\t" + str(L_area) + "\t" + str(T_area) + "\t" + str(R_area) + "\t" + str(T_area+R_area) + "\t" + str(CP) + "\n")


