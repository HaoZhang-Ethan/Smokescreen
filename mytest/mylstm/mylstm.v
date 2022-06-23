//////////////////////////////////////////////////////////////////////////////
// Author: Zolid Hogr 8 bit
// Author: Aishwarya Rajen
//////////////////////////////////////////////////////////////////////////////

//`define SIMULATION_MEMORY
`define ARRAY_DEPTH 64      //Number of Hidden neurons
`define INPUT_DEPTH 100	    //LSTM input vector dimensions
`define DATA_WIDTH 8		//8 bit representation
`define INWEIGHT_DEPTH 6400 //100x64
`define HWEIGHT_DEPTH 4096  //64x64
`define varraysize 800   //100x8
`define uarraysize 512  //64x8

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
output reg Done        //Stays high indicating the end of lstm output computation for all the Xin words provided.
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

reg [63:0] Ui_pimdata_in;
reg [63:0] Ui_pimdata_out;
reg [3:0] Ui_add_pim;


reg [63:0] Uf_pimdata_in;
reg [63:0] Uf_pimdata_out;
reg [3:0] Uf_add_pim;


reg [63:0] Uo_pimdata_in;
reg [63:0] Uo_pimdata_out;
reg [3:0] Uo_add_pim;


reg [63:0] Uc_pimdata_in;
reg [63:0] Uc_pimdata_out;
reg [3:0] Uc_add_pim;


reg [63:0] Wi_pimdata_in;
reg [63:0] Wi_pimdata_out;
reg [3:0] Wi_add_pim;


reg [63:0] Wf_pimdata_in;
reg [63:0] Wf_pimdata_out;
reg [3:0] Wf_add_pim;


reg [63:0] Wo_pimdata_in;
reg [63:0] Wo_pimdata_out;
reg [3:0] Wo_add_pim;


reg [63:0] Wc_pimdata_in;
reg [63:0] Wc_pimdata_out;
reg [3:0] Wc_add_pim;


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
// spram_u Ui_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Ui_in));
// spram_u Uf_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Uf_in));
// spram_u Uo_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Uo_in));
// spram_u Uc_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Uc_in));
// spram_v Wi_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wi_in));
// spram_v Wf_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wf_in));
// spram_v Wo_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wo_in));
// spram_v Wc_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(Wc_in));

single_port_ram Ui_PIM(.addr(Ui_add_pim),.we(wren_a),.data(Ui_pimdata_in),.out(Ui_pimdata_out),.clk(clk));
single_port_ram Uf_PIM(.addr(Uf_add_pim),.we(wren_a),.data(Uf_pimdata_in),.out(Uf_pimdata_out),.clk(clk));
single_port_ram Uo_PIM(.addr(Uo_add_pim),.we(wren_a),.data(Uo_pimdata_in),.out(Uo_pimdata_out),.clk(clk));
single_port_ram Uc_PIM(.addr(Uc_add_pim),.we(wren_a),.data(Uc_pimdata_in),.out(Uc_pimdata_out),.clk(clk));
single_port_ram Wi_PIM(.addr(Wi_add_pim),.we(wren_a),.data(Wi_pimdata_in),.out(Wi_pimdata_out),.clk(clk));
single_port_ram Wf_PIM(.addr(Wf_add_pim),.we(wren_a),.data(Wf_pimdata_in),.out(Wf_pimdata_out),.clk(clk));
single_port_ram Wo_PIM(.addr(Wo_add_pim),.we(wren_a),.data(Wo_pimdata_in),.out(Wo_pimdata_out),.clk(clk));
single_port_ram Wc_PIM(.addr(Wc_add_pim),.we(wren_a),.data(Wc_pimdata_in),.out(Wc_pimdata_out),.clk(clk));



// single_port_ram Ui_PIM(.Add_in(waddr),.We(wren_a),.Data_in(dummyin_v),.CoM(wren_a),.Data_out(Wc_in),.clk(clk));
// single_port_ram Ui_PIM(.addr(waddr),.we(wren_a),.data(dummyin_v),.out(Wc_in),.clk(clk));
//BRAM of the input vectors to LSTM
spram_v Xi_mem(.clk(clk),.address_a(inaddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(x_in));

//BRAM storing Bias of each gate
spram_b bi_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bi_in));
spram_b bf_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bf_in));
spram_b bo_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bo_in));
spram_b bc_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bc_in));



lstm_top lstm(.clk(clk),.rst(reset),.ht_out(ht),.Ui_in(Ui_in),.Wi_in(Wi_in),.Uf_in(Uf_in),.Wf_in(Wf_in),.Uo_in(Uo_in),.Wo_in(Wo_in),
.Uc_in(Uc_in),.Wc_in(Wc_in),.x_in(x_in),.h_in(h_in),.C_in(C_in),.bi_in(bi_in),.bf_in(bf_in),.bo_in(bo_in),.bc_in(bc_in),.add_cf(add_cf));

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
			0: C_in<=Ct[8*0+:8] ;
			1: C_in<=Ct[8*1+:8] ;
			2: C_in<=Ct[8*2+:8] ;
			3: C_in<=Ct[8*3+:8] ;
			4: C_in<=Ct[8*4+:8] ;
			5: C_in<=Ct[8*5+:8] ;
			6: C_in<=Ct[8*6+:8] ;
			7: C_in<=Ct[8*7+:8] ;
			8: C_in<=Ct[8*8+:8] ;
			9: C_in<=Ct[8*9+:8] ;
			10: C_in <=Ct[8*10+:8];
			11: C_in <=Ct[8*11+:8];
			12: C_in <=Ct[8*12+:8];
			13: C_in <=Ct[8*13+:8];
			14: C_in <=Ct[8*14+:8];
			15: C_in <=Ct[8*15+:8];
			16: C_in <=Ct[8*16+:8];
			17: C_in <=Ct[8*17+:8];
			18: C_in <=Ct[8*18+:8];
			19: C_in <=Ct[8*19+:8];
			20: C_in <=Ct[8*20+:8];
			21: C_in <=Ct[8*21+:8];
			22: C_in <=Ct[8*22+:8];
			23: C_in <=Ct[8*23+:8];
			24: C_in <=Ct[8*24+:8];
			25: C_in <=Ct[8*25+:8];
			26: C_in <=Ct[8*26+:8];
			27: C_in <=Ct[8*27+:8];
			28: C_in <=Ct[8*28+:8];
			29: C_in <=Ct[8*29+:8];
			30: C_in <=Ct[8*30+:8];
			31: C_in <=Ct[8*31+:8];
			32: C_in <=Ct[8*32+:8];
			33: C_in <=Ct[8*33+:8];
			34: C_in <=Ct[8*34+:8];
			35: C_in <=Ct[8*35+:8];
			36: C_in <=Ct[8*36+:8];
			37: C_in <=Ct[8*37+:8];
			38: C_in <=Ct[8*38+:8];
			39: C_in <=Ct[8*39+:8];
			40: C_in <=Ct[8*40+:8];
			41: C_in <=Ct[8*41+:8];
			42: C_in <=Ct[8*42+:8];
			43: C_in <=Ct[8*43+:8];
			44: C_in <=Ct[8*44+:8];
			45: C_in <=Ct[8*45+:8];
			46: C_in <=Ct[8*46+:8];
			47: C_in <=Ct[8*47+:8];
			48: C_in <=Ct[8*48+:8];
			49: C_in <=Ct[8*49+:8];
			50: C_in <=Ct[8*50+:8];
			51: C_in <=Ct[8*51+:8];
			52: C_in <=Ct[8*52+:8];
			53: C_in <=Ct[8*53+:8];
			54: C_in <=Ct[8*54+:8];
			55: C_in <=Ct[8*55+:8];
			56: C_in <=Ct[8*56+:8];
			57: C_in <=Ct[8*57+:8];
			58: C_in <=Ct[8*58+:8];
			59: C_in <=Ct[8*59+:8];
			60: C_in <=Ct[8*60+:8];
			61: C_in <=Ct[8*61+:8];
			62: C_in <=Ct[8*62+:8];
			63: C_in <=Ct[8*63+:8];
			default : C_in <= 0;
		endcase	
		end

		if(count >11) begin  //for storing output of Ct
			ct_count <= ct_count+1;
		 //storing cell state
			case(ct_count)
			0:	Ct[8*0+:8] <= add_cf;
			1:	Ct[8*1+:8] <= add_cf;
			2:	Ct[8*2+:8] <= add_cf;
			3:	Ct[8*3+:8] <= add_cf;
			4:	Ct[8*4+:8] <= add_cf;
			5:	Ct[8*5+:8] <= add_cf;
			6:	Ct[8*6+:8] <= add_cf;
			7:	Ct[8*7+:8] <= add_cf;
			8:	Ct[8*8+:8] <= add_cf;
			9:	Ct[8*9+:8] <= add_cf;
			10:	Ct[8*10+:8] <=add_cf;
			11:	Ct[8*11+:8] <=add_cf;
			12:	Ct[8*12+:8] <=add_cf;
			13:	Ct[8*13+:8] <=add_cf;
			14:	Ct[8*14+:8] <=add_cf;
			15:	Ct[8*15+:8] <=add_cf;
			16:	Ct[8*16+:8] <=add_cf;
			17:	Ct[8*17+:8] <=add_cf;
			18:	Ct[8*18+:8] <=add_cf;
			19:	Ct[8*19+:8] <=add_cf;
			20:	Ct[8*20+:8] <=add_cf;
			21:	Ct[8*21+:8] <=add_cf;
			22:	Ct[8*22+:8] <=add_cf;
			23:	Ct[8*23+:8] <=add_cf;
			24:	Ct[8*24+:8] <=add_cf;
			25:	Ct[8*25+:8] <=add_cf;
			26:	Ct[8*26+:8] <=add_cf;
			27:	Ct[8*27+:8] <=add_cf;
			28:	Ct[8*28+:8] <=add_cf;
			29:	Ct[8*29+:8] <=add_cf;
			30:	Ct[8*30+:8] <=add_cf;
			31:	Ct[8*31+:8] <=add_cf;
			32:	Ct[8*32+:8] <=add_cf;
			33:	Ct[8*33+:8] <=add_cf;
			34:	Ct[8*34+:8] <=add_cf;
			35:	Ct[8*35+:8] <=add_cf;
			36:	Ct[8*36+:8] <=add_cf;
			37:	Ct[8*37+:8] <=add_cf;
			38:	Ct[8*38+:8] <=add_cf;
			39:	Ct[8*39+:8] <=add_cf;
			40:	Ct[8*40+:8] <=add_cf;
			41:	Ct[8*41+:8] <=add_cf;
			42:	Ct[8*42+:8] <=add_cf;
			43:	Ct[8*43+:8] <=add_cf;
			44:	Ct[8*44+:8] <=add_cf;
			45:	Ct[8*45+:8] <=add_cf;
			46:	Ct[8*46+:8] <=add_cf;
			47:	Ct[8*47+:8] <=add_cf;
			48:	Ct[8*48+:8] <=add_cf;
			49:	Ct[8*49+:8] <=add_cf;
			50:	Ct[8*50+:8] <=add_cf;
			51:	Ct[8*51+:8] <=add_cf;
			52:	Ct[8*52+:8] <=add_cf;
			53:	Ct[8*53+:8] <=add_cf;
			54:	Ct[8*54+:8] <=add_cf;
			55:	Ct[8*55+:8] <=add_cf;
			56:	Ct[8*56+:8] <=add_cf;
			57:	Ct[8*57+:8] <=add_cf;
			58:	Ct[8*58+:8] <=add_cf;
			59:	Ct[8*59+:8] <=add_cf;
			60:	Ct[8*60+:8] <=add_cf;
			61:	Ct[8*61+:8] <=add_cf;
			62:	Ct[8*62+:8] <=add_cf;
			63:	Ct[8*63+:8] <=add_cf;
			default : Ct <= 0;
		 endcase
		end
		if(count >16) begin
			h_count <= h_count + 1;
			case(h_count)
			0:	ht_prev[8*0+:8] <= ht;
			1:	ht_prev[8*1+:8] <= ht;
			2:	ht_prev[8*2+:8] <= ht;
			3:	ht_prev[8*3+:8] <= ht;
			4:	ht_prev[8*4+:8] <= ht;
			5:	ht_prev[8*5+:8] <= ht;
			6:	ht_prev[8*6+:8] <= ht;
			7:	ht_prev[8*7+:8] <= ht;
			8:	ht_prev[8*8+:8] <= ht;
			9:	ht_prev[8*9+:8] <= ht;
			10:	ht_prev[8*10+:8] <= ht;
			11:	ht_prev[8*11+:8] <= ht;
			12:	ht_prev[8*12+:8] <= ht;
			13:	ht_prev[8*13+:8] <= ht;
			14:	ht_prev[8*14+:8] <= ht;
			15:	ht_prev[8*15+:8] <= ht;
			16:	ht_prev[8*16+:8] <= ht;
			17:	ht_prev[8*17+:8] <= ht;
			18:	ht_prev[8*18+:8] <= ht;
			19:	ht_prev[8*19+:8] <= ht;
			20:	ht_prev[8*20+:8] <= ht;
			21:	ht_prev[8*21+:8] <= ht;
			22:	ht_prev[8*22+:8] <= ht;
			23:	ht_prev[8*23+:8] <= ht;
			24:	ht_prev[8*24+:8] <= ht;
			25:	ht_prev[8*25+:8] <= ht;
			26:	ht_prev[8*26+:8] <= ht;
			27:	ht_prev[8*27+:8] <= ht;
			28:	ht_prev[8*28+:8] <= ht;
			29:	ht_prev[8*29+:8] <= ht;
			30:	ht_prev[8*30+:8] <= ht;
			31:	ht_prev[8*31+:8] <= ht;
			32:	ht_prev[8*32+:8] <= ht;
			33:	ht_prev[8*33+:8] <= ht;
			34:	ht_prev[8*34+:8] <= ht;
			35:	ht_prev[8*35+:8] <= ht;
			36:	ht_prev[8*36+:8] <= ht;
			37:	ht_prev[8*37+:8] <= ht;
			38:	ht_prev[8*38+:8] <= ht;
			39:	ht_prev[8*39+:8] <= ht;
			40:	ht_prev[8*40+:8] <= ht;
			41:	ht_prev[8*41+:8] <= ht;
			42:	ht_prev[8*42+:8] <= ht;
			43:	ht_prev[8*43+:8] <= ht;
			44:	ht_prev[8*44+:8] <= ht;
			45:	ht_prev[8*45+:8] <= ht;
			46:	ht_prev[8*46+:8] <= ht;
			47:	ht_prev[8*47+:8] <= ht;
			48:	ht_prev[8*48+:8] <= ht;
			49:	ht_prev[8*49+:8] <= ht;
			50:	ht_prev[8*50+:8] <= ht;
			51:	ht_prev[8*51+:8] <= ht;
			52:	ht_prev[8*52+:8] <= ht;
			53:	ht_prev[8*53+:8] <= ht;
			54:	ht_prev[8*54+:8] <= ht;
			55:	ht_prev[8*55+:8] <= ht;
			56:	ht_prev[8*56+:8] <= ht;
			57:	ht_prev[8*57+:8] <= ht;
			58:	ht_prev[8*58+:8] <= ht;
			59:	ht_prev[8*59+:8] <= ht;
			60:	ht_prev[8*60+:8] <= ht;
			61:	ht_prev[8*61+:8] <= ht;
			62:	ht_prev[8*62+:8] <= ht;
			63:	ht_prev[8*63+:8] <= ht;
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
output [`DATA_WIDTH-1:0] add_cf);


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
//----------- Zolid ---------------------
		mac_fx_reg <= mulout_fx;
		mac_fh_reg <= mulout_fh;
