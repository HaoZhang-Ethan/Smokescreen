`define ARRAY_DEPTH 64      //Number of Hidden neurons
`define INPUT_DEPTH 100	    //LSTM input vector dimensions
`define DATA_WIDTH 8		//16 bit representation
`define INWEIGHT_DEPTH 6400 //100x64
`define HWEIGHT_DEPTH 4096  //64x64
`define varraysize 1600   //100x16
`define uarraysize 1024  //64x16


module vecmat_h_8_CLB #( parameter uarraysize=1024, vectwidth=64)
(
	input clk,
	input reset,
	input [uarraysize-1:0] data_h,
	input [uarraysize-1:0] W_h,

	output reg [15:0] data_out_h
);

	wire [uarraysize-1:0] mulout_h;
	vecmat_mul_h_clb #(`uarraysize,`ARRAY_DEPTH) f_gateh(.clk(clk),.reset(rst),.data(data_h),.W(W_h),.tmp(mulout_h));
	vecmat_add_h #(`uarraysize,`ARRAY_DEPTH) f_gateaddh(.clk(clk),.reset(rst),.mulout(mulout_h),.data_out(data_out_h));


	
endmodule




module vecmat_mul_h_clb #( parameter uarraysize=1024,parameter vectwidth=64)  //,matsize=64)   // varraysize=1024 vectwidth=64,matsize=4096
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
          signedmul_clb mult_u0(.a(vector[j*16+:16]),.b(matrix[j*16+:16]),.c(tmp[j*16+:16]));
  end
  endgenerate*/

   	signedmul_clb mult_u0(.clk(clk),.a(vector[0*16+:16]),.b(matrix[0*16+:16]),.c(tmp[0*16+:16]));
	signedmul_clb mult_u1(.clk(clk),.a(vector[1*16+:16]),.b(matrix[1*16+:16]),.c(tmp[1*16+:16]));
	signedmul_clb mult_u2(.clk(clk),.a(vector[2*16+:16]),.b(matrix[2*16+:16]),.c(tmp[2*16+:16]));
	signedmul_clb mult_u3(.clk(clk),.a(vector[3*16+:16]),.b(matrix[3*16+:16]),.c(tmp[3*16+:16]));
	signedmul_clb mult_u4(.clk(clk),.a(vector[4*16+:16]),.b(matrix[4*16+:16]),.c(tmp[4*16+:16]));
	signedmul_clb mult_u5(.clk(clk),.a(vector[5*16+:16]),.b(matrix[5*16+:16]),.c(tmp[5*16+:16]));
	signedmul_clb mult_u6(.clk(clk),.a(vector[6*16+:16]),.b(matrix[6*16+:16]),.c(tmp[6*16+:16]));
	signedmul_clb mult_u7(.clk(clk),.a(vector[7*16+:16]),.b(matrix[7*16+:16]),.c(tmp[7*16+:16]));
	signedmul_clb mult_u8(.clk(clk),.a(vector[8*16+:16]),.b(matrix[8*16+:16]),.c(tmp[8*16+:16]));
	signedmul_clb mult_u9(.clk(clk),.a(vector[9*16+:16]),.b(matrix[9*16+:16]),.c(tmp[9*16+:16]));
	signedmul_clb mult_u10(.clk(clk),.a(vector[10*16+:16]),.b(matrix[10*16+:16]),.c(tmp[10*16+:16]));
	signedmul_clb mult_u11(.clk(clk),.a(vector[11*16+:16]),.b(matrix[11*16+:16]),.c(tmp[11*16+:16]));
	signedmul_clb mult_u12(.clk(clk),.a(vector[12*16+:16]),.b(matrix[12*16+:16]),.c(tmp[12*16+:16]));
	signedmul_clb mult_u13(.clk(clk),.a(vector[13*16+:16]),.b(matrix[13*16+:16]),.c(tmp[13*16+:16]));
	signedmul_clb mult_u14(.clk(clk),.a(vector[14*16+:16]),.b(matrix[14*16+:16]),.c(tmp[14*16+:16]));
	signedmul_clb mult_u15(.clk(clk),.a(vector[15*16+:16]),.b(matrix[15*16+:16]),.c(tmp[15*16+:16]));
	signedmul_clb mult_u16(.clk(clk),.a(vector[16*16+:16]),.b(matrix[16*16+:16]),.c(tmp[16*16+:16]));
	signedmul_clb mult_u17(.clk(clk),.a(vector[17*16+:16]),.b(matrix[17*16+:16]),.c(tmp[17*16+:16]));
	signedmul_clb mult_u18(.clk(clk),.a(vector[18*16+:16]),.b(matrix[18*16+:16]),.c(tmp[18*16+:16]));
	signedmul_clb mult_u19(.clk(clk),.a(vector[19*16+:16]),.b(matrix[19*16+:16]),.c(tmp[19*16+:16]));
	signedmul_clb mult_u20(.clk(clk),.a(vector[20*16+:16]),.b(matrix[20*16+:16]),.c(tmp[20*16+:16]));
	signedmul_clb mult_u21(.clk(clk),.a(vector[21*16+:16]),.b(matrix[21*16+:16]),.c(tmp[21*16+:16]));
	signedmul_clb mult_u22(.clk(clk),.a(vector[22*16+:16]),.b(matrix[22*16+:16]),.c(tmp[22*16+:16]));
	signedmul_clb mult_u23(.clk(clk),.a(vector[23*16+:16]),.b(matrix[23*16+:16]),.c(tmp[23*16+:16]));
	signedmul_clb mult_u24(.clk(clk),.a(vector[24*16+:16]),.b(matrix[24*16+:16]),.c(tmp[24*16+:16]));
	signedmul_clb mult_u25(.clk(clk),.a(vector[25*16+:16]),.b(matrix[25*16+:16]),.c(tmp[25*16+:16]));
	signedmul_clb mult_u26(.clk(clk),.a(vector[26*16+:16]),.b(matrix[26*16+:16]),.c(tmp[26*16+:16]));
	signedmul_clb mult_u27(.clk(clk),.a(vector[27*16+:16]),.b(matrix[27*16+:16]),.c(tmp[27*16+:16]));
	signedmul_clb mult_u28(.clk(clk),.a(vector[28*16+:16]),.b(matrix[28*16+:16]),.c(tmp[28*16+:16]));
	signedmul_clb mult_u29(.clk(clk),.a(vector[29*16+:16]),.b(matrix[29*16+:16]),.c(tmp[29*16+:16]));
	signedmul_clb mult_u30(.clk(clk),.a(vector[30*16+:16]),.b(matrix[30*16+:16]),.c(tmp[30*16+:16]));
	signedmul_clb mult_u31(.clk(clk),.a(vector[31*16+:16]),.b(matrix[31*16+:16]),.c(tmp[31*16+:16]));
	signedmul_clb mult_u32(.clk(clk),.a(vector[32*16+:16]),.b(matrix[32*16+:16]),.c(tmp[32*16+:16]));
	signedmul_clb mult_u33(.clk(clk),.a(vector[33*16+:16]),.b(matrix[33*16+:16]),.c(tmp[33*16+:16]));
	signedmul_clb mult_u34(.clk(clk),.a(vector[34*16+:16]),.b(matrix[34*16+:16]),.c(tmp[34*16+:16]));
	signedmul_clb mult_u35(.clk(clk),.a(vector[35*16+:16]),.b(matrix[35*16+:16]),.c(tmp[35*16+:16]));
	signedmul_clb mult_u36(.clk(clk),.a(vector[36*16+:16]),.b(matrix[36*16+:16]),.c(tmp[36*16+:16]));
	signedmul_clb mult_u37(.clk(clk),.a(vector[37*16+:16]),.b(matrix[37*16+:16]),.c(tmp[37*16+:16]));
	signedmul_clb mult_u38(.clk(clk),.a(vector[38*16+:16]),.b(matrix[38*16+:16]),.c(tmp[38*16+:16]));
	signedmul_clb mult_u39(.clk(clk),.a(vector[39*16+:16]),.b(matrix[39*16+:16]),.c(tmp[39*16+:16]));
	signedmul_clb mult_u40(.clk(clk),.a(vector[40*16+:16]),.b(matrix[40*16+:16]),.c(tmp[40*16+:16]));
	signedmul_clb mult_u41(.clk(clk),.a(vector[41*16+:16]),.b(matrix[41*16+:16]),.c(tmp[41*16+:16]));
	signedmul_clb mult_u42(.clk(clk),.a(vector[42*16+:16]),.b(matrix[42*16+:16]),.c(tmp[42*16+:16]));
	signedmul_clb mult_u43(.clk(clk),.a(vector[43*16+:16]),.b(matrix[43*16+:16]),.c(tmp[43*16+:16]));
	signedmul_clb mult_u44(.clk(clk),.a(vector[44*16+:16]),.b(matrix[44*16+:16]),.c(tmp[44*16+:16]));
	signedmul_clb mult_u45(.clk(clk),.a(vector[45*16+:16]),.b(matrix[45*16+:16]),.c(tmp[45*16+:16]));
	signedmul_clb mult_u46(.clk(clk),.a(vector[46*16+:16]),.b(matrix[46*16+:16]),.c(tmp[46*16+:16]));
	signedmul_clb mult_u47(.clk(clk),.a(vector[47*16+:16]),.b(matrix[47*16+:16]),.c(tmp[47*16+:16]));
	signedmul_clb mult_u48(.clk(clk),.a(vector[48*16+:16]),.b(matrix[48*16+:16]),.c(tmp[48*16+:16]));
	signedmul_clb mult_u49(.clk(clk),.a(vector[49*16+:16]),.b(matrix[49*16+:16]),.c(tmp[49*16+:16]));
	signedmul_clb mult_u50(.clk(clk),.a(vector[50*16+:16]),.b(matrix[50*16+:16]),.c(tmp[50*16+:16]));
	signedmul_clb mult_u51(.clk(clk),.a(vector[51*16+:16]),.b(matrix[51*16+:16]),.c(tmp[51*16+:16]));
	signedmul_clb mult_u52(.clk(clk),.a(vector[52*16+:16]),.b(matrix[52*16+:16]),.c(tmp[52*16+:16]));
	signedmul_clb mult_u53(.clk(clk),.a(vector[53*16+:16]),.b(matrix[53*16+:16]),.c(tmp[53*16+:16]));
	signedmul_clb mult_u54(.clk(clk),.a(vector[54*16+:16]),.b(matrix[54*16+:16]),.c(tmp[54*16+:16]));
	signedmul_clb mult_u55(.clk(clk),.a(vector[55*16+:16]),.b(matrix[55*16+:16]),.c(tmp[55*16+:16]));
	signedmul_clb mult_u56(.clk(clk),.a(vector[56*16+:16]),.b(matrix[56*16+:16]),.c(tmp[56*16+:16]));
	signedmul_clb mult_u57(.clk(clk),.a(vector[57*16+:16]),.b(matrix[57*16+:16]),.c(tmp[57*16+:16]));
	signedmul_clb mult_u58(.clk(clk),.a(vector[58*16+:16]),.b(matrix[58*16+:16]),.c(tmp[58*16+:16]));
	signedmul_clb mult_u59(.clk(clk),.a(vector[59*16+:16]),.b(matrix[59*16+:16]),.c(tmp[59*16+:16]));
	signedmul_clb mult_u60(.clk(clk),.a(vector[60*16+:16]),.b(matrix[60*16+:16]),.c(tmp[60*16+:16]));
	signedmul_clb mult_u61(.clk(clk),.a(vector[61*16+:16]),.b(matrix[61*16+:16]),.c(tmp[61*16+:16]));
	signedmul_clb mult_u62(.clk(clk),.a(vector[62*16+:16]),.b(matrix[62*16+:16]),.c(tmp[62*16+:16]));
	signedmul_clb mult_u63(.clk(clk),.a(vector[63*16+:16]),.b(matrix[63*16+:16]),.c(tmp[63*16+:16]));
	
endmodule                    


 