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

wire [63:0] Ui_pimdata_in;
wire [63:0] Ui_pimdata_out;
reg [3:0] Ui_add_pim;


wire [63:0] Uf_pimdata_in;
wire [63:0] Uf_pimdata_out;
reg [3:0] Uf_add_pim;


wire [63:0] Uo_pimdata_in;
wire [63:0] Uo_pimdata_out;
reg [3:0] Uo_add_pim;


wire [63:0] Uc_pimdata_in;
wire [63:0] Uc_pimdata_out;
reg [3:0] Uc_add_pim;


wire [63:0] Wi_pimdata_in;
wire [63:0] Wi_pimdata_out;
reg [3:0] Wi_add_pim;


wire [63:0] Wf_pimdata_in;
wire [63:0] Wf_pimdata_out;
reg [3:0] Wf_add_pim;


wire [63:0] Wo_pimdata_in;
wire [63:0] Wo_pimdata_out;
reg [3:0] Wo_add_pim;


wire [63:0] Wc_pimdata_in;
wire [63:0] Wc_pimdata_out;
reg [3:0] Wc_add_pim;

reg [3:0] pim_read_X;
reg [2:0] pim_read_H;

//keeping an additional bit so that the counters don't get reset to 0 automatically after 63 
//and start repeating access to elements prematurely
reg [6:0] inaddr; 
reg [6:0] waddr;
reg wren_a;
reg wren_a_0;
reg wren_a_1;
reg wren_a_2;
reg wren_a_3;
reg wren_a_4;
reg wren_a_5;
reg wren_a_6;
reg wren_a_7;
reg [6:0] c_count;
reg [6:0] b_count;
reg [6:0] ct_count;
reg [6:0] count;
reg [6:0] i,j;
reg [5:0] h_count;

wire [63:0] ht;
reg [`uarraysize-1:0] ht_prev;
reg [`uarraysize-1:0] Ct;
wire [63:0] add_cf;

reg wren_a_ct, wren_b_cin;

reg [15:0] tmp;

assign ht_out = ht;


//indicates that the ht_out output is valid 
assign ht_valid = (count>16)?1:0;


//BRAMs storing the input and hidden weights of each of the gates
//Hidden weights are represented by U and Input weights by W