// ------------------------------------
		add_f_reg <= add_f;
		addb_f_reg <= addbias_f; 
		sig_fo_reg <= sig_fo;
		elmul_fo_reg <= elmul_fo; //check if need to delay to wait for elmul_co

//----------- Zolid ---------------------
		// mulout_ix_reg <= mulout_ix;
		// mulout_ih_reg <= mulout_ih;
		// mac_ix_reg <= macout_ix;
		// mac_ih_reg <= macout_ih;


		mac_ix_reg <= mulout_ix;
		mac_ih_reg <= mulout_ih;
// ------------------------------------
		add_i_reg <= add_i;
		addb_i_reg <= addbias_i; 
		sig_io_reg <= sig_io;

//----------- Zolid ---------------------		
		// mulout_ox_reg <= mulout_ox;
		// mulout_oh_reg <= mulout_oh;
		// mac_ox_reg <= macout_ox;
		// mac_oh_reg <= macout_oh;

		mac_ox_reg <= mulout_ox;
		mac_oh_reg <= mulout_oh;
// ------------------------------------
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
  vecmat_mul_x #(`varraysize,`INPUT_DEPTH) f_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wf_in),.tmp(mulout_fx));
  vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) f_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Uf_in),.tmp(mulout_fh));
//   vecmat_add_x #(`varraysize,`INPUT_DEPTH) f_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_fx_reg),.data_out(macout_fx));
//   vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) f_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_fh_reg),.data_out(macout_fh));
  qadd2 f_gate_add(.a(mac_fx_reg),.b(mac_fh_reg),.c(add_f));
  qadd2 f_gate_biasadd(.a(bf_in),.b(add_f),.c(addbias_f));
  sigmoid sigf(addb_f_reg,sig_fo);
  //qmult #(12,16) f_elmul(.i_multiplicand(sig_fo_reg),.i_multiplier(C_in),.o_result(elmul_fo),.ovr(overflow0));
  signedmul f_elmul(.clk(clk),.a(sig_fo_reg),.b(C_in),.c(elmul_fo));

