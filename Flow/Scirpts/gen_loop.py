'''
Author: haozhang haozhang@mail.sdu.edu.cn
Date: 2023-03-31 03:03:29
LastEditors: haozhang haozhang@mail.sdu.edu.cn
LastEditTime: 2023-03-31 07:08:36
FilePath: /Smokescreen/Flow/Scirpts/gen_loop.py
Description: 

Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
'''
# 展开verilog 中的 generate for 循环
# 生成的文件放在当前目录下
# 生成的文件名为：原文件名 + _gen.v

import os

from pyverilog.vparser.parser import parse
from pyverilog.vparser.ast import *


# Parse the Verilog file
filename = 'test.v'
ast, _ = parse([filename])

# Find the generate for loop
for item in ast.description.definitions:
    if isinstance(item, ModuleDef):
        for item2 in item.items:
            if isinstance(item2, Genvar):
                if item2.name == 'i':
                    for item3 in item.items:
                        if isinstance(item3, GenerateFor):
                            print(item3)
                            # Do something with the generate for loop