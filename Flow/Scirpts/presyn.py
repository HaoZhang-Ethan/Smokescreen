'''
Author: haozhang haozhang@mail.sdu.edu.cn
Date: 2023-04-02 03:13:45
LastEditors: haozhang haozhang@mail.sdu.edu.cn
LastEditTime: 2023-04-02 06:31:23
FilePath: /Smokescreen/Flow/Scirpts/presyn.py
Description: 

Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
'''
# 读取一个verilog文件，找到其中的所有包含某关键词的instances，然后将这些instances的名字和对应的module名字写入到一个文件中
# 用法：python main.py -i input.v -o output.txt -k keyword1,keyword2,keyword3
import argparse

parser = argparse.ArgumentParser(description='Find instances in a Verilog file containing certain keywords and write their names and corresponding module names to a file.')
parser.add_argument('-i', '--input', type=str, required=True, help='Input Verilog file')
parser.add_argument('-o', '--output', type=str, required=True, help='Output file')
parser.add_argument('-k', '--keywords', type=str, required=True, help='Comma-separated list of keywords to search for')
args = parser.parse_args()

keywords = args.keywords.split(',')

instances = []

with open(args.input, 'r') as f:
    for line in f:
        for keyword in keywords:
            if keyword in line:
                instance_name = line.split()[1]
                instances.append(instance_name)

with open(args.output, 'w') as f:
    for instance in instances:
        f.write(instance + '\n')