//INPUT GATE
  vecmat_mul_x #(`varraysize,`INPUT_DEPTH) i_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wi_in),.tmp(mulout_ix));
  vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) i_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Ui_in),.tmp(mulout_ih));
//   vecmat_add_x #(`varraysize,`INPUT_DEPTH) i_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_ix_reg),.data_out(macout_ix));
//   vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) i_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_ih_reg),.data_out(macout_ih));
  qadd2 i_gate_add(.a(mac_ix_reg),.b(mac_ih_reg),.c(add_i));
  qadd2 i_gate_biasadd(.a(bi_in),.b(add_i),.c(addbias_i));
  sigmoid sigi(addb_i_reg,sig_io);

//OUTPUT GATE
  vecmat_mul_x #(`varraysize,`INPUT_DEPTH) o_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wo_in),.tmp(mulout_ox));
  vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) o_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Uo_in),.tmp(mulout_oh));
//   vecmat_add_x #(`varraysize,`INPUT_DEPTH) o_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_ox_reg),.data_out(macout_ox));
//   vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) o_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_oh_reg),.data_out(macout_oh));
  qadd2 o_gate_add(.a(mac_ox_reg),.b(mac_oh_reg),.c(add_o));
  qadd2 o_gate_biasadd(.a(bo_in),.b(add_o),.c(addbias_o));
  sigmoid sigo(addb_o_reg,sig_oo);

//CELL STATE GATE
  vecmat_mul_x #(`varraysize,`INPUT_DEPTH) c_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wc_in),.tmp(mulout_cx));
  vecmat_mul_h #(`uarraysize,`ARRAY_DEPTH) c_gateh(.clk(clk),.reset(rst),.data(h_in),.W(Uc_in),.tmp(mulout_ch));
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
 

