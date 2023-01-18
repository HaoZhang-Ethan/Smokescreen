`define varraysize 2048   //100x16
`define Size_H 100   
`define Size_W 100   
`define DATA_WIDTH 8
`define INPUT_DEPTH 8
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
 //output reg [8:0] data_out
 output [varraysize-1:0] tmp
 );

 
// wire overflow [vectwidth-1:0];  

 wire [8:0] matrix_output[vectwidth-1:0];  
 //wire [8:0] tmp[vectwidth-1:0];


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
	signedmul mult_u100(.clk(clk),.a(vector[100*8+:8]),.b(matrix[100*8+:8]),.c(tmp[100*8+:8]));
	signedmul mult_u101(.clk(clk),.a(vector[101*8+:8]),.b(matrix[101*8+:8]),.c(tmp[101*8+:8]));
	signedmul mult_u102(.clk(clk),.a(vector[102*8+:8]),.b(matrix[102*8+:8]),.c(tmp[102*8+:8]));
	signedmul mult_u103(.clk(clk),.a(vector[103*8+:8]),.b(matrix[103*8+:8]),.c(tmp[103*8+:8]));
	signedmul mult_u104(.clk(clk),.a(vector[104*8+:8]),.b(matrix[104*8+:8]),.c(tmp[104*8+:8]));
	signedmul mult_u105(.clk(clk),.a(vector[105*8+:8]),.b(matrix[105*8+:8]),.c(tmp[105*8+:8]));
	signedmul mult_u106(.clk(clk),.a(vector[106*8+:8]),.b(matrix[106*8+:8]),.c(tmp[106*8+:8]));
	signedmul mult_u107(.clk(clk),.a(vector[107*8+:8]),.b(matrix[107*8+:8]),.c(tmp[107*8+:8]));
	signedmul mult_u108(.clk(clk),.a(vector[108*8+:8]),.b(matrix[108*8+:8]),.c(tmp[108*8+:8]));
	signedmul mult_u109(.clk(clk),.a(vector[109*8+:8]),.b(matrix[109*8+:8]),.c(tmp[109*8+:8]));
	signedmul mult_u110(.clk(clk),.a(vector[110*8+:8]),.b(matrix[110*8+:8]),.c(tmp[110*8+:8]));
	signedmul mult_u111(.clk(clk),.a(vector[111*8+:8]),.b(matrix[111*8+:8]),.c(tmp[111*8+:8]));
	signedmul mult_u112(.clk(clk),.a(vector[112*8+:8]),.b(matrix[112*8+:8]),.c(tmp[112*8+:8]));
	signedmul mult_u113(.clk(clk),.a(vector[113*8+:8]),.b(matrix[113*8+:8]),.c(tmp[113*8+:8]));
	signedmul mult_u114(.clk(clk),.a(vector[114*8+:8]),.b(matrix[114*8+:8]),.c(tmp[114*8+:8]));
	signedmul mult_u115(.clk(clk),.a(vector[115*8+:8]),.b(matrix[115*8+:8]),.c(tmp[115*8+:8]));
	signedmul mult_u116(.clk(clk),.a(vector[116*8+:8]),.b(matrix[116*8+:8]),.c(tmp[116*8+:8]));
	signedmul mult_u117(.clk(clk),.a(vector[117*8+:8]),.b(matrix[117*8+:8]),.c(tmp[117*8+:8]));
	signedmul mult_u118(.clk(clk),.a(vector[118*8+:8]),.b(matrix[118*8+:8]),.c(tmp[118*8+:8]));
	signedmul mult_u119(.clk(clk),.a(vector[119*8+:8]),.b(matrix[119*8+:8]),.c(tmp[119*8+:8]));
	signedmul mult_u120(.clk(clk),.a(vector[120*8+:8]),.b(matrix[120*8+:8]),.c(tmp[120*8+:8]));
	signedmul mult_u121(.clk(clk),.a(vector[121*8+:8]),.b(matrix[121*8+:8]),.c(tmp[121*8+:8]));
	signedmul mult_u122(.clk(clk),.a(vector[122*8+:8]),.b(matrix[122*8+:8]),.c(tmp[122*8+:8]));
	signedmul mult_u123(.clk(clk),.a(vector[123*8+:8]),.b(matrix[123*8+:8]),.c(tmp[123*8+:8]));
	signedmul mult_u124(.clk(clk),.a(vector[124*8+:8]),.b(matrix[124*8+:8]),.c(tmp[124*8+:8]));
	signedmul mult_u125(.clk(clk),.a(vector[125*8+:8]),.b(matrix[125*8+:8]),.c(tmp[125*8+:8]));
	signedmul mult_u126(.clk(clk),.a(vector[126*8+:8]),.b(matrix[126*8+:8]),.c(tmp[126*8+:8]));
	signedmul mult_u127(.clk(clk),.a(vector[127*8+:8]),.b(matrix[127*8+:8]),.c(tmp[127*8+:8]));
	signedmul mult_u128(.clk(clk),.a(vector[128*8+:8]),.b(matrix[128*8+:8]),.c(tmp[128*8+:8]));
	signedmul mult_u129(.clk(clk),.a(vector[129*8+:8]),.b(matrix[129*8+:8]),.c(tmp[129*8+:8]));
	signedmul mult_u130(.clk(clk),.a(vector[130*8+:8]),.b(matrix[130*8+:8]),.c(tmp[130*8+:8]));
	signedmul mult_u131(.clk(clk),.a(vector[131*8+:8]),.b(matrix[131*8+:8]),.c(tmp[131*8+:8]));
	signedmul mult_u132(.clk(clk),.a(vector[132*8+:8]),.b(matrix[132*8+:8]),.c(tmp[132*8+:8]));
	signedmul mult_u133(.clk(clk),.a(vector[133*8+:8]),.b(matrix[133*8+:8]),.c(tmp[133*8+:8]));
	signedmul mult_u134(.clk(clk),.a(vector[134*8+:8]),.b(matrix[134*8+:8]),.c(tmp[134*8+:8]));
	signedmul mult_u135(.clk(clk),.a(vector[135*8+:8]),.b(matrix[135*8+:8]),.c(tmp[135*8+:8]));
	signedmul mult_u136(.clk(clk),.a(vector[136*8+:8]),.b(matrix[136*8+:8]),.c(tmp[136*8+:8]));
	signedmul mult_u137(.clk(clk),.a(vector[137*8+:8]),.b(matrix[137*8+:8]),.c(tmp[137*8+:8]));
	signedmul mult_u138(.clk(clk),.a(vector[138*8+:8]),.b(matrix[138*8+:8]),.c(tmp[138*8+:8]));
	signedmul mult_u139(.clk(clk),.a(vector[139*8+:8]),.b(matrix[139*8+:8]),.c(tmp[139*8+:8]));
	signedmul mult_u140(.clk(clk),.a(vector[140*8+:8]),.b(matrix[140*8+:8]),.c(tmp[140*8+:8]));
	signedmul mult_u141(.clk(clk),.a(vector[141*8+:8]),.b(matrix[141*8+:8]),.c(tmp[141*8+:8]));
	signedmul mult_u142(.clk(clk),.a(vector[142*8+:8]),.b(matrix[142*8+:8]),.c(tmp[142*8+:8]));
	signedmul mult_u143(.clk(clk),.a(vector[143*8+:8]),.b(matrix[143*8+:8]),.c(tmp[143*8+:8]));
	signedmul mult_u144(.clk(clk),.a(vector[144*8+:8]),.b(matrix[144*8+:8]),.c(tmp[144*8+:8]));
	signedmul mult_u145(.clk(clk),.a(vector[145*8+:8]),.b(matrix[145*8+:8]),.c(tmp[145*8+:8]));
	signedmul mult_u146(.clk(clk),.a(vector[146*8+:8]),.b(matrix[146*8+:8]),.c(tmp[146*8+:8]));
	signedmul mult_u147(.clk(clk),.a(vector[147*8+:8]),.b(matrix[147*8+:8]),.c(tmp[147*8+:8]));
	signedmul mult_u148(.clk(clk),.a(vector[148*8+:8]),.b(matrix[148*8+:8]),.c(tmp[148*8+:8]));
	signedmul mult_u149(.clk(clk),.a(vector[149*8+:8]),.b(matrix[149*8+:8]),.c(tmp[149*8+:8]));
	signedmul mult_u150(.clk(clk),.a(vector[150*8+:8]),.b(matrix[150*8+:8]),.c(tmp[150*8+:8]));
	signedmul mult_u151(.clk(clk),.a(vector[151*8+:8]),.b(matrix[151*8+:8]),.c(tmp[151*8+:8]));
	signedmul mult_u152(.clk(clk),.a(vector[152*8+:8]),.b(matrix[152*8+:8]),.c(tmp[152*8+:8]));
	signedmul mult_u153(.clk(clk),.a(vector[153*8+:8]),.b(matrix[153*8+:8]),.c(tmp[153*8+:8]));
	signedmul mult_u154(.clk(clk),.a(vector[154*8+:8]),.b(matrix[154*8+:8]),.c(tmp[154*8+:8]));
	signedmul mult_u155(.clk(clk),.a(vector[155*8+:8]),.b(matrix[155*8+:8]),.c(tmp[155*8+:8]));
	signedmul mult_u156(.clk(clk),.a(vector[156*8+:8]),.b(matrix[156*8+:8]),.c(tmp[156*8+:8]));
	signedmul mult_u157(.clk(clk),.a(vector[157*8+:8]),.b(matrix[157*8+:8]),.c(tmp[157*8+:8]));
	signedmul mult_u158(.clk(clk),.a(vector[158*8+:8]),.b(matrix[158*8+:8]),.c(tmp[158*8+:8]));
	signedmul mult_u159(.clk(clk),.a(vector[159*8+:8]),.b(matrix[159*8+:8]),.c(tmp[159*8+:8]));
	signedmul mult_u160(.clk(clk),.a(vector[160*8+:8]),.b(matrix[160*8+:8]),.c(tmp[160*8+:8]));
	signedmul mult_u161(.clk(clk),.a(vector[161*8+:8]),.b(matrix[161*8+:8]),.c(tmp[161*8+:8]));
	signedmul mult_u162(.clk(clk),.a(vector[162*8+:8]),.b(matrix[162*8+:8]),.c(tmp[162*8+:8]));
	signedmul mult_u163(.clk(clk),.a(vector[163*8+:8]),.b(matrix[163*8+:8]),.c(tmp[163*8+:8]));
	signedmul mult_u164(.clk(clk),.a(vector[164*8+:8]),.b(matrix[164*8+:8]),.c(tmp[164*8+:8]));
	signedmul mult_u165(.clk(clk),.a(vector[165*8+:8]),.b(matrix[165*8+:8]),.c(tmp[165*8+:8]));
	signedmul mult_u166(.clk(clk),.a(vector[166*8+:8]),.b(matrix[166*8+:8]),.c(tmp[166*8+:8]));
	signedmul mult_u167(.clk(clk),.a(vector[167*8+:8]),.b(matrix[167*8+:8]),.c(tmp[167*8+:8]));
	signedmul mult_u168(.clk(clk),.a(vector[168*8+:8]),.b(matrix[168*8+:8]),.c(tmp[168*8+:8]));
	signedmul mult_u169(.clk(clk),.a(vector[169*8+:8]),.b(matrix[169*8+:8]),.c(tmp[169*8+:8]));
	signedmul mult_u170(.clk(clk),.a(vector[170*8+:8]),.b(matrix[170*8+:8]),.c(tmp[170*8+:8]));
	signedmul mult_u171(.clk(clk),.a(vector[171*8+:8]),.b(matrix[171*8+:8]),.c(tmp[171*8+:8]));
	signedmul mult_u172(.clk(clk),.a(vector[172*8+:8]),.b(matrix[172*8+:8]),.c(tmp[172*8+:8]));
	signedmul mult_u173(.clk(clk),.a(vector[173*8+:8]),.b(matrix[173*8+:8]),.c(tmp[173*8+:8]));
	signedmul mult_u174(.clk(clk),.a(vector[174*8+:8]),.b(matrix[174*8+:8]),.c(tmp[174*8+:8]));
	signedmul mult_u175(.clk(clk),.a(vector[175*8+:8]),.b(matrix[175*8+:8]),.c(tmp[175*8+:8]));
	signedmul mult_u176(.clk(clk),.a(vector[176*8+:8]),.b(matrix[176*8+:8]),.c(tmp[176*8+:8]));
	signedmul mult_u177(.clk(clk),.a(vector[177*8+:8]),.b(matrix[177*8+:8]),.c(tmp[177*8+:8]));
	signedmul mult_u178(.clk(clk),.a(vector[178*8+:8]),.b(matrix[178*8+:8]),.c(tmp[178*8+:8]));
	signedmul mult_u179(.clk(clk),.a(vector[179*8+:8]),.b(matrix[179*8+:8]),.c(tmp[179*8+:8]));
	signedmul mult_u180(.clk(clk),.a(vector[180*8+:8]),.b(matrix[180*8+:8]),.c(tmp[180*8+:8]));
	signedmul mult_u181(.clk(clk),.a(vector[181*8+:8]),.b(matrix[181*8+:8]),.c(tmp[181*8+:8]));
	signedmul mult_u182(.clk(clk),.a(vector[182*8+:8]),.b(matrix[182*8+:8]),.c(tmp[182*8+:8]));
	signedmul mult_u183(.clk(clk),.a(vector[183*8+:8]),.b(matrix[183*8+:8]),.c(tmp[183*8+:8]));
	signedmul mult_u184(.clk(clk),.a(vector[184*8+:8]),.b(matrix[184*8+:8]),.c(tmp[184*8+:8]));
	signedmul mult_u185(.clk(clk),.a(vector[185*8+:8]),.b(matrix[185*8+:8]),.c(tmp[185*8+:8]));
	signedmul mult_u186(.clk(clk),.a(vector[186*8+:8]),.b(matrix[186*8+:8]),.c(tmp[186*8+:8]));
	signedmul mult_u187(.clk(clk),.a(vector[187*8+:8]),.b(matrix[187*8+:8]),.c(tmp[187*8+:8]));
	signedmul mult_u188(.clk(clk),.a(vector[188*8+:8]),.b(matrix[188*8+:8]),.c(tmp[188*8+:8]));
	signedmul mult_u189(.clk(clk),.a(vector[189*8+:8]),.b(matrix[189*8+:8]),.c(tmp[189*8+:8]));
	signedmul mult_u190(.clk(clk),.a(vector[190*8+:8]),.b(matrix[190*8+:8]),.c(tmp[190*8+:8]));
	signedmul mult_u191(.clk(clk),.a(vector[191*8+:8]),.b(matrix[191*8+:8]),.c(tmp[191*8+:8]));
	signedmul mult_u192(.clk(clk),.a(vector[192*8+:8]),.b(matrix[192*8+:8]),.c(tmp[192*8+:8]));
	signedmul mult_u193(.clk(clk),.a(vector[193*8+:8]),.b(matrix[193*8+:8]),.c(tmp[193*8+:8]));
	signedmul mult_u194(.clk(clk),.a(vector[194*8+:8]),.b(matrix[194*8+:8]),.c(tmp[194*8+:8]));
	signedmul mult_u195(.clk(clk),.a(vector[195*8+:8]),.b(matrix[195*8+:8]),.c(tmp[195*8+:8]));
	signedmul mult_u196(.clk(clk),.a(vector[196*8+:8]),.b(matrix[196*8+:8]),.c(tmp[196*8+:8]));
	signedmul mult_u197(.clk(clk),.a(vector[197*8+:8]),.b(matrix[197*8+:8]),.c(tmp[197*8+:8]));
	signedmul mult_u198(.clk(clk),.a(vector[198*8+:8]),.b(matrix[198*8+:8]),.c(tmp[198*8+:8]));
	signedmul mult_u199(.clk(clk),.a(vector[199*8+:8]),.b(matrix[199*8+:8]),.c(tmp[199*8+:8]));
	signedmul mult_u200(.clk(clk),.a(vector[200*8+:8]),.b(matrix[200*8+:8]),.c(tmp[200*8+:8]));
	signedmul mult_u201(.clk(clk),.a(vector[201*8+:8]),.b(matrix[201*8+:8]),.c(tmp[201*8+:8]));
	signedmul mult_u202(.clk(clk),.a(vector[202*8+:8]),.b(matrix[202*8+:8]),.c(tmp[202*8+:8]));
	signedmul mult_u203(.clk(clk),.a(vector[203*8+:8]),.b(matrix[203*8+:8]),.c(tmp[203*8+:8]));
	signedmul mult_u204(.clk(clk),.a(vector[204*8+:8]),.b(matrix[204*8+:8]),.c(tmp[204*8+:8]));
	signedmul mult_u205(.clk(clk),.a(vector[205*8+:8]),.b(matrix[205*8+:8]),.c(tmp[205*8+:8]));
	signedmul mult_u206(.clk(clk),.a(vector[206*8+:8]),.b(matrix[206*8+:8]),.c(tmp[206*8+:8]));
	signedmul mult_u207(.clk(clk),.a(vector[207*8+:8]),.b(matrix[207*8+:8]),.c(tmp[207*8+:8]));
	signedmul mult_u208(.clk(clk),.a(vector[208*8+:8]),.b(matrix[208*8+:8]),.c(tmp[208*8+:8]));
	signedmul mult_u209(.clk(clk),.a(vector[209*8+:8]),.b(matrix[209*8+:8]),.c(tmp[209*8+:8]));
	signedmul mult_u210(.clk(clk),.a(vector[210*8+:8]),.b(matrix[210*8+:8]),.c(tmp[210*8+:8]));
	signedmul mult_u211(.clk(clk),.a(vector[211*8+:8]),.b(matrix[211*8+:8]),.c(tmp[211*8+:8]));
	signedmul mult_u212(.clk(clk),.a(vector[212*8+:8]),.b(matrix[212*8+:8]),.c(tmp[212*8+:8]));
	signedmul mult_u213(.clk(clk),.a(vector[213*8+:8]),.b(matrix[213*8+:8]),.c(tmp[213*8+:8]));
	signedmul mult_u214(.clk(clk),.a(vector[214*8+:8]),.b(matrix[214*8+:8]),.c(tmp[214*8+:8]));
	signedmul mult_u215(.clk(clk),.a(vector[215*8+:8]),.b(matrix[215*8+:8]),.c(tmp[215*8+:8]));
	signedmul mult_u216(.clk(clk),.a(vector[216*8+:8]),.b(matrix[216*8+:8]),.c(tmp[216*8+:8]));
	signedmul mult_u217(.clk(clk),.a(vector[217*8+:8]),.b(matrix[217*8+:8]),.c(tmp[217*8+:8]));
	signedmul mult_u218(.clk(clk),.a(vector[218*8+:8]),.b(matrix[218*8+:8]),.c(tmp[218*8+:8]));
	signedmul mult_u219(.clk(clk),.a(vector[219*8+:8]),.b(matrix[219*8+:8]),.c(tmp[219*8+:8]));
	signedmul mult_u220(.clk(clk),.a(vector[220*8+:8]),.b(matrix[220*8+:8]),.c(tmp[220*8+:8]));
	signedmul mult_u221(.clk(clk),.a(vector[221*8+:8]),.b(matrix[221*8+:8]),.c(tmp[221*8+:8]));
	signedmul mult_u222(.clk(clk),.a(vector[222*8+:8]),.b(matrix[222*8+:8]),.c(tmp[222*8+:8]));
	signedmul mult_u223(.clk(clk),.a(vector[223*8+:8]),.b(matrix[223*8+:8]),.c(tmp[223*8+:8]));
	signedmul mult_u224(.clk(clk),.a(vector[224*8+:8]),.b(matrix[224*8+:8]),.c(tmp[224*8+:8]));
	signedmul mult_u225(.clk(clk),.a(vector[225*8+:8]),.b(matrix[225*8+:8]),.c(tmp[225*8+:8]));
	signedmul mult_u226(.clk(clk),.a(vector[226*8+:8]),.b(matrix[226*8+:8]),.c(tmp[226*8+:8]));
	signedmul mult_u227(.clk(clk),.a(vector[227*8+:8]),.b(matrix[227*8+:8]),.c(tmp[227*8+:8]));
	signedmul mult_u228(.clk(clk),.a(vector[228*8+:8]),.b(matrix[228*8+:8]),.c(tmp[228*8+:8]));
	signedmul mult_u229(.clk(clk),.a(vector[229*8+:8]),.b(matrix[229*8+:8]),.c(tmp[229*8+:8]));
	signedmul mult_u230(.clk(clk),.a(vector[230*8+:8]),.b(matrix[230*8+:8]),.c(tmp[230*8+:8]));
	signedmul mult_u231(.clk(clk),.a(vector[231*8+:8]),.b(matrix[231*8+:8]),.c(tmp[231*8+:8]));
	signedmul mult_u232(.clk(clk),.a(vector[232*8+:8]),.b(matrix[232*8+:8]),.c(tmp[232*8+:8]));
	signedmul mult_u233(.clk(clk),.a(vector[233*8+:8]),.b(matrix[233*8+:8]),.c(tmp[233*8+:8]));
	signedmul mult_u234(.clk(clk),.a(vector[234*8+:8]),.b(matrix[234*8+:8]),.c(tmp[234*8+:8]));
	signedmul mult_u235(.clk(clk),.a(vector[235*8+:8]),.b(matrix[235*8+:8]),.c(tmp[235*8+:8]));
	signedmul mult_u236(.clk(clk),.a(vector[236*8+:8]),.b(matrix[236*8+:8]),.c(tmp[236*8+:8]));
	signedmul mult_u237(.clk(clk),.a(vector[237*8+:8]),.b(matrix[237*8+:8]),.c(tmp[237*8+:8]));
	signedmul mult_u238(.clk(clk),.a(vector[238*8+:8]),.b(matrix[238*8+:8]),.c(tmp[238*8+:8]));
	signedmul mult_u239(.clk(clk),.a(vector[239*8+:8]),.b(matrix[239*8+:8]),.c(tmp[239*8+:8]));
	signedmul mult_u240(.clk(clk),.a(vector[240*8+:8]),.b(matrix[240*8+:8]),.c(tmp[240*8+:8]));
	signedmul mult_u241(.clk(clk),.a(vector[241*8+:8]),.b(matrix[241*8+:8]),.c(tmp[241*8+:8]));
	signedmul mult_u242(.clk(clk),.a(vector[242*8+:8]),.b(matrix[242*8+:8]),.c(tmp[242*8+:8]));
	signedmul mult_u243(.clk(clk),.a(vector[243*8+:8]),.b(matrix[243*8+:8]),.c(tmp[243*8+:8]));
	signedmul mult_u244(.clk(clk),.a(vector[244*8+:8]),.b(matrix[244*8+:8]),.c(tmp[244*8+:8]));
	signedmul mult_u245(.clk(clk),.a(vector[245*8+:8]),.b(matrix[245*8+:8]),.c(tmp[245*8+:8]));
	signedmul mult_u246(.clk(clk),.a(vector[246*8+:8]),.b(matrix[246*8+:8]),.c(tmp[246*8+:8]));
	signedmul mult_u247(.clk(clk),.a(vector[247*8+:8]),.b(matrix[247*8+:8]),.c(tmp[247*8+:8]));
	signedmul mult_u248(.clk(clk),.a(vector[248*8+:8]),.b(matrix[248*8+:8]),.c(tmp[248*8+:8]));
	signedmul mult_u249(.clk(clk),.a(vector[249*8+:8]),.b(matrix[249*8+:8]),.c(tmp[249*8+:8]));
	signedmul mult_u250(.clk(clk),.a(vector[250*8+:8]),.b(matrix[250*8+:8]),.c(tmp[250*8+:8]));
	signedmul mult_u251(.clk(clk),.a(vector[251*8+:8]),.b(matrix[251*8+:8]),.c(tmp[251*8+:8]));
	signedmul mult_u252(.clk(clk),.a(vector[252*8+:8]),.b(matrix[252*8+:8]),.c(tmp[252*8+:8]));
	signedmul mult_u253(.clk(clk),.a(vector[253*8+:8]),.b(matrix[253*8+:8]),.c(tmp[253*8+:8]));
	signedmul mult_u254(.clk(clk),.a(vector[254*8+:8]),.b(matrix[254*8+:8]),.c(tmp[254*8+:8]));
	signedmul mult_u255(.clk(clk),.a(vector[255*8+:8]),.b(matrix[255*8+:8]),.c(tmp[255*8+:8]));
 
 
 endmodule

 module vecmat_add_x #(parameter varraysize=1600,vectwidth=100) 
 (
 input clk,reset,
 input [varraysize-1:0] mulout,
 output reg [8:0] data_out
 );
          
 wire [8:0] tmp0, tmp1 ,tmp2 ,tmp3 ,tmp4 ,tmp5 ,tmp6 ,tmp7 ,tmp8 ,tmp9 ,tmp10 ,tmp11 ,tmp12 ,tmp13 ,tmp14 ,tmp15 ,tmp16 ,tmp17 ,tmp18 ,tmp19 ,tmp20 ,tmp21 ,tmp22 ,tmp23 ,tmp24 ,tmp25 ,tmp26 ,tmp27 ,tmp28 ,tmp29 ,tmp30 ,tmp31 ,tmp32 ,tmp33 ,tmp34 ,tmp35 ,tmp36 ,tmp37 ,tmp38 ,tmp39 ,tmp40 ,tmp41 ,tmp42 ,tmp43 ,tmp44 ,tmp45 ,tmp46 ,tmp47 ,tmp48 ,tmp49 ,tmp50,tmp51 ,tmp52 ,tmp53,tmp54 ,tmp55 ,tmp56 ,tmp57 ,tmp58,tmp59 ,tmp60 ,tmp61 ,tmp62 ,tmp63 ,tmp64 ,tmp65 ; 
 wire [8:0] tmp66 ,tmp67 ,tmp68 ,tmp69 ,tmp70 ,tmp71 ,tmp72 ,tmp73 ,tmp74 ,tmp75 ,tmp76 ,tmp77 ,tmp78 ,tmp79 ,tmp80 ,tmp81 ,tmp82 ,tmp83 ,tmp84, tmp85 ,tmp86, tmp87,tmp88 ,tmp89 ,tmp90 ,tmp91 ,tmp92 ,tmp93 ,tmp94 ,tmp95, tmp96, tmp97, tmp98, tmp99;
 wire [8:0] tmp100, tmp101, tmp102, tmp103, tmp104, tmp105, tmp106, tmp107, tmp108, tmp109, tmp110, tmp111, tmp112, tmp113, tmp114, tmp115, tmp116, tmp117, tmp118, tmp119, tmp120, tmp121, tmp122, tmp123, tmp124, tmp125, tmp126, tmp127, tmp128, tmp129, tmp130, tmp131, tmp132, tmp133, tmp134, tmp135, tmp136, tmp137, tmp138, tmp139, tmp140, tmp141, tmp142, tmp143, tmp144, tmp145, tmp146, tmp147, tmp148, tmp149, tmp150, tmp151, tmp152, tmp153, tmp154, tmp155, tmp156, tmp157, tmp158, tmp159, tmp160, tmp161, tmp162, tmp163, tmp164, tmp165, tmp166, tmp167, tmp168, tmp169, tmp170, tmp171, tmp172, tmp173, tmp174, tmp175, tmp176, tmp177, tmp178, tmp179, tmp180, tmp181, tmp182, tmp183, tmp184, tmp185, tmp186, tmp187, tmp188, tmp189, tmp190, tmp191, tmp192, tmp193, tmp194, tmp195, tmp196, tmp197, tmp198, tmp199, tmp200, tmp201, tmp202, tmp203, tmp204, tmp205, tmp206, tmp207, tmp208, tmp209, tmp210, tmp211, tmp212, tmp213, tmp214, tmp215, tmp216, tmp217, tmp218, tmp219, tmp220, tmp221, tmp222, tmp223, tmp224, tmp225, tmp226, tmp227, tmp228, tmp229, tmp230, tmp231, tmp232, tmp233, tmp234, tmp235, tmp236, tmp237, tmp238, tmp239, tmp240, tmp241, tmp242, tmp243, tmp244, tmp245, tmp246, tmp247, tmp248, tmp249, tmp250, tmp251, tmp252, tmp253, tmp254, tmp255;
 reg[31:0] i;

 wire [8:0] ff0, ff1, ff2, ff3, ff4, ff5, ff6, ff7, ff8, ff9, ff10, ff11, ff12, ff13, ff14, ff15, ff16, ff17, ff18, ff19, ff20, ff21, ff22, ff23, ff24, ff25, ff26, ff27, ff28, ff29, ff30, ff31, ff32, ff33, ff34, ff35, ff36, ff37, ff38, ff39, ff40, ff41, ff42, ff43, ff44, ff45, ff46, ff47, ff48, ff49, ff50, ff51, ff52, ff53, ff54, ff55, ff56, ff57, ff58, ff59, ff60, ff61, ff62;

 wire [8:0] mf0, mf1, mf2, mf3, mf4, mf5, mf6, mf7, mf8, mf9, mf10, mf11, mf12, mf13;

assign data_out = mf13;

		qadd2 Add_u0(.a(mulout[8*0+:8]),.b(mulout[8*1+:8]),.c(tmp0));
		qadd2 Add_u2(.a(mulout[8*2+:8]),.b(mulout[8*3+:8]),.c(tmp2));
		qadd2 Add_u4(.a(mulout[8*4+:8]),.b(mulout[8*5+:8]),.c(tmp4));
		qadd2 Add_u6(.a(mulout[8*6+:8]),.b(mulout[8*7+:8]),.c(tmp6));
		qadd2 Add_u8(.a(mulout[8*8+:8]),.b(mulout[8*9+:8]),.c(tmp8));
		qadd2 Add_u10(.a(mulout[8*10+:8]),.b(mulout[8*11+:8]),.c(tmp10));
		qadd2 Add_u12(.a(mulout[8*12+:8]),.b(mulout[8*13+:8]),.c(tmp12));
		qadd2 Add_u14(.a(mulout[8*14+:8]),.b(mulout[8*15+:8]),.c(tmp14));
		qadd2 Add_u16(.a(mulout[8*8+:8]),.b(mulout[8*17+:8]),.c(tmp16));
		qadd2 Add_u18(.a(mulout[8*18+:8]),.b(mulout[8*19+:8]),.c(tmp18));
		qadd2 Add_u20(.a(mulout[8*20+:8]),.b(mulout[8*21+:8]),.c(tmp20));
		qadd2 Add_u22(.a(mulout[8*22+:8]),.b(mulout[8*23+:8]),.c(tmp22));
		qadd2 Add_u24(.a(mulout[8*24+:8]),.b(mulout[8*25+:8]),.c(tmp24));
		qadd2 Add_u26(.a(mulout[8*26+:8]),.b(mulout[8*27+:8]),.c(tmp26));
		qadd2 Add_u28(.a(mulout[8*28+:8]),.b(mulout[8*29+:8]),.c(tmp28));
		qadd2 Add_u30(.a(mulout[8*30+:8]),.b(mulout[8*31+:8]),.c(tmp30));
		qadd2 Add_u32(.a(mulout[8*32+:8]),.b(mulout[8*33+:8]),.c(tmp32));
		qadd2 Add_u34(.a(mulout[8*34+:8]),.b(mulout[8*35+:8]),.c(tmp34));
		qadd2 Add_u36(.a(mulout[8*36+:8]),.b(mulout[8*37+:8]),.c(tmp36));
		qadd2 Add_u38(.a(mulout[8*38+:8]),.b(mulout[8*39+:8]),.c(tmp38));
		qadd2 Add_u40(.a(mulout[8*40+:8]),.b(mulout[8*41+:8]),.c(tmp40));
		qadd2 Add_u42(.a(mulout[8*42+:8]),.b(mulout[8*43+:8]),.c(tmp42));
		qadd2 Add_u44(.a(mulout[8*44+:8]),.b(mulout[8*45+:8]),.c(tmp44));
		qadd2 Add_u46(.a(mulout[8*46+:8]),.b(mulout[8*47+:8]),.c(tmp46));
		qadd2 Add_u48(.a(mulout[8*48+:8]),.b(mulout[8*49+:8]),.c(tmp48));
		qadd2 Add_u50(.a(mulout[8*50+:8]),.b(mulout[8*51+:8]),.c(tmp50));
		qadd2 Add_u52(.a(mulout[8*52+:8]),.b(mulout[8*53+:8]),.c(tmp52));
		qadd2 Add_u54(.a(mulout[8*54+:8]),.b(mulout[8*55+:8]),.c(tmp54));
		qadd2 Add_u56(.a(mulout[8*56+:8]),.b(mulout[8*57+:8]),.c(tmp56));
		qadd2 Add_u58(.a(mulout[8*58+:8]),.b(mulout[8*59+:8]),.c(tmp58));
		qadd2 Add_u60(.a(mulout[8*60+:8]),.b(mulout[8*61+:8]),.c(tmp60));
		qadd2 Add_u62(.a(mulout[8*62+:8]),.b(mulout[8*63+:8]),.c(tmp62));
		qadd2 Add_u64(.a(mulout[8*64+:8]),.b(mulout[8*65+:8]),.c(tmp64));
		qadd2 Add_u66(.a(mulout[8*66+:8]),.b(mulout[8*67+:8]),.c(tmp66));
		qadd2 Add_u68(.a(mulout[8*68+:8]),.b(mulout[8*69+:8]),.c(tmp68));
		qadd2 Add_u70(.a(mulout[8*70+:8]),.b(mulout[8*71+:8]),.c(tmp70));
		qadd2 Add_u72(.a(mulout[8*72+:8]),.b(mulout[8*73+:8]),.c(tmp72));
		qadd2 Add_u74(.a(mulout[8*74+:8]),.b(mulout[8*75+:8]),.c(tmp74));
		qadd2 Add_u76(.a(mulout[8*76+:8]),.b(mulout[8*77+:8]),.c(tmp76));
		qadd2 Add_u78(.a(mulout[8*78+:8]),.b(mulout[8*79+:8]),.c(tmp78));
		qadd2 Add_u80(.a(mulout[8*80+:8]),.b(mulout[8*81+:8]),.c(tmp80));
		qadd2 Add_u82(.a(mulout[8*82+:8]),.b(mulout[8*83+:8]),.c(tmp82));
		qadd2 Add_u84(.a(mulout[8*84+:8]),.b(mulout[8*85+:8]),.c(tmp84));
		qadd2 Add_u86(.a(mulout[8*86+:8]),.b(mulout[8*87+:8]),.c(tmp86));
		qadd2 Add_u88(.a(mulout[8*88+:8]),.b(mulout[8*89+:8]),.c(tmp88));
		qadd2 Add_u90(.a(mulout[8*90+:8]),.b(mulout[8*91+:8]),.c(tmp90));
		qadd2 Add_u92(.a(mulout[8*92+:8]),.b(mulout[8*93+:8]),.c(tmp92));
		qadd2 Add_u94(.a(mulout[8*94+:8]),.b(mulout[8*95+:8]),.c(tmp94));
		qadd2 Add_u96(.a(mulout[8*96+:8]),.b(mulout[8*97+:8]),.c(tmp96));
		qadd2 Add_u98(.a(mulout[8*98+:8]),.b(mulout[8*99+:8]),.c(tmp98));
		qadd2 Add_u100(.a(mulout[8*100+:8]),.b(mulout[8*101+:8]),.c(tmp100));
		qadd2 Add_u102(.a(mulout[8*102+:8]),.b(mulout[8*103+:8]),.c(tmp102));
		qadd2 Add_u104(.a(mulout[8*104+:8]),.b(mulout[8*105+:8]),.c(tmp104));
		qadd2 Add_u106(.a(mulout[8*106+:8]),.b(mulout[8*107+:8]),.c(tmp106));
		qadd2 Add_u108(.a(mulout[8*108+:8]),.b(mulout[8*109+:8]),.c(tmp108));
		qadd2 Add_u110(.a(mulout[8*110+:8]),.b(mulout[8*111+:8]),.c(tmp110));
		qadd2 Add_u112(.a(mulout[8*112+:8]),.b(mulout[8*113+:8]),.c(tmp112));
		qadd2 Add_u114(.a(mulout[8*114+:8]),.b(mulout[8*115+:8]),.c(tmp114));
		qadd2 Add_u116(.a(mulout[8*116+:8]),.b(mulout[8*117+:8]),.c(tmp116));
		qadd2 Add_u118(.a(mulout[8*118+:8]),.b(mulout[8*119+:8]),.c(tmp118));
		qadd2 Add_u120(.a(mulout[8*120+:8]),.b(mulout[8*121+:8]),.c(tmp120));
		qadd2 Add_u122(.a(mulout[8*122+:8]),.b(mulout[8*123+:8]),.c(tmp122));
		qadd2 Add_u124(.a(mulout[8*124+:8]),.b(mulout[8*125+:8]),.c(tmp124));
		qadd2 Add_u126(.a(mulout[8*126+:8]),.b(mulout[8*127+:8]),.c(tmp126));
		qadd2 Add_u128(.a(mulout[8*128+:8]),.b(mulout[8*129+:8]),.c(tmp128));
		qadd2 Add_u130(.a(mulout[8*130+:8]),.b(mulout[8*131+:8]),.c(tmp130));
		qadd2 Add_u132(.a(mulout[8*132+:8]),.b(mulout[8*133+:8]),.c(tmp132));
		qadd2 Add_u134(.a(mulout[8*134+:8]),.b(mulout[8*135+:8]),.c(tmp134));
		qadd2 Add_u136(.a(mulout[8*136+:8]),.b(mulout[8*137+:8]),.c(tmp136));
		qadd2 Add_u138(.a(mulout[8*138+:8]),.b(mulout[8*139+:8]),.c(tmp138));
		qadd2 Add_u140(.a(mulout[8*140+:8]),.b(mulout[8*141+:8]),.c(tmp140));
		qadd2 Add_u142(.a(mulout[8*142+:8]),.b(mulout[8*143+:8]),.c(tmp142));
		qadd2 Add_u144(.a(mulout[8*144+:8]),.b(mulout[8*145+:8]),.c(tmp144));
		qadd2 Add_u146(.a(mulout[8*146+:8]),.b(mulout[8*147+:8]),.c(tmp146));
		qadd2 Add_u148(.a(mulout[8*148+:8]),.b(mulout[8*149+:8]),.c(tmp148));
		qadd2 Add_u150(.a(mulout[8*150+:8]),.b(mulout[8*151+:8]),.c(tmp150));
		qadd2 Add_u152(.a(mulout[8*152+:8]),.b(mulout[8*153+:8]),.c(tmp152));
		qadd2 Add_u154(.a(mulout[8*154+:8]),.b(mulout[8*155+:8]),.c(tmp154));
		qadd2 Add_u156(.a(mulout[8*156+:8]),.b(mulout[8*157+:8]),.c(tmp156));
		qadd2 Add_u158(.a(mulout[8*158+:8]),.b(mulout[8*159+:8]),.c(tmp158));
		qadd2 Add_u160(.a(mulout[8*160+:8]),.b(mulout[8*161+:8]),.c(tmp160));
		qadd2 Add_u162(.a(mulout[8*162+:8]),.b(mulout[8*163+:8]),.c(tmp162));
		qadd2 Add_u164(.a(mulout[8*164+:8]),.b(mulout[8*165+:8]),.c(tmp164));
		qadd2 Add_u166(.a(mulout[8*166+:8]),.b(mulout[8*167+:8]),.c(tmp166));
		qadd2 Add_u168(.a(mulout[8*168+:8]),.b(mulout[8*169+:8]),.c(tmp168));
		qadd2 Add_u170(.a(mulout[8*170+:8]),.b(mulout[8*171+:8]),.c(tmp170));
		qadd2 Add_u172(.a(mulout[8*172+:8]),.b(mulout[8*173+:8]),.c(tmp172));
		qadd2 Add_u174(.a(mulout[8*174+:8]),.b(mulout[8*175+:8]),.c(tmp174));
		qadd2 Add_u176(.a(mulout[8*176+:8]),.b(mulout[8*177+:8]),.c(tmp176));
		qadd2 Add_u178(.a(mulout[8*178+:8]),.b(mulout[8*179+:8]),.c(tmp178));
		qadd2 Add_u180(.a(mulout[8*180+:8]),.b(mulout[8*181+:8]),.c(tmp180));
		qadd2 Add_u182(.a(mulout[8*182+:8]),.b(mulout[8*183+:8]),.c(tmp182));
		qadd2 Add_u184(.a(mulout[8*184+:8]),.b(mulout[8*185+:8]),.c(tmp184));
		qadd2 Add_u186(.a(mulout[8*186+:8]),.b(mulout[8*187+:8]),.c(tmp186));
		qadd2 Add_u188(.a(mulout[8*188+:8]),.b(mulout[8*189+:8]),.c(tmp188));
		qadd2 Add_u190(.a(mulout[8*190+:8]),.b(mulout[8*191+:8]),.c(tmp190));
		qadd2 Add_u192(.a(mulout[8*192+:8]),.b(mulout[8*193+:8]),.c(tmp192));
		qadd2 Add_u194(.a(mulout[8*194+:8]),.b(mulout[8*195+:8]),.c(tmp194));
		qadd2 Add_u196(.a(mulout[8*196+:8]),.b(mulout[8*197+:8]),.c(tmp196));
		qadd2 Add_u198(.a(mulout[8*198+:8]),.b(mulout[8*199+:8]),.c(tmp198));
		qadd2 Add_u200(.a(mulout[8*200+:8]),.b(mulout[8*201+:8]),.c(tmp200));
		qadd2 Add_u202(.a(mulout[8*202+:8]),.b(mulout[8*203+:8]),.c(tmp202));
		qadd2 Add_u204(.a(mulout[8*204+:8]),.b(mulout[8*205+:8]),.c(tmp204));
		qadd2 Add_u206(.a(mulout[8*206+:8]),.b(mulout[8*207+:8]),.c(tmp206));
		qadd2 Add_u208(.a(mulout[8*208+:8]),.b(mulout[8*209+:8]),.c(tmp208));
		qadd2 Add_u210(.a(mulout[8*210+:8]),.b(mulout[8*211+:8]),.c(tmp210));
		qadd2 Add_u212(.a(mulout[8*212+:8]),.b(mulout[8*213+:8]),.c(tmp212));
		qadd2 Add_u214(.a(mulout[8*214+:8]),.b(mulout[8*215+:8]),.c(tmp214));
		qadd2 Add_u216(.a(mulout[8*216+:8]),.b(mulout[8*217+:8]),.c(tmp216));
		qadd2 Add_u218(.a(mulout[8*218+:8]),.b(mulout[8*219+:8]),.c(tmp218));
		qadd2 Add_u220(.a(mulout[8*220+:8]),.b(mulout[8*221+:8]),.c(tmp220));
		qadd2 Add_u222(.a(mulout[8*222+:8]),.b(mulout[8*223+:8]),.c(tmp222));
		qadd2 Add_u224(.a(mulout[8*224+:8]),.b(mulout[8*225+:8]),.c(tmp224));
		qadd2 Add_u226(.a(mulout[8*226+:8]),.b(mulout[8*227+:8]),.c(tmp226));
		qadd2 Add_u228(.a(mulout[8*228+:8]),.b(mulout[8*229+:8]),.c(tmp228));
		qadd2 Add_u230(.a(mulout[8*230+:8]),.b(mulout[8*231+:8]),.c(tmp230));
		qadd2 Add_u232(.a(mulout[8*232+:8]),.b(mulout[8*233+:8]),.c(tmp232));
		qadd2 Add_u234(.a(mulout[8*234+:8]),.b(mulout[8*235+:8]),.c(tmp234));
		qadd2 Add_u236(.a(mulout[8*236+:8]),.b(mulout[8*237+:8]),.c(tmp236));
		qadd2 Add_u238(.a(mulout[8*238+:8]),.b(mulout[8*239+:8]),.c(tmp238));
		qadd2 Add_u240(.a(mulout[8*240+:8]),.b(mulout[8*241+:8]),.c(tmp240));
		qadd2 Add_u242(.a(mulout[8*242+:8]),.b(mulout[8*243+:8]),.c(tmp242));
		qadd2 Add_u244(.a(mulout[8*244+:8]),.b(mulout[8*245+:8]),.c(tmp244));
		qadd2 Add_u246(.a(mulout[8*246+:8]),.b(mulout[8*247+:8]),.c(tmp246));
		qadd2 Add_u248(.a(mulout[8*248+:8]),.b(mulout[8*249+:8]),.c(tmp248));
		qadd2 Add_u250(.a(mulout[8*250+:8]),.b(mulout[8*251+:8]),.c(tmp250));
		qadd2 Add_u252(.a(mulout[8*252+:8]),.b(mulout[8*253+:8]),.c(tmp252));
		qadd2 Add_u254(.a(mulout[8*254+:8]),.b(mulout[8*255+:8]),.c(tmp254));

		
		 
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
			qadd2 Add_u51(.a(tmp100),.b(tmp102),.c(tmp51));
			qadd2 Add_u53(.a(tmp104),.b(tmp106),.c(tmp53));
			qadd2 Add_u55(.a(tmp108),.b(tmp110),.c(tmp55));
			qadd2 Add_u57(.a(tmp112),.b(tmp114),.c(tmp57));
			qadd2 Add_u59(.a(tmp116),.b(tmp118),.c(tmp59));
			qadd2 Add_u61(.a(tmp120),.b(tmp122),.c(tmp61));
			qadd2 Add_u63(.a(tmp124),.b(tmp126),.c(tmp63));
			qadd2 Add_u65(.a(tmp128),.b(tmp130),.c(tmp65));
			qadd2 Add_u67(.a(tmp132),.b(tmp134),.c(tmp67));
			qadd2 Add_u69(.a(tmp136),.b(tmp138),.c(tmp69));
			qadd2 Add_u71(.a(tmp140),.b(tmp142),.c(tmp71));
			qadd2 Add_u73(.a(tmp144),.b(tmp146),.c(tmp73));
			qadd2 Add_u75(.a(tmp148),.b(tmp150),.c(tmp75));
			qadd2 Add_u77(.a(tmp152),.b(tmp154),.c(tmp77));
			qadd2 Add_u79(.a(tmp156),.b(tmp158),.c(tmp79));
			qadd2 Add_u81(.a(tmp160),.b(tmp162),.c(tmp81));
			qadd2 Add_u83(.a(tmp164),.b(tmp166),.c(tmp83));
			qadd2 Add_u85(.a(tmp168),.b(tmp170),.c(tmp85));
			qadd2 Add_u87(.a(tmp172),.b(tmp174),.c(tmp87));
			qadd2 Add_u89(.a(tmp176),.b(tmp178),.c(tmp89));
			qadd2 Add_u91(.a(tmp180),.b(tmp182),.c(tmp91));
			qadd2 Add_u93(.a(tmp184),.b(tmp186),.c(tmp93));
			qadd2 Add_u95(.a(tmp188),.b(tmp190),.c(tmp95));
			qadd2 Add_u97(.a(tmp192),.b(tmp194),.c(tmp97));
			qadd2 Add_u99(.a(tmp196),.b(tmp198),.c(tmp99));
			qadd2 Add_u101(.a(tmp200),.b(tmp202),.c(tmp101));
			qadd2 Add_u103(.a(tmp204),.b(tmp206),.c(tmp103));
			qadd2 Add_u105(.a(tmp208),.b(tmp210),.c(tmp105));
			qadd2 Add_u107(.a(tmp212),.b(tmp214),.c(tmp107));
			qadd2 Add_u109(.a(tmp216),.b(tmp218),.c(tmp109));
			qadd2 Add_u111(.a(tmp220),.b(tmp222),.c(tmp111));
			qadd2 Add_u113(.a(tmp224),.b(tmp226),.c(tmp113));
			qadd2 Add_u115(.a(tmp228),.b(tmp230),.c(tmp115));
			qadd2 Add_u117(.a(tmp232),.b(tmp234),.c(tmp117));
			qadd2 Add_u119(.a(tmp236),.b(tmp238),.c(tmp119));
			qadd2 Add_u121(.a(tmp240),.b(tmp242),.c(tmp121));
			qadd2 Add_u123(.a(tmp244),.b(tmp246),.c(tmp123));
			qadd2 Add_u125(.a(tmp248),.b(tmp250),.c(tmp125));
			qadd2 Add_u127(.a(tmp252),.b(tmp254),.c(tmp127));


						
			qadd2 Add_ff0(.a(tmp1),.b(tmp3),.c(ff0));
			qadd2 Add_ff2(.a(tmp5),.b(tmp7),.c(ff2));
			qadd2 Add_ff4(.a(tmp9),.b(tmp11),.c(ff4));
			qadd2 Add_ff6(.a(tmp13),.b(tmp15),.c(ff6));
			qadd2 Add_ff8(.a(tmp17),.b(tmp19),.c(ff8));
			qadd2 Add_ff10(.a(tmp21),.b(tmp23),.c(ff10));
			qadd2 Add_ff12(.a(tmp25),.b(tmp27),.c(ff12));
			qadd2 Add_ff14(.a(tmp29),.b(tmp31),.c(ff14));
			qadd2 Add_ff16(.a(tmp33),.b(tmp35),.c(ff16));
			qadd2 Add_ff18(.a(tmp37),.b(tmp39),.c(ff18));
			qadd2 Add_ff20(.a(tmp41),.b(tmp43),.c(ff20));
			qadd2 Add_ff22(.a(tmp45),.b(tmp47),.c(ff22));
			qadd2 Add_ff24(.a(tmp49),.b(tmp51),.c(ff24));
			qadd2 Add_ff26(.a(tmp53),.b(tmp55),.c(ff26));
			qadd2 Add_ff28(.a(tmp57),.b(tmp59),.c(ff28));
			qadd2 Add_ff30(.a(tmp61),.b(tmp63),.c(ff30));
			qadd2 Add_ff32(.a(tmp65),.b(tmp67),.c(ff32));
			qadd2 Add_ff34(.a(tmp69),.b(tmp71),.c(ff34));
			qadd2 Add_ff36(.a(tmp73),.b(tmp75),.c(ff36));
			qadd2 Add_ff38(.a(tmp77),.b(tmp79),.c(ff38));
			qadd2 Add_ff40(.a(tmp81),.b(tmp83),.c(ff40));
			qadd2 Add_ff42(.a(tmp85),.b(tmp87),.c(ff42));
			qadd2 Add_ff44(.a(tmp89),.b(tmp91),.c(ff44));
			qadd2 Add_ff46(.a(tmp93),.b(tmp95),.c(ff46));
			qadd2 Add_ff48(.a(tmp97),.b(tmp99),.c(ff48));
			qadd2 Add_ff50(.a(tmp101),.b(tmp103),.c(ff50));
			qadd2 Add_ff52(.a(tmp105),.b(tmp107),.c(ff52));
			qadd2 Add_ff54(.a(tmp109),.b(tmp111),.c(ff54));
			qadd2 Add_ff56(.a(tmp113),.b(tmp115),.c(ff56));
			qadd2 Add_ff58(.a(tmp117),.b(tmp119),.c(ff58));
			qadd2 Add_ff60(.a(tmp121),.b(tmp123),.c(ff60));
			qadd2 Add_ff62(.a(tmp125),.b(tmp127),.c(ff62));


			
			qadd2 Add_ff1(.a(ff0),.b(ff2),.c(ff1));
			qadd2 Add_ff3(.a(ff4),.b(ff6),.c(ff3));
			qadd2 Add_ff5(.a(ff8),.b(ff10),.c(ff5));
			qadd2 Add_ff7(.a(ff12),.b(ff14),.c(ff7));
			qadd2 Add_ff9(.a(ff16),.b(ff18),.c(ff9));
			qadd2 Add_ff11(.a(ff20),.b(ff22),.c(ff11));
			qadd2 Add_ff13(.a(ff24),.b(ff26),.c(ff13));
			qadd2 Add_ff15(.a(ff28),.b(ff30),.c(ff15));
			qadd2 Add_ff17(.a(ff32),.b(ff34),.c(ff17));
			qadd2 Add_ff19(.a(ff36),.b(ff38),.c(ff19));
			qadd2 Add_ff21(.a(ff40),.b(ff42),.c(ff21));
			qadd2 Add_ff23(.a(ff44),.b(ff46),.c(ff23));
			qadd2 Add_ff25(.a(ff48),.b(ff50),.c(ff25));
			qadd2 Add_ff27(.a(ff52),.b(ff54),.c(ff27));
			qadd2 Add_ff29(.a(ff56),.b(ff58),.c(ff29));
			qadd2 Add_ff31(.a(ff60),.b(ff62),.c(ff31));
			

			qadd2 Add_mf0(.a(ff1),.b(ff3),.c(mf0));
			qadd2 Add_mf2(.a(ff5),.b(ff7),.c(mf2));
			qadd2 Add_mf4(.a(ff9),.b(ff11),.c(mf4));
			qadd2 Add_mf6(.a(ff13),.b(ff15),.c(mf6));
			qadd2 Add_mf8(.a(ff17),.b(ff19),.c(mf8));
			qadd2 Add_mf10(.a(ff21),.b(ff23),.c(mf10));
			qadd2 Add_mf12(.a(ff25),.b(ff27),.c(mf12));
			qadd2 Add_mf14(.a(ff29),.b(ff31),.c(mf14));

			qadd2 Add_mf1(.a(mf0),.b(mf2),.c(mf1));
			qadd2 Add_mf3(.a(mf4),.b(mf6),.c(mf3));
			qadd2 Add_mf5(.a(mf8),.b(mf10),.c(mf5));
			qadd2 Add_mf7(.a(mf12),.b(mf14),.c(mf7));

			qadd2 Add_mf9(.a(mf1),.b(mf3),.c(mf9));
			qadd2 Add_mf11(.a(mf5),.b(mf7),.c(mf11));

			qadd2 Add_mf13(.a(mf9),.b(mf11),.c(mf13));



			
		
									
	   
endmodule

module signedmul(
  input clk,
  input [8:0] a,
  input [8:0] b,
  output [8:0] c
);

wire [31:0] result;
wire [8:0] a_new;
wire [8:0] b_new;

reg [8:0] a_ff;
reg [8:0] b_ff;
reg [31:0] result_ff;
reg a_sign,b_sign,a_sign_ff,b_sign_ff;

assign c = (b_sign_ff==a_sign_ff)?result_ff[26:12]:(~result_ff[26:12]+1'b1);
assign a_new = a[15]?(~a + 1'b1):a;
assign b_new = b[15]?(~b + 1'b1):b;
assign result = a_ff*b_ff;

always@(posedge clk) begin
	a_ff <= a_new;
	b_ff <= b_new; 

	a_sign <= a[15];
	b_sign <= b[15];
	a_sign_ff <= a_sign;
	b_sign_ff <= b_sign;
    result_ff <= result;
    
end


endmodule



module qadd2(
 input [8:0] a,
 input [8:0] b,
 output [8:0] c
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