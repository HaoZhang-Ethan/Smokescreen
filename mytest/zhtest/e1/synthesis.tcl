#################################################################

# Yosys synthesis script, including generic 'synth' commands,   #

# in addition to techmap asynchronous FFs and VTR hard blocks.  #

# Once the VTR flow runs with the Yosys front-end, Yosys        #

# synthesizes the input design using the following commands.    #

#                                                               #

# NOTE: the script is adapted from the one Eddie Hung proposed  #

# for VTR-to-Bitstream[1]. However, a few minor changes to make #

# it adaptable with the current VTR flow have been made.        #

#                                                               #

# [1] http://eddiehung.github.io/vtb.html                       #

#                                                               #

# Author: Eddie Hung                                            #

# Co-author: Seyed Alireza Damghani (sdamghann@gmail.com)       #

#################################################################

yosys -import



# t1.v (input circuit) is replaced with filename by the run_vtr_flow script

read_verilog -sv -nolatches t1.v



# read the custom complex blocks in the architecture

read_verilog -lib /home/zolid/Project/Smokescreen/mytest/zhtest/e1/arch_dsps.v



# These commands follow the generic `synth'

# command script inside Yosys

# The -libdir argument allows Yosys to search the current 

# directory for any definitions to modules it doesn't know

# about, such as hand-instantiated (not inferred) memories

hierarchy -check -auto-top -libdir .

procs



# Check that there are no combinational loops

scc -select

select -assert-none %

select -clear





opt_expr

opt_clean

check

opt -nodffe -nosdff

fsm

opt

wreduce

peepopt

opt_clean

share

opt

memory -nomap

opt -full



# Transform all async FFs into synchronous ones

techmap -map +/adff2dff.v

techmap -map /home/zolid/Project/Smokescreen/Tools/vtr-verilog-to-routing/vtr_flow/misc/yosyslib/../../../ODIN_II/techlib/adffe2dff.v



# Map multipliers, DSPs, and add/subtracts according to yosys_models.v

techmap -map /home/zolid/Project/Smokescreen/mytest/zhtest/e1/yosys_models.v */t:\$mul */t:\$mem */t:\$sub */t:\$add

opt -fast -full



memory_map

# Taking care to remove any undefined muxes that

# are introduced to promote resource sharing

opt -full



# Then techmap all other `complex' blocks into basic

# (lookup table) logic

techmap 

opt -fast



# read the definitions for all the VTR primitives

# as blackboxes

read_verilog -lib /home/zolid/Project/Smokescreen/Tools/vtr-verilog-to-routing/vtr_flow/misc/yosyslib/adder.v

read_verilog -lib /home/zolid/Project/Smokescreen/Tools/vtr-verilog-to-routing/vtr_flow/misc/yosyslib/multiply.v

#(/home/zolid/Project/Smokescreen/mytest/zhtest/e1/single_port_ram.v) will be replaced by single_port_ram.v by python script

read_verilog -lib /home/zolid/Project/Smokescreen/mytest/zhtest/e1/single_port_ram.v

read_verilog -lib /home/zolid/Project/Smokescreen/mytest/zhtest/e1/memory_pim.v

#(/home/zolid/Project/Smokescreen/mytest/zhtest/e1/dual_port_ram.v) will be replaced by dual_port_ram.v by python script

read_verilog -lib /home/zolid/Project/Smokescreen/mytest/zhtest/e1/dual_port_ram.v



# Rename singlePortRam to single_port_ram

# Rename dualPortRam to dual_port_ram

# rename function of Yosys not work here

# since it may outcome hierarchy error

#(/home/zolid/Project/Smokescreen/mytest/zhtest/e1/spram_rename.v) will be replaced by spram_rename.v by python script

read_verilog /home/zolid/Project/Smokescreen/mytest/zhtest/e1/spram_rename.v

read_verilog /home/zolid/Project/Smokescreen/mytest/zhtest/e1/pimram_rename.v

#(/home/zolid/Project/Smokescreen/mytest/zhtest/e1/dpram_rename.v) will be replaced by dpram_rename.v by python script

read_verilog /home/zolid/Project/Smokescreen/mytest/zhtest/e1/dpram_rename.v



# Flatten the netlist

flatten

# Turn all DFFs into simple latches

dffunmap

opt -fast -noff



# Lastly, check the hierarchy for any unknown modules,

# and purge all modules (including blackboxes) that

# aren't used

hierarchy -check -purge_lib

tee -o /dev/stdout stat



autoname



# Then write it out as a blif file, remembering to call

# the internal `$true'/`$false' signals vcc/gnd, but

# switch `-impltf' doesn't output them

# t1.yosys.blif will be replaced by run_vtr_flow.pl

write_blif -true + vcc -false + gnd -undef + unconn -blackbox t1.yosys.blif