single_port_ram Ui_PIM(.addr(Ui_add_pim),.we(wren_a_0),.data(Ui_pimdata_in),.out(Ui_pimdata_out),.clk(clk));
single_port_ram Uf_PIM(.addr(Uf_add_pim),.we(wren_a_1),.data(Uf_pimdata_in),.out(Uf_pimdata_out),.clk(clk));
single_port_ram Uo_PIM(.addr(Uo_add_pim),.we(wren_a_2),.data(Uo_pimdata_in),.out(Uo_pimdata_out),.clk(clk));
single_port_ram Uc_PIM(.addr(Uc_add_pim),.we(wren_a_3),.data(Uc_pimdata_in),.out(Uc_pimdata_out),.clk(clk));
single_port_ram Wi_PIM(.addr(Wi_add_pim),.we(wren_a_4),.data(Wi_pimdata_in),.out(Wi_pimdata_out),.clk(clk));
single_port_ram Wf_PIM(.addr(Wf_add_pim),.we(wren_a_5),.data(Wf_pimdata_in),.out(Wf_pimdata_out),.clk(clk));
single_port_ram Wo_PIM(.addr(Wo_add_pim),.we(wren_a_6),.data(Wo_pimdata_in),.out(Wo_pimdata_out),.clk(clk));
single_port_ram Wc_PIM(.addr(Wc_add_pim),.we(wren_a_7),.data(Wc_pimdata_in),.out(Wc_pimdata_out),.clk(clk));
lstm_top mylstm_0(.clk(clk),.mac_fx_reg(Wf_pimdata_out[7:0]),.mac_fh_reg(Uf_pimdata_out[7:0]),.mac_ox_reg(Wo_pimdata_out[7:0]),.mac_oh_reg(Uo_pimdata_out[7:0]),.mac_ix_reg(Wi_pimdata_out[7:0]),.mac_ih_reg(Ui_pimdata_out[7:0]),.mac_cx_reg(Wc_pimdata_out[7:0]),.mac_ch_reg(Uc_pimdata_out[7:0]),.bi_in(bi_in),.bf_in(bf_in),.bo_in(bo_in),.bc_in(bc_in),.C_in(C_in[7:0]),.ht_out(ht[7:0]),.add_cf(add_cf[7:0]));
lstm_top mylstm_1(.clk(clk),.mac_fx_reg(Wf_pimdata_out[15:8]),.mac_fh_reg(Uf_pimdata_out[15:8]),.mac_ox_reg(Wo_pimdata_out[15:8]),.mac_oh_reg(Uo_pimdata_out[15:8]),.mac_ix_reg(Wi_pimdata_out[15:8]),.mac_ih_reg(Ui_pimdata_out[15:8]),.mac_cx_reg(Wc_pimdata_out[15:8]),.mac_ch_reg(Uc_pimdata_out[15:8]),.bi_in(bi_in),.bf_in(bf_in),.bo_in(bo_in),.bc_in(bc_in),.C_in(C_in[15:8]),.ht_out(ht[15:8]),.add_cf(add_cf[15:8]));
lstm_top mylstm_2(.clk(clk),.mac_fx_reg(Wf_pimdata_out[23:16]),.mac_fh_reg(Uf_pimdata_out[23:16]),.mac_ox_reg(Wo_pimdata_out[23:16]),.mac_oh_reg(Uo_pimdata_out[23:16]),.mac_ix_reg(Wi_pimdata_out[23:16]),.mac_ih_reg(Ui_pimdata_out[23:16]),.mac_cx_reg(Wc_pimdata_out[23:16]),.mac_ch_reg(Uc_pimdata_out[23:16]),.bi_in(bi_in),.bf_in(bf_in),.bo_in(bo_in),.bc_in(bc_in),.C_in(C_in[23:16]),.ht_out(ht[23:16]),.add_cf(add_cf[23:16]));
lstm_top mylstm_3(.clk(clk),.mac_fx_reg(Wf_pimdata_out[31:24]),.mac_fh_reg(Uf_pimdata_out[31:24]),.mac_ox_reg(Wo_pimdata_out[31:24]),.mac_oh_reg(Uo_pimdata_out[31:24]),.mac_ix_reg(Wi_pimdata_out[31:24]),.mac_ih_reg(Ui_pimdata_out[31:24]),.mac_cx_reg(Wc_pimdata_out[31:24]),.mac_ch_reg(Uc_pimdata_out[31:24]),.bi_in(bi_in),.bf_in(bf_in),.bo_in(bo_in),.bc_in(bc_in),.C_in(C_in[31:24]),.ht_out(ht[31:24]),.add_cf(add_cf[31:24]));
lstm_top mylstm_4(.clk(clk),.mac_fx_reg(Wf_pimdata_out[39:32]),.mac_fh_reg(Uf_pimdata_out[39:32]),.mac_ox_reg(Wo_pimdata_out[39:32]),.mac_oh_reg(Uo_pimdata_out[39:32]),.mac_ix_reg(Wi_pimdata_out[39:32]),.mac_ih_reg(Ui_pimdata_out[39:32]),.mac_cx_reg(Wc_pimdata_out[39:32]),.mac_ch_reg(Uc_pimdata_out[39:32]),.bi_in(bi_in),.bf_in(bf_in),.bo_in(bo_in),.bc_in(bc_in),.C_in(C_in[39:32]),.ht_out(ht[39:32]),.add_cf(add_cf[39:32]));
lstm_top mylstm_5(.clk(clk),.mac_fx_reg(Wf_pimdata_out[47:40]),.mac_fh_reg(Uf_pimdata_out[47:40]),.mac_ox_reg(Wo_pimdata_out[47:40]),.mac_oh_reg(Uo_pimdata_out[47:40]),.mac_ix_reg(Wi_pimdata_out[47:40]),.mac_ih_reg(Ui_pimdata_out[47:40]),.mac_cx_reg(Wc_pimdata_out[47:40]),.mac_ch_reg(Uc_pimdata_out[47:40]),.bi_in(bi_in),.bf_in(bf_in),.bo_in(bo_in),.bc_in(bc_in),.C_in(C_in[47:40]),.ht_out(ht[47:40]),.add_cf(add_cf[47:40]));
lstm_top mylstm_6(.clk(clk),.mac_fx_reg(Wf_pimdata_out[55:48]),.mac_fh_reg(Uf_pimdata_out[55:48]),.mac_ox_reg(Wo_pimdata_out[55:48]),.mac_oh_reg(Uo_pimdata_out[55:48]),.mac_ix_reg(Wi_pimdata_out[55:48]),.mac_ih_reg(Ui_pimdata_out[55:48]),.mac_cx_reg(Wc_pimdata_out[55:48]),.mac_ch_reg(Uc_pimdata_out[55:48]),.bi_in(bi_in),.bf_in(bf_in),.bo_in(bo_in),.bc_in(bc_in),.C_in(C_in[55:48]),.ht_out(ht[55:48]),.add_cf(add_cf[55:48]));
lstm_top mylstm_7(.clk(clk),.mac_fx_reg(Wf_pimdata_out[63:56]),.mac_fh_reg(Uf_pimdata_out[63:56]),.mac_ox_reg(Wo_pimdata_out[63:56]),.mac_oh_reg(Uo_pimdata_out[63:56]),.mac_ix_reg(Wi_pimdata_out[63:56]),.mac_ih_reg(Ui_pimdata_out[63:56]),.mac_cx_reg(Wc_pimdata_out[63:56]),.mac_ch_reg(Uc_pimdata_out[63:56]),.bi_in(bi_in),.bf_in(bf_in),.bo_in(bo_in),.bc_in(bc_in),.C_in(C_in[63:56]),.ht_out(ht[63:56]),.add_cf(add_cf[63:56]));




