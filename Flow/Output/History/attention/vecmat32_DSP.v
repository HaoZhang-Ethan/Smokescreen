

module vecmat32_DSP
(
	input clk,
	input reset,
	input [511:0] vector,
	input [511:0] matrix,

	output [15:0] data_out
);

	wire [511:0] mul_out2;
	//Multiplying output of softmax with V vector
	vecmat_mul_32 rv_mul (.clk(clk),.reset(rst),.vector(data_to_MVM),.matrix(v),.tmp(mul_out2));
	vecmat_add_32 rv_acc (.clk(clk),.reset(rst),.mulout(mul_out2),.data_out(softmulv));


	
endmodule

module vecmat_mul_32 #( parameter arraysize=512,parameter vectdepth=32)  //,matsize=64)   // varraysize=1024 vectwidth=64,matsize=4096
(
 input clk,
 input reset,
 input [arraysize-1:0] vector,  //softmax vector
 input [arraysize-1:0] matrix,  //vector from V matrix 
 output [arraysize-1:0] tmp
 );
  
/*always @(posedge clk) begin
	if(~reset) begin

	    vector <= data;
		matrix <= W;
    
	end
 end */
	 

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

 	
endmodule                    


module vecmat_add_32 #(parameter arraysize=512,parameter vectdepth=32)
 (
 input clk,reset,
 input [arraysize-1:0] mulout,
 output reg [15:0] data_out
 );
           
 wire [15:0] tmp0, tmp1 ,tmp2 ,tmp3 ,tmp4 ,tmp5 ,tmp6 ,tmp7 ,tmp8 ,tmp9 ,tmp10 ,tmp11 ,tmp12 ,tmp13 ,tmp14 ,tmp15 ,tmp16 ,tmp17 ,tmp18 ,tmp19 ,tmp20 ,tmp21 ,tmp22 ,tmp23 ,tmp24 ,tmp25 ,tmp26 ,tmp27 ,tmp28 ,tmp29 ,tmp30 ,tmp31 ,tmp32 ,tmp33 ,tmp34 ,tmp35 ,tmp36 ,tmp37 ,tmp38 ,tmp39 ,tmp40 ,tmp41 ,tmp42 ,tmp43 ,tmp44 ,tmp45 ,tmp46 ,tmp47 ,tmp48 ,tmp49 ,tmp50,tmp51 ,tmp52 ,tmp53,tmp54 ,tmp55 ,tmp56 ,tmp57 ,tmp58, tmp59 ,tmp60 ,tmp61,tmp62; 
 reg[31:0] i;
 reg [15:0] ff1,ff3,ff5,ff7,ff9,ff11,ff13,ff15,ff17,ff19,ff21,ff23,ff25,ff27,ff29,ff31;

 always @(posedge clk) begin
	if(~reset) begin
		data_out <= tmp57;

		//adding a flop pipeline stage
		ff1 <= tmp1;
		ff3 <= tmp3;
		ff5 <= tmp5;
		ff7 <= tmp7;
		ff9 <= tmp9;
		ff11 <= tmp11;
		ff13 <= tmp13;
		ff15 <= tmp15;
		end   
 end     
                                                        
        // fixed point addition  
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
	            
			qadd2 Add_u1(.a(tmp0),.b(tmp2),.c(tmp1));
			qadd2 Add_u3(.a(tmp4),.b(tmp6),.c(tmp3));
			qadd2 Add_u5(.a(tmp8),.b(tmp10),.c(tmp5));
			qadd2 Add_u7(.a(tmp12),.b(tmp14),.c(tmp7));
			qadd2 Add_u9(.a(tmp16),.b(tmp18),.c(tmp9));
			qadd2 Add_u11(.a(tmp20),.b(tmp22),.c(tmp11));
			qadd2 Add_u13(.a(tmp24),.b(tmp26),.c(tmp13));
			qadd2 Add_u15(.a(tmp28),.b(tmp30),.c(tmp15));
		
			qadd2 Add_u33(.a(ff1),.b(ff3),.c(tmp33));
			qadd2 Add_u35(.a(ff5),.b(ff7),.c(tmp35));
			qadd2 Add_u37(.a(ff9),.b(ff11),.c(tmp37));
			qadd2 Add_u39(.a(ff13),.b(ff15),.c(tmp39));

			qadd2 Add_u49(.a(tmp33),.b(tmp35),.c(tmp49));
			qadd2 Add_u51(.a(tmp37),.b(tmp39),.c(tmp51));
	
			qadd2 Add_u57(.a(tmp49),.b(tmp51),.c(tmp57));
					
endmodule
