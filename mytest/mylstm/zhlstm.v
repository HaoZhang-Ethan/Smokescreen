//////////////////////////////////////////////////////////////////////////////
// Author: Zolid Hoge 8 bit base function
// Author: Aishwarya Rajen
//////////////////////////////////////////////////////////////////////////////
`define ARRAY_DEPTH 64      //Number of Hidden neurons
`define INPUT_DEPTH 100	    //LSTM input vector dimensions
`define DATA_WIDTH 8		//8 bit representation
`define INWEIGHT_DEPTH 6400 //100x64
`define HWEIGHT_DEPTH 4096  //64x64
`define varraysize 800   //100x8
`define uarraysize 512  //64x8
`define PIM_cyc 26      //cycles of PIM



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
wire [63:0] Ui_pimdata_out;
reg [3:0] Ui_add_pim;


reg [63:0] Uf_pimdata_in;
wire [63:0] Uf_pimdata_out;
reg [3:0] Uf_add_pim;


reg [63:0] Uo_pimdata_in;
wire [63:0] Uo_pimdata_out;
reg [3:0] Uo_add_pim;


reg [63:0] Uc_pimdata_in;
wire [63:0] Uc_pimdata_out;
reg [3:0] Uc_add_pim;


reg [63:0] Wi_pimdata_in;
wire [63:0] Wi_pimdata_out;
reg [3:0] Wi_add_pim;


reg [63:0] Wf_pimdata_in;
wire [63:0] Wf_pimdata_out;
reg [3:0] Wf_add_pim;


reg [63:0] Wo_pimdata_in;
wire [63:0] Wo_pimdata_out;
reg [3:0] Wo_add_pim;


reg [63:0] Wc_pimdata_in;
wire [63:0] Wc_pimdata_out;
reg [3:0] Wc_add_pim;

reg [3:0] pim_read_X;
reg [2:0] pim_read_H;

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

single_port_ram Ui_PIM(.addr(Ui_add_pim),.we(wren_a),.data(Ui_pimdata_in),.out(Ui_pimdata_out),.clk(clk));
single_port_ram Uf_PIM(.addr(Uf_add_pim),.we(wren_a),.data(Uf_pimdata_in),.out(Uf_pimdata_out),.clk(clk));
single_port_ram Uo_PIM(.addr(Uo_add_pim),.we(wren_a),.data(Uo_pimdata_in),.out(Uo_pimdata_out),.clk(clk));
single_port_ram Uc_PIM(.addr(Uc_add_pim),.we(wren_a),.data(Uc_pimdata_in),.out(Uc_pimdata_out),.clk(clk));
single_port_ram Wi_PIM(.addr(Wi_add_pim),.we(wren_a),.data(Wi_pimdata_in),.out(Wi_pimdata_out),.clk(clk));
single_port_ram Wf_PIM(.addr(Wf_add_pim),.we(wren_a),.data(Wf_pimdata_in),.out(Wf_pimdata_out),.clk(clk));
single_port_ram Wo_PIM(.addr(Wo_add_pim),.we(wren_a),.data(Wo_pimdata_in),.out(Wo_pimdata_out),.clk(clk));
single_port_ram Wc_PIM(.addr(Wc_add_pim),.we(wren_a),.data(Wc_pimdata_in),.out(Wc_pimdata_out),.clk(clk));


//BRAM of the input vectors to LSTM
spram_v Xi_mem(.clk(clk),.address_a(inaddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(x_in));

//BRAM storing Bias of each gate
spram_b bi_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bi_in));
spram_b bf_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bf_in));
spram_b bo_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bo_in));
spram_b bc_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bc_in));


always @(posedge clk) begin

//Pipeline Registers
//----------- Zolid --------------------
		mac_fx_reg <= mulout_fx;
		mac_fh_reg <= mulout_fh;
// ------------------------------------
		add_f_reg <= add_f;
		addb_f_reg <= addbias_f; 
		sig_fo_reg <= sig_fo;
		elmul_fo_reg <= elmul_fo; //check if need to delay to wait for elmul_co

//----------- Zolid ---------------------
		mac_ix_reg <= mulout_ix;
		mac_ih_reg <= mulout_ih;
// ------------------------------------
		add_i_reg <= add_i;
		addb_i_reg <= addbias_i; 
		sig_io_reg <= sig_io;