//BRAM of the input vectors to LSTM
spram_v Xi_mem(.clk(clk),.address_a(inaddr),.wren_a(wren_a),.data_a(dummyin_v),.out_a(x_in));

//BRAM storing Bias of each gate
spram_b bi_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bi_in));
spram_b bf_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bf_in));
spram_b bo_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bo_in));
spram_b bc_mem(.clk(clk),.address_a(b_count),.wren_a(wren_a),.data_a(dummyin_b),.out_a(bc_in));



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
       wren_a_0 <= 0;
       wren_a_1 <= 0;
       wren_a_2 <= 0;
       wren_a_3 <= 0;
       wren_a_4 <= 0;
       wren_a_5 <= 0;
       wren_a_6 <= 0;
       wren_a_7 <= 0;
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

            wren_a_0 <= 1;
            wren_a_1 <= 1;
            wren_a_2 <= 1;
            wren_a_3 <= 1;
            wren_a_4 <= 1;
            wren_a_5 <= 1;
            wren_a_6 <= 1;
            wren_a_7 <= 1;
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
            default : begin Ui_pimdata_in <= 0; Uf_pimdata_in <= 0 ; Uo_pimdata_in <= 0 ; Uc_pimdata_in <= 0 ; end
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

		if(count >8)  begin //delay before Cin elmul
			c_count <=c_count+1;
			case(c_count)
			0: C_in<=Ct[8*0+:64] ;
			1: C_in<=Ct[8*1+:64] ;
			2: C_in<=Ct[8*2+:64] ;
			3: C_in<=Ct[8*3+:64] ;
			4: C_in<=Ct[8*4+:64] ;
			5: C_in<=Ct[8*5+:64] ;
			6: C_in<=Ct[8*6+:64] ;
			7: C_in<=Ct[8*7+:64] ;
			default : C_in <= 0;
		endcase	
		end

		if(count >11) begin  //for storing output of Ct
			ct_count <= ct_count+1;
		 //storing cell state
			case(ct_count)
			0:	Ct[8*0+:64] <= add_cf;
			1:	Ct[8*1+:64] <= add_cf;
			2:	Ct[8*2+:64] <= add_cf;
			3:	Ct[8*3+:64] <= add_cf;
			4:	Ct[8*4+:64] <= add_cf;
			5:	Ct[8*5+:64] <= add_cf;
			6:	Ct[8*6+:64] <= add_cf;
			7:	Ct[8*7+:64] <= add_cf;
			default : Ct <= 0;
		 endcase
		end
		if(count >16) begin
			h_count <= h_count + 1;
			case(h_count)
			0:	ht_prev[8*0+:64] <= ht[8*0+:64];
			1:	ht_prev[8*1+:64] <= ht[8*1+:64];
			2:	ht_prev[8*2+:64] <= ht[8*2+:64];
			3:	ht_prev[8*3+:64] <= ht[8*3+:64];
			4:	ht_prev[8*4+:64] <= ht[8*4+:64];
			5:	ht_prev[8*5+:64] <= ht[8*5+:64];
			6:	ht_prev[8*6+:64] <= ht[8*6+:64];
			7:	ht_prev[8*7+:64] <= ht[8*7+:64];
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

