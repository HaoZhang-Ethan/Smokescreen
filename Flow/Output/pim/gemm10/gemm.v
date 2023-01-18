`define varraysize 1600   //100x16
`define Size 100   //100x16


module top(
input clk,
input reset,
input start,  		   //start the computation
input [6:0] start_addr,   //start address of the Xin bram (input words to LSTM)
input [6:0] end_addr,	  //end address of the Xin bram  
input [`varraysize-1:0] dummyin_u,
input [`varraysize-1:0] dummyin_v,
output [`DATA_WIDTH-1:0] ht_out, //output ht from the lstm
output reg Done        //Stays high indicating the end of lstm output computation for all the Xin words provided.
);


reg [6:0] waddr, inaddr;
reg wren_a, inren_a;
wire [`varraysize-1:0] mulout_fx;
assign ht_out = macout_fx;
//BRAMs storing the input and hidden weights of each of the gates
spram_v Wi_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wi_in));
//BRAM of the input vectors to LSTM
spram_v Xi_mem(.clk(clk),.address_a(inaddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(x_in));
vecmat_mul_x #(`varraysize,`INPUT_DEPTH) f_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wf_in),.tmp(mulout_fx));
vecmat_add_x #(`varraysize,`INPUT_DEPTH) f_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_fx),.data_out(macout_fx));




always @(posedge clk) begin
	if(reset == 1'b1) begin      
		waddr <= start_addr;
		inaddr <= start_addr;
		wren_a <= 1'b0;
		inren_a <= 1'b0;
		Done <= 1'b0;
	end
	else if (start==1'b0) begin 
			if(inaddr == end_addr_vec) begin
				Done = 1'b1;
			end
			else begin
				Done = 1'b0;
				inaddr = inaddr + 1'b1;
				waddr = waddr + 1'b1;
			end
	end

 


endmodule