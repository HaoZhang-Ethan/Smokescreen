<!--
 * @Author: Hao Zhang haozhang@mail.sdu.edu.cn
 * @Date: 2022-08-13 15:33:31
 * @LastEditors: haozhang-hoge haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2022-11-29 20:13:55
 * @FilePath: /Smokescreen/README.md
 * @Description: 
 * 
 * Copyright (c) 2022 by Hao Zhang haozhang@mail.sdu.edu.cn, All Rights Reserved. 
-->
# Smokescreen

## Introduction

Vector matrix multiplication by NV-FPGA

## Files structure

```
├── Flow                                                                        # Main work space
│   ├── Arch                                                                    # FPGA Architecture files
│   │   ├── k6FracN10LB_mem20K_complexDSP_customSB_22nm_pim_ald                 # Architecture file: BRAM-PIM with heavy DSP 
│   │   ├── k6FracN10LB_mem20K_complexDSP_customSB_22nm_pim_aln                 # Architecture file: BRAM-PIM with normal density DSP
│   │   ├── k6FracN10LB_mem20K_complexDSP_customSB_22nm.dsp_heavy               # Architecture file: heavy DSP
│   │   ├── k6FracN10LB_mem20K_complexDSP_customSB_22nm                         # Architecture file: normal density DSP
│   ├── Circuits                                                                # Circuits files
│   ├── Output                                                                  # Output files
│   ├── Scripts                                                                 # Scripts files
│   ├── Documents                                                               # Some documents of this project
├── Tool                                                                        # Some Tools
│   ├── MNSIM-2.0                                                               # MNSIM simulator used for quantization simulation
│   ├── vtr-verilog-to-routing                                                  # FPGA synthesis tool
├── README.md
```

## Implementation

### 1. git clone some dependent submodules

```bash
git submodule init
git submodule update
```

or you can use `git clone --recursive` to clone the whole project.

### 2. build vtr with yosys

Yosys is a framework for Verilog RTL synthesis, used as one of three VTR front-ends to perform logic synthesis, elaboration, and converting a subset of the Verilog Hardware Description Language (HDL) into a BLIF netlist.
For more information, please refer to [vtr](https://docs.verilogtorouting.org/en/latest/yosys/).

Maybe you have to install some python packages, such as `prettytable`.

Before building vtr, you should install some packages.
please refer to [vtr](https://docs.verilogtorouting.org/en/latest/BUILDING/) and [yosys](https://docs.verilogtorouting.org/en/latest/yosys/quickstart/#building)

```bash
$VTR_ROOT/ make CMAKE_PARAMS="-DWITH_YOSYS=ON"
```

### 