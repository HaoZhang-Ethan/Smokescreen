//////////////////////////////////////////////////////////////////////////////
// Author: Aishwarya Rajen
//////////////////////////////////////////////////////////////////////////////

function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = -1; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction


//`define SIMULATION_MEMORY
`define ARRAY_DEPTH 64      //Number of Hidden neurons
`define INPUT_DEPTH 100	    //LSTM input vector dimensions
`define DATA_WIDTH 16		//16 bit representation
`define INWEIGHT_DEPTH 6400 //100x64
`define HWEIGHT_DEPTH 4096  //64x64
`define varraysize 1600   //100x16
`define uarraysize 1024  //64x16

/////////////////////////////////////////////////////////////////////////////////
//LSTM layer design
/////////////////////////////////////////////////////////////////////////////////
//
//This verilog implementation can be used for LSTM inference applications.
//LSTM contains four gates :Input,Output,Forget and Cell State.
//The architecture is such that the four gates can be parallelized for the 
//most part except for the ending few stages were previous cycle output is 
//required. The weights of the gates (obtained from training using Python or
//other sources) is stored and accessed through BRAMs on the FPGA.
//Fixed Point 16 (4.12) format is used
//This is a pipelined LSTM network design with the following blocks:
//1.MVM - Matrix vector multiplication Block
//	Every cycle one row of the matrix gets multiplied with the vector producing 
//	one 16 bit output which can get processed by further stages.
//2.ELEMENT WISE ADD 
//	16 bit addition
//3.SIGMOID
//	LUT based Sigmoid approximation
//4.ELEMENT WISE MULTIPLICATION
//	2s complement based signed multiplication
//5.TANH
//	LUT based tanH approximation
//
//////////////////////////////////////////////////////////////////////////////////



module top(
input clk,
input reset,
input start,  		   //start the computation
input [6:0] start_addr,   //start address of the Xin bram (input words to LSTM)
input [6:0] end_addr,	  //end address of the Xin bram 
output ht_valid,	//indicates the output ht_out is valid in those cycles
output [`DATA_WIDTH-1:0] ht_out, //output ht from the lstm
output reg cycle_complete,	//generates a pulse when a cycle fo 64 ht outputs are complete
output reg Done,        //Stays high indicating the end of lstm output computation for all the Xin words provided.
output [21:0] test_1
);

wire [`uarraysize-1:0] Ui_in;
wire [`varraysize-1:0] Wi_in;
wire [`uarraysize-1:0] Uf_in;
wire [`varraysize-1:0] Wf_in;
wire [`uarraysize-1:0] Uo_in;
wire [`varraysize-1:0] Wo_in;
wire [`uarraysize-1:0] Uc_in;
wire [`varraysize-1:0] Wc_in;
wire [`varraysize-1:0] x_in;
reg [`uarraysize-1:0] h_in;


reg [`uarraysize-1:0] dummyin_u;
reg [`varraysize-1:0] dummyin_v;
reg [`DATA_WIDTH-1:0] dummyin_b;

wire [`DATA_WIDTH-1:0] bi_in;
wire [`DATA_WIDTH-1:0] bf_in;
wire [`DATA_WIDTH-1:0] bo_in;
wire [`DATA_WIDTH-1:0] bc_in;
reg [`DATA_WIDTH-1:0] C_in;
//wire [`varraysize-1:0] xdata_b_ext;
//wire [`uarraysize-1:0] hdata_b_ext;

//keeping an additional bit so that the counters don't get reset to 0 automatically after 63 
//and start repeating access to elements prematurely
reg [6:0] inaddr; 
reg [6:0] waddr;
reg wren_a;
reg [6:0] c_count;
reg [6:0] b_count;
reg [6:0] ct_count;
reg [6:0] count;
reg [6:0] i,j;
reg [5:0] h_count;

wire [`DATA_WIDTH-1:0] ht;
reg [`uarraysize-1:0] ht_prev;
reg [`uarraysize-1:0] Ct;
wire [`DATA_WIDTH-1:0] add_cf;
reg wren_a_ct, wren_b_cin;

assign ht_out = ht;


//indicates that the ht_out output is valid 
assign ht_valid = (count>16)?1:0;


//BRAMs storing the input and hidden weights of each of the gates
//Hidden weights are represented by U and Input weights by W
spram_u Ui_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Ui_in));
spram_u Uf_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Uf_in));
spram_u Uo_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Uo_in));
spram_u Uc_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Uc_in));
spram_v Wi_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wi_in));
spram_v Wf_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wf_in));
spram_v Wo_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wo_in));
spram_v Wc_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wc_in));

//BRAM of the input vectors to LSTM
spram_v Xi_mem(.clk(clk),.address_a(inaddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(x_in));

//BRAM storing Bias of each gate
spram_b bi_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bi_in));
spram_b bf_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bf_in));
spram_b bo_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bo_in));
spram_b bc_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bc_in));


lstm_top lstm(.clk(clk),.rst(reset),.ht_out(ht),.Ui_in(Ui_in),.Wi_in(Wi_in),.Uf_in(Uf_in),.Wf_in(Wf_in),.Uo_in(Uo_in),.Wo_in(Wo_in),
.Uc_in(Uc_in),.Wc_in(Wc_in),.x_in(x_in),.h_in(h_in),.C_in(C_in),.bi_in(bi_in),.bf_in(bf_in),.bo_in(bo_in),.bc_in(bc_in),.add_cf(add_cf),.test_1(test_1));

