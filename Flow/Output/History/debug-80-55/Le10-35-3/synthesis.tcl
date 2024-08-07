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



# Read the HDL file with pre-defined parser in the run_vtr_flow script

# test_op.v (input circuit) is replaced with filename by the run_vtr_flow script

if {$env(PARSER) == "surelog" } {

	puts "Using Yosys read_uhdm command"

	plugin -i systemverilog

	yosys -import

	read_uhdm -debug test_op.v

} elseif {$env(PARSER) == "yosys-plugin" } {

	puts "Using Yosys read_systemverilog command"

	plugin -i systemverilog

	yosys -import

	read_systemverilog -debug test_op.v

} elseif {$env(PARSER) == "yosys" } {

	puts "Using Yosys read_verilog command"

	read_verilog -sv -nolatches test_op.v

} else {

	error "Invalid PARSER"

}



# read the custom complex blocks in the architecture

read_verilog -lib /root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/arch_dsps.v



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

techmap -map /root/Project/Smokescreen/Tools/vtr-verilog-to-routing/vtr_flow/misc/yosyslib/../../../ODIN_II/techlib/adffe2dff.v



# Map multipliers, DSPs, and add/subtracts according to yosys_models.v

techmap -map /root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/yosys_models.v */t:\$mul */t:\$mem */t:\$sub */t:\$add

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

read_verilog -lib /root/Project/Smokescreen/Tools/vtr-verilog-to-routing/vtr_flow/misc/yosyslib/adder.v

read_verilog -lib /root/Project/Smokescreen/Tools/vtr-verilog-to-routing/vtr_flow/misc/yosyslib/multiply.v

#(/root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/single_port_ram.v) will be replaced by single_port_ram.v by python script

read_verilog -lib /root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/single_port_ram.v

read_verilog -lib /root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/memory_pim.v

#(/root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/dual_port_ram.v) will be replaced by dual_port_ram.v by python script

read_verilog -lib /root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/dual_port_ram.v



# Rename singlePortRam to single_port_ram

# Rename dualPortRam to dual_port_ram

# rename function of Yosys not work here

# since it may outcome hierarchy error

#(/root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/spram_rename.v) will be replaced by spram_rename.v by python script

read_verilog /root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/spram_rename.v

read_verilog /root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/pimram_rename.v

#(/root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/dpram_rename.v) will be replaced by dpram_rename.v by python script

read_verilog /root/Project/Smokescreen/Flow/Output/debug/Le10-35-3/dpram_rename.v



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

# test_op.yosys.blif will be replaced by run_vtr_flow.pl

write_blif -true + vcc -false + gnd -undef + unconn -blackbox test_op.yosys.blif