module vecmat_mul_h #( parameter uarraysize=1024,parameter vectwidth=64)  //,matsize=64)   // varraysize=1024 vectwidth=64,matsize=4096
(
 input clk,
 input reset,
 input [uarraysize-1:0] data,
 input [uarraysize-1:0] W,
 //output reg [15:0] data_out
 output [uarraysize-1:0] tmp
 );
  
 //wire [uarraysize-1:0] tmp;

 reg [uarraysize-1:0] matrix;
 reg [uarraysize-1:0] vector;


 always @(posedge clk) begin
	if(~reset) begin

	    vector <= data;
		matrix <= W;
    
	end
 end
	 
  /*genvar j;
  generate 
  for (j=0;j<vectwidth;j=j+1) begin
          signedmul mult_u0(.a(vector[j*8+:8]),.b(matrix[j*8+:8]),.c(tmp[j*8+:8]));
  end
  endgenerate*/

   	signedmul mult_u0(.clk(clk),.a(vector[0*8+:8]),.b(matrix[0*8+:8]),.c(tmp[0*8+:8]));
	signedmul mult_u1(.clk(clk),.a(vector[1*8+:8]),.b(matrix[1*8+:8]),.c(tmp[1*8+:8]));
	signedmul mult_u2(.clk(clk),.a(vector[2*8+:8]),.b(matrix[2*8+:8]),.c(tmp[2*8+:8]));
	signedmul mult_u3(.clk(clk),.a(vector[3*8+:8]),.b(matrix[3*8+:8]),.c(tmp[3*8+:8]));
	signedmul mult_u4(.clk(clk),.a(vector[4*8+:8]),.b(matrix[4*8+:8]),.c(tmp[4*8+:8]));
	signedmul mult_u5(.clk(clk),.a(vector[5*8+:8]),.b(matrix[5*8+:8]),.c(tmp[5*8+:8]));
	signedmul mult_u6(.clk(clk),.a(vector[6*8+:8]),.b(matrix[6*8+:8]),.c(tmp[6*8+:8]));
	signedmul mult_u7(.clk(clk),.a(vector[7*8+:8]),.b(matrix[7*8+:8]),.c(tmp[7*8+:8]));
	signedmul mult_u8(.clk(clk),.a(vector[8*8+:8]),.b(matrix[8*8+:8]),.c(tmp[8*8+:8]));
	signedmul mult_u9(.clk(clk),.a(vector[9*8+:8]),.b(matrix[9*8+:8]),.c(tmp[9*8+:8]));
	signedmul mult_u10(.clk(clk),.a(vector[10*8+:8]),.b(matrix[10*8+:8]),.c(tmp[10*8+:8]));
	signedmul mult_u11(.clk(clk),.a(vector[11*8+:8]),.b(matrix[11*8+:8]),.c(tmp[11*8+:8]));
	signedmul mult_u12(.clk(clk),.a(vector[12*8+:8]),.b(matrix[12*8+:8]),.c(tmp[12*8+:8]));
	signedmul mult_u13(.clk(clk),.a(vector[13*8+:8]),.b(matrix[13*8+:8]),.c(tmp[13*8+:8]));
	signedmul mult_u14(.clk(clk),.a(vector[14*8+:8]),.b(matrix[14*8+:8]),.c(tmp[14*8+:8]));
	signedmul mult_u15(.clk(clk),.a(vector[15*8+:8]),.b(matrix[15*8+:8]),.c(tmp[15*8+:8]));
	signedmul mult_u16(.clk(clk),.a(vector[16*8+:8]),.b(matrix[16*8+:8]),.c(tmp[16*8+:8]));
	signedmul mult_u17(.clk(clk),.a(vector[17*8+:8]),.b(matrix[17*8+:8]),.c(tmp[17*8+:8]));
	signedmul mult_u18(.clk(clk),.a(vector[18*8+:8]),.b(matrix[18*8+:8]),.c(tmp[18*8+:8]));
	signedmul mult_u19(.clk(clk),.a(vector[19*8+:8]),.b(matrix[19*8+:8]),.c(tmp[19*8+:8]));
	signedmul mult_u20(.clk(clk),.a(vector[20*8+:8]),.b(matrix[20*8+:8]),.c(tmp[20*8+:8]));
	signedmul mult_u21(.clk(clk),.a(vector[21*8+:8]),.b(matrix[21*8+:8]),.c(tmp[21*8+:8]));
	signedmul mult_u22(.clk(clk),.a(vector[22*8+:8]),.b(matrix[22*8+:8]),.c(tmp[22*8+:8]));
	signedmul mult_u23(.clk(clk),.a(vector[23*8+:8]),.b(matrix[23*8+:8]),.c(tmp[23*8+:8]));
	signedmul mult_u24(.clk(clk),.a(vector[24*8+:8]),.b(matrix[24*8+:8]),.c(tmp[24*8+:8]));
	signedmul mult_u25(.clk(clk),.a(vector[25*8+:8]),.b(matrix[25*8+:8]),.c(tmp[25*8+:8]));
	signedmul mult_u26(.clk(clk),.a(vector[26*8+:8]),.b(matrix[26*8+:8]),.c(tmp[26*8+:8]));
	signedmul mult_u27(.clk(clk),.a(vector[27*8+:8]),.b(matrix[27*8+:8]),.c(tmp[27*8+:8]));
	signedmul mult_u28(.clk(clk),.a(vector[28*8+:8]),.b(matrix[28*8+:8]),.c(tmp[28*8+:8]));
	signedmul mult_u29(.clk(clk),.a(vector[29*8+:8]),.b(matrix[29*8+:8]),.c(tmp[29*8+:8]));
	signedmul mult_u30(.clk(clk),.a(vector[30*8+:8]),.b(matrix[30*8+:8]),.c(tmp[30*8+:8]));
	signedmul mult_u31(.clk(clk),.a(vector[31*8+:8]),.b(matrix[31*8+:8]),.c(tmp[31*8+:8]));
	signedmul mult_u32(.clk(clk),.a(vector[32*8+:8]),.b(matrix[32*8+:8]),.c(tmp[32*8+:8]));
	signedmul mult_u33(.clk(clk),.a(vector[33*8+:8]),.b(matrix[33*8+:8]),.c(tmp[33*8+:8]));
	signedmul mult_u34(.clk(clk),.a(vector[34*8+:8]),.b(matrix[34*8+:8]),.c(tmp[34*8+:8]));
	signedmul mult_u35(.clk(clk),.a(vector[35*8+:8]),.b(matrix[35*8+:8]),.c(tmp[35*8+:8]));
	signedmul mult_u36(.clk(clk),.a(vector[36*8+:8]),.b(matrix[36*8+:8]),.c(tmp[36*8+:8]));
	signedmul mult_u37(.clk(clk),.a(vector[37*8+:8]),.b(matrix[37*8+:8]),.c(tmp[37*8+:8]));
	signedmul mult_u38(.clk(clk),.a(vector[38*8+:8]),.b(matrix[38*8+:8]),.c(tmp[38*8+:8]));
	signedmul mult_u39(.clk(clk),.a(vector[39*8+:8]),.b(matrix[39*8+:8]),.c(tmp[39*8+:8]));
	signedmul mult_u40(.clk(clk),.a(vector[40*8+:8]),.b(matrix[40*8+:8]),.c(tmp[40*8+:8]));
	signedmul mult_u41(.clk(clk),.a(vector[41*8+:8]),.b(matrix[41*8+:8]),.c(tmp[41*8+:8]));
	signedmul mult_u42(.clk(clk),.a(vector[42*8+:8]),.b(matrix[42*8+:8]),.c(tmp[42*8+:8]));
	signedmul mult_u43(.clk(clk),.a(vector[43*8+:8]),.b(matrix[43*8+:8]),.c(tmp[43*8+:8]));
	signedmul mult_u44(.clk(clk),.a(vector[44*8+:8]),.b(matrix[44*8+:8]),.c(tmp[44*8+:8]));
	signedmul mult_u45(.clk(clk),.a(vector[45*8+:8]),.b(matrix[45*8+:8]),.c(tmp[45*8+:8]));
	signedmul mult_u46(.clk(clk),.a(vector[46*8+:8]),.b(matrix[46*8+:8]),.c(tmp[46*8+:8]));
	signedmul mult_u47(.clk(clk),.a(vector[47*8+:8]),.b(matrix[47*8+:8]),.c(tmp[47*8+:8]));
	signedmul mult_u48(.clk(clk),.a(vector[48*8+:8]),.b(matrix[48*8+:8]),.c(tmp[48*8+:8]));
	signedmul mult_u49(.clk(clk),.a(vector[49*8+:8]),.b(matrix[49*8+:8]),.c(tmp[49*8+:8]));
	signedmul mult_u50(.clk(clk),.a(vector[50*8+:8]),.b(matrix[50*8+:8]),.c(tmp[50*8+:8]));
	signedmul mult_u51(.clk(clk),.a(vector[51*8+:8]),.b(matrix[51*8+:8]),.c(tmp[51*8+:8]));
	signedmul mult_u52(.clk(clk),.a(vector[52*8+:8]),.b(matrix[52*8+:8]),.c(tmp[52*8+:8]));
	signedmul mult_u53(.clk(clk),.a(vector[53*8+:8]),.b(matrix[53*8+:8]),.c(tmp[53*8+:8]));
	signedmul mult_u54(.clk(clk),.a(vector[54*8+:8]),.b(matrix[54*8+:8]),.c(tmp[54*8+:8]));
	signedmul mult_u55(.clk(clk),.a(vector[55*8+:8]),.b(matrix[55*8+:8]),.c(tmp[55*8+:8]));
	signedmul mult_u56(.clk(clk),.a(vector[56*8+:8]),.b(matrix[56*8+:8]),.c(tmp[56*8+:8]));
	signedmul mult_u57(.clk(clk),.a(vector[57*8+:8]),.b(matrix[57*8+:8]),.c(tmp[57*8+:8]));
	signedmul mult_u58(.clk(clk),.a(vector[58*8+:8]),.b(matrix[58*8+:8]),.c(tmp[58*8+:8]));
	signedmul mult_u59(.clk(clk),.a(vector[59*8+:8]),.b(matrix[59*8+:8]),.c(tmp[59*8+:8]));
	signedmul mult_u60(.clk(clk),.a(vector[60*8+:8]),.b(matrix[60*8+:8]),.c(tmp[60*8+:8]));
	signedmul mult_u61(.clk(clk),.a(vector[61*8+:8]),.b(matrix[61*8+:8]),.c(tmp[61*8+:8]));
	signedmul mult_u62(.clk(clk),.a(vector[62*8+:8]),.b(matrix[62*8+:8]),.c(tmp[62*8+:8]));
	signedmul mult_u63(.clk(clk),.a(vector[63*8+:8]),.b(matrix[63*8+:8]),.c(tmp[63*8+:8]));
	