always @(posedge clk) begin
 if(reset == 1'b1 || start==1'b0) 
  begin      
	   count <= 0;
	   b_count <=0;
	   h_count <= 0;
	   c_count <= 0;
	   ct_count <=0;
	   Ct <= 0;
	   C_in <=0;
	   h_in <= 0;
	   ht_prev <= 0;
	   wren_a <= 0;
	   wren_a_ct <= 1;
	   wren_b_cin <= 0;
	   cycle_complete <=0;
	   Done <= 0;
   	   waddr <=0;	
	   inaddr <= start_addr;
	  
	   //dummy ports initialize
	   dummyin_u <= 0; 
	   dummyin_v <=0;
	   dummyin_b <= 0;
 
  end
  else begin
	
	if(h_count == `ARRAY_DEPTH-1) begin
		cycle_complete <= 1; 
		waddr <= 0;
		count <=0;
		b_count <= 0;
		ct_count <=0;
		c_count <= 0;
	
		if(inaddr == end_addr)
			Done = 1;			
		else begin
			inaddr <= inaddr+1;
			h_count <= 0;

		 end
	 end
	 else begin
		cycle_complete <= 0;
    	waddr <= waddr+1;
	  	count <= count+1;
	 
		if(count>7)     //delay before bias add
			b_count <= b_count+1; 

		if(count >8)  begin //delay before Cin elmul
			c_count <=c_count+1;
			case(c_count)
			0: C_in<=Ct[16*0+:16] ;
			1: C_in<=Ct[16*1+:16] ;
			2: C_in<=Ct[16*2+:16] ;
			3: C_in<=Ct[16*3+:16] ;
			4: C_in<=Ct[16*4+:16] ;
			5: C_in<=Ct[16*5+:16] ;
			6: C_in<=Ct[16*6+:16] ;
			7: C_in<=Ct[16*7+:16] ;
			8: C_in<=Ct[16*8+:16] ;
			9: C_in<=Ct[16*9+:16] ;
			10: C_in <=Ct[16*10+:16];
			11: C_in <=Ct[16*11+:16];
			12: C_in <=Ct[16*12+:16];
			13: C_in <=Ct[16*13+:16];
			14: C_in <=Ct[16*14+:16];
			15: C_in <=Ct[16*15+:16];
			16: C_in <=Ct[16*16+:16];
			17: C_in <=Ct[16*17+:16];
			18: C_in <=Ct[16*18+:16];
			19: C_in <=Ct[16*19+:16];
			20: C_in <=Ct[16*20+:16];
			21: C_in <=Ct[16*21+:16];
			22: C_in <=Ct[16*22+:16];
			23: C_in <=Ct[16*23+:16];
			24: C_in <=Ct[16*24+:16];
			25: C_in <=Ct[16*25+:16];
			26: C_in <=Ct[16*26+:16];
			27: C_in <=Ct[16*27+:16];
			28: C_in <=Ct[16*28+:16];
			29: C_in <=Ct[16*29+:16];
			30: C_in <=Ct[16*30+:16];
			31: C_in <=Ct[16*31+:16];
			32: C_in <=Ct[16*32+:16];
			33: C_in <=Ct[16*33+:16];
			34: C_in <=Ct[16*34+:16];
			35: C_in <=Ct[16*35+:16];
			36: C_in <=Ct[16*36+:16];
			37: C_in <=Ct[16*37+:16];
			38: C_in <=Ct[16*38+:16];
			39: C_in <=Ct[16*39+:16];
			40: C_in <=Ct[16*40+:16];
			41: C_in <=Ct[16*41+:16];
			42: C_in <=Ct[16*42+:16];
			43: C_in <=Ct[16*43+:16];
			44: C_in <=Ct[16*44+:16];
			45: C_in <=Ct[16*45+:16];
			46: C_in <=Ct[16*46+:16];
			47: C_in <=Ct[16*47+:16];
			48: C_in <=Ct[16*48+:16];
			49: C_in <=Ct[16*49+:16];
			50: C_in <=Ct[16*50+:16];
			51: C_in <=Ct[16*51+:16];
			52: C_in <=Ct[16*52+:16];
			53: C_in <=Ct[16*53+:16];
			54: C_in <=Ct[16*54+:16];
			55: C_in <=Ct[16*55+:16];
			56: C_in <=Ct[16*56+:16];
			57: C_in <=Ct[16*57+:16];
			58: C_in <=Ct[16*58+:16];
			59: C_in <=Ct[16*59+:16];
			60: C_in <=Ct[16*60+:16];
			61: C_in <=Ct[16*61+:16];
			62: C_in <=Ct[16*62+:16];
			63: C_in <=Ct[16*63+:16];
			default : C_in <= 0;
		endcase	
		end

		if(count >11) begin  //for storing output of Ct
			ct_count <= ct_count+1;
		 //storing cell state
			case(ct_count)
			0:	Ct[16*0+:16] <= add_cf;
			1:	Ct[16*1+:16] <= add_cf;
			2:	Ct[16*2+:16] <= add_cf;
			3:	Ct[16*3+:16] <= add_cf;
			4:	Ct[16*4+:16] <= add_cf;
			5:	Ct[16*5+:16] <= add_cf;
			6:	Ct[16*6+:16] <= add_cf;
			7:	Ct[16*7+:16] <= add_cf;
			8:	Ct[16*8+:16] <= add_cf;
			9:	Ct[16*9+:16] <= add_cf;
			10:	Ct[16*10+:16] <=add_cf;
			11:	Ct[16*11+:16] <=add_cf;
			12:	Ct[16*12+:16] <=add_cf;
			13:	Ct[16*13+:16] <=add_cf;
			14:	Ct[16*14+:16] <=add_cf;
			15:	Ct[16*15+:16] <=add_cf;
			16:	Ct[16*16+:16] <=add_cf;
			17:	Ct[16*17+:16] <=add_cf;
			18:	Ct[16*18+:16] <=add_cf;
			19:	Ct[16*19+:16] <=add_cf;
			20:	Ct[16*20+:16] <=add_cf;
			21:	Ct[16*21+:16] <=add_cf;
			22:	Ct[16*22+:16] <=add_cf;
			23:	Ct[16*23+:16] <=add_cf;
			24:	Ct[16*24+:16] <=add_cf;
			25:	Ct[16*25+:16] <=add_cf;
			26:	Ct[16*26+:16] <=add_cf;
			27:	Ct[16*27+:16] <=add_cf;
			28:	Ct[16*28+:16] <=add_cf;
			29:	Ct[16*29+:16] <=add_cf;
			30:	Ct[16*30+:16] <=add_cf;
			31:	Ct[16*31+:16] <=add_cf;
			32:	Ct[16*32+:16] <=add_cf;
			33:	Ct[16*33+:16] <=add_cf;
			34:	Ct[16*34+:16] <=add_cf;
			35:	Ct[16*35+:16] <=add_cf;
			36:	Ct[16*36+:16] <=add_cf;
			37:	Ct[16*37+:16] <=add_cf;
			38:	Ct[16*38+:16] <=add_cf;
			39:	Ct[16*39+:16] <=add_cf;
			40:	Ct[16*40+:16] <=add_cf;
			41:	Ct[16*41+:16] <=add_cf;
			42:	Ct[16*42+:16] <=add_cf;
			43:	Ct[16*43+:16] <=add_cf;
			44:	Ct[16*44+:16] <=add_cf;
			45:	Ct[16*45+:16] <=add_cf;
			46:	Ct[16*46+:16] <=add_cf;
			47:	Ct[16*47+:16] <=add_cf;
			48:	Ct[16*48+:16] <=add_cf;
			49:	Ct[16*49+:16] <=add_cf;
			50:	Ct[16*50+:16] <=add_cf;
			51:	Ct[16*51+:16] <=add_cf;
			52:	Ct[16*52+:16] <=add_cf;
			53:	Ct[16*53+:16] <=add_cf;
			54:	Ct[16*54+:16] <=add_cf;
			55:	Ct[16*55+:16] <=add_cf;
			56:	Ct[16*56+:16] <=add_cf;
			57:	Ct[16*57+:16] <=add_cf;
			58:	Ct[16*58+:16] <=add_cf;
			59:	Ct[16*59+:16] <=add_cf;
			60:	Ct[16*60+:16] <=add_cf;
			61:	Ct[16*61+:16] <=add_cf;
			62:	Ct[16*62+:16] <=add_cf;
			63:	Ct[16*63+:16] <=add_cf;
			default : Ct <= 0;
		 endcase
		end
		if(count >16) begin
			h_count <= h_count + 1;
			case(h_count)
			0:	ht_prev[16*0+:16] <= ht;
			1:	ht_prev[16*1+:16] <= ht;
			2:	ht_prev[16*2+:16] <= ht;
			3:	ht_prev[16*3+:16] <= ht;
			4:	ht_prev[16*4+:16] <= ht;
			5:	ht_prev[16*5+:16] <= ht;
			6:	ht_prev[16*6+:16] <= ht;
			7:	ht_prev[16*7+:16] <= ht;
			8:	ht_prev[16*8+:16] <= ht;
			9:	ht_prev[16*9+:16] <= ht;
			10:	ht_prev[16*10+:16] <= ht;
			11:	ht_prev[16*11+:16] <= ht;
			12:	ht_prev[16*12+:16] <= ht;
			13:	ht_prev[16*13+:16] <= ht;
			14:	ht_prev[16*14+:16] <= ht;
			15:	ht_prev[16*15+:16] <= ht;
			16:	ht_prev[16*16+:16] <= ht;
			17:	ht_prev[16*17+:16] <= ht;
			18:	ht_prev[16*18+:16] <= ht;
			19:	ht_prev[16*19+:16] <= ht;
			20:	ht_prev[16*20+:16] <= ht;
			21:	ht_prev[16*21+:16] <= ht;
			22:	ht_prev[16*22+:16] <= ht;
			23:	ht_prev[16*23+:16] <= ht;
			24:	ht_prev[16*24+:16] <= ht;
			25:	ht_prev[16*25+:16] <= ht;
			26:	ht_prev[16*26+:16] <= ht;
			27:	ht_prev[16*27+:16] <= ht;
			28:	ht_prev[16*28+:16] <= ht;
			29:	ht_prev[16*29+:16] <= ht;
			30:	ht_prev[16*30+:16] <= ht;
			31:	ht_prev[16*31+:16] <= ht;
			32:	ht_prev[16*32+:16] <= ht;
			33:	ht_prev[16*33+:16] <= ht;
			34:	ht_prev[16*34+:16] <= ht;
			35:	ht_prev[16*35+:16] <= ht;
			36:	ht_prev[16*36+:16] <= ht;
			37:	ht_prev[16*37+:16] <= ht;
			38:	ht_prev[16*38+:16] <= ht;
			39:	ht_prev[16*39+:16] <= ht;
			40:	ht_prev[16*40+:16] <= ht;
			41:	ht_prev[16*41+:16] <= ht;
			42:	ht_prev[16*42+:16] <= ht;
			43:	ht_prev[16*43+:16] <= ht;
			44:	ht_prev[16*44+:16] <= ht;
			45:	ht_prev[16*45+:16] <= ht;
			46:	ht_prev[16*46+:16] <= ht;
			47:	ht_prev[16*47+:16] <= ht;
			48:	ht_prev[16*48+:16] <= ht;
			49:	ht_prev[16*49+:16] <= ht;
			50:	ht_prev[16*50+:16] <= ht;
			51:	ht_prev[16*51+:16] <= ht;
			52:	ht_prev[16*52+:16] <= ht;
			53:	ht_prev[16*53+:16] <= ht;
			54:	ht_prev[16*54+:16] <= ht;
			55:	ht_prev[16*55+:16] <= ht;
			56:	ht_prev[16*56+:16] <= ht;
			57:	ht_prev[16*57+:16] <= ht;
			58:	ht_prev[16*58+:16] <= ht;
			59:	ht_prev[16*59+:16] <= ht;
			60:	ht_prev[16*60+:16] <= ht;
			61:	ht_prev[16*61+:16] <= ht;
			62:	ht_prev[16*62+:16] <= ht;
			63:	ht_prev[16*63+:16] <= ht;
			default: ht_prev <= 0;
			endcase
		 end
			
	end
		


	if(cycle_complete==1) begin
		  h_in <= ht_prev; 
	end

  end
 end
 


endmodule





module spram_v(	
input clk,
input [(7-1):0] address_a,
input  wren_a,
input [(`varraysize-1):0] data_a,
output reg [(`varraysize-1):0] out_a
);


`ifdef SIMULATION_MEMORY

reg [`varraysize-1:0] ram[`ARRAY_DEPTH-1:0];

always @ (posedge clk) begin 
  if (wren_a) begin
      ram[address_a] <= data_a;
  end
  else begin
      out_a <= ram[address_a];
  end
end
  

`else

defparam u_single_port_ram.ADDR_WIDTH = 7;
defparam u_single_port_ram.DATA_WIDTH = `varraysize;
single_port_ram u_single_port_ram(
.addr(address_a),
.we(wren_a),
.data(data_a),
.out(out_a),
.clk(clk)
);

`endif

endmodule

module spram_u (	
input clk,
input [(7-1):0] address_a,
input  wren_a,
input [(`uarraysize-1):0] data_a,
output reg [(`uarraysize-1):0] out_a
);


`ifdef SIMULATION_MEMORY

reg [`uarraysize-1:0] ram[`ARRAY_DEPTH-1:0];

always @ (posedge clk) begin 
  if (wren_a) begin
      ram[address_a] <= data_a;
  end
  else begin
      out_a <= ram[address_a];
  end
end
  

`else

defparam u_single_port_ram.ADDR_WIDTH = 7;
defparam u_single_port_ram.DATA_WIDTH = `uarraysize;
single_port_ram u_single_port_ram(
.addr(address_a),
.we(wren_a),
.data(data_a),
.out(out_a),
.clk(clk)
);

`endif

endmodule

module spram_b (	
input clk,
input [(7-1):0] address_a,
input  wren_a,
input [(`DATA_WIDTH-1):0] data_a,
output reg [(`DATA_WIDTH-1):0] out_a
);


`ifdef SIMULATION_MEMORY

reg [`DATA_WIDTH-1:0] ram[`ARRAY_DEPTH-1:0];

always @ (posedge clk) begin 
  if (wren_a) begin
      ram[address_a] <= data_a;
  end
  else begin
      out_a <= ram[address_a];
  end
end
  

`else

defparam u_single_port_ram.ADDR_WIDTH = 7;
defparam u_single_port_ram.DATA_WIDTH = `DATA_WIDTH;
single_port_ram u_single_port_ram(
.addr(address_a),
.we(wren_a),
.data(data_a),
.out(out_a),
.clk(clk)
);

`endif

endmodule


module lstm_top(
input clk,
input rst,
output  [15:0] ht_out,
input [`uarraysize-1:0] Ui_in,
input [`varraysize-1:0] Wi_in,
input [`uarraysize-1:0] Uf_in,
input [`varraysize-1:0] Wf_in,
input [`uarraysize-1:0] Uo_in,
input [`varraysize-1:0] Wo_in,
input [`uarraysize-1:0] Uc_in,
input [`varraysize-1:0] Wc_in,
input [`varraysize-1:0] x_in,
input [`uarraysize-1:0] h_in,
input [`DATA_WIDTH-1:0] bi_in,
input [`DATA_WIDTH-1:0] bf_in,
input [`DATA_WIDTH-1:0] bo_in,
input [`DATA_WIDTH-1:0] bc_in,
input [`DATA_WIDTH-1:0] C_in,
output [`DATA_WIDTH-1:0] add_cf,
output [`DATA_WIDTH-1:0] test_1
);


wire [`uarraysize-1:0] mulout_ih;
wire [`uarraysize-1:0] mulout_fh;
wire [`uarraysize-1:0] mulout_ch;
wire [`uarraysize-1:0] mulout_oh;

wire [`varraysize-1:0] mulout_ix;
wire [`varraysize-1:0] mulout_fx;
wire [`varraysize-1:0] mulout_cx;
wire [`varraysize-1:0] mulout_ox;

wire [`DATA_WIDTH-1:0] macout_ix;
wire [`DATA_WIDTH-1:0] macout_ih;
wire [`DATA_WIDTH-1:0] add_i;
wire [`DATA_WIDTH-1:0] macout_fx;
wire [`DATA_WIDTH-1:0] macout_fh;
wire [`DATA_WIDTH-1:0] add_f;
wire [`DATA_WIDTH-1:0] macout_cx;
wire [`DATA_WIDTH-1:0] macout_ch;
wire [`DATA_WIDTH-1:0] add_c;
wire [`DATA_WIDTH-1:0] macout_ox;
wire [`DATA_WIDTH-1:0] macout_oh;
wire [`DATA_WIDTH-1:0] add_o;
//wire [`DATA_WIDTH-1:0] add_cf;


wire [`DATA_WIDTH-1:0] addbias_i;
wire [`DATA_WIDTH-1:0] addbias_f;
wire [`DATA_WIDTH-1:0] addbias_o;
wire [`DATA_WIDTH-1:0] addbias_c;

