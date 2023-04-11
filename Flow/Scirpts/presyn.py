#!/usr/bin/env python3

'''
Author: haozhang haozhang@mail.sdu.edu.cn
Date: 2023-04-02 03:13:45
LastEditors: haozhang haozhang@mail.sdu.edu.cn
LastEditTime: 2023-04-11 14:24:05
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

# initialize the OP
OP_SET = []
OP_DICT = {}
OP_AREA_DICT = {}

# TODO: if you add a new type op, you should add the following code
OP_SET.append(OP("conv55_6bit", "conv55_6bit", "conv55_6bit_DSP", "conv55_6bit_CLB", "conv55_6bit_PIM", "conv55_6bit_BLK"))
OP_DICT["conv55_6bit"] = ["conv55_6bit_DSP", "conv55_6bit_CLB", "conv55_6bit_PIM"]
OP_AREA_DICT["conv55_6bit_DSP"] = [25, 24, 0]
OP_AREA_DICT["conv55_6bit_CLB"] = [150, 0, 0]
OP_AREA_DICT["conv55_6bit_PIM"] = [14, 0, 3]

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
with open(args.output, 'w') as f:
    for tmp_verilog_ in tmp_verilog_buffer:
        f.write(tmp_verilog_)

# TODO: auto run the synthesis tool








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
    CIRCUIT_inst.DICT_OP[key][1] = random.choice(OP_DICT[CIRCUIT_inst.DICT_OP[key][0]])
    CIRCUIT_inst.NUM_BASE_CLB = CIRCUIT_inst.NUM_BASE_CLB + OP_AREA_DICT[CIRCUIT_inst.DICT_OP[key][1]][0]
    CIRCUIT_inst.NUM_BASE_DSP = CIRCUIT_inst.NUM_BASE_DSP + OP_AREA_DICT[CIRCUIT_inst.DICT_OP[key][1]][1]
    CIRCUIT_inst.NUM_BASE_BRAM = CIRCUIT_inst.NUM_BASE_BRAM + OP_AREA_DICT[CIRCUIT_inst.DICT_OP[key][1]][2]
    CIRCUIT_inst.BASE_FPGA_SIZE = calu_FPGA_SIZE(CIRCUIT_inst.BASE_FPGA_SIZE, CIRCUIT_inst)


        


    


def simulated_annealing(cost_function, initial_solution, temperature, cooling_rate, stopping_temperature):
    NUM_SA_TRY = 0
    current_solution = initial_solution
    current_cost = cost_function(current_solution)
    best_solution = current_solution
    best_cost = current_cost
    print(best_cost)
    while temperature > stopping_temperature:
        NUM_SA_TRY = NUM_SA_TRY + 1
        candidate_solution = generate_neighbor(current_solution)
        candidate_cost = cost_function(candidate_solution)
        delta = candidate_cost - current_cost
        if delta < 0 or math.exp(-delta / temperature) > random.uniform(0, 1):
            current_solution = copy.deepcopy(candidate_solution)
            current_cost = copy.deepcopy(candidate_cost)
        if current_cost < best_cost:
            best_solution = copy.deepcopy(current_solution)
            best_cost = current_cost
        temperature *= cooling_rate
    print("try swap " + str(NUM_SA_TRY) + "\n")
    print(best_cost)
    return best_solution, best_cost

def generate_neighbor(solution):
    # print("generate_neighbor")
    random_key = random.choice(list(solution.DICT_OP))
    solution.NUM_BASE_CLB = solution.NUM_BASE_CLB - OP_AREA_DICT[solution.DICT_OP[random_key][1]][0]
    solution.NUM_BASE_DSP = solution.NUM_BASE_DSP - OP_AREA_DICT[solution.DICT_OP[random_key][1]][1]
    solution.NUM_BASE_BRAM = solution.NUM_BASE_BRAM - OP_AREA_DICT[solution.DICT_OP[random_key][1]][2]
    solution.DICT_OP[random_key][1] = random.choice(OP_DICT[solution.DICT_OP[random_key][0]])
    solution.NUM_BASE_CLB = solution.NUM_BASE_CLB + OP_AREA_DICT[solution.DICT_OP[random_key][1]][0]
    solution.NUM_BASE_DSP = solution.NUM_BASE_DSP + OP_AREA_DICT[solution.DICT_OP[random_key][1]][1]
    solution.NUM_BASE_BRAM = solution.NUM_BASE_BRAM + OP_AREA_DICT[solution.DICT_OP[random_key][1]][2]
    solution.BASE_FPGA_SIZE = calu_FPGA_SIZE(solution.BASE_FPGA_SIZE, solution)
    # print("ok")
    
    return solution

def cost_function(solution):
    # print("cost_function")
    return  solution.BASE_FPGA_SIZE

def func(cost_function):
    cost_function()

best_solution, best_cost = simulated_annealing(cost_function, CIRCUIT_inst, temperature = 999, cooling_rate = 0.9999, stopping_temperature = 0.0001)

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
with open(args.input.replace(".v","_op.v"), 'w') as f:
    for tmp_verilog_ in tmp_verilog_buffer:
        f.write(tmp_verilog_)

print("ok")