endmodule                    




 
module vecmat_mul_x #(parameter varraysize=1600,vectwidth=100) //,matsize=64)   // varraysize=1024 vectwidth=64,matsize=4096
(
 input clk,reset,
 input [varraysize-1:0] data,
 input [varraysize-1:0] W,
 //output reg [15:0] data_out
 output [varraysize-1:0] tmp
 );

 
// wire overflow [vectwidth-1:0];  

 wire [15:0] matrix_output[vectwidth-1:0];  
 //wire [15:0] tmp[vectwidth-1:0];


 reg [varraysize-1:0] vector;
 reg [varraysize-1:0] matrix;

 
   
 always @(posedge clk) begin
	if(~reset) begin
		vector <= data;
		matrix <= W;			
       	                         
	   	///count <= count+1;
		//data_out <= tmp97;
	end   
 end      


 /*genvar j;
 generate
	 for(j=0;j<100;j=j+1) begin
   			signedmul mult_u0(.a(vector[j*8+:8]),.b(matrix[j*8+:8]),.c(tmp[j*8+:8]));
	 end
 endgenerate*/
 
 	 signedmul mult_u0(.clk(clk),.a(vector[0*8+:8]),.b(matrix[0*8+:8]),.c(tmp[0*8+:8]));
	signedmul mult_u1(.clk(clk),.a(vector[1*8+:8]),.b(matrix[1*8+:8]),.c(tmp[1*8+:8]));
	signedmul mult_u2(.clk(clk),.a(vector[2*8+:8]),.b(matrix[2*8+:8]),.c(tmp[2*8+:8]));
	signedmul mult_u3(.clk(clk),.a(vector[3*8+:8]),.b(matrix[3*8+:8]),.c(tmp[3*8+:8]));
	signedmul mult_u4(.clk(clk),.a(vector[4*8+:8]),.b(matrix[4*8+:8]),.c(tmp[4*8+:8]));
	signedmul mult_u5(.clk(clk),.a(vector[5*8+:8]),.b(matrix[5*8+:8]),.c(tmp[5*8+:8]));
	signedmul mult_u6(.clk(clk),.a(vector[6*8+:8]),.b(matrix[6*8+:8]),.c(tmp[6*8+:8]));
	signedmul mult_u7(.clk(clk),.a(vector[7*8+:8]),.b(matrix[7*8+:8]),.c(tmp[7*8+:8]));
	signedmul mult_u8(.clk(clk),.a(vector[8*8+:8]),.b(matrix[8*8+:8]),.c(tmp[8*8+:8]));
	signedmul mult_u9(.clk(clk),.a(vector[9*8+:8]),.b(matrix[9*8+:8]),.c(tmp[9*8+:8]));
	signedmul mult_u10(.clk(clk),.a(vector[10*8+:8]),.b(matrix[10*8+:8]),.c(tmp[10*8+:8]));
	signedmul mult_u11(.clk(clk),.a(vector[11*8+:8]),.b(matrix[11*8+:8]),.c(tmp[11*8+:8]));
	signedmul mult_u12(.clk(clk),.a(vector[12*8+:8]),.b(matrix[12*8+:8]),.c(tmp[12*8+:8]));
	signedmul mult_u13(.clk(clk),.a(vector[13*8+:8]),.b(matrix[13*8+:8]),.c(tmp[13*8+:8]));
	signedmul mult_u14(.clk(clk),.a(vector[14*8+:8]),.b(matrix[14*8+:8]),.c(tmp[14*8+:8]));
	signedmul mult_u15(.clk(clk),.a(vector[15*8+:8]),.b(matrix[15*8+:8]),.c(tmp[15*8+:8]));
	signedmul mult_u16(.clk(clk),.a(vector[16*8+:8]),.b(matrix[16*8+:8]),.c(tmp[16*8+:8]));
	signedmul mult_u17(.clk(clk),.a(vector[17*8+:8]),.b(matrix[17*8+:8]),.c(tmp[17*8+:8]));
	signedmul mult_u18(.clk(clk),.a(vector[18*8+:8]),.b(matrix[18*8+:8]),.c(tmp[18*8+:8]));
	signedmul mult_u19(.clk(clk),.a(vector[19*8+:8]),.b(matrix[19*8+:8]),.c(tmp[19*8+:8]));
	signedmul mult_u20(.clk(clk),.a(vector[20*8+:8]),.b(matrix[20*8+:8]),.c(tmp[20*8+:8]));
	signedmul mult_u21(.clk(clk),.a(vector[21*8+:8]),.b(matrix[21*8+:8]),.c(tmp[21*8+:8]));
	signedmul mult_u22(.clk(clk),.a(vector[22*8+:8]),.b(matrix[22*8+:8]),.c(tmp[22*8+:8]));
	signedmul mult_u23(.clk(clk),.a(vector[23*8+:8]),.b(matrix[23*8+:8]),.c(tmp[23*8+:8]));
	signedmul mult_u24(.clk(clk),.a(vector[24*8+:8]),.b(matrix[24*8+:8]),.c(tmp[24*8+:8]));
	signedmul mult_u25(.clk(clk),.a(vector[25*8+:8]),.b(matrix[25*8+:8]),.c(tmp[25*8+:8]));
	signedmul mult_u26(.clk(clk),.a(vector[26*8+:8]),.b(matrix[26*8+:8]),.c(tmp[26*8+:8]));
	signedmul mult_u27(.clk(clk),.a(vector[27*8+:8]),.b(matrix[27*8+:8]),.c(tmp[27*8+:8]));
	signedmul mult_u28(.clk(clk),.a(vector[28*8+:8]),.b(matrix[28*8+:8]),.c(tmp[28*8+:8]));
	signedmul mult_u29(.clk(clk),.a(vector[29*8+:8]),.b(matrix[29*8+:8]),.c(tmp[29*8+:8]));
	signedmul mult_u30(.clk(clk),.a(vector[30*8+:8]),.b(matrix[30*8+:8]),.c(tmp[30*8+:8]));
	signedmul mult_u31(.clk(clk),.a(vector[31*8+:8]),.b(matrix[31*8+:8]),.c(tmp[31*8+:8]));
	signedmul mult_u32(.clk(clk),.a(vector[32*8+:8]),.b(matrix[32*8+:8]),.c(tmp[32*8+:8]));
	signedmul mult_u33(.clk(clk),.a(vector[33*8+:8]),.b(matrix[33*8+:8]),.c(tmp[33*8+:8]));
	signedmul mult_u34(.clk(clk),.a(vector[34*8+:8]),.b(matrix[34*8+:8]),.c(tmp[34*8+:8]));
	signedmul mult_u35(.clk(clk),.a(vector[35*8+:8]),.b(matrix[35*8+:8]),.c(tmp[35*8+:8]));
	signedmul mult_u36(.clk(clk),.a(vector[36*8+:8]),.b(matrix[36*8+:8]),.c(tmp[36*8+:8]));
	signedmul mult_u37(.clk(clk),.a(vector[37*8+:8]),.b(matrix[37*8+:8]),.c(tmp[37*8+:8]));
	signedmul mult_u38(.clk(clk),.a(vector[38*8+:8]),.b(matrix[38*8+:8]),.c(tmp[38*8+:8]));
	signedmul mult_u39(.clk(clk),.a(vector[39*8+:8]),.b(matrix[39*8+:8]),.c(tmp[39*8+:8]));
	signedmul mult_u40(.clk(clk),.a(vector[40*8+:8]),.b(matrix[40*8+:8]),.c(tmp[40*8+:8]));
	signedmul mult_u41(.clk(clk),.a(vector[41*8+:8]),.b(matrix[41*8+:8]),.c(tmp[41*8+:8]));
	signedmul mult_u42(.clk(clk),.a(vector[42*8+:8]),.b(matrix[42*8+:8]),.c(tmp[42*8+:8]));
	signedmul mult_u43(.clk(clk),.a(vector[43*8+:8]),.b(matrix[43*8+:8]),.c(tmp[43*8+:8]));
	signedmul mult_u44(.clk(clk),.a(vector[44*8+:8]),.b(matrix[44*8+:8]),.c(tmp[44*8+:8]));
	signedmul mult_u45(.clk(clk),.a(vector[45*8+:8]),.b(matrix[45*8+:8]),.c(tmp[45*8+:8]));
	signedmul mult_u46(.clk(clk),.a(vector[46*8+:8]),.b(matrix[46*8+:8]),.c(tmp[46*8+:8]));
	signedmul mult_u47(.clk(clk),.a(vector[47*8+:8]),.b(matrix[47*8+:8]),.c(tmp[47*8+:8]));
	signedmul mult_u48(.clk(clk),.a(vector[48*8+:8]),.b(matrix[48*8+:8]),.c(tmp[48*8+:8]));
	signedmul mult_u49(.clk(clk),.a(vector[49*8+:8]),.b(matrix[49*8+:8]),.c(tmp[49*8+:8]));
	signedmul mult_u50(.clk(clk),.a(vector[50*8+:8]),.b(matrix[50*8+:8]),.c(tmp[50*8+:8]));
	signedmul mult_u51(.clk(clk),.a(vector[51*8+:8]),.b(matrix[51*8+:8]),.c(tmp[51*8+:8]));
	signedmul mult_u52(.clk(clk),.a(vector[52*8+:8]),.b(matrix[52*8+:8]),.c(tmp[52*8+:8]));
	signedmul mult_u53(.clk(clk),.a(vector[53*8+:8]),.b(matrix[53*8+:8]),.c(tmp[53*8+:8]));
	signedmul mult_u54(.clk(clk),.a(vector[54*8+:8]),.b(matrix[54*8+:8]),.c(tmp[54*8+:8]));
	signedmul mult_u55(.clk(clk),.a(vector[55*8+:8]),.b(matrix[55*8+:8]),.c(tmp[55*8+:8]));
	signedmul mult_u56(.clk(clk),.a(vector[56*8+:8]),.b(matrix[56*8+:8]),.c(tmp[56*8+:8]));
	signedmul mult_u57(.clk(clk),.a(vector[57*8+:8]),.b(matrix[57*8+:8]),.c(tmp[57*8+:8]));
	signedmul mult_u58(.clk(clk),.a(vector[58*8+:8]),.b(matrix[58*8+:8]),.c(tmp[58*8+:8]));
	signedmul mult_u59(.clk(clk),.a(vector[59*8+:8]),.b(matrix[59*8+:8]),.c(tmp[59*8+:8]));
	signedmul mult_u60(.clk(clk),.a(vector[60*8+:8]),.b(matrix[60*8+:8]),.c(tmp[60*8+:8]));
	signedmul mult_u61(.clk(clk),.a(vector[61*8+:8]),.b(matrix[61*8+:8]),.c(tmp[61*8+:8]));
	signedmul mult_u62(.clk(clk),.a(vector[62*8+:8]),.b(matrix[62*8+:8]),.c(tmp[62*8+:8]));
	signedmul mult_u63(.clk(clk),.a(vector[63*8+:8]),.b(matrix[63*8+:8]),.c(tmp[63*8+:8]));
	signedmul mult_u64(.clk(clk),.a(vector[64*8+:8]),.b(matrix[64*8+:8]),.c(tmp[64*8+:8]));
	signedmul mult_u65(.clk(clk),.a(vector[65*8+:8]),.b(matrix[65*8+:8]),.c(tmp[65*8+:8]));
	signedmul mult_u66(.clk(clk),.a(vector[66*8+:8]),.b(matrix[66*8+:8]),.c(tmp[66*8+:8]));
	signedmul mult_u67(.clk(clk),.a(vector[67*8+:8]),.b(matrix[67*8+:8]),.c(tmp[67*8+:8]));
	signedmul mult_u68(.clk(clk),.a(vector[68*8+:8]),.b(matrix[68*8+:8]),.c(tmp[68*8+:8]));
	signedmul mult_u69(.clk(clk),.a(vector[69*8+:8]),.b(matrix[69*8+:8]),.c(tmp[69*8+:8]));
	signedmul mult_u70(.clk(clk),.a(vector[70*8+:8]),.b(matrix[70*8+:8]),.c(tmp[70*8+:8]));
	signedmul mult_u71(.clk(clk),.a(vector[71*8+:8]),.b(matrix[71*8+:8]),.c(tmp[71*8+:8]));
	signedmul mult_u72(.clk(clk),.a(vector[72*8+:8]),.b(matrix[72*8+:8]),.c(tmp[72*8+:8]));
	signedmul mult_u73(.clk(clk),.a(vector[73*8+:8]),.b(matrix[73*8+:8]),.c(tmp[73*8+:8]));
	signedmul mult_u74(.clk(clk),.a(vector[74*8+:8]),.b(matrix[74*8+:8]),.c(tmp[74*8+:8]));
	signedmul mult_u75(.clk(clk),.a(vector[75*8+:8]),.b(matrix[75*8+:8]),.c(tmp[75*8+:8]));
	signedmul mult_u76(.clk(clk),.a(vector[76*8+:8]),.b(matrix[76*8+:8]),.c(tmp[76*8+:8]));
	signedmul mult_u77(.clk(clk),.a(vector[77*8+:8]),.b(matrix[77*8+:8]),.c(tmp[77*8+:8]));
	signedmul mult_u78(.clk(clk),.a(vector[78*8+:8]),.b(matrix[78*8+:8]),.c(tmp[78*8+:8]));
	signedmul mult_u79(.clk(clk),.a(vector[79*8+:8]),.b(matrix[79*8+:8]),.c(tmp[79*8+:8]));
	signedmul mult_u80(.clk(clk),.a(vector[80*8+:8]),.b(matrix[80*8+:8]),.c(tmp[80*8+:8]));
	signedmul mult_u81(.clk(clk),.a(vector[81*8+:8]),.b(matrix[81*8+:8]),.c(tmp[81*8+:8]));
	signedmul mult_u82(.clk(clk),.a(vector[82*8+:8]),.b(matrix[82*8+:8]),.c(tmp[82*8+:8]));
	signedmul mult_u83(.clk(clk),.a(vector[83*8+:8]),.b(matrix[83*8+:8]),.c(tmp[83*8+:8]));
	signedmul mult_u84(.clk(clk),.a(vector[84*8+:8]),.b(matrix[84*8+:8]),.c(tmp[84*8+:8]));
	signedmul mult_u85(.clk(clk),.a(vector[85*8+:8]),.b(matrix[85*8+:8]),.c(tmp[85*8+:8]));
	signedmul mult_u86(.clk(clk),.a(vector[86*8+:8]),.b(matrix[86*8+:8]),.c(tmp[86*8+:8]));
	signedmul mult_u87(.clk(clk),.a(vector[87*8+:8]),.b(matrix[87*8+:8]),.c(tmp[87*8+:8]));
	signedmul mult_u88(.clk(clk),.a(vector[88*8+:8]),.b(matrix[88*8+:8]),.c(tmp[88*8+:8]));
	signedmul mult_u89(.clk(clk),.a(vector[89*8+:8]),.b(matrix[89*8+:8]),.c(tmp[89*8+:8]));
	signedmul mult_u90(.clk(clk),.a(vector[90*8+:8]),.b(matrix[90*8+:8]),.c(tmp[90*8+:8]));
	signedmul mult_u91(.clk(clk),.a(vector[91*8+:8]),.b(matrix[91*8+:8]),.c(tmp[91*8+:8]));
	signedmul mult_u92(.clk(clk),.a(vector[92*8+:8]),.b(matrix[92*8+:8]),.c(tmp[92*8+:8]));
	signedmul mult_u93(.clk(clk),.a(vector[93*8+:8]),.b(matrix[93*8+:8]),.c(tmp[93*8+:8]));
	signedmul mult_u94(.clk(clk),.a(vector[94*8+:8]),.b(matrix[94*8+:8]),.c(tmp[94*8+:8]));
	signedmul mult_u95(.clk(clk),.a(vector[95*8+:8]),.b(matrix[95*8+:8]),.c(tmp[95*8+:8]));
	signedmul mult_u96(.clk(clk),.a(vector[96*8+:8]),.b(matrix[96*8+:8]),.c(tmp[96*8+:8]));
	signedmul mult_u97(.clk(clk),.a(vector[97*8+:8]),.b(matrix[97*8+:8]),.c(tmp[97*8+:8]));
	signedmul mult_u98(.clk(clk),.a(vector[98*8+:8]),.b(matrix[98*8+:8]),.c(tmp[98*8+:8]));
	signedmul mult_u99(.clk(clk),.a(vector[99*8+:8]),.b(matrix[99*8+:8]),.c(tmp[99*8+:8]));
	
 endmodule

