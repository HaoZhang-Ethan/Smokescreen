# synthesis different FPGA layout to get the resource with different FPGA SIZE
import os 



with open("/root/Project/Smokescreen/Flow/Scirpts/Lib/FPGA_SIZE.lib", 'w') as f:
    tmp_str = "SIZE" + "\t" + "CLB" + "\t" +  "DSP" + "\t" + "BRAM" +"\n"
    f.write(tmp_str)      

for i in range(5,1000):
    #   Read the Verilog file
    tmp_verilog_buffer = []
    with open("/root/Project/Smokescreen/Flow/Scirpts/get_FPGA_SIZE/data/Arch/k6FracN10LB_mem20K_complexDSP_customSB_22nm_pim_ald_n.xml", 'r') as f:
        for line in f:
            line = line.replace("zhwidth" , str(i)).replace("zhheight" , str(i))
            tmp_verilog_buffer.append(line)
    # write the blackboxes Verilog file
    with open("/root/Project/Smokescreen/Flow/Scirpts/get_FPGA_SIZE/data/Arch/tmp.xml", 'w') as f:
        for tmp_verilog_ in tmp_verilog_buffer:
            f.write(tmp_verilog_)
    cmd = "/root/Project/Smokescreen/Flow/Scirpts/get_FPGA_SIZE/data/vpr /root/Project/Smokescreen/Flow/Scirpts/get_FPGA_SIZE/data/Arch/tmp.xml /root/Project/Smokescreen/Flow/Scirpts/get_FPGA_SIZE/data/demo.blif --pack --route_chan_width 20"
    # 执行指令
    os.system(cmd)

    while not os.path.exists("/root/Project/Smokescreen/Flow/Scirpts/get_FPGA_SIZE/vpr_stdout.log"):
        pass
        print("---")

    
    #   Read the synthesis result
    tmp_flag_res_find = 0
    with open("/root/Project/Smokescreen/Flow/Scirpts/get_FPGA_SIZE/vpr_stdout.log", 'r') as f:
        for line in f:
            if line.find("Resource usage") != -1:
                tmp_flag_res_find = 6
            if tmp_flag_res_find > 0:
                if tmp_flag_res_find == 6 and line.find("clb") != -1 :
                    tmp_flag_res_find = tmp_flag_res_find -1
                    NUM_BASE_CLB = line.split()[0]
                elif tmp_flag_res_find == 5 and line.find("clb") != -1 :
                    tmp_flag_res_find = tmp_flag_res_find -1
                    NUM_BASE_FPGA_CLB = line.split()[0]
                elif tmp_flag_res_find == 4 and line.find("dsp_top") != -1 :
                    tmp_flag_res_find = tmp_flag_res_find -1
                    NUM_BASE_DSP = line.split()[0] 
                elif tmp_flag_res_find == 3 and line.find("dsp_top") != -1 :
                    tmp_flag_res_find = tmp_flag_res_find -1
                    NUM_BASE_FPGA_DSP = line.split()[0]   
                elif tmp_flag_res_find == 2 and line.find("memory") != -1 :
                    tmp_flag_res_find = tmp_flag_res_find -1
                    NUM_BASE_BRAM = line.split()[0]
                elif tmp_flag_res_find == 1 and line.find("memory") != -1 :
                    tmp_flag_res_find = tmp_flag_res_find -2
                    NUM_BASE_FPGA_BRAM = line.split()[0]     

    with open("/root/Project/Smokescreen/Flow/Scirpts/Lib/FPGA_SIZE.lib", 'a') as f:
        tmp_str = str(i) + "\t" + NUM_BASE_FPGA_CLB + "\t" +  NUM_BASE_FPGA_DSP + "\t" + NUM_BASE_FPGA_BRAM +"\n"
        f.write(tmp_str)         
