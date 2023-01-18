`define varraysize 1600   //100x16
`define Size_H 100   
`define Size_W 100   
`define DATA_WIDTH 16
`define INPUT_DEPTH 16
`define ADD_BIT_MAT 7
`define ADD_BIT_VEC 1

module top(
input clk,
input reset,
input [`ADD_BIT_MAT-1:0] start_addr_matrix,   //start address of the Xin bram (input words to LSTM)
input [`ADD_BIT_MAT-1:0] end_addr_matrix,	  //end address of the Xin bram 
input [`ADD_BIT_VEC-1:0] start_addr_vector,   //start address of the Xin bram (input words to LSTM)
input [`ADD_BIT_VEC-1:0] end_addr_vector,	  //end address of the Xin bram   
output [`DATA_WIDTH-1:0] ht_out, //output ht from the lstm
output reg Done
);


reg [6:0] waddr, inaddr;
reg wren_a, inren_a;
wire [`varraysize-1:0] mulout_fx;
wire [`varraysize-1:0] Wi_in;
wire [`varraysize-1:0] x_in;
assign ht_out = macout_fx;
//BRAMs storing the input and hidden weights of each of the gates
spram_v Wi_mem(.clk(clk),.address_a(waddr),.wren_a(wren_a),.data_a(dummyin_u),.out_a(Wi_in));
//BRAM of the input vectors to LSTM
spram_v Xi_mem(.clk(clk),.address_a(inaddr),.wren_a(inren_a),.data_a(dummyin_v),.out_a(x_in));
vecmat_mul_x #(`varraysize,`INPUT_DEPTH) f_gatex(.clk(clk),.reset(rst),.data(x_in),.W(Wi_in),.tmp(mulout_fx));
vecmat_add_x #(`varraysize,`INPUT_DEPTH) f_gateaddx(.clk(clk),.reset(rst),.mulout(mulout_fx),.data_out(macout_fx));




always @(posedge clk) begin
	if(reset == 1'b1) begin      
		waddr <= start_addr_matrix;
		inaddr <= start_addr_vector;
		wren_a <= 1'b0;
		inren_a <= 1'b0;
		Done <= 1'b0;
	end
	else if (start==1'b0) begin 
			if(inaddr == end_addr_vector) begin
				inaddr <= 1'b0;
				waddr <= 1'b0;
			end
			else if(waddr == end_addr_matrix) begin
				Done = 1'b1;
				inaddr = inaddr + 1'b1;
				waddr <= 1'b0;
			end else begin
				Done = 1'b0;
				waddr = waddr + 1'b1;
			end
			
	end
end

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
   			signedmul mult_u0(.a(vector[j*16+:16]),.b(matrix[j*16+:16]),.c(tmp[j*16+:16]));
	 end
 endgenerate*/
 
 	 signedmul mult_u0(.clk(clk),.a(vector[0*16+:16]),.b(matrix[0*16+:16]),.c(tmp[0*16+:16]));
	signedmul mult_u1(.clk(clk),.a(vector[1*16+:16]),.b(matrix[1*16+:16]),.c(tmp[1*16+:16]));
	signedmul mult_u2(.clk(clk),.a(vector[2*16+:16]),.b(matrix[2*16+:16]),.c(tmp[2*16+:16]));
	signedmul mult_u3(.clk(clk),.a(vector[3*16+:16]),.b(matrix[3*16+:16]),.c(tmp[3*16+:16]));
	signedmul mult_u4(.clk(clk),.a(vector[4*16+:16]),.b(matrix[4*16+:16]),.c(tmp[4*16+:16]));
	signedmul mult_u5(.clk(clk),.a(vector[5*16+:16]),.b(matrix[5*16+:16]),.c(tmp[5*16+:16]));
	signedmul mult_u6(.clk(clk),.a(vector[6*16+:16]),.b(matrix[6*16+:16]),.c(tmp[6*16+:16]));
	signedmul mult_u7(.clk(clk),.a(vector[7*16+:16]),.b(matrix[7*16+:16]),.c(tmp[7*16+:16]));
	signedmul mult_u8(.clk(clk),.a(vector[8*16+:16]),.b(matrix[8*16+:16]),.c(tmp[8*16+:16]));
	signedmul mult_u9(.clk(clk),.a(vector[9*16+:16]),.b(matrix[9*16+:16]),.c(tmp[9*16+:16]));
	signedmul mult_u10(.clk(clk),.a(vector[10*16+:16]),.b(matrix[10*16+:16]),.c(tmp[10*16+:16]));
	signedmul mult_u11(.clk(clk),.a(vector[11*16+:16]),.b(matrix[11*16+:16]),.c(tmp[11*16+:16]));
	signedmul mult_u12(.clk(clk),.a(vector[12*16+:16]),.b(matrix[12*16+:16]),.c(tmp[12*16+:16]));
	signedmul mult_u13(.clk(clk),.a(vector[13*16+:16]),.b(matrix[13*16+:16]),.c(tmp[13*16+:16]));
	signedmul mult_u14(.clk(clk),.a(vector[14*16+:16]),.b(matrix[14*16+:16]),.c(tmp[14*16+:16]));
	signedmul mult_u15(.clk(clk),.a(vector[15*16+:16]),.b(matrix[15*16+:16]),.c(tmp[15*16+:16]));
	signedmul mult_u16(.clk(clk),.a(vector[16*16+:16]),.b(matrix[16*16+:16]),.c(tmp[16*16+:16]));
	signedmul mult_u17(.clk(clk),.a(vector[17*16+:16]),.b(matrix[17*16+:16]),.c(tmp[17*16+:16]));
	signedmul mult_u18(.clk(clk),.a(vector[18*16+:16]),.b(matrix[18*16+:16]),.c(tmp[18*16+:16]));
	signedmul mult_u19(.clk(clk),.a(vector[19*16+:16]),.b(matrix[19*16+:16]),.c(tmp[19*16+:16]));
	signedmul mult_u20(.clk(clk),.a(vector[20*16+:16]),.b(matrix[20*16+:16]),.c(tmp[20*16+:16]));
	signedmul mult_u21(.clk(clk),.a(vector[21*16+:16]),.b(matrix[21*16+:16]),.c(tmp[21*16+:16]));
	signedmul mult_u22(.clk(clk),.a(vector[22*16+:16]),.b(matrix[22*16+:16]),.c(tmp[22*16+:16]));
	signedmul mult_u23(.clk(clk),.a(vector[23*16+:16]),.b(matrix[23*16+:16]),.c(tmp[23*16+:16]));
	signedmul mult_u24(.clk(clk),.a(vector[24*16+:16]),.b(matrix[24*16+:16]),.c(tmp[24*16+:16]));
	signedmul mult_u25(.clk(clk),.a(vector[25*16+:16]),.b(matrix[25*16+:16]),.c(tmp[25*16+:16]));
	signedmul mult_u26(.clk(clk),.a(vector[26*16+:16]),.b(matrix[26*16+:16]),.c(tmp[26*16+:16]));
	signedmul mult_u27(.clk(clk),.a(vector[27*16+:16]),.b(matrix[27*16+:16]),.c(tmp[27*16+:16]));
	signedmul mult_u28(.clk(clk),.a(vector[28*16+:16]),.b(matrix[28*16+:16]),.c(tmp[28*16+:16]));
	signedmul mult_u29(.clk(clk),.a(vector[29*16+:16]),.b(matrix[29*16+:16]),.c(tmp[29*16+:16]));
	signedmul mult_u30(.clk(clk),.a(vector[30*16+:16]),.b(matrix[30*16+:16]),.c(tmp[30*16+:16]));
	signedmul mult_u31(.clk(clk),.a(vector[31*16+:16]),.b(matrix[31*16+:16]),.c(tmp[31*16+:16]));
	signedmul mult_u32(.clk(clk),.a(vector[32*16+:16]),.b(matrix[32*16+:16]),.c(tmp[32*16+:16]));
	signedmul mult_u33(.clk(clk),.a(vector[33*16+:16]),.b(matrix[33*16+:16]),.c(tmp[33*16+:16]));
	signedmul mult_u34(.clk(clk),.a(vector[34*16+:16]),.b(matrix[34*16+:16]),.c(tmp[34*16+:16]));
	signedmul mult_u35(.clk(clk),.a(vector[35*16+:16]),.b(matrix[35*16+:16]),.c(tmp[35*16+:16]));
	signedmul mult_u36(.clk(clk),.a(vector[36*16+:16]),.b(matrix[36*16+:16]),.c(tmp[36*16+:16]));
	signedmul mult_u37(.clk(clk),.a(vector[37*16+:16]),.b(matrix[37*16+:16]),.c(tmp[37*16+:16]));
	signedmul mult_u38(.clk(clk),.a(vector[38*16+:16]),.b(matrix[38*16+:16]),.c(tmp[38*16+:16]));
	signedmul mult_u39(.clk(clk),.a(vector[39*16+:16]),.b(matrix[39*16+:16]),.c(tmp[39*16+:16]));
	signedmul mult_u40(.clk(clk),.a(vector[40*16+:16]),.b(matrix[40*16+:16]),.c(tmp[40*16+:16]));
	signedmul mult_u41(.clk(clk),.a(vector[41*16+:16]),.b(matrix[41*16+:16]),.c(tmp[41*16+:16]));
	signedmul mult_u42(.clk(clk),.a(vector[42*16+:16]),.b(matrix[42*16+:16]),.c(tmp[42*16+:16]));
	signedmul mult_u43(.clk(clk),.a(vector[43*16+:16]),.b(matrix[43*16+:16]),.c(tmp[43*16+:16]));
	signedmul mult_u44(.clk(clk),.a(vector[44*16+:16]),.b(matrix[44*16+:16]),.c(tmp[44*16+:16]));
	signedmul mult_u45(.clk(clk),.a(vector[45*16+:16]),.b(matrix[45*16+:16]),.c(tmp[45*16+:16]));
	signedmul mult_u46(.clk(clk),.a(vector[46*16+:16]),.b(matrix[46*16+:16]),.c(tmp[46*16+:16]));
	signedmul mult_u47(.clk(clk),.a(vector[47*16+:16]),.b(matrix[47*16+:16]),.c(tmp[47*16+:16]));
	signedmul mult_u48(.clk(clk),.a(vector[48*16+:16]),.b(matrix[48*16+:16]),.c(tmp[48*16+:16]));
	signedmul mult_u49(.clk(clk),.a(vector[49*16+:16]),.b(matrix[49*16+:16]),.c(tmp[49*16+:16]));
	signedmul mult_u50(.clk(clk),.a(vector[50*16+:16]),.b(matrix[50*16+:16]),.c(tmp[50*16+:16]));
	signedmul mult_u51(.clk(clk),.a(vector[51*16+:16]),.b(matrix[51*16+:16]),.c(tmp[51*16+:16]));
	signedmul mult_u52(.clk(clk),.a(vector[52*16+:16]),.b(matrix[52*16+:16]),.c(tmp[52*16+:16]));
	signedmul mult_u53(.clk(clk),.a(vector[53*16+:16]),.b(matrix[53*16+:16]),.c(tmp[53*16+:16]));
	signedmul mult_u54(.clk(clk),.a(vector[54*16+:16]),.b(matrix[54*16+:16]),.c(tmp[54*16+:16]));
	signedmul mult_u55(.clk(clk),.a(vector[55*16+:16]),.b(matrix[55*16+:16]),.c(tmp[55*16+:16]));
	signedmul mult_u56(.clk(clk),.a(vector[56*16+:16]),.b(matrix[56*16+:16]),.c(tmp[56*16+:16]));
	signedmul mult_u57(.clk(clk),.a(vector[57*16+:16]),.b(matrix[57*16+:16]),.c(tmp[57*16+:16]));
	signedmul mult_u58(.clk(clk),.a(vector[58*16+:16]),.b(matrix[58*16+:16]),.c(tmp[58*16+:16]));
	signedmul mult_u59(.clk(clk),.a(vector[59*16+:16]),.b(matrix[59*16+:16]),.c(tmp[59*16+:16]));
	signedmul mult_u60(.clk(clk),.a(vector[60*16+:16]),.b(matrix[60*16+:16]),.c(tmp[60*16+:16]));
	signedmul mult_u61(.clk(clk),.a(vector[61*16+:16]),.b(matrix[61*16+:16]),.c(tmp[61*16+:16]));
	signedmul mult_u62(.clk(clk),.a(vector[62*16+:16]),.b(matrix[62*16+:16]),.c(tmp[62*16+:16]));
	signedmul mult_u63(.clk(clk),.a(vector[63*16+:16]),.b(matrix[63*16+:16]),.c(tmp[63*16+:16]));
	signedmul mult_u64(.clk(clk),.a(vector[64*16+:16]),.b(matrix[64*16+:16]),.c(tmp[64*16+:16]));
	signedmul mult_u65(.clk(clk),.a(vector[65*16+:16]),.b(matrix[65*16+:16]),.c(tmp[65*16+:16]));
	signedmul mult_u66(.clk(clk),.a(vector[66*16+:16]),.b(matrix[66*16+:16]),.c(tmp[66*16+:16]));
	signedmul mult_u67(.clk(clk),.a(vector[67*16+:16]),.b(matrix[67*16+:16]),.c(tmp[67*16+:16]));
	signedmul mult_u68(.clk(clk),.a(vector[68*16+:16]),.b(matrix[68*16+:16]),.c(tmp[68*16+:16]));
	signedmul mult_u69(.clk(clk),.a(vector[69*16+:16]),.b(matrix[69*16+:16]),.c(tmp[69*16+:16]));
	signedmul mult_u70(.clk(clk),.a(vector[70*16+:16]),.b(matrix[70*16+:16]),.c(tmp[70*16+:16]));
	signedmul mult_u71(.clk(clk),.a(vector[71*16+:16]),.b(matrix[71*16+:16]),.c(tmp[71*16+:16]));
	signedmul mult_u72(.clk(clk),.a(vector[72*16+:16]),.b(matrix[72*16+:16]),.c(tmp[72*16+:16]));
	signedmul mult_u73(.clk(clk),.a(vector[73*16+:16]),.b(matrix[73*16+:16]),.c(tmp[73*16+:16]));
	signedmul mult_u74(.clk(clk),.a(vector[74*16+:16]),.b(matrix[74*16+:16]),.c(tmp[74*16+:16]));
	signedmul mult_u75(.clk(clk),.a(vector[75*16+:16]),.b(matrix[75*16+:16]),.c(tmp[75*16+:16]));
	signedmul mult_u76(.clk(clk),.a(vector[76*16+:16]),.b(matrix[76*16+:16]),.c(tmp[76*16+:16]));
	signedmul mult_u77(.clk(clk),.a(vector[77*16+:16]),.b(matrix[77*16+:16]),.c(tmp[77*16+:16]));
	signedmul mult_u78(.clk(clk),.a(vector[78*16+:16]),.b(matrix[78*16+:16]),.c(tmp[78*16+:16]));
	signedmul mult_u79(.clk(clk),.a(vector[79*16+:16]),.b(matrix[79*16+:16]),.c(tmp[79*16+:16]));
	signedmul mult_u80(.clk(clk),.a(vector[80*16+:16]),.b(matrix[80*16+:16]),.c(tmp[80*16+:16]));
	signedmul mult_u81(.clk(clk),.a(vector[81*16+:16]),.b(matrix[81*16+:16]),.c(tmp[81*16+:16]));
	signedmul mult_u82(.clk(clk),.a(vector[82*16+:16]),.b(matrix[82*16+:16]),.c(tmp[82*16+:16]));
	signedmul mult_u83(.clk(clk),.a(vector[83*16+:16]),.b(matrix[83*16+:16]),.c(tmp[83*16+:16]));
	signedmul mult_u84(.clk(clk),.a(vector[84*16+:16]),.b(matrix[84*16+:16]),.c(tmp[84*16+:16]));
	signedmul mult_u85(.clk(clk),.a(vector[85*16+:16]),.b(matrix[85*16+:16]),.c(tmp[85*16+:16]));
	signedmul mult_u86(.clk(clk),.a(vector[86*16+:16]),.b(matrix[86*16+:16]),.c(tmp[86*16+:16]));
	signedmul mult_u87(.clk(clk),.a(vector[87*16+:16]),.b(matrix[87*16+:16]),.c(tmp[87*16+:16]));
	signedmul mult_u88(.clk(clk),.a(vector[88*16+:16]),.b(matrix[88*16+:16]),.c(tmp[88*16+:16]));
	signedmul mult_u89(.clk(clk),.a(vector[89*16+:16]),.b(matrix[89*16+:16]),.c(tmp[89*16+:16]));
	signedmul mult_u90(.clk(clk),.a(vector[90*16+:16]),.b(matrix[90*16+:16]),.c(tmp[90*16+:16]));
	signedmul mult_u91(.clk(clk),.a(vector[91*16+:16]),.b(matrix[91*16+:16]),.c(tmp[91*16+:16]));
	signedmul mult_u92(.clk(clk),.a(vector[92*16+:16]),.b(matrix[92*16+:16]),.c(tmp[92*16+:16]));
	signedmul mult_u93(.clk(clk),.a(vector[93*16+:16]),.b(matrix[93*16+:16]),.c(tmp[93*16+:16]));
	signedmul mult_u94(.clk(clk),.a(vector[94*16+:16]),.b(matrix[94*16+:16]),.c(tmp[94*16+:16]));
	signedmul mult_u95(.clk(clk),.a(vector[95*16+:16]),.b(matrix[95*16+:16]),.c(tmp[95*16+:16]));
	signedmul mult_u96(.clk(clk),.a(vector[96*16+:16]),.b(matrix[96*16+:16]),.c(tmp[96*16+:16]));
	signedmul mult_u97(.clk(clk),.a(vector[97*16+:16]),.b(matrix[97*16+:16]),.c(tmp[97*16+:16]));
	signedmul mult_u98(.clk(clk),.a(vector[98*16+:16]),.b(matrix[98*16+:16]),.c(tmp[98*16+:16]));
	signedmul mult_u99(.clk(clk),.a(vector[99*16+:16]),.b(matrix[99*16+:16]),.c(tmp[99*16+:16]));
	
 endmodule

 module vecmat_add_x #(parameter varraysize=1600,vectwidth=100) 
 (
 input clk,reset,
 input [varraysize-1:0] mulout,
 output reg [15:0] data_out
 );
          
  wire [15:0] tmp0, tmp1 ,tmp2 ,tmp3 ,tmp4 ,tmp5 ,tmp6 ,tmp7 ,tmp8 ,tmp9 ,tmp10 ,tmp11 ,tmp12 ,tmp13 ,tmp14 ,tmp15 ,tmp16 ,tmp17 ,tmp18 ,tmp19 ,tmp20 ,tmp21 ,tmp22 ,tmp23 ,tmp24 ,tmp25 ,tmp26 ,tmp27 ,tmp28 ,tmp29 ,tmp30 ,tmp31 ,tmp32 ,tmp33 ,tmp34 ,tmp35 ,tmp36 ,tmp37 ,tmp38 ,tmp39 ,tmp40 ,tmp41 ,tmp42 ,tmp43 ,tmp44 ,tmp45 ,tmp46 ,tmp47 ,tmp48 ,tmp49 ,tmp50,tmp51 ,tmp52 ,tmp53,tmp54 ,tmp55 ,tmp56 ,tmp57 ,tmp58,tmp59 ,tmp60 ,tmp61 ,tmp62 ,tmp63 ,tmp64 ,tmp65 ; 
 wire [15:0] tmp66 ,tmp67 ,tmp68 ,tmp69 ,tmp70 ,tmp71 ,tmp72 ,tmp73 ,tmp74 ,tmp75 ,tmp76 ,tmp77 ,tmp78 ,tmp79 ,tmp80 ,tmp81 ,tmp82 ,tmp83 ,tmp84, tmp85 ,tmp86, tmp87,tmp88 ,tmp89 ,tmp90 ,tmp91 ,tmp92 ,tmp93 ,tmp94 ,tmp95, tmp96, tmp97, tmp98, tmp99;
 reg[31:0] i;

 reg [15:0] ff49,ff51,ff53,ff55,ff57,ff59,ff61,ff63,ff65,ff67,ff69,ff71,ff73;

 always @(posedge clk) begin
	if(~reset) begin	
		data_out <= tmp97;
	//adding a flop pipeline stage
		ff49 <= tmp49;
		ff51 <= tmp51;
		ff53 <= tmp53;
		ff55 <= tmp55;
		ff57 <= tmp57;	
		ff59 <= tmp59;
		ff61 <= tmp61;
		ff63 <= tmp63;
		ff65 <= tmp65;
		ff67 <= tmp67;
		ff69 <= tmp69;
		ff71 <= tmp71;
		ff73 <= tmp73;


	end   
 end     

		qadd2 Add_u0(.a(mulout[16*0+:16]),.b(mulout[16*1+:16]),.c(tmp0));
		qadd2 Add_u2(.a(mulout[16*2+:16]),.b(mulout[16*3+:16]),.c(tmp2));
		qadd2 Add_u4(.a(mulout[16*4+:16]),.b(mulout[16*5+:16]),.c(tmp4));
		qadd2 Add_u6(.a(mulout[16*6+:16]),.b(mulout[16*7+:16]),.c(tmp6));
		qadd2 Add_u8(.a(mulout[16*8+:16]),.b(mulout[16*9+:16]),.c(tmp8));
		qadd2 Add_u10(.a(mulout[16*10+:16]),.b(mulout[16*11+:16]),.c(tmp10));
		qadd2 Add_u12(.a(mulout[16*12+:16]),.b(mulout[16*13+:16]),.c(tmp12));
		qadd2 Add_u14(.a(mulout[16*14+:16]),.b(mulout[16*15+:16]),.c(tmp14));
		qadd2 Add_u16(.a(mulout[16*16+:16]),.b(mulout[16*17+:16]),.c(tmp16));
		qadd2 Add_u18(.a(mulout[16*18+:16]),.b(mulout[16*19+:16]),.c(tmp18));
		qadd2 Add_u20(.a(mulout[16*20+:16]),.b(mulout[16*21+:16]),.c(tmp20));
		qadd2 Add_u22(.a(mulout[16*22+:16]),.b(mulout[16*23+:16]),.c(tmp22));
		qadd2 Add_u24(.a(mulout[16*24+:16]),.b(mulout[16*25+:16]),.c(tmp24));
		qadd2 Add_u26(.a(mulout[16*26+:16]),.b(mulout[16*27+:16]),.c(tmp26));
		qadd2 Add_u28(.a(mulout[16*28+:16]),.b(mulout[16*29+:16]),.c(tmp28));
		qadd2 Add_u30(.a(mulout[16*30+:16]),.b(mulout[16*31+:16]),.c(tmp30));
		qadd2 Add_u32(.a(mulout[16*32+:16]),.b(mulout[16*33+:16]),.c(tmp32));
		qadd2 Add_u34(.a(mulout[16*34+:16]),.b(mulout[16*35+:16]),.c(tmp34));
		qadd2 Add_u36(.a(mulout[16*36+:16]),.b(mulout[16*37+:16]),.c(tmp36));
		qadd2 Add_u38(.a(mulout[16*38+:16]),.b(mulout[16*39+:16]),.c(tmp38));
		qadd2 Add_u40(.a(mulout[16*40+:16]),.b(mulout[16*41+:16]),.c(tmp40));
		qadd2 Add_u42(.a(mulout[16*42+:16]),.b(mulout[16*43+:16]),.c(tmp42));
		qadd2 Add_u44(.a(mulout[16*44+:16]),.b(mulout[16*45+:16]),.c(tmp44));
		qadd2 Add_u46(.a(mulout[16*46+:16]),.b(mulout[16*47+:16]),.c(tmp46));
		qadd2 Add_u48(.a(mulout[16*48+:16]),.b(mulout[16*49+:16]),.c(tmp48));
		qadd2 Add_u50(.a(mulout[16*50+:16]),.b(mulout[16*51+:16]),.c(tmp50));
		qadd2 Add_u52(.a(mulout[16*52+:16]),.b(mulout[16*53+:16]),.c(tmp52));
		qadd2 Add_u54(.a(mulout[16*54+:16]),.b(mulout[16*55+:16]),.c(tmp54));
		qadd2 Add_u56(.a(mulout[16*56+:16]),.b(mulout[16*57+:16]),.c(tmp56));
		qadd2 Add_u58(.a(mulout[16*58+:16]),.b(mulout[16*59+:16]),.c(tmp58));
		qadd2 Add_u60(.a(mulout[16*60+:16]),.b(mulout[16*61+:16]),.c(tmp60));
		qadd2 Add_u62(.a(mulout[16*62+:16]),.b(mulout[16*63+:16]),.c(tmp62));
		qadd2 Add_u64(.a(mulout[16*64+:16]),.b(mulout[16*65+:16]),.c(tmp64));
		qadd2 Add_u66(.a(mulout[16*66+:16]),.b(mulout[16*67+:16]),.c(tmp66));
		qadd2 Add_u68(.a(mulout[16*68+:16]),.b(mulout[16*69+:16]),.c(tmp68));
		qadd2 Add_u70(.a(mulout[16*70+:16]),.b(mulout[16*71+:16]),.c(tmp70));
		qadd2 Add_u72(.a(mulout[16*72+:16]),.b(mulout[16*73+:16]),.c(tmp72));
		qadd2 Add_u74(.a(mulout[16*74+:16]),.b(mulout[16*75+:16]),.c(tmp74));
		qadd2 Add_u76(.a(mulout[16*76+:16]),.b(mulout[16*77+:16]),.c(tmp76));
		qadd2 Add_u78(.a(mulout[16*78+:16]),.b(mulout[16*79+:16]),.c(tmp78));
		qadd2 Add_u80(.a(mulout[16*80+:16]),.b(mulout[16*81+:16]),.c(tmp80));
		qadd2 Add_u82(.a(mulout[16*82+:16]),.b(mulout[16*83+:16]),.c(tmp82));
		qadd2 Add_u84(.a(mulout[16*84+:16]),.b(mulout[16*85+:16]),.c(tmp84));
		qadd2 Add_u86(.a(mulout[16*86+:16]),.b(mulout[16*87+:16]),.c(tmp86));
		qadd2 Add_u88(.a(mulout[16*88+:16]),.b(mulout[16*89+:16]),.c(tmp88));
		qadd2 Add_u90(.a(mulout[16*90+:16]),.b(mulout[16*91+:16]),.c(tmp90));
		qadd2 Add_u92(.a(mulout[16*92+:16]),.b(mulout[16*93+:16]),.c(tmp92));
		qadd2 Add_u94(.a(mulout[16*94+:16]),.b(mulout[16*95+:16]),.c(tmp94));
		qadd2 Add_u96(.a(mulout[16*96+:16]),.b(mulout[16*97+:16]),.c(tmp96));
		qadd2 Add_u98(.a(mulout[16*98+:16]),.b(mulout[16*99+:16]),.c(tmp98));
		
		 
			qadd2 Add_u1(.a(tmp0),.b(tmp2),.c(tmp1));
			qadd2 Add_u3(.a(tmp4),.b(tmp6),.c(tmp3));
			qadd2 Add_u5(.a(tmp8),.b(tmp10),.c(tmp5));
			qadd2 Add_u7(.a(tmp12),.b(tmp14),.c(tmp7));
			qadd2 Add_u9(.a(tmp16),.b(tmp18),.c(tmp9));
			qadd2 Add_u11(.a(tmp20),.b(tmp22),.c(tmp11));
			qadd2 Add_u13(.a(tmp24),.b(tmp26),.c(tmp13));
			qadd2 Add_u15(.a(tmp28),.b(tmp30),.c(tmp15));
			qadd2 Add_u17(.a(tmp32),.b(tmp34),.c(tmp17));
			qadd2 Add_u19(.a(tmp36),.b(tmp38),.c(tmp19));
			qadd2 Add_u21(.a(tmp40),.b(tmp42),.c(tmp21));
			qadd2 Add_u23(.a(tmp44),.b(tmp46),.c(tmp23));
			qadd2 Add_u25(.a(tmp48),.b(tmp50),.c(tmp25));
			qadd2 Add_u27(.a(tmp52),.b(tmp54),.c(tmp27));
			qadd2 Add_u29(.a(tmp56),.b(tmp58),.c(tmp29));
			qadd2 Add_u31(.a(tmp60),.b(tmp62),.c(tmp31));
			qadd2 Add_u33(.a(tmp64),.b(tmp66),.c(tmp33));
			qadd2 Add_u35(.a(tmp68),.b(tmp70),.c(tmp35));
			qadd2 Add_u37(.a(tmp72),.b(tmp74),.c(tmp37));
			qadd2 Add_u39(.a(tmp76),.b(tmp78),.c(tmp39));
			qadd2 Add_u41(.a(tmp80),.b(tmp82),.c(tmp41));
			qadd2 Add_u43(.a(tmp84),.b(tmp86),.c(tmp43));
			qadd2 Add_u45(.a(tmp88),.b(tmp90),.c(tmp45));
			qadd2 Add_u47(.a(tmp92),.b(tmp94),.c(tmp47));
			qadd2 Add_u49(.a(tmp96),.b(tmp98),.c(tmp49));
						
			qadd2 Add_u51(.a(tmp1),.b(tmp3),.c(tmp51));
			qadd2 Add_u53(.a(tmp5),.b(tmp7),.c(tmp53));
			qadd2 Add_u55(.a(tmp9),.b(tmp11),.c(tmp55));
			qadd2 Add_u57(.a(tmp13),.b(tmp15),.c(tmp57));
			qadd2 Add_u59(.a(tmp17),.b(tmp19),.c(tmp59));
			qadd2 Add_u61(.a(tmp21),.b(tmp23),.c(tmp61));
			qadd2 Add_u63(.a(tmp25),.b(tmp27),.c(tmp63));
			qadd2 Add_u65(.a(tmp29),.b(tmp31),.c(tmp65));
			qadd2 Add_u67(.a(tmp33),.b(tmp35),.c(tmp67));
			qadd2 Add_u69(.a(tmp37),.b(tmp39),.c(tmp69));
			qadd2 Add_u71(.a(tmp41),.b(tmp43),.c(tmp71));
			qadd2 Add_u73(.a(tmp45),.b(tmp47),.c(tmp73));
			
			qadd2 Add_u75(.a(ff49),.b(ff51),.c(tmp75));
			qadd2 Add_u77(.a(ff53),.b(ff55),.c(tmp77));
			qadd2 Add_u79(.a(ff57),.b(ff59),.c(tmp79));
			qadd2 Add_u81(.a(ff61),.b(ff63),.c(tmp81));
			qadd2 Add_u83(.a(ff65),.b(ff67),.c(tmp83));
			qadd2 Add_u85(.a(ff69),.b(ff71),.c(tmp85));

			qadd2 Add_u87(.a(ff73),.b(tmp75),.c(tmp87));
			qadd2 Add_u89(.a(tmp77),.b(tmp79),.c(tmp89));
			qadd2 Add_u91(.a(tmp81),.b(tmp83),.c(tmp91));

			qadd2 Add_u93(.a(tmp85),.b(tmp87),.c(tmp93));
			qadd2 Add_u95(.a(tmp89),.b(tmp91),.c(tmp95));

			qadd2 Add_u97(.a(tmp93),.b(tmp95),.c(tmp97));
			
		
									
	   
endmodule

module signedmul(
  input clk,
  input [15:0] a,
  input [15:0] b,
  output [15:0] c
);

wire [31:0] result;
wire [15:0] a_new;
wire [15:0] b_new;

wire [15:0] a_ff;
wire [15:0] b_ff;
wire [31:0] result_ff;
wire a_sign,b_sign,a_sign_ff,b_sign_ff;

assign c = (b_sign_ff==a_sign_ff)?result_ff[26:12]:(~result_ff[26:12]+1'b1);
assign a_new = a[15]?(~a + 1'b1):a;
assign b_new = b[15]?(~b + 1'b1):b;
assign result = a_ff*b_ff;

// always@(posedge clk) begin
assign	a_ff = a_new;
assign	b_ff = b_new; 

assign	a_sign = a[15];
assign	b_sign = b[15];
assign	a_sign_ff = a_sign;
assign	b_sign_ff = b_sign;
assign    result_ff = result;
    
// end
endmodule


module qadd2(
 input [15:0] a,
 input [15:0] b,
 output [15:0] c
    );
    
assign c = a + b;


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