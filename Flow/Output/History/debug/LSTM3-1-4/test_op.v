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
spram_u Ui_mem (.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Ui_in));
spram_u Uf_mem (.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Uf_in));
spram_u Uo_mem (.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Uo_in));
spram_u Uc_mem (.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Uc_in));
spram_v Wi_mem (.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wi_in));
spram_v Wf_mem (.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wf_in));
spram_v Wo_mem (.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wo_in));
spram_v Wc_mem (.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wc_in));

//BRAM of the input vectors to LSTM
spram_v Xi_mem (.clk(clk),.address_a(inaddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(x_in));

//BRAM storing Bias of each gate
spram_b bi_mem (.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bi_in));
spram_b bf_mem (.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bf_in));
spram_b bo_mem (.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bo_in));
spram_b bc_mem (.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bc_in));


lstm_top lstm (.clk(clk),.rst(reset),.ht_out(ht),.Ui_in(Ui_in),.Wi_in(Wi_in),.Uf_in(Uf_in),.Wf_in(Wf_in),.Uo_in(Uo_in),.Wo_in(Wo_in),
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
  vecmat_x_6_DSP vecmat_add_OP_1 (.clk(clk), .reset(rst), .data_x(x_in), .W_x(Wf_in), .data_out_x(macout_fx));
  vecmat_h_6_PIM vecmat_add_OP_2 (.clk(clk), .reset(rst), .data_h(h_in), .W_h(Uf_in), .data_out_h(macout_fh));
//   vecmat_mul_x #(`varraysize,`INPUT_DEPTH) f_gatex (.clk(clk),.reset(rst),.data(x_in),.W(Wf_in),.tmp(mulout_fx));
//   vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) f_gateh (.clk(clk),.reset(rst),.data(h_in),.W(Uf_in),.tmp(mulout_fh));
//   vecmat_add_x #(`varraysize,`INPUT_DEPTH) f_gateaddx (.clk(clk),.reset(rst),.mulout(mulout_fx_reg),.data_out(macout_fx));
//   vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) f_gateaddh (.clk(clk),.reset(rst),.mulout(mulout_fh_reg),.data_out(macout_fh));
  qadd2 f_gate_add(.a(mac_fx_reg),.b(mac_fh_reg),.c(add_f));
//   assign add_f = macout_fx | macout_fh;
//   assign addbias_f = add_f | bf_in;
  qadd2 f_gate_biasadd(.a(bf_in),.b(add_f),.c(addbias_f));
  sigmoid sigf(addbias_f,sig_fo);
  //qmult #(12,16) f_elmul(.i_multiplicand(sig_fo_reg),.i_multiplier(C_in),.o_result(elmul_fo),.ovr(overflow0));
  signedmul f_elmul (.clk(clk),.a(sig_fo_reg),.b(C_in),.c(elmul_fo));
//   assign test_1 = sig_fo;
//INPUT GATE
  vecmat_x_6_PIM vecmat_add_OP_3 (.clk(clk), .reset(rst), .data_x(Wi_in), .W_x(Wi_in), .data_out_x(macout_ix));
  vecmat_h_6_CLB vecmat_add_OP_4 (.clk(clk), .reset(rst), .data_h(Ui_in), .W_h(Ui_in), .data_out_h(macout_ih));
//   vecmat_mul_x #(`varraysize,`INPUT_DEPTH) i_gatex (.clk(clk),.reset(rst),.data(x_in),.W(Wi_in),.tmp(mulout_ix));
//   vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) i_gateh (.clk(clk),.reset(rst),.data(h_in),.W(Ui_in),.tmp(mulout_ih));
//   vecmat_add_x #(`varraysize,`INPUT_DEPTH) i_gateaddx (.clk(clk),.reset(rst),.mulout(mulout_ix_reg),.data_out(macout_ix));
//   vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) i_gateaddh (.clk(clk),.reset(rst),.mulout(mulout_ih_reg),.data_out(macout_ih));
  qadd2 i_gate_add(.a(mac_ix_reg),.b(mac_ih_reg),.c(add_i));
  qadd2 i_gate_biasadd(.a(bi_in),.b(add_i),.c(addbias_i));
  sigmoid sigi(addb_i_reg,sig_io);

//OUTPUT GATE
  vecmat_x_6_PIM vecmat_add_OP_5 (.clk(clk), .reset(rst), .data_x(x_in), .W_x(Wo_in), .data_out_x(macout_ox));
  vecmat_h_6_PIM vecmat_add_OP_6 (.clk(clk), .reset(rst), .data_h(h_in), .W_h(Uo_in), .data_out_h(macout_oh));
//   vecmat_mul_x #(`varraysize,`INPUT_DEPTH) o_gatex (.clk(clk),.reset(rst),.data(x_in),.W(Wo_in),.tmp(mulout_ox));
//   vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) o_gateh (.clk(clk),.reset(rst),.data(h_in),.W(Uo_in),.tmp(mulout_oh));
//   vecmat_add_x #(`varraysize,`INPUT_DEPTH) o_gateaddx (.clk(clk),.reset(rst),.mulout(mulout_ox_reg),.data_out(macout_ox));
//   vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) o_gateaddh (.clk(clk),.reset(rst),.mulout(mulout_oh_reg),.data_out(macout_oh));
  qadd2 o_gate_add(.a(mac_ox_reg),.b(mac_oh_reg),.c(add_o));
  qadd2 o_gate_biasadd(.a(bo_in),.b(add_o),.c(addbias_o));
  sigmoid sigo(addb_o_reg,sig_oo);

//CELL STATE GATE
  vecmat_x_6_DSP vecmat_add_OP_7 (.clk(clk), .reset(rst), .data_x(x_in), .W_x(Wc_in), .data_out_x(macout_cx));
  vecmat_h_6_DSP vecmat_add_OP_8 (.clk(clk), .reset(rst), .data_h(h_in), .W_h(Uc_in), .data_out_h(macout_ch));
//   vecmat_mul_x #(`varraysize,`INPUT_DEPTH) c_gatex (.clk(clk),.reset(rst),.data(x_in),.W(Wc_in),.tmp(mulout_cx));
//   vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) c_gateh (.clk(clk),.reset(rst),.data(h_in),.W(Uc_in),.tmp(mulout_ch));
//   vecmat_add_x #(`varraysize,`INPUT_DEPTH) c_gateaddx (.clk(clk),.reset(rst),.mulout(mulout_cx_reg),.data_out(macout_cx));
//   vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) c_gateaddh (.clk(clk),.reset(rst),.mulout(mulout_ch_reg),.data_out(macout_ch));
  qadd2 c_gate_add(.a(mac_cx_reg),.b(mac_ch_reg),.c(add_c));
  qadd2 c_gate_biasadd(.a(bc_in),.b(add_c),.c(addbias_c)); 
  tanh tan_c1(addb_c_reg,tan_c);
  //qmult #(12,16) c_elmul(.i_multiplicand(tan_c_reg),.i_multiplier(sig_io_reg),.o_result(elmul_co),.ovr(overflow0));
  signedmul c_elmul (.clk(clk),.a(tan_c_reg),.b(sig_io_reg),.c(elmul_co));	  
  qadd2 cf_gate_add(.a(elmul_co_reg),.b(elmul_fo_reg),.c(add_cf));
  tanh tan_c2(add_cf_reg,tan_h);
  //qmult #(12,16) h_elmul(.i_multiplicand(tan_h_reg),.i_multiplier(sig_oo_d3),.o_result(ht),.ovr(overflow0));
  signedmul h_elmul (.clk(clk),.a(tan_h_reg),.b(sig_oo_d5),.c(ht));



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