module signedmul(
  input clk,
  input [7:0] a,
  input [7:0] b,
  output [7:0] c
);

wire [16:0] result;
wire [7:0] a_new;
wire [7:0] b_new;

reg [7:0] a_ff;
reg [7:0] b_ff;
reg [15:0] result_ff;
reg a_sign,b_sign,a_sign_ff,b_sign_ff;

assign c = (b_sign_ff==a_sign_ff)?result_ff[13:6]:(~result_ff[13:6]+1'b1);
assign a_new = a[7]?(~a + 1'b1):a;
assign b_new = b[7]?(~b + 1'b1):b;
assign result = a_ff*b_ff;

always@(posedge clk) begin
	a_ff <= a_new;
	b_ff <= b_new; 

	a_sign <= a[7];
	b_sign <= b[7];
	a_sign_ff <= a_sign;
	b_sign_ff <= b_sign;
    result_ff <= result;
    
end


endmodule



module qadd2(
 input [7:0] a,
 input [7:0] b,
 output [7:0] c
    );
    
assign c = a + b;


endmodule


module sigmoid(
input [7:0] x,
output [15:0] sig_out
);


wire [15:0] myx;

reg [15:0] lut;
reg [5:0] address;

assign sig_out = lut;

assign myx=x;

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


always@(myx)
begin
 
    case({myx[15:12]})
	4'b1000:address = 6'd48; 
	4'b1001:address = 6'd48; 
	4'b1010:address = 6'd48; 
	4'b1011:address = 6'd48; 
	4'b1100:address = 6'd48;  
        4'b1101:if((myx[11:0] >= 12'h000) && (myx[11:0] <= 12'h333)) // -3
                    begin
                       address = 6'd8;                 
                    end 
                else if((myx[11:0] > 12'h333) && (myx[11:0] <= 12'h666))
                    begin
                        address = 6'd9;
                    end
                 else if((myx[11:0] > 12'h666) && (myx[11:0] <= 12'h99a))
                    begin
                        address = 6'd10;                                        
                    end
                 else if((myx[11:0] > 12'h99a) && (myx[11:0] <= 12'hccd))
                    begin
                        address =  6'd11;                                                          
                    end
                 else if(myx[11:0] > 12'hccd)
                    begin
                        address =  6'd12;                                    
                    end   
        4'b1110:if((myx[11:0] >= 12'h000) && (myx[11:0] <= 12'h333)) // -2
                    begin
                        address =  6'd13;              
                    end 
                else if((myx[11:0] > 12'h333) && (myx[11:0] <= 12'h666))
                    begin
                        address =  6'd14;                
                    end
                 else if((myx[11:0] > 12'h666) && (myx[11:0] <= 12'h99a))
                    begin
                        address = 6'd15;                                                         
                    end
                 else if((myx[11:0] > 12'h99a) && (myx[11:0] <= 12'hccd))
                    begin
                        address =  6'd16;                                                                           
                    end
                 else if(myx[11:0] > 12'hccd)
                    begin
                        address =  6'd17;                                                        
                    end 
        4'b1111:if((myx[11:0] >= 12'h000) && (myx[11:0] <= 12'h333))  // -1
                    begin
                        address =  6'd18;                
                    end 
                else if((myx[11:0] > 12'h333) && (myx[11:0] <= 12'h666))
                    begin
                        address =  6'd19;                                    
                    end
                 else if((myx[11:0] > 12'h666) && (myx[11:0] <= 12'h99a))
                    begin
                        address =  6'd20;                                                                         
                    end
                 else if((myx[11:0] > 12'h99a) && (myx[11:0] <= 12'hccd))
                    begin
                        address =  6'd21;                                                                                                
                    end
                 else if(myx[11:0] > 12'hccd)
                    begin
                        address =  6'd22;                                                                            
                    end 
        4'b0000:if((myx[11:0] >= 12'h000) && (myx[11:0] <= 12'h333)) // 0
                    begin
                        address =  6'd23;                
                    end 
                else if((myx[11:0] > 12'h333) && (myx[11:0] <= 12'h666))
                    begin
                        address =  6'd24;                
                    end
                 else if((myx[11:0] > 12'h666) && (myx[11:0] <= 12'h99a))
                    begin
                        address =  6'd25;                                                        
                    end
                 else if((myx[11:0] > 12'h99a) && (myx[11:0] <= 12'hccd))
                    begin
                        address =  6'd26;                                                                            
                    end
                 else if(myx[11:0] > 12'hccd)
                    begin
                        address =  6'd27;                                                        
                    end 
        4'b0001:if((myx[11:0] >= 12'h000) && (myx[11:0] <= 12'h333)) // 1
                    begin
                        address =  6'd28;                
                    end 
                else if((myx[11:0] > 12'h333) && (myx[11:0] <= 12'h666))
                    begin
                        address =  6'd29;                
                    end
                else if((myx[11:0] > 12'h666) && (myx[11:0] <= 12'h99a))
                    begin
                        address =  6'd30;                                                        
                    end
                else if((myx[11:0] > 12'h99a) && (myx[11:0] <= 12'hccd))
                    begin
                        address =  6'd31;                                                                            
                    end
                else if(myx[11:0] > 12'hccd)
                    begin
                       address =  6'd32;                                                         
                    end 
        4'b0010:if((myx[11:0] >= 12'h000) && (myx[11:0] <= 12'h333))  // 2
                    begin
                      address =  6'd33;                  
                    end 
                else if((myx[11:0] > 12'h333) && (myx[11:0] <= 12'h666))
                    begin
                      address =  6'd34;                   
                    end
                 else if((myx[11:0] > 12'h666) && (myx[11:0] <= 12'h99a))
                    begin
                       address =  6'd35;                                                          
                    end
                 else if((myx[11:0] > 12'h99a) && (myx[11:0] <= 12'hccd))
                    begin
                       address =  6'd36;                                                                               
                    end
                 else if(myx[11:0] > 12'hccd)
                    begin
                       address =  6'd37;                                                          
                    end 
        4'b0011:if((myx[11:0] >= 12'h000) && (myx[11:0] <= 12'h333)) // 3
                    begin
                       address =  6'd38;                  
                    end 
                else if((myx[11:0] > 12'h333) && (myx[11:0] <= 12'h666))
                    begin
                      address =  6'd39;                  
                    end
                else if((myx[11:0] > 12'h666) && (myx[11:0] <= 12'h99a))
                    begin
                      address =  6'd40;                                                          
                    end
                else if((myx[11:0] > 12'h99a) && (myx[11:0] <= 12'hccd))
                    begin
                      address = 6'd41;                                                                              
                    end
               else if(myx[11:0] > 12'hccd)
                    begin
                       address = 6'd42;                                                        
                    end 
	4'b0100:address = 6'd49;  
	4'b0101:address = 6'd49;  
	4'b0110:address = 6'd49;  
	4'b0111:address = 6'd49;  
       /* 4'b0100:if((myx[11:0] >= 12'h000) && (myx[11:0] <= 12'h333)) //4
                    begin
                      address = lut[43];                 
                    end 
                else if((myx[11:0] > 12'h333) && (myx[11:0] <= 12'h666))
                    begin
                       address = lut[44];                 
                    end
                else if((myx[11:0] > 12'h666) && (myx[11:0] <= 12'h99a))
                    begin
                       address = lut[45];                                                   
                    end
                else if(myx[11:0] > 12'h99a) 
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


assign x_comp = x[15]? {1'b0,~(myx[14:0])}+1'b1:x; // first take 2's complement if x is negative
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
    /*if(myx[15] == 1'b1)
        begin
            x_comp = {1'b0,~(myx[14:0])}+1'b1;
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