module lstm_top(
input clk,
input [7:0] mac_fx_reg,
input [7:0] mac_fh_reg,
input [7:0] mac_ox_reg,
input [7:0] mac_oh_reg,
input [7:0] mac_ix_reg,
input [7:0] mac_ih_reg,
input [7:0] mac_cx_reg,
input [7:0] mac_ch_reg,
input [`DATA_WIDTH-1:0] bi_in,
input [`DATA_WIDTH-1:0] bf_in,
input [`DATA_WIDTH-1:0] bo_in,
input [`DATA_WIDTH-1:0] bc_in,
input [`DATA_WIDTH-1:0] C_in,
output  [7:0] ht_out,
output [`DATA_WIDTH-1:0] add_cf);



wire [`DATA_WIDTH-1:0] add_i;

wire [`DATA_WIDTH-1:0] add_f;

wire [`DATA_WIDTH-1:0] add_c;

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


assign ht_out = ht[7:0] + ht[15:8];

reg [15:0] add_f_reg,addb_f_reg,sig_fo_reg;
reg [15:0] add_i_reg,addb_i_reg,sig_io_reg;
reg [15:0] add_o_reg,addb_o_reg,sig_oo_reg;
reg [15:0] add_c_reg,addb_c_reg,sig_co_reg;
reg [15:0] tan_c_reg,elmul_co_reg,add_cf_reg,tan_h_reg,elmul_fo_reg;


reg [15:0] sig_oo_d1,sig_oo_d2,sig_oo_d3,sig_oo_d4,sig_oo_d5;

always @(posedge clk) begin

//Pipeline Registers

		addb_f_reg <= addbias_f; 
		sig_fo_reg <= sig_fo;
		elmul_fo_reg <= elmul_fo; //check if need to delay to wait for elmul_co


		add_i_reg <= add_i;
		addb_i_reg <= addbias_i; 
		sig_io_reg <= sig_io;
		

		add_o_reg <= add_o;
		addb_o_reg <= addbias_o; 
		sig_oo_reg <= sig_oo;   


		sig_oo_d1 <= sig_oo_reg; //delaying sig_oo by 5 cycles to feed to c gate
		sig_oo_d2 <= sig_oo_d1;
		sig_oo_d3 <= sig_oo_d2;
	    sig_oo_d4 <= sig_oo_d3;
		sig_oo_d5 <= sig_oo_d4;


		add_c_reg <= add_c;
		addb_c_reg <= addbias_c; 
		tan_c_reg <= tan_c;
		elmul_co_reg <= elmul_co;
		add_cf_reg <= add_cf;
		tan_h_reg <= tan_h; 

end


qadd2 f_gate_add(.a(mac_fx_reg),.b(mac_fh_reg),.c(add_f));
qadd2 f_gate_biasadd(.a(bf_in),.b(add_f),.c(addbias_f));
sigmoid sigf(addb_f_reg,sig_fo);
//qmult #(12,16) f_elmul(.i_multiplicand(sig_fo_reg),.i_multiplier(C_in),.o_result(elmul_fo),.ovr(overflow0));
signedmul f_elmul(.clk(clk),.a(sig_fo_reg),.b(C_in),.c(elmul_fo));

qadd2 o_gate_add(.a(mac_ox_reg),.b(mac_oh_reg),.c(add_o));
qadd2 o_gate_biasadd(.a(bo_in),.b(add_o),.c(addbias_o));
sigmoid sigo(addb_o_reg,sig_oo);

qadd2 i_gate_add(.a(mac_ix_reg),.b(mac_ih_reg),.c(add_i));
qadd2 i_gate_biasadd(.a(bi_in),.b(add_i),.c(addbias_i));
sigmoid sigi(addb_i_reg,sig_io);


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