wire [`DATA_WIDTH-1:0] sig_io;
wire [`DATA_WIDTH-1:0] sig_fo;
wire [`DATA_WIDTH-1:0] sig_oo;


wire [`DATA_WIDTH-1:0] elmul_fo;
wire [`DATA_WIDTH-1:0] elmul_co;
wire [`DATA_WIDTH-1:0] tan_c;
wire [`DATA_WIDTH-1:0] tan_h;


wire [15:0] ht;


assign ht_out = ht;

reg [15:0] mac_fx_reg,mac_fh_reg,add_f_reg,addb_f_reg,sig_fo_reg;
reg [15:0] mac_ix_reg,mac_ih_reg,add_i_reg,addb_i_reg,sig_io_reg;
reg [15:0] mac_ox_reg,mac_oh_reg, add_o_reg,addb_o_reg,sig_oo_reg;
reg [15:0] mac_cx_reg,mac_ch_reg, add_c_reg,addb_c_reg,sig_co_reg;
reg [15:0] tan_c_reg,elmul_co_reg,add_cf_reg,tan_h_reg,elmul_fo_reg;

reg [`uarraysize-1:0] mulout_ih_reg,mulout_fh_reg,mulout_oh_reg,mulout_ch_reg;
reg [`varraysize-1:0] mulout_ix_reg,mulout_fx_reg,mulout_ox_reg,mulout_cx_reg;

reg [15:0] sig_oo_d1,sig_oo_d2,sig_oo_d3,sig_oo_d4,sig_oo_d5;

always @(posedge clk) begin

//Pipeline Registers
		mulout_fx_reg <= mulout_fx;
		mulout_fh_reg <= mulout_fh;
		mac_fx_reg <= macout_fx;
		mac_fh_reg <= macout_fh;
		add_f_reg <= add_f;
		addb_f_reg <= addbias_f; 
		sig_fo_reg <= sig_fo;
		elmul_fo_reg <= elmul_fo; //check if need to delay to wait for elmul_co

		mulout_ix_reg <= mulout_ix;
		mulout_ih_reg <= mulout_ih;
		mac_ix_reg <= macout_ix;
		mac_ih_reg <= macout_ih;
		add_i_reg <= add_i;
		addb_i_reg <= addbias_i; 
		sig_io_reg <= sig_io;
		
		mulout_ox_reg <= mulout_ox;
		mulout_oh_reg <= mulout_oh;
		mac_ox_reg <= macout_ox;
		mac_oh_reg <= macout_oh;
		add_o_reg <= add_o;
		addb_o_reg <= addbias_o; 
		sig_oo_reg <= sig_oo;   


		sig_oo_d1 <= sig_oo_reg; //delaying sig_oo by 5 cycles to feed to c gate
		sig_oo_d2 <= sig_oo_d1;
		sig_oo_d3 <= sig_oo_d2;
	    sig_oo_d4 <= sig_oo_d3;
		sig_oo_d5 <= sig_oo_d4;

		mulout_cx_reg <= mulout_cx;
		mulout_ch_reg <= mulout_ch;
		mac_cx_reg <= macout_cx;
		mac_ch_reg <= macout_ch;
		add_c_reg <= add_c;
		addb_c_reg <= addbias_c; 
		tan_c_reg <= tan_c;
		elmul_co_reg <= elmul_co;
		add_cf_reg <= add_cf;
		tan_h_reg <= tan_h; 

end


//FORGET GATE
  vecmat_x_8_CLB vecmat_add_OP_1(.clk(clk), .reset(rst), .data_x(x_in), .W_x(Wf_in), .data_out_x(macout_fx));
  vecmat_h_8_CLB vecmat_add_OP_2(.clk(clk), .reset(rst), .data_h(h_in), .W_h(Uf_in), .data_out_h(macout_fh));
//   vecmat_mul_x #(`varraysize,`INPUT_DEPTH) f_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wf_in),.tmp(mulout_fx));
//   vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) f_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Uf_in),.tmp(mulout_fh));
//   vecmat_add_x #(`varraysize,`INPUT_DEPTH) f_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_fx_reg),.data_out(macout_fx));
//   vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) f_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_fh_reg),.data_out(macout_fh));
  qadd2 f_gate_add(.a(mac_fx_reg),.b(mac_fh_reg),.c(add_f));
//   assign add_f = macout_fx | macout_fh;
//   assign addbias_f = add_f | bf_in;
  qadd2 f_gate_biasadd(.a(bf_in),.b(add_f),.c(addbias_f));
  sigmoid sigf(addbias_f,sig_fo);
  //qmult #(12,16) f_elmul(.i_multiplicand(sig_fo_reg),.i_multiplier(C_in),.o_result(elmul_fo),.ovr(overflow0));
  signedmul f_elmul(.clk(clk),.a(sig_fo_reg),.b(C_in),.c(elmul_fo));
//   assign test_1 = sig_fo;
//INPUT GATE
  vecmat_x_8_CLB vecmat_add_OP_3(.clk(clk), .reset(rst), .data_x(Wi_in), .W_x(Wi_in), .data_out_x(macout_ix));
  vecmat_h_8_CLB vecmat_add_OP_4(.clk(clk), .reset(rst), .data_h(Ui_in), .W_h(Ui_in), .data_out_h(macout_ih));
//   vecmat_mul_x #(`varraysize,`INPUT_DEPTH) i_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wi_in),.tmp(mulout_ix));
//   vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) i_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Ui_in),.tmp(mulout_ih));
//   vecmat_add_x #(`varraysize,`INPUT_DEPTH) i_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_ix_reg),.data_out(macout_ix));
//   vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) i_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_ih_reg),.data_out(macout_ih));
  qadd2 i_gate_add(.a(mac_ix_reg),.b(mac_ih_reg),.c(add_i));
  qadd2 i_gate_biasadd(.a(bi_in),.b(add_i),.c(addbias_i));
  sigmoid sigi(addb_i_reg,sig_io);

//OUTPUT GATE
  vecmat_x_8_CLB vecmat_add_OP_5(.clk(clk), .reset(rst), .data_x(x_in), .W_x(Wo_in), .data_out_x(macout_ox));
  vecmat_h_8_CLB vecmat_add_OP_6(.clk(clk), .reset(rst), .data_h(h_in), .W_h(Uo_in), .data_out_h(macout_oh));
//   vecmat_mul_x #(`varraysize,`INPUT_DEPTH) o_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wo_in),.tmp(mulout_ox));
//   vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) o_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Uo_in),.tmp(mulout_oh));
//   vecmat_add_x #(`varraysize,`INPUT_DEPTH) o_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_ox_reg),.data_out(macout_ox));
//   vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) o_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_oh_reg),.data_out(macout_oh));
  qadd2 o_gate_add(.a(mac_ox_reg),.b(mac_oh_reg),.c(add_o));
  qadd2 o_gate_biasadd(.a(bo_in),.b(add_o),.c(addbias_o));
  sigmoid sigo(addb_o_reg,sig_oo);

//CELL STATE GATE
  vecmat_x_8_CLB vecmat_add_OP_7(.clk(clk), .reset(rst), .data_x(x_in), .W_x(Wc_in), .data_out_x(macout_cx));
  vecmat_h_8_CLB vecmat_add_OP_8(.clk(clk), .reset(rst), .data_h(h_in), .W_h(Uc_in), .data_out_h(macout_ch));
//   vecmat_mul_x #(`varraysize,`INPUT_DEPTH) c_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wc_in),.tmp(mulout_cx));
//   vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) c_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Uc_in),.tmp(mulout_ch));
//   vecmat_add_x #(`varraysize,`INPUT_DEPTH) c_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_cx_reg),.data_out(macout_cx));
//   vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) c_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_ch_reg),.data_out(macout_ch));
  qadd2 c_gate_add(.a(mac_cx_reg),.b(mac_ch_reg),.c(add_c));
  qadd2 c_gate_biasadd(.a(bc_in),.b(add_c),.c(addbias_c)); 
  tanh tan_c1(addb_c_reg,tan_c);
  //qmult #(12,16) c_elmul(.i_multiplicand(tan_c_reg),.i_multiplier(sig_io_reg),.o_result(elmul_co),.ovr(overflow0));
  signedmul c_elmul(.clk(clk),.a(tan_c_reg),.b(sig_io_reg),.c(elmul_co));	  
  qadd2 cf_gate_add(.a(elmul_co_reg),.b(elmul_fo_reg),.c(add_cf));
  tanh tan_c2(add_cf_reg,tan_h);
  //qmult #(12,16) h_elmul(.i_multiplicand(tan_h_reg),.i_multiplier(sig_oo_d3),.o_result(ht),.ovr(overflow0));
  signedmul h_elmul(.clk(clk),.a(tan_h_reg),.b(sig_oo_d5),.c(ht));



endmodule
 
// module qaddm2(
//  input [15:0] a,
//  input [15:0] b,
//  output [15:0] c
//     );
    
// assign c = a + b;


// endmodule


module sigmoid(
input [15:0] x,
output [15:0] sig_out
);

reg [15:0] lut;
reg [5:0] address;

assign sig_out = lut;

always @(address)
begin

       case(address)
       6'd0: lut = 16'b0000000000101101; //sig(-4.5)
       6'd1: lut = 16'b0000000000110110; //sig(-4.3)
       6'd2: lut = 16'b0000000001000010; //sig(-4.1)
       6'd3: lut = 16'b0000000001010001; //sig(-3.9)
       6'd4:  lut = 16'b0000000001100010; //sig(-3.7)
       6'd5 :  lut = 16'b0000000001111000; //sig(-3.5)
       6'd6 :  lut= 16'b0000000010010001; //sig(-3.3)
       6'd7 :  lut= 16'b0000000010110000; //sig(-3.1)
       6'd8:  lut= 16'b0000000011010101; //sig(-2.9)
       6'd9 :  lut= 16'b0000000100000010; //sig(-2.7)
       6'd10 :  lut= 16'b0000000100110110; //sig(-2.5)
       6'd11 :  lut= 16'b0000000101110101; //sig(-2.3)
       6'd12 :  lut= 16'b0000000110111110; //sig(-2.1)
       6'd13 :  lut= 16'b0000001000010100; //sig(-1.9)
       6'd14 :  lut= 16'b0000001001111000; //sig(-1.7)
       6'd15 :  lut= 16'b0000001011101011; //sig(-1.5)
       6'd16 :  lut= 16'b0000001101101101; //sig(-1.3)
       6'd17:  lut= 16'b0000001111111110; //sig(-1.1) 
       6'd18 :  lut= 16'b0000010010100000; //sig(-0.9)
       6'd19 :  lut= 16'b0000010101001111; //sig(-0.7)
       6'd20 :  lut= 16'b0000011000001010; //sig(-0.5)
       6'd21 :  lut= 16'b0000011011001111; //sig(-0.3)
       6'd22 :  lut= 16'b0000011110011001; //sig(-0.1)
       6'd23 :  lut= 16'b0000100001100110; //sig(0.1)
       6'd24 :  lut= 16'b0000100100110000; //sig(0.3)
       6'd25 :  lut= 16'b0000100111110101; //sig(0.5)
       6'd26 :  lut= 16'b0000101010110000; //sig(0.7)
       6'd27 :  lut= 16'b0000101101100000; //sig(0.9)
       6'd28 :  lut= 16'b0000110000000001; //sig(1.1)
       6'd29 :  lut= 16'b0000110010010010; //sig(1.3)
       6'd30 :  lut= 16'b0000110100010100; //sig(1.5)
       6'd31 :  lut= 16'b0000110110000111; //sig(1.7)
       6'd32 :  lut= 16'b0000110111101011; //sig(1.9)
       6'd33 :  lut= 16'b0000111001000001; //sig(2.1)
       6'd34 :  lut= 16'b0000111010001010; //sig(2.3)
       6'd35 :  lut= 16'b0000111011001001; //sig(2.5)
       6'd36 :  lut= 16'b0000111011111110; //sig(2.7)
       6'd37 :  lut= 16'b0000111100101010; //sig(2.9)
       6'd38 :  lut= 16'b0000111101001111; //sig(3.1)
       6'd39 :  lut= 16'b0000111101101110; //sig(3.3)
       6'd40 :  lut= 16'b0000111110000111; //sig(3.5)
       6'd41 :  lut= 16'b0000111110011101; //sig(3.7)
       6'd42 :  lut= 16'b0000111110101110; //sig(3.9)
       6'd43 :  lut= 16'b0000111110111101; //sig(4.1)
       6'd44 :  lut= 16'b0000111111001001; //sig(4.3)
       6'd45 :  lut= 16'b0000111111010011; //sig(4.5) 
       6'd46 :  lut= 16'b0000111111011011; //sig(4.7) 
       6'd47 :  lut= 16'b0000000000100100; //sig(-4.7)
       6'd48:	lut= 16'b0000000000000000; //0  
       6'd49:	lut= 16'b0001000000000000; //1 
       default: lut=0;
	endcase
end


always@(x)
begin
 
    case({x[15:12]})
	4'b1000:address = 6'd48; 
	4'b1001:address = 6'd48; 
	4'b1010:address = 6'd48; 
	4'b1011:address = 6'd48; 
	4'b1100:address = 6'd48;  
        4'b1101:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) // -3
                    begin
                       address = 6'd8;                 
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                        address = 6'd9;
                    end
                 else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                        address = 6'd10;                                        
                    end
                 else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                        address =  6'd11;                                                          
                    end
                 else if(x[11:0] > 12'hccd)
                    begin
                        address =  6'd12;                                    
                    end   
        4'b1110:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) // -2
                    begin
                        address =  6'd13;              
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                        address =  6'd14;                
                    end
                 else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                        address = 6'd15;                                                         
                    end
                 else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                        address =  6'd16;                                                                           
                    end
                 else if(x[11:0] > 12'hccd)
                    begin
                        address =  6'd17;                                                        
                    end 
        4'b1111:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333))  // -1
                    begin
                        address =  6'd18;                
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                        address =  6'd19;                                    
                    end
                 else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                        address =  6'd20;                                                                         
                    end
                 else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                        address =  6'd21;                                                                                                
                    end
                 else if(x[11:0] > 12'hccd)
                    begin
                        address =  6'd22;                                                                            
                    end 
        4'b0000:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) // 0
                    begin
                        address =  6'd23;                
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                        address =  6'd24;                
                    end
                 else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                        address =  6'd25;                                                        
                    end
                 else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                        address =  6'd26;                                                                            
                    end
                 else if(x[11:0] > 12'hccd)
                    begin
                        address =  6'd27;                                                        
                    end 
        4'b0001:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) // 1
                    begin
                        address =  6'd28;                
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                        address =  6'd29;                
                    end
                else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                        address =  6'd30;                                                        
                    end
                else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                        address =  6'd31;                                                                            
                    end
                else if(x[11:0] > 12'hccd)
                    begin
                       address =  6'd32;                                                         
                    end 
        4'b0010:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333))  // 2
                    begin
                      address =  6'd33;                  
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                      address =  6'd34;                   
                    end
                 else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                       address =  6'd35;                                                          
                    end
                 else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                       address =  6'd36;                                                                               
                    end
                 else if(x[11:0] > 12'hccd)
                    begin
                       address =  6'd37;                                                          
                    end 
        4'b0011:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) // 3
                    begin
                       address =  6'd38;                  
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                      address =  6'd39;                  
                    end
                else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                      address =  6'd40;                                                          
                    end
                else if((x[11:0] > 12'h99a) && (x[11:0] <= 12'hccd))
                    begin
                      address = 6'd41;                                                                              
                    end
               else if(x[11:0] > 12'hccd)
                    begin
                       address = 6'd42;                                                        
                    end 
	4'b0100:address = 6'd49;  
	4'b0101:address = 6'd49;  
	4'b0110:address = 6'd49;  
	4'b0111:address = 6'd49;  
       /* 4'b0100:if((x[11:0] >= 12'h000) && (x[11:0] <= 12'h333)) //4
                    begin
                      address = lut[43];                 
                    end 
                else if((x[11:0] > 12'h333) && (x[11:0] <= 12'h666))
                    begin
                       address = lut[44];                 
                    end
                else if((x[11:0] > 12'h666) && (x[11:0] <= 12'h99a))
                    begin
                       address = lut[45];                                                   
                    end
                else if(x[11:0] > 12'h99a) 
                    begin
                        address = lut[46];                                                                            
                    end
	4'b0101: address = lut[46];    
	4'b0110: address = lut[46];   
	4'b0111: address = lut[46];  */ 
	/*default:begin
			address = 16'h1000;
		end*/
        endcase

end

endmodule

module tanh(
input [15:0] x,
output [15:0] tanh_out);

reg [15:0] lut;
wire [15:0] x_comp;
reg [15:0] tanh_comp;
//reg [15:0] tanh;
reg [4:0] address;


assign x_comp = x[15]? {1'b0,~(x[14:0])}+1'b1:x; // first take 2's complement if x is negative
assign tanh_out = x[15]?(~lut+1'b1):lut; // take 2's complement of tanh if x was negative

always @(address)
begin
  case(address) 	    
  5'd0:  lut =16'b0000100000000010; //address(0.55)
  5'd1:  lut=16'b0000100100100101; //address(0.65)
  5'd2:  lut=16'b0000101000101001; //address(0.75)
  5'd3:  lut=16'b0000101100001110; //address(0.85)
  5'd4:  lut=16'b0000101111010110; //address(0.95)
  5'd5:  lut=16'b0000110010000010; //address(1.05)
  5'd6:  lut=16'b0000110100010101; //address(1.15)
  5'd7:  lut=16'b0000110110010010; //address(1.25)
  5'd8:  lut=16'b0000110111111100; //address(1.35)
  5'd9:  lut=16'b0000111001010100; //address(1.45)
  5'd10:  lut=16'b0000111010011110; //address(1.55)
  5'd11:  lut=16'b0000111011011100; //address(1.65)
  5'd12:  lut=16'b0000111100001111; //address(1.75)
  5'd13:  lut=16'b0000111100111010; //address(1.85)
  5'd14:  lut=16'b0000111101011101; //address(1.95)
  5'd15:  lut=16'b0000111101111010; //address(2.05)
  5'd16:  lut=16'b0000111110010010; //address(2.15)
  5'd17:  lut=16'b0000111110100110; //address(2.25)
  5'd18:  lut=16'b0000111110110110; //address(2.35)
  5'd19:  lut=16'b0000111111000011; //address(2.45)
  5'd20:  lut=16'b0000111111001110; //address(2.55)
  5'd21:  lut=16'b0000111111101011; //address(3.0)
  5'd22:  lut=16'b0001000000000000; //1
  5'd23:  lut=x_comp;
  default: lut=0;
  endcase
end

always@(x)
begin
  /*if(rst == 0)
        tanh_out = 0;
  else
    begin*/
    // first take 2's complement if x is negative
    /*if(x[15] == 1'b1)
        begin
            x_comp = {1'b0,~(x[14:0])}+1'b1;
        end
    else
        begin
            x_comp = x;
    end*/
    
    // next find the address
   
    if((x_comp >= 16'h0800) && (x_comp < 16'h3000))
    begin
    case(x_comp[15:12])
        4'b0000:begin
                if((x_comp[11:0] >= 16'h800) && (x_comp[11:0] < 16'h99a))
                    address = 5'd0;
                else if((x_comp[11:0] >= 16'h99a) && (x_comp[11:0] < 16'hb33))
                    address = 5'd1;
                else if((x_comp[11:0] >= 16'hb33) && (x_comp[11:0] < 16'hccd))
                    address = 5'd2;
                else if((x_comp[11:0] >= 16'hccd) && (x_comp[11:0] < 16'he66))
                    address = 5'd3;
                else if(x_comp[11:0] >= 16'he66)
                    address = 5'd4;
                end
        4'b0001:begin
                if((x_comp[11:0] >= 16'h000) && (x_comp[11:0] < 16'h19a))
                    address = 5'd5;
                else if((x_comp[11:0] >= 16'h19a) && (x_comp[11:0] < 16'h333))
                    address = 5'd6;
                else if((x_comp[11:0] >= 16'h333) && (x_comp[11:0] < 16'h4cd))
                    address = 5'd7;
                else if((x_comp[11:0] >= 16'h4cd) && (x_comp[11:0] < 16'h666))
                    address = 5'd8;
                else if((x_comp[11:0] >= 16'h666) && (x_comp[11:0] < 16'h800))
                    address = 5'd9;
                else if((x_comp[11:0] >= 16'h800) && (x_comp[11:0] < 16'h99a))
                    address = 5'd10;
                else if((x_comp[11:0] >= 16'h99a) && (x_comp[11:0] < 16'hb33))
                    address = 5'd11;
                else if((x_comp[11:0] >= 16'hb33) && (x_comp[11:0] < 16'hccd))
                    address = 5'd12;
                else if((x_comp[11:0] >= 16'hccd) && (x_comp[11:0] < 16'he66))
                    address = 5'd13;
                else if(x_comp[11:0] >= 16'he66)
                    address = 5'd14;
                end
        4'b0010:begin
                if((x_comp[11:0] >= 16'h000) && (x_comp[11:0] < 16'h19a))
                    address = 5'd15;
                else if((x_comp[11:0] >= 16'h19a) && (x_comp[11:0] < 16'h333))
                    address = 5'd16;
                else if((x_comp[11:0] >= 16'h333) && (x_comp[11:0] < 16'h4cd))
                    address = 5'd17;
                else if((x_comp[11:0] >= 16'h4cd) && (x_comp[11:0] < 16'h666))
                    address = 5'd18;
                else if((x_comp[11:0] >= 16'h666) && (x_comp[11:0] < 16'h800))
                    address = 5'd19;
                else if((x_comp[11:0] >= 16'h800) && (x_comp[11:0] < 16'h99a))
                    address = 5'd20;
                else if(x_comp[11:0] >= 16'h99a)
                    address = 5'd21;
                end
	default: address = 0;
    endcase
    end
    
    else if((x_comp >= 16'h0000) && (x_comp < 16'h0800))
           begin
               address = 5'd23;
           end
    else if(x_comp >= 16'h3000)
           begin
               address = 5'd22;
           end               
   //end
    
end


endmodule





// module vecmat_x_8_CLB #( parameter varraysize=1600, vectwidth=100)
// (
// 	input clk,
// 	input reset,
// 	input [varraysize-1:0] data_x,
// 	input [varraysize-1:0] W_x,

// 	output reg [15:0] data_out_x
// );

// conv_top_100 conv_top_100_inst_1(
// .in_data_0(data_x[7:0]), .in_data_1(data_x[23:16]), .in_data_2(data_x[39:32]), .in_data_3(data_x[55:48]), .in_data_4(data_x[71:64]), .in_data_5(data_x[87:80]), .in_data_6(data_x[103:96]), .in_data_7(data_x[119:112]), .in_data_8(data_x[135:128]), .in_data_9(data_x[151:144]), .in_data_10(data_x[167:160]), .in_data_11(data_x[183:176]), .in_data_12(data_x[199:192]), .in_data_13(data_x[215:208]), .in_data_14(data_x[231:224]), .in_data_15(data_x[247:240]), .in_data_16(data_x[263:256]), .in_data_17(data_x[279:272]), .in_data_18(data_x[295:288]), .in_data_19(data_x[311:304]), .in_data_20(data_x[327:320]), .in_data_21(data_x[343:336]), .in_data_22(data_x[359:352]), .in_data_23(data_x[375:368]), .in_data_24(data_x[391:384]), .in_data_25(data_x[407:400]), .in_data_26(data_x[423:416]), .in_data_27(data_x[439:432]), .in_data_28(data_x[455:448]), .in_data_29(data_x[471:464]), .in_data_30(data_x[487:480]), .in_data_31(data_x[503:496]), .in_data_32(data_x[519:512]), .in_data_33(data_x[535:528]), .in_data_34(data_x[551:544]), .in_data_35(data_x[567:560]), .in_data_36(data_x[583:576]), .in_data_37(data_x[599:592]), .in_data_38(data_x[615:608]), .in_data_39(data_x[631:624]), .in_data_40(data_x[647:640]), .in_data_41(data_x[663:656]), .in_data_42(data_x[679:672]), .in_data_43(data_x[695:688]), .in_data_44(data_x[711:704]), .in_data_45(data_x[727:720]), .in_data_46(data_x[743:736]), .in_data_47(data_x[759:752]), .in_data_48(data_x[775:768]), .in_data_49(data_x[791:784]), .in_data_50(data_x[807:800]), .in_data_51(data_x[823:816]), .in_data_52(data_x[839:832]), .in_data_53(data_x[855:848]), .in_data_54(data_x[871:864]), .in_data_55(data_x[887:880]), .in_data_56(data_x[903:896]), .in_data_57(data_x[919:912]), .in_data_58(data_x[935:928]), .in_data_59(data_x[951:944]), .in_data_60(data_x[967:960]), .in_data_61(data_x[983:976]), .in_data_62(data_x[999:992]), .in_data_63(data_x[1015:1008]), .in_data_64( data_x[1031:1024]), .in_data_65(data_x[1047:1040]), .in_data_66(data_x[1063:1056]), .in_data_67(data_x[1079:1072]), .in_data_68(data_x[1095:1088]), .in_data_69(data_x[1111:1104]), .in_data_70(data_x[1127:1120]), .in_data_71(data_x[1143:1136]), .in_data_72(data_x[1159:1152]), .in_data_73(data_x[1175:1168]), .in_data_74(data_x[1191:1184]), .in_data_75(data_x[1207:1200]), .in_data_76(data_x[1223:1216]), .in_data_77(data_x[1239:1232]), .in_data_78(data_x[1255:1248]), .in_data_79(data_x[1271:1264]), .in_data_80(data_x[1287:1280]), .in_data_81(data_x[1303:1296]), .in_data_82(data_x[1319:1312]), .in_data_83(data_x[1335:1328]), .in_data_84(data_x[1351:1344]), .in_data_85(data_x[1367:1360]), .in_data_86(data_x[1383:1376]), .in_data_87(data_x[1399:1392]), .in_data_88(data_x[1415:1408]), .in_data_89(data_x[1431:1424]), .in_data_90(data_x[1447:1440]), .in_data_91(data_x[1463:1456]), .in_data_92(data_x[1479:1472]), .in_data_93(data_x[1495:1488]), .in_data_94(data_x[1511:1504]), .in_data_95(data_x[1527:1520]), .in_data_96(data_x[1543:1536]), .in_data_97(data_x[1559:1552]), .in_data_98(data_x[1575:1568]), .in_data_99(data_x[1591:1584]), 
// .Add_pim(4'b0000),
// .Compute_flag(1'b1),
// .clk(clk),
// .Out_data(data_out_x)
// );

// endmodule


// module conv_top_100 (
//   input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24, input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44, input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48, input [7:0] in_data_49, input [7:0] in_data_50, input [7:0] in_data_51, input [7:0] in_data_52, input [7:0] in_data_53, input [7:0] in_data_54, input [7:0] in_data_55, input [7:0] in_data_56, input [7:0] in_data_57, input [7:0] in_data_58, input [7:0] in_data_59, input [7:0] in_data_60, input [7:0] in_data_61, input [7:0] in_data_62, input [7:0] in_data_63, input [7:0] in_data_64, input [7:0] in_data_65, input [7:0] in_data_66, input [7:0] in_data_67, input [7:0] in_data_68, input [7:0] in_data_69, input [7:0] in_data_70, input [7:0] in_data_71, input [7:0] in_data_72, input [7:0] in_data_73, input [7:0] in_data_74, input [7:0] in_data_75, input [7:0] in_data_76, input [7:0] in_data_77, input [7:0] in_data_78, input [7:0] in_data_79, input [7:0] in_data_80, input [7:0] in_data_81, input [7:0] in_data_82, input [7:0] in_data_83, input [7:0] in_data_84, input [7:0] in_data_85, input [7:0] in_data_86, input [7:0] in_data_87, input [7:0] in_data_88, input [7:0] in_data_89, input [7:0] in_data_90, input [7:0] in_data_91, input [7:0] in_data_92, input [7:0] in_data_93, input [7:0] in_data_94, input [7:0] in_data_95, input [7:0] in_data_96, input [7:0] in_data_97, input [7:0] in_data_98, input [7:0] in_data_99,   
//   input [4:0] Add_pim, // 地址
//   input Compute_flag, // 计算标志
//   input clk,
//   output [15:0] Out_data // 输出数据
// );  

// 	wire [7:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
// //  HH Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH0(
// 		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7], in_data_65[7], in_data_66[7], in_data_67[7], in_data_68[7], in_data_69[7], in_data_70[7], in_data_71[7], in_data_72[7], in_data_73[7], in_data_74[7], in_data_75[7], in_data_76[7], in_data_77[7], in_data_78[7], in_data_79[7], in_data_80[7], in_data_81[7], in_data_82[7], in_data_83[7], in_data_84[7], in_data_85[7], in_data_86[7], in_data_87[7], in_data_88[7], in_data_89[7], in_data_90[7], in_data_91[7], in_data_92[7], in_data_93[7], in_data_94[7], in_data_95[7], in_data_96[7], in_data_97[7], in_data_98[7], in_data_99[7]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HH),
// 		.clk(clk)
// 	);

// //  HL Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL1(
// 		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7], in_data_65[7], in_data_66[7], in_data_67[7], in_data_68[7], in_data_69[7], in_data_70[7], in_data_71[7], in_data_72[7], in_data_73[7], in_data_74[7], in_data_75[7], in_data_76[7], in_data_77[7], in_data_78[7], in_data_79[7], in_data_80[7], in_data_81[7], in_data_82[7], in_data_83[7], in_data_84[7], in_data_85[7], in_data_86[7], in_data_87[7], in_data_88[7], in_data_89[7], in_data_90[7], in_data_91[7], in_data_92[7], in_data_93[7], in_data_94[7], in_data_95[7], in_data_96[7], in_data_97[7], in_data_98[7], in_data_99[7]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HL),
// 		.clk(clk)
// 	);

// //  LH Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH2(
// 		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6], in_data_49[6], in_data_50[6], in_data_51[6], in_data_52[6], in_data_53[6], in_data_54[6], in_data_55[6], in_data_56[6], in_data_57[6], in_data_58[6], in_data_59[6], in_data_60[6], in_data_61[6], in_data_62[6], in_data_63[6], in_data_64[6], in_data_65[6], in_data_66[6], in_data_67[6], in_data_68[6], in_data_69[6], in_data_70[6], in_data_71[6], in_data_72[6], in_data_73[6], in_data_74[6], in_data_75[6], in_data_76[6], in_data_77[6], in_data_78[6], in_data_79[6], in_data_80[6], in_data_81[6], in_data_82[6], in_data_83[6], in_data_84[6], in_data_85[6], in_data_86[6], in_data_87[6], in_data_88[6], in_data_89[6], in_data_90[6], in_data_91[6], in_data_92[6], in_data_93[6], in_data_94[6], in_data_95[6], in_data_96[6], in_data_97[6], in_data_98[6], in_data_99[6]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LH),
// 		.clk(clk)
// 	);

// //  LL Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL3(
// 		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6], in_data_49[6], in_data_50[6], in_data_51[6], in_data_52[6], in_data_53[6], in_data_54[6], in_data_55[6], in_data_56[6], in_data_57[6], in_data_58[6], in_data_59[6], in_data_60[6], in_data_61[6], in_data_62[6], in_data_63[6], in_data_64[6], in_data_65[6], in_data_66[6], in_data_67[6], in_data_68[6], in_data_69[6], in_data_70[6], in_data_71[6], in_data_72[6], in_data_73[6], in_data_74[6], in_data_75[6], in_data_76[6], in_data_77[6], in_data_78[6], in_data_79[6], in_data_80[6], in_data_81[6], in_data_82[6], in_data_83[6], in_data_84[6], in_data_85[6], in_data_86[6], in_data_87[6], in_data_88[6], in_data_89[6], in_data_90[6], in_data_91[6], in_data_92[6], in_data_93[6], in_data_94[6], in_data_95[6], in_data_96[6], in_data_97[6], in_data_98[6], in_data_99[6]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LL),
// 		.clk(clk)
// 	);
	



// 	// assign Out_data = tmp_result_HH1 + tmp_result_HL1 + tmp_result_LH1 + tmp_result_LL1;


// 	wire [7:0] tmp_result_HH_1, tmp_result_HL_1, tmp_result_LH_1, tmp_result_LL_1;
// //  HH Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH4(
// 		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5], in_data_32[5], in_data_33[5], in_data_34[5], in_data_35[5], in_data_36[5], in_data_37[5], in_data_38[5], in_data_39[5], in_data_40[5], in_data_41[5], in_data_42[5], in_data_43[5], in_data_44[5], in_data_45[5], in_data_46[5], in_data_47[5], in_data_48[5], in_data_49[5], in_data_50[5], in_data_51[5], in_data_52[5], in_data_53[5], in_data_54[5], in_data_55[5], in_data_56[5], in_data_57[5], in_data_58[5], in_data_59[5], in_data_60[5], in_data_61[5], in_data_62[5], in_data_63[5], in_data_64[5], in_data_65[5], in_data_66[5], in_data_67[5], in_data_68[5], in_data_69[5], in_data_70[5], in_data_71[5], in_data_72[5], in_data_73[5], in_data_74[5], in_data_75[5], in_data_76[5], in_data_77[5], in_data_78[5], in_data_79[5], in_data_80[5], in_data_81[5], in_data_82[5], in_data_83[5], in_data_84[5], in_data_85[5], in_data_86[5], in_data_87[5], in_data_88[5], in_data_89[5], in_data_90[5], in_data_91[5], in_data_92[5], in_data_93[5], in_data_94[5], in_data_95[5], in_data_96[5], in_data_97[5], in_data_98[5], in_data_99[5]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HH_1),
// 		.clk(clk)
// 	);

// //  HL Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL5(
// 		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5], in_data_32[5], in_data_33[5], in_data_34[5], in_data_35[5], in_data_36[5], in_data_37[5], in_data_38[5], in_data_39[5], in_data_40[5], in_data_41[5], in_data_42[5], in_data_43[5], in_data_44[5], in_data_45[5], in_data_46[5], in_data_47[5], in_data_48[5], in_data_49[5], in_data_50[5], in_data_51[5], in_data_52[5], in_data_53[5], in_data_54[5], in_data_55[5], in_data_56[5], in_data_57[5], in_data_58[5], in_data_59[5], in_data_60[5], in_data_61[5], in_data_62[5], in_data_63[5], in_data_64[5], in_data_65[5], in_data_66[5], in_data_67[5], in_data_68[5], in_data_69[5], in_data_70[5], in_data_71[5], in_data_72[5], in_data_73[5], in_data_74[5], in_data_75[5], in_data_76[5], in_data_77[5], in_data_78[5], in_data_79[5], in_data_80[5], in_data_81[5], in_data_82[5], in_data_83[5], in_data_84[5], in_data_85[5], in_data_86[5], in_data_87[5], in_data_88[5], in_data_89[5], in_data_90[5], in_data_91[5], in_data_92[5], in_data_93[5], in_data_94[5], in_data_95[5], in_data_96[5], in_data_97[5], in_data_98[5], in_data_99[5]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HL_1),
// 		.clk(clk)
// 	);

// //  LH Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH6(
// 		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4], in_data_32[4], in_data_33[4], in_data_34[4], in_data_35[4], in_data_36[4], in_data_37[4], in_data_38[4], in_data_39[4], in_data_40[4], in_data_41[4], in_data_42[4], in_data_43[4], in_data_44[4], in_data_45[4], in_data_46[4], in_data_47[4], in_data_48[4], in_data_49[4], in_data_50[4], in_data_51[4], in_data_52[4], in_data_53[4], in_data_54[4], in_data_55[4], in_data_56[4], in_data_57[4], in_data_58[4], in_data_59[4], in_data_60[4], in_data_61[4], in_data_62[4], in_data_63[4], in_data_64[4], in_data_65[4], in_data_66[4], in_data_67[4], in_data_68[4], in_data_69[4], in_data_70[4], in_data_71[4], in_data_72[4], in_data_73[4], in_data_74[4], in_data_75[4], in_data_76[4], in_data_77[4], in_data_78[4], in_data_79[4], in_data_80[4], in_data_81[4], in_data_82[4], in_data_83[4], in_data_84[4], in_data_85[4], in_data_86[4], in_data_87[4], in_data_88[4], in_data_89[4], in_data_90[4], in_data_91[4], in_data_92[4], in_data_93[4], in_data_94[4], in_data_95[4], in_data_96[4], in_data_97[4], in_data_98[4], in_data_99[4]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LH_1),
// 		.clk(clk)
// 	);

// //  LL Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL7(
// 		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4], in_data_32[4], in_data_33[4], in_data_34[4], in_data_35[4], in_data_36[4], in_data_37[4], in_data_38[4], in_data_39[4], in_data_40[4], in_data_41[4], in_data_42[4], in_data_43[4], in_data_44[4], in_data_45[4], in_data_46[4], in_data_47[4], in_data_48[4], in_data_49[4], in_data_50[4], in_data_51[4], in_data_52[4], in_data_53[4], in_data_54[4], in_data_55[4], in_data_56[4], in_data_57[4], in_data_58[4], in_data_59[4], in_data_60[4], in_data_61[4], in_data_62[4], in_data_63[4], in_data_64[4], in_data_65[4], in_data_66[4], in_data_67[4], in_data_68[4], in_data_69[4], in_data_70[4], in_data_71[4], in_data_72[4], in_data_73[4], in_data_74[4], in_data_75[4], in_data_76[4], in_data_77[4], in_data_78[4], in_data_79[4], in_data_80[4], in_data_81[4], in_data_82[4], in_data_83[4], in_data_84[4], in_data_85[4], in_data_86[4], in_data_87[4], in_data_88[4], in_data_89[4], in_data_90[4], in_data_91[4], in_data_92[4], in_data_93[4], in_data_94[4], in_data_95[4], in_data_96[4], in_data_97[4], in_data_98[4], in_data_99[4]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LL_1),
// 		.clk(clk)
// 	);
	

// 	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;

// 	wire [7:0] tmp_result_HH_2, tmp_result_HL_2, tmp_result_LH_2, tmp_result_LL_2;
// //  HH Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH8(
// 		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3], in_data_32[3], in_data_33[3], in_data_34[3], in_data_35[3], in_data_36[3], in_data_37[3], in_data_38[3], in_data_39[3], in_data_40[3], in_data_41[3], in_data_42[3], in_data_43[3], in_data_44[3], in_data_45[3], in_data_46[3], in_data_47[3], in_data_48[3], in_data_49[3], in_data_50[3], in_data_51[3], in_data_52[3], in_data_53[3], in_data_54[3], in_data_55[3], in_data_56[3], in_data_57[3], in_data_58[3], in_data_59[3], in_data_60[3], in_data_61[3], in_data_62[3], in_data_63[3], in_data_64[3], in_data_65[3], in_data_66[3], in_data_67[3], in_data_68[3], in_data_69[3], in_data_70[3], in_data_71[3], in_data_72[3], in_data_73[3], in_data_74[3], in_data_75[3], in_data_76[3], in_data_77[3], in_data_78[3], in_data_79[3], in_data_80[3], in_data_81[3], in_data_82[3], in_data_83[3], in_data_84[3], in_data_85[3], in_data_86[3], in_data_87[3], in_data_88[3], in_data_89[3], in_data_90[3], in_data_91[3], in_data_92[3], in_data_93[3], in_data_94[3], in_data_95[3], in_data_96[3], in_data_97[3], in_data_98[3], in_data_99[3]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HH_2),
// 		.clk(clk)
// 	);

// //  HL Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL9(
// 		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3], in_data_32[3], in_data_33[3], in_data_34[3], in_data_35[3], in_data_36[3], in_data_37[3], in_data_38[3], in_data_39[3], in_data_40[3], in_data_41[3], in_data_42[3], in_data_43[3], in_data_44[3], in_data_45[3], in_data_46[3], in_data_47[3], in_data_48[3], in_data_49[3], in_data_50[3], in_data_51[3], in_data_52[3], in_data_53[3], in_data_54[3], in_data_55[3], in_data_56[3], in_data_57[3], in_data_58[3], in_data_59[3], in_data_60[3], in_data_61[3], in_data_62[3], in_data_63[3], in_data_64[3], in_data_65[3], in_data_66[3], in_data_67[3], in_data_68[3], in_data_69[3], in_data_70[3], in_data_71[3], in_data_72[3], in_data_73[3], in_data_74[3], in_data_75[3], in_data_76[3], in_data_77[3], in_data_78[3], in_data_79[3], in_data_80[3], in_data_81[3], in_data_82[3], in_data_83[3], in_data_84[3], in_data_85[3], in_data_86[3], in_data_87[3], in_data_88[3], in_data_89[3], in_data_90[3], in_data_91[3], in_data_92[3], in_data_93[3], in_data_94[3], in_data_95[3], in_data_96[3], in_data_97[3], in_data_98[3], in_data_99[3]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HL_2),
// 		.clk(clk)
// 	);

// //  LH Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH10(
// 		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2], in_data_32[2], in_data_33[2], in_data_34[2], in_data_35[2], in_data_36[2], in_data_37[2], in_data_38[2], in_data_39[2], in_data_40[2], in_data_41[2], in_data_42[2], in_data_43[2], in_data_44[2], in_data_45[2], in_data_46[2], in_data_47[2], in_data_48[2], in_data_49[2], in_data_50[2], in_data_51[2], in_data_52[2], in_data_53[2], in_data_54[2], in_data_55[2], in_data_56[2], in_data_57[2], in_data_58[2], in_data_59[2], in_data_60[2], in_data_61[2], in_data_62[2], in_data_63[2], in_data_64[2], in_data_65[2], in_data_66[2], in_data_67[2], in_data_68[2], in_data_69[2], in_data_70[2], in_data_71[2], in_data_72[2], in_data_73[2], in_data_74[2], in_data_75[2], in_data_76[2], in_data_77[2], in_data_78[2], in_data_79[2], in_data_80[2], in_data_81[2], in_data_82[2], in_data_83[2], in_data_84[2], in_data_85[2], in_data_86[2], in_data_87[2], in_data_88[2], in_data_89[2], in_data_90[2], in_data_91[2], in_data_92[2], in_data_93[2], in_data_94[2], in_data_95[2], in_data_96[2], in_data_97[2], in_data_98[2], in_data_99[2]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LH_2),
// 		.clk(clk)
// 	);

// //  LL Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL11(
// 		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2], in_data_32[2], in_data_33[2], in_data_34[2], in_data_35[2], in_data_36[2], in_data_37[2], in_data_38[2], in_data_39[2], in_data_40[2], in_data_41[2], in_data_42[2], in_data_43[2], in_data_44[2], in_data_45[2], in_data_46[2], in_data_47[2], in_data_48[2], in_data_49[2], in_data_50[2], in_data_51[2], in_data_52[2], in_data_53[2], in_data_54[2], in_data_55[2], in_data_56[2], in_data_57[2], in_data_58[2], in_data_59[2], in_data_60[2], in_data_61[2], in_data_62[2], in_data_63[2], in_data_64[2], in_data_65[2], in_data_66[2], in_data_67[2], in_data_68[2], in_data_69[2], in_data_70[2], in_data_71[2], in_data_72[2], in_data_73[2], in_data_74[2], in_data_75[2], in_data_76[2], in_data_77[2], in_data_78[2], in_data_79[2], in_data_80[2], in_data_81[2], in_data_82[2], in_data_83[2], in_data_84[2], in_data_85[2], in_data_86[2], in_data_87[2], in_data_88[2], in_data_89[2], in_data_90[2], in_data_91[2], in_data_92[2], in_data_93[2], in_data_94[2], in_data_95[2], in_data_96[2], in_data_97[2], in_data_98[2], in_data_99[2]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LL_2),
// 		.clk(clk)
// 	);
	
// 	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;




// 	wire [7:0] tmp_result_HH_3, tmp_result_HL_3, tmp_result_LH_3, tmp_result_LL_3;
// //  HH Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH12(
// 		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1], in_data_32[1], in_data_33[1], in_data_34[1], in_data_35[1], in_data_36[1], in_data_37[1], in_data_38[1], in_data_39[1], in_data_40[1], in_data_41[1], in_data_42[1], in_data_43[1], in_data_44[1], in_data_45[1], in_data_46[1], in_data_47[1], in_data_48[1], in_data_49[1], in_data_50[1], in_data_51[1], in_data_52[1], in_data_53[1], in_data_54[1], in_data_55[1], in_data_56[1], in_data_57[1], in_data_58[1], in_data_59[1], in_data_60[1], in_data_61[1], in_data_62[1], in_data_63[1], in_data_64[1], in_data_65[1], in_data_66[1], in_data_67[1], in_data_68[1], in_data_69[1], in_data_70[1], in_data_71[1], in_data_72[1], in_data_73[1], in_data_74[1], in_data_75[1], in_data_76[1], in_data_77[1], in_data_78[1], in_data_79[1], in_data_80[1], in_data_81[1], in_data_82[1], in_data_83[1], in_data_84[1], in_data_85[1], in_data_86[1], in_data_87[1], in_data_88[1], in_data_89[1], in_data_90[1], in_data_91[1], in_data_92[1], in_data_93[1], in_data_94[1], in_data_95[1], in_data_96[1], in_data_97[1], in_data_98[1], in_data_99[1]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HH_3),
// 		.clk(clk)
// 	);

// //  HL Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL13(
// 		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1], in_data_32[1], in_data_33[1], in_data_34[1], in_data_35[1], in_data_36[1], in_data_37[1], in_data_38[1], in_data_39[1], in_data_40[1], in_data_41[1], in_data_42[1], in_data_43[1], in_data_44[1], in_data_45[1], in_data_46[1], in_data_47[1], in_data_48[1], in_data_49[1], in_data_50[1], in_data_51[1], in_data_52[1], in_data_53[1], in_data_54[1], in_data_55[1], in_data_56[1], in_data_57[1], in_data_58[1], in_data_59[1], in_data_60[1], in_data_61[1], in_data_62[1], in_data_63[1], in_data_64[1], in_data_65[1], in_data_66[1], in_data_67[1], in_data_68[1], in_data_69[1], in_data_70[1], in_data_71[1], in_data_72[1], in_data_73[1], in_data_74[1], in_data_75[1], in_data_76[1], in_data_77[1], in_data_78[1], in_data_79[1], in_data_80[1], in_data_81[1], in_data_82[1], in_data_83[1], in_data_84[1], in_data_85[1], in_data_86[1], in_data_87[1], in_data_88[1], in_data_89[1], in_data_90[1], in_data_91[1], in_data_92[1], in_data_93[1], in_data_94[1], in_data_95[1], in_data_96[1], in_data_97[1], in_data_98[1], in_data_99[1]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HL_3),
// 		.clk(clk)
// 	);

// //  LH Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH14(
// 		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0], in_data_32[0], in_data_33[0], in_data_34[0], in_data_35[0], in_data_36[0], in_data_37[0], in_data_38[0], in_data_39[0], in_data_40[0], in_data_41[0], in_data_42[0], in_data_43[0], in_data_44[0], in_data_45[0], in_data_46[0], in_data_47[0], in_data_48[0], in_data_49[0], in_data_50[0], in_data_51[0], in_data_52[0], in_data_53[0], in_data_54[0], in_data_55[0], in_data_56[0], in_data_57[0], in_data_58[0], in_data_59[0], in_data_60[0], in_data_61[0], in_data_62[0], in_data_63[0], in_data_64[0], in_data_65[0], in_data_66[0], in_data_67[0], in_data_68[0], in_data_69[0], in_data_70[0], in_data_71[0], in_data_72[0], in_data_73[0], in_data_74[0], in_data_75[0], in_data_76[0], in_data_77[0], in_data_78[0], in_data_79[0], in_data_80[0], in_data_81[0], in_data_82[0], in_data_83[0], in_data_84[0], in_data_85[0], in_data_86[0], in_data_87[0], in_data_88[0], in_data_89[0], in_data_90[0], in_data_91[0], in_data_92[0], in_data_93[0], in_data_94[0], in_data_95[0], in_data_96[0], in_data_97[0], in_data_98[0], in_data_99[0]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LH_3),
// 		.clk(clk)
// 	);

// //  LL Unit
// 	conv #(.INPUT_SIZE(100), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL15(
// 		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0], in_data_32[0], in_data_33[0], in_data_34[0], in_data_35[0], in_data_36[0], in_data_37[0], in_data_38[0], in_data_39[0], in_data_40[0], in_data_41[0], in_data_42[0], in_data_43[0], in_data_44[0], in_data_45[0], in_data_46[0], in_data_47[0], in_data_48[0], in_data_49[0], in_data_50[0], in_data_51[0], in_data_52[0], in_data_53[0], in_data_54[0], in_data_55[0], in_data_56[0], in_data_57[0], in_data_58[0], in_data_59[0], in_data_60[0], in_data_61[0], in_data_62[0], in_data_63[0], in_data_64[0], in_data_65[0], in_data_66[0], in_data_67[0], in_data_68[0], in_data_69[0], in_data_70[0], in_data_71[0], in_data_72[0], in_data_73[0], in_data_74[0], in_data_75[0], in_data_76[0], in_data_77[0], in_data_78[0], in_data_79[0], in_data_80[0], in_data_81[0], in_data_82[0], in_data_83[0], in_data_84[0], in_data_85[0], in_data_86[0], in_data_87[0], in_data_88[0], in_data_89[0], in_data_90[0], in_data_91[0], in_data_92[0], in_data_93[0], in_data_94[0], in_data_95[0], in_data_96[0], in_data_97[0], in_data_98[0], in_data_99[0]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LL_3),
// 		.clk(clk)
// 	);
	

// 	wire [15:0] tmp_res[15];
//     qadd_in qadd_in_0(.a(tmp_result_HH), .b(tmp_result_HL), .sum(tmp_res[0]));
//     qadd_in qadd_in_1(.a(tmp_result_LH), .b(tmp_result_LL), .sum(tmp_res[1]));
//     qadd_in qadd_in_2(.a(tmp_result_HH_1), .b(tmp_result_HL_1), .sum(tmp_res[2]));
//     qadd_in qadd_in_3(.a(tmp_result_LH_1), .b(tmp_result_LL_1), .sum(tmp_res[3]));
//     qadd_in qadd_in_4(.a(tmp_result_HH_2), .b(tmp_result_HL_2), .sum(tmp_res[4]));
//     qadd_in qadd_in_5(.a(tmp_result_LH_2), .b(tmp_result_LL_2), .sum(tmp_res[5]));
//     qadd_in qadd_in_6(.a(tmp_result_HH_3), .b(tmp_result_HL_3), .sum(tmp_res[6]));
//     qadd_in qadd_in_7(.a(tmp_result_LH_3), .b(tmp_result_LL_3), .sum(tmp_res[7]));
//     qadd_in qadd_in_8(.a(tmp_res[0]), .b(tmp_res[1]), .sum(tmp_res[8]));
//     qadd_in qadd_in_9(.a(tmp_res[2]), .b(tmp_res[3]), .sum(tmp_res[9]));
//     qadd_in qadd_in_10(.a(tmp_res[4]), .b(tmp_res[5]), .sum(tmp_res[10]));
//     qadd_in qadd_in_11(.a(tmp_res[6]), .b(tmp_res[7]), .sum(tmp_res[11]));
//     qadd_in qadd_in_12(.a(tmp_res[8]), .b(tmp_res[9]), .sum(tmp_res[12]));
//     qadd_in qadd_in_13(.a(tmp_res[10]), .b(tmp_res[11]), .sum(tmp_res[13]));
//     qadd_in qadd_in_14(.a(tmp_res[12]), .b(tmp_res[13]), .sum(Out_data));


// endmodule


// module vecmat_h_8_CLB #( parameter uarraysize=1024, vectwidth=64)
// (
// 	input clk,
// 	input reset,
// 	input [uarraysize-1:0] data_h,
// 	input [uarraysize-1:0] W_h,

// 	output reg [15:0] data_out_h
// );

// conv_top_64 conv_top_64_inst_1(
// .in_data_0(data_h[7:0]), .in_data_1(data_h[23:16]), .in_data_2(data_h[39:32]), .in_data_3(data_h[55:48]), .in_data_4(data_h[71:64]), .in_data_5(data_h[87:80]), .in_data_6(data_h[103:96]), .in_data_7(data_h[119:112]), .in_data_8(data_h[135:128]), .in_data_9(data_h[151:144]), .in_data_10(data_h[167:160]), .in_data_11(data_h[183:176]), .in_data_12(data_h[199:192]), .in_data_13(data_h[215:208]), .in_data_14(data_h[231:224]), .in_data_15(data_h[247:240]), .in_data_16(data_h[263:256]), .in_data_17(data_h[279:272]), .in_data_18(data_h[295:288]), .in_data_19(data_h[311:304]), .in_data_20(data_h[327:320]), .in_data_21(data_h[343:336]), .in_data_22(data_h[359:352]), .in_data_23(data_h[375:368]), .in_data_24(data_h[391:384]), .in_data_25(data_h[407:400]), .in_data_26(data_h[423:416]), .in_data_27(data_h[439:432]), .in_data_28(data_h[455:448]), .in_data_29(data_h[471:464]), .in_data_30(data_h[487:480]), .in_data_31(data_h[503:496]), .in_data_32(data_h[519:512]), .in_data_33(data_h[535:528]), .in_data_34(data_h[551:544]), .in_data_35(data_h[567:560]), .in_data_36(data_h[583:576]), .in_data_37(data_h[599:592]), .in_data_38(data_h[615:608]), .in_data_39(data_h[631:624]), .in_data_40(data_h[647:640]), .in_data_41(data_h[663:656]), .in_data_42(data_h[679:672]), .in_data_43(data_h[695:688]), .in_data_44(data_h[711:704]), .in_data_45(data_h[727:720]), .in_data_46(data_h[743:736]), .in_data_47(data_h[759:752]), .in_data_48(data_h[775:768]), .in_data_49(data_h[791:784]), .in_data_50(data_h[807:800]), .in_data_51(data_h[823:816]), .in_data_52(data_h[839:832]), .in_data_53(data_h[855:848]), .in_data_54(data_h[871:864]), .in_data_55(data_h[887:880]), .in_data_56(data_h[903:896]), .in_data_57(data_h[919:912]), .in_data_58(data_h[935:928]), .in_data_59(data_h[951:944]), .in_data_60(data_h[967:960]), .in_data_61(data_h[983:976]), .in_data_62(data_h[999:992]), .in_data_63(data_h[1015:1008]),
// .Add_pim(4'b0000),
// .Compute_flag(1'b1),
// .clk(clk),
// .Out_data(data_out_h)
// );



	
// endmodule


// module conv_top_64 (
//   input [7:0] in_data_0, input [7:0] in_data_1, input [7:0] in_data_2, input [7:0] in_data_3, input [7:0] in_data_4, input [7:0] in_data_5, input [7:0] in_data_6, input [7:0] in_data_7, input [7:0] in_data_8, input [7:0] in_data_9, input [7:0] in_data_10, input [7:0] in_data_11, input [7:0] in_data_12, input [7:0] in_data_13, input [7:0] in_data_14, input [7:0] in_data_15, input [7:0] in_data_16, input [7:0] in_data_17, input [7:0] in_data_18, input [7:0] in_data_19, input [7:0] in_data_20, input [7:0] in_data_21, input [7:0] in_data_22, input [7:0] in_data_23, input [7:0] in_data_24, input [7:0] in_data_25, input [7:0] in_data_26, input [7:0] in_data_27, input [7:0] in_data_28, input [7:0] in_data_29, input [7:0] in_data_30, input [7:0] in_data_31, input [7:0] in_data_32, input [7:0] in_data_33, input [7:0] in_data_34, input [7:0] in_data_35, input [7:0] in_data_36, input [7:0] in_data_37, input [7:0] in_data_38, input [7:0] in_data_39, input [7:0] in_data_40, input [7:0] in_data_41, input [7:0] in_data_42, input [7:0] in_data_43, input [7:0] in_data_44, input [7:0] in_data_45, input [7:0] in_data_46, input [7:0] in_data_47, input [7:0] in_data_48, input [7:0] in_data_49, input [7:0] in_data_50, input [7:0] in_data_51, input [7:0] in_data_52, input [7:0] in_data_53, input [7:0] in_data_54, input [7:0] in_data_55, input [7:0] in_data_56, input [7:0] in_data_57, input [7:0] in_data_58, input [7:0] in_data_59, input [7:0] in_data_60, input [7:0] in_data_61, input [7:0] in_data_62, input [7:0] in_data_63, 
//   input [4:0] Add_pim, // 地址
//   input Compute_flag, // 计算标志
//   input clk,
//   output [15:0] Out_data // 输出数据
// );  


// 	wire [7:0] tmp_result_HH, tmp_result_HL, tmp_result_LH, tmp_result_LL;
// //  HH Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH0(
// 		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7] }),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HH),
// 		.clk(clk)
// 	);

// //  HL Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL1(
// 		.Input_feature({in_data_0[7], in_data_1[7], in_data_2[7], in_data_3[7], in_data_4[7], in_data_5[7], in_data_6[7], in_data_7[7], in_data_8[7], in_data_9[7], in_data_10[7], in_data_11[7], in_data_12[7], in_data_13[7], in_data_14[7], in_data_15[7], in_data_16[7], in_data_17[7], in_data_18[7], in_data_19[7], in_data_20[7], in_data_21[7], in_data_22[7], in_data_23[7], in_data_24[7], in_data_25[7], in_data_26[7], in_data_27[7], in_data_28[7], in_data_29[7], in_data_30[7], in_data_31[7], in_data_32[7], in_data_33[7], in_data_34[7], in_data_35[7], in_data_36[7], in_data_37[7], in_data_38[7], in_data_39[7], in_data_40[7], in_data_41[7], in_data_42[7], in_data_43[7], in_data_44[7], in_data_45[7], in_data_46[7], in_data_47[7], in_data_48[7], in_data_49[7], in_data_50[7], in_data_51[7], in_data_52[7], in_data_53[7], in_data_54[7], in_data_55[7], in_data_56[7], in_data_57[7], in_data_58[7], in_data_59[7], in_data_60[7], in_data_61[7], in_data_62[7], in_data_63[7], in_data_64[7] }),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HL),
// 		.clk(clk)
// 	);

// //  LH Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH2(
// 		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6], in_data_49[6], in_data_50[6], in_data_51[6], in_data_52[6], in_data_53[6], in_data_54[6], in_data_55[6], in_data_56[6], in_data_57[6], in_data_58[6], in_data_59[6], in_data_60[6], in_data_61[6], in_data_62[6], in_data_63[6], in_data_64[6] }),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LH),
// 		.clk(clk)
// 	);

// //  LL Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL3(
// 		.Input_feature({in_data_0[6], in_data_1[6], in_data_2[6], in_data_3[6], in_data_4[6], in_data_5[6], in_data_6[6], in_data_7[6], in_data_8[6], in_data_9[6], in_data_10[6], in_data_11[6], in_data_12[6], in_data_13[6], in_data_14[6], in_data_15[6], in_data_16[6], in_data_17[6], in_data_18[6], in_data_19[6], in_data_20[6], in_data_21[6], in_data_22[6], in_data_23[6], in_data_24[6], in_data_25[6], in_data_26[6], in_data_27[6], in_data_28[6], in_data_29[6], in_data_30[6], in_data_31[6], in_data_32[6], in_data_33[6], in_data_34[6], in_data_35[6], in_data_36[6], in_data_37[6], in_data_38[6], in_data_39[6], in_data_40[6], in_data_41[6], in_data_42[6], in_data_43[6], in_data_44[6], in_data_45[6], in_data_46[6], in_data_47[6], in_data_48[6], in_data_49[6], in_data_50[6], in_data_51[6], in_data_52[6], in_data_53[6], in_data_54[6], in_data_55[6], in_data_56[6], in_data_57[6], in_data_58[6], in_data_59[6], in_data_60[6], in_data_61[6], in_data_62[6], in_data_63[6], in_data_64[6]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LL),
// 		.clk(clk)
// 	);
	



// 	// assign Out_data = tmp_result_HH1 + tmp_result_HL1 + tmp_result_LH1 + tmp_result_LL1;


// 	wire [7:0] tmp_result_HH_1, tmp_result_HL_1, tmp_result_LH_1, tmp_result_LL_1;
// //  HH Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH4(
// 		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5], in_data_32[5], in_data_33[5], in_data_34[5], in_data_35[5], in_data_36[5], in_data_37[5], in_data_38[5], in_data_39[5], in_data_40[5], in_data_41[5], in_data_42[5], in_data_43[5], in_data_44[5], in_data_45[5], in_data_46[5], in_data_47[5], in_data_48[5], in_data_49[5], in_data_50[5], in_data_51[5], in_data_52[5], in_data_53[5], in_data_54[5], in_data_55[5], in_data_56[5], in_data_57[5], in_data_58[5], in_data_59[5], in_data_60[5], in_data_61[5], in_data_62[5], in_data_63[5], in_data_64[5] }),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HH_1),
// 		.clk(clk)
// 	);

// //  HL Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL5(
// 		.Input_feature({in_data_0[5], in_data_1[5], in_data_2[5], in_data_3[5], in_data_4[5], in_data_5[5], in_data_6[5], in_data_7[5], in_data_8[5], in_data_9[5], in_data_10[5], in_data_11[5], in_data_12[5], in_data_13[5], in_data_14[5], in_data_15[5], in_data_16[5], in_data_17[5], in_data_18[5], in_data_19[5], in_data_20[5], in_data_21[5], in_data_22[5], in_data_23[5], in_data_24[5], in_data_25[5], in_data_26[5], in_data_27[5], in_data_28[5], in_data_29[5], in_data_30[5], in_data_31[5], in_data_32[5], in_data_33[5], in_data_34[5], in_data_35[5], in_data_36[5], in_data_37[5], in_data_38[5], in_data_39[5], in_data_40[5], in_data_41[5], in_data_42[5], in_data_43[5], in_data_44[5], in_data_45[5], in_data_46[5], in_data_47[5], in_data_48[5], in_data_49[5], in_data_50[5], in_data_51[5], in_data_52[5], in_data_53[5], in_data_54[5], in_data_55[5], in_data_56[5], in_data_57[5], in_data_58[5], in_data_59[5], in_data_60[5], in_data_61[5], in_data_62[5], in_data_63[5], in_data_64[5]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HL_1),
// 		.clk(clk)
// 	);

// //  LH Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH6(
// 		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4], in_data_32[4], in_data_33[4], in_data_34[4], in_data_35[4], in_data_36[4], in_data_37[4], in_data_38[4], in_data_39[4], in_data_40[4], in_data_41[4], in_data_42[4], in_data_43[4], in_data_44[4], in_data_45[4], in_data_46[4], in_data_47[4], in_data_48[4], in_data_49[4], in_data_50[4], in_data_51[4], in_data_52[4], in_data_53[4], in_data_54[4], in_data_55[4], in_data_56[4], in_data_57[4], in_data_58[4], in_data_59[4], in_data_60[4], in_data_61[4], in_data_62[4], in_data_63[4], in_data_64[4]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LH_1),
// 		.clk(clk)
// 	);

// //  LL Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL7(
// 		.Input_feature({in_data_0[4], in_data_1[4], in_data_2[4], in_data_3[4], in_data_4[4], in_data_5[4], in_data_6[4], in_data_7[4], in_data_8[4], in_data_9[4], in_data_10[4], in_data_11[4], in_data_12[4], in_data_13[4], in_data_14[4], in_data_15[4], in_data_16[4], in_data_17[4], in_data_18[4], in_data_19[4], in_data_20[4], in_data_21[4], in_data_22[4], in_data_23[4], in_data_24[4], in_data_25[4], in_data_26[4], in_data_27[4], in_data_28[4], in_data_29[4], in_data_30[4], in_data_31[4], in_data_32[4], in_data_33[4], in_data_34[4], in_data_35[4], in_data_36[4], in_data_37[4], in_data_38[4], in_data_39[4], in_data_40[4], in_data_41[4], in_data_42[4], in_data_43[4], in_data_44[4], in_data_45[4], in_data_46[4], in_data_47[4], in_data_48[4], in_data_49[4], in_data_50[4], in_data_51[4], in_data_52[4], in_data_53[4], in_data_54[4], in_data_55[4], in_data_56[4], in_data_57[4], in_data_58[4], in_data_59[4], in_data_60[4], in_data_61[4], in_data_62[4], in_data_63[4], in_data_64[4]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LL_1),
// 		.clk(clk)
// 	);
	

// 	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;

// 	wire [7:0] tmp_result_HH_2, tmp_result_HL_2, tmp_result_LH_2, tmp_result_LL_2;
// //  HH Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH8(
// 		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3], in_data_32[3], in_data_33[3], in_data_34[3], in_data_35[3], in_data_36[3], in_data_37[3], in_data_38[3], in_data_39[3], in_data_40[3], in_data_41[3], in_data_42[3], in_data_43[3], in_data_44[3], in_data_45[3], in_data_46[3], in_data_47[3], in_data_48[3], in_data_49[3], in_data_50[3], in_data_51[3], in_data_52[3], in_data_53[3], in_data_54[3], in_data_55[3], in_data_56[3], in_data_57[3], in_data_58[3], in_data_59[3], in_data_60[3], in_data_61[3], in_data_62[3], in_data_63[3], in_data_64[3]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HH_2),
// 		.clk(clk)
// 	);

// //  HL Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL9(
// 		.Input_feature({in_data_0[3], in_data_1[3], in_data_2[3], in_data_3[3], in_data_4[3], in_data_5[3], in_data_6[3], in_data_7[3], in_data_8[3], in_data_9[3], in_data_10[3], in_data_11[3], in_data_12[3], in_data_13[3], in_data_14[3], in_data_15[3], in_data_16[3], in_data_17[3], in_data_18[3], in_data_19[3], in_data_20[3], in_data_21[3], in_data_22[3], in_data_23[3], in_data_24[3], in_data_25[3], in_data_26[3], in_data_27[3], in_data_28[3], in_data_29[3], in_data_30[3], in_data_31[3], in_data_32[3], in_data_33[3], in_data_34[3], in_data_35[3], in_data_36[3], in_data_37[3], in_data_38[3], in_data_39[3], in_data_40[3], in_data_41[3], in_data_42[3], in_data_43[3], in_data_44[3], in_data_45[3], in_data_46[3], in_data_47[3], in_data_48[3], in_data_49[3], in_data_50[3], in_data_51[3], in_data_52[3], in_data_53[3], in_data_54[3], in_data_55[3], in_data_56[3], in_data_57[3], in_data_58[3], in_data_59[3], in_data_60[3], in_data_61[3], in_data_62[3], in_data_63[3], in_data_64[3]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HL_2),
// 		.clk(clk)
// 	);

// //  LH Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH10(
// 		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2], in_data_32[2], in_data_33[2], in_data_34[2], in_data_35[2], in_data_36[2], in_data_37[2], in_data_38[2], in_data_39[2], in_data_40[2], in_data_41[2], in_data_42[2], in_data_43[2], in_data_44[2], in_data_45[2], in_data_46[2], in_data_47[2], in_data_48[2], in_data_49[2], in_data_50[2], in_data_51[2], in_data_52[2], in_data_53[2], in_data_54[2], in_data_55[2], in_data_56[2], in_data_57[2], in_data_58[2], in_data_59[2], in_data_60[2], in_data_61[2], in_data_62[2], in_data_63[2], in_data_64[2]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LH_2),
// 		.clk(clk)
// 	);

// //  LL Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL11(
// 		.Input_feature({in_data_0[2], in_data_1[2], in_data_2[2], in_data_3[2], in_data_4[2], in_data_5[2], in_data_6[2], in_data_7[2], in_data_8[2], in_data_9[2], in_data_10[2], in_data_11[2], in_data_12[2], in_data_13[2], in_data_14[2], in_data_15[2], in_data_16[2], in_data_17[2], in_data_18[2], in_data_19[2], in_data_20[2], in_data_21[2], in_data_22[2], in_data_23[2], in_data_24[2], in_data_25[2], in_data_26[2], in_data_27[2], in_data_28[2], in_data_29[2], in_data_30[2], in_data_31[2], in_data_32[2], in_data_33[2], in_data_34[2], in_data_35[2], in_data_36[2], in_data_37[2], in_data_38[2], in_data_39[2], in_data_40[2], in_data_41[2], in_data_42[2], in_data_43[2], in_data_44[2], in_data_45[2], in_data_46[2], in_data_47[2], in_data_48[2], in_data_49[2], in_data_50[2], in_data_51[2], in_data_52[2], in_data_53[2], in_data_54[2], in_data_55[2], in_data_56[2], in_data_57[2], in_data_58[2], in_data_59[2], in_data_60[2], in_data_61[2], in_data_62[2], in_data_63[2], in_data_64[2]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LL_2),
// 		.clk(clk)
// 	);
	
// 	// assign Out_data = tmp_result_HH + tmp_result_HL + tmp_result_LH + tmp_result_LL;




// 	wire [7:0] tmp_result_HH_3, tmp_result_HL_3, tmp_result_LH_3, tmp_result_LL_3;
// //  HH Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HH12(
// 		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1], in_data_32[1], in_data_33[1], in_data_34[1], in_data_35[1], in_data_36[1], in_data_37[1], in_data_38[1], in_data_39[1], in_data_40[1], in_data_41[1], in_data_42[1], in_data_43[1], in_data_44[1], in_data_45[1], in_data_46[1], in_data_47[1], in_data_48[1], in_data_49[1], in_data_50[1], in_data_51[1], in_data_52[1], in_data_53[1], in_data_54[1], in_data_55[1], in_data_56[1], in_data_57[1], in_data_58[1], in_data_59[1], in_data_60[1], in_data_61[1], in_data_62[1], in_data_63[1], in_data_64[1]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HH_3),
// 		.clk(clk)
// 	);

// //  HL Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_HL13(
// 		.Input_feature({in_data_0[1], in_data_1[1], in_data_2[1], in_data_3[1], in_data_4[1], in_data_5[1], in_data_6[1], in_data_7[1], in_data_8[1], in_data_9[1], in_data_10[1], in_data_11[1], in_data_12[1], in_data_13[1], in_data_14[1], in_data_15[1], in_data_16[1], in_data_17[1], in_data_18[1], in_data_19[1], in_data_20[1], in_data_21[1], in_data_22[1], in_data_23[1], in_data_24[1], in_data_25[1], in_data_26[1], in_data_27[1], in_data_28[1], in_data_29[1], in_data_30[1], in_data_31[1], in_data_32[1], in_data_33[1], in_data_34[1], in_data_35[1], in_data_36[1], in_data_37[1], in_data_38[1], in_data_39[1], in_data_40[1], in_data_41[1], in_data_42[1], in_data_43[1], in_data_44[1], in_data_45[1], in_data_46[1], in_data_47[1], in_data_48[1], in_data_49[1], in_data_50[1], in_data_51[1], in_data_52[1], in_data_53[1], in_data_54[1], in_data_55[1], in_data_56[1], in_data_57[1], in_data_58[1], in_data_59[1], in_data_60[1], in_data_61[1], in_data_62[1], in_data_63[1], in_data_64[1]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_HL_3),
// 		.clk(clk)
// 	);

// //  LH Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LH14(
// 		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0], in_data_32[0], in_data_33[0], in_data_34[0], in_data_35[0], in_data_36[0], in_data_37[0], in_data_38[0], in_data_39[0], in_data_40[0], in_data_41[0], in_data_42[0], in_data_43[0], in_data_44[0], in_data_45[0], in_data_46[0], in_data_47[0], in_data_48[0], in_data_49[0], in_data_50[0], in_data_51[0], in_data_52[0], in_data_53[0], in_data_54[0], in_data_55[0], in_data_56[0], in_data_57[0], in_data_58[0], in_data_59[0], in_data_60[0], in_data_61[0], in_data_62[0], in_data_63[0], in_data_64[0]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LH_3),
// 		.clk(clk)
// 	);

// //  LL Unit
// 	conv #(.INPUT_SIZE(64), .DEPTH(clogb2(1)), .ADC_P(6)) single_conv_LL15(
// 		.Input_feature({in_data_0[0], in_data_1[0], in_data_2[0], in_data_3[0], in_data_4[0], in_data_5[0], in_data_6[0], in_data_7[0], in_data_8[0], in_data_9[0], in_data_10[0], in_data_11[0], in_data_12[0], in_data_13[0], in_data_14[0], in_data_15[0], in_data_16[0], in_data_17[0], in_data_18[0], in_data_19[0], in_data_20[0], in_data_21[0], in_data_22[0], in_data_23[0], in_data_24[0], in_data_25[0], in_data_26[0], in_data_27[0], in_data_28[0], in_data_29[0], in_data_30[0], in_data_31[0], in_data_32[0], in_data_33[0], in_data_34[0], in_data_35[0], in_data_36[0], in_data_37[0], in_data_38[0], in_data_39[0], in_data_40[0], in_data_41[0], in_data_42[0], in_data_43[0], in_data_44[0], in_data_45[0], in_data_46[0], in_data_47[0], in_data_48[0], in_data_49[0], in_data_50[0], in_data_51[0], in_data_52[0], in_data_53[0], in_data_54[0], in_data_55[0], in_data_56[0], in_data_57[0], in_data_58[0], in_data_59[0], in_data_60[0], in_data_61[0], in_data_62[0], in_data_63[0], in_data_64[0]}),
// 		.Address(Add_pim),
// 		.en(Compute_flag),
// 		.Output(tmp_result_LL_3),
// 		.clk(clk)
// 	);
	
// 	wire [15:0] tmp_res[15];
//     qadd_in qadd_in_0(.a(tmp_result_HH), .b(tmp_result_HL), .sum(tmp_res[0]));
//     qadd_in qadd_in_1(.a(tmp_result_LH), .b(tmp_result_LL), .sum(tmp_res[1]));
//     qadd_in qadd_in_2(.a(tmp_result_HH_1), .b(tmp_result_HL_1), .sum(tmp_res[2]));
//     qadd_in qadd_in_3(.a(tmp_result_LH_1), .b(tmp_result_LL_1), .sum(tmp_res[3]));
//     qadd_in qadd_in_4(.a(tmp_result_HH_2), .b(tmp_result_HL_2), .sum(tmp_res[4]));
//     qadd_in qadd_in_5(.a(tmp_result_LH_2), .b(tmp_result_LL_2), .sum(tmp_res[5]));
//     qadd_in qadd_in_6(.a(tmp_result_HH_3), .b(tmp_result_HL_3), .sum(tmp_res[6]));
//     qadd_in qadd_in_7(.a(tmp_result_LH_3), .b(tmp_result_LL_3), .sum(tmp_res[7]));
//     qadd_in qadd_in_8(.a(tmp_res[0]), .b(tmp_res[1]), .sum(tmp_res[8]));
//     qadd_in qadd_in_9(.a(tmp_res[2]), .b(tmp_res[3]), .sum(tmp_res[9]));
//     qadd_in qadd_in_10(.a(tmp_res[4]), .b(tmp_res[5]), .sum(tmp_res[10]));
//     qadd_in qadd_in_11(.a(tmp_res[6]), .b(tmp_res[7]), .sum(tmp_res[11]));
//     qadd_in qadd_in_12(.a(tmp_res[8]), .b(tmp_res[9]), .sum(tmp_res[12]));
//     qadd_in qadd_in_13(.a(tmp_res[10]), .b(tmp_res[11]), .sum(tmp_res[13]));
//     qadd_in qadd_in_14(.a(tmp_res[12]), .b(tmp_res[13]), .sum(Out_data));



// endmodule

