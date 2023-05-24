/*********************************************************************



# Description: Renaming depth-split PimRam to memory_pim #



#			   to be recognized by VTR flow CAD tools. This file  	 #



#			   is executed by the Yosys synthesis flow once the      #



#			   memory_pim.v is executed.		  	  			 #



#																  	 #



# Author: Seyed Alireza Damghani (sdamghann@gmail.com)   		 	 #



*********************************************************************/







`timescale 1ps/1ps







`define MEM_MAXADDR 9



`define MEM_MAXDATA 36







// depth and data may need to be splited



module PimRam(clk, we, addr, data, out);







    parameter ADDR_WIDTH = `MEM_MAXADDR;



    parameter DATA_WIDTH = 1;







    input clk;



    input we;



    input [ADDR_WIDTH - 1:0] addr;



    input [DATA_WIDTH - 1:0] data;



    



    output reg [DATA_WIDTH - 1:0] out;    







	memory_pim uut (



                    .clk(clk), 



                    .we(we), 



                    .addr(addr), 



                    .data(data), 



                    .out(out)



                );







endmodule







(* blackbox *)



module memory_pim(clk, data, addr, we, out);







    localparam ADDR_WIDTH = `MEM_MAXADDR;



    localparam DATA_WIDTH = 1;







    input clk;



    input we;



    input [ADDR_WIDTH-1:0] addr;



    input [DATA_WIDTH-1:0] data;



    



    output reg [DATA_WIDTH-1:0] out;



    /*



    reg [DATA_WIDTH-1:0] RAM [(1<<ADDR_WIDTH)-1:0];







    always @(posedge clk)



    begin



        if (we)



                RAM[addr] <= data;



                



        out <= RAM[addr];



    end



    */



endmodule