//----------- Zolid ---------------------		
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
       pim_read_X <= 0;
	   //dummy ports initialize
	   dummyin_u <= 0; 
	   dummyin_v <=0;
	   dummyin_b <= 0;
 
  end
  else begin
	
	if(h_count == `PIM_cyc-1) begin
		cycle_complete <= 1; 
		waddr <= 0;
		count <=0;
		b_count <= 0;
		ct_count <=0;
		c_count <= 0;
        pim_read_X <= 0;
		pim_read_H <= 0;

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
    
        if(count>6)     //delay before bias add
			pim_read_X <= pim_read_X + 1;
			pim_read_H <= pim_read_H + 1;
            case(pim_read_X)
            0: begin Ui_pimdata_in <= x_in[64*0+:64] ; Uf_pimdata_in <= x_in[64*0+:64] ; Uo_pimdata_in <= x_in[64*0+:64] ;Uc_pimdata_in <= x_in[64*0+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1; end
			1: begin Ui_pimdata_in <= x_in[64*1+:64] ; Uf_pimdata_in <= x_in[64*1+:64] ; Uo_pimdata_in <= x_in[64*1+:64] ;Uc_pimdata_in <= x_in[64*1+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1; end
			2: begin Ui_pimdata_in <= x_in[64*2+:64] ; Uf_pimdata_in <= x_in[64*2+:64] ; Uo_pimdata_in <= x_in[64*2+:64] ;Uc_pimdata_in <= x_in[64*2+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1;  end
			3: begin Ui_pimdata_in <= x_in[64*3+:64] ; Uf_pimdata_in <= x_in[64*3+:64] ; Uo_pimdata_in <= x_in[64*3+:64] ;Uc_pimdata_in <= x_in[64*3+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1;  end
			4: begin Ui_pimdata_in <= x_in[64*4+:64] ; Uf_pimdata_in <= x_in[64*4+:64] ; Uo_pimdata_in <= x_in[64*4+:64] ;Uc_pimdata_in <= x_in[64*4+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1;  end
			5: begin Ui_pimdata_in <= x_in[64*5+:64] ; Uf_pimdata_in <= x_in[64*5+:64] ; Uo_pimdata_in <= x_in[64*5+:64] ;Uc_pimdata_in <= x_in[64*5+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1;  end
			6: begin Ui_pimdata_in <= x_in[64*6+:64] ; Uf_pimdata_in <= x_in[64*6+:64] ; Uo_pimdata_in <= x_in[64*6+:64] ;Uc_pimdata_in <= x_in[64*6+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1;  end
			7: begin Ui_pimdata_in <= x_in[64*7+:64] ; Uf_pimdata_in <= x_in[64*7+:64] ; Uo_pimdata_in <= x_in[64*7+:64] ;Uc_pimdata_in <= x_in[64*7+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1;  end
			8: begin Ui_pimdata_in <= x_in[64*8+:64] ; Uf_pimdata_in <= x_in[64*8+:64] ; Uo_pimdata_in <= x_in[64*8+:64] ;Uc_pimdata_in <= x_in[64*8+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1;  end
			9: begin Ui_pimdata_in <= x_in[64*9+:64] ; Uf_pimdata_in <= x_in[64*9+:64] ; Uo_pimdata_in <= x_in[64*9+:64] ;Uc_pimdata_in <= x_in[64*9+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1;  end
			10: begin Ui_pimdata_in <= x_in[64*10+:64]; Uf_pimdata_in <= x_in[64*10+:64] ; Uo_pimdata_in <= x_in[64*10+:64] ;Uc_pimdata_in <= x_in[64*10+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1;  end
			11: begin Ui_pimdata_in <= x_in[64*11+:64]; Uf_pimdata_in <= x_in[64*11+:64] ; Uo_pimdata_in <= x_in[64*11+:64] ;Uc_pimdata_in <= x_in[64*11+:64] ; Ui_add_pim <=  Ui_add_pim +1; Uf_add_pim <=  Uf_add_pim +1; Uo_add_pim <=  Uo_add_pim +1; Uc_add_pim <=  Uc_add_pim +1;  end
			12: begin Ui_pimdata_in <= x_in[64*12+:31]; Uf_pimdata_in <= x_in[64*12+:31] ; Uo_pimdata_in <= x_in[64*12+:31] ;Uc_pimdata_in <= x_in[64*12+:31] ;  end
            default : begin Ui_pimdata_in <= 0; Uf_pimdata_in <= 0 ; Uo_pimdata_in <= 0 ;Uc_pimdata_in <= 0 ; end
			endcase	

			case(pim_read_H)
            0: begin Wi_pimdata_in <= h_in[64*0+:64] ; Wf_pimdata_in <= h_in[64*0+:64] ; Wo_pimdata_in <= h_in[64*0+:64] ;Wc_pimdata_in <= h_in[64*0+:64] ; Wi_add_pim <=  Wi_add_pim +1; Wf_add_pim <=  Wf_add_pim +1; Wo_add_pim <=  Wo_add_pim +1; Wc_add_pim <=  Wc_add_pim +1;  end
			1: begin Wi_pimdata_in <= h_in[64*1+:64] ; Wf_pimdata_in <= h_in[64*1+:64] ; Wo_pimdata_in <= h_in[64*1+:64] ;Wc_pimdata_in <= h_in[64*1+:64] ; Wi_add_pim <=  Wi_add_pim +1; Wf_add_pim <=  Wf_add_pim +1; Wo_add_pim <=  Wo_add_pim +1; Wc_add_pim <=  Wc_add_pim +1;  end
			2: begin Wi_pimdata_in <= h_in[64*2+:64] ; Wf_pimdata_in <= h_in[64*2+:64] ; Wo_pimdata_in <= h_in[64*2+:64] ;Wc_pimdata_in <= h_in[64*2+:64] ; Wi_add_pim <=  Wi_add_pim +1; Wf_add_pim <=  Wf_add_pim +1; Wo_add_pim <=  Wo_add_pim +1; Wc_add_pim <=  Wc_add_pim +1;  end
			3: begin Wi_pimdata_in <= h_in[64*3+:64] ; Wf_pimdata_in <= h_in[64*3+:64] ; Wo_pimdata_in <= h_in[64*3+:64] ;Wc_pimdata_in <= h_in[64*3+:64] ; Wi_add_pim <=  Wi_add_pim +1; Wf_add_pim <=  Wf_add_pim +1; Wo_add_pim <=  Wo_add_pim +1; Wc_add_pim <=  Wc_add_pim +1;  end
			4: begin Wi_pimdata_in <= h_in[64*4+:64] ; Wf_pimdata_in <= h_in[64*4+:64] ; Wo_pimdata_in <= h_in[64*4+:64] ;Wc_pimdata_in <= h_in[64*4+:64] ; Wi_add_pim <=  Wi_add_pim +1; Wf_add_pim <=  Wf_add_pim +1; Wo_add_pim <=  Wo_add_pim +1; Wc_add_pim <=  Wc_add_pim +1;  end
			5: begin Wi_pimdata_in <= h_in[64*5+:64] ; Wf_pimdata_in <= h_in[64*5+:64] ; Wo_pimdata_in <= h_in[64*5+:64] ;Wc_pimdata_in <= h_in[64*5+:64] ; Wi_add_pim <=  Wi_add_pim +1; Wf_add_pim <=  Wf_add_pim +1; Wo_add_pim <=  Wo_add_pim +1; Wc_add_pim <=  Wc_add_pim +1;  end
			6: begin Wi_pimdata_in <= h_in[64*6+:64] ; Wf_pimdata_in <= h_in[64*6+:64] ; Wo_pimdata_in <= h_in[64*6+:64] ;Wc_pimdata_in <= h_in[64*6+:64] ; Wi_add_pim <=  Wi_add_pim +1; Wf_add_pim <=  Wf_add_pim +1; Wo_add_pim <=  Wo_add_pim +1; Wc_add_pim <=  Wc_add_pim +1;  end
			7: begin Wi_pimdata_in <= h_in[64*7+:64] ; Wf_pimdata_in <= h_in[64*7+:64] ; Wo_pimdata_in <= h_in[64*7+:64] ;Wc_pimdata_in <= h_in[64*7+:64] ; end
            default : begin Wi_pimdata_in <= 0; Wf_pimdata_in <= 0 ; Wo_pimdata_in <= 0 ;Wc_pimdata_in <= 0 ; end
			endcase	
		
		if(count>7)     //delay before bias add
			b_count <= b_count+1; 

			//FORGET GATE
			qadd2 f_gate_add(.a(mac_fx_reg),.b(mac_fh_reg),.c(add_f));
			qadd2 f_gate_biasadd(.a(bf_in),.b(add_f),.c(addbias_f));
			sigmoid sigf(addb_f_reg,sig_fo);
			//qmult #(12,16) f_elmul(.i_multiplicand(sig_fo_reg),.i_multiplier(C_in),.o_result(elmul_fo),.ovr(overflow0));
			signedmul f_elmul(.clk(clk),.a(sig_fo_reg),.b(C_in),.c(elmul_fo));

			//INPUT GATE
			qadd2 i_gate_add(.a(mac_ix_reg),.b(mac_ih_reg),.c(add_i));
			qadd2 i_gate_biasadd(.a(bi_in),.b(add_i),.c(addbias_i));
			sigmoid sigi(addb_i_reg,sig_io);

			//OUTPUT GATE
			qadd2 o_gate_add(.a(mac_ox_reg),.b(mac_oh_reg),.c(add_o));
			qadd2 o_gate_biasadd(.a(bo_in),.b(add_o),.c(addbias_o));
			sigmoid sigo(addb_o_reg,sig_oo);

			//CELL STATE GATE
			qadd2 c_gate_add(.a(mac_cx_reg),.b(mac_ch_reg),.c(add_c));
			qadd2 c_gate_biasadd(.a(bc_in),.b(add_c),.c(addbias_c)); 
			tanh tan_c1(addb_c_reg,tan_c);
			//qmult #(12,16) c_elmul(.i_multiplicand(tan_c_reg),.i_multiplier(sig_io_reg),.o_result(elmul_co),.ovr(overflow0));
			signedmul c_elmul(.clk(clk),.a(tan_c_reg),.b(sig_io_reg),.c(elmul_co));	  
			qadd2 cf_gate_add(.a(elmul_co_reg),.b(elmul_fo_reg),.c(add_cf));
			tanh tan_c2(add_cf_reg,tan_h);
			//qmult #(12,16) h_elmul(.i_multiplicand(tan_h_reg),.i_multiplier(sig_oo_d3),.o_result(ht),.ovr(overflow0));
			signedmul h_elmul(.clk(clk),.a(tan_h_reg),.b(sig_oo_d5),.c(ht));


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
