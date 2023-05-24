`define varraysize 160   //100x16
`define Size_H 10   
`define Size_W 10   
`define DATA_WIDTH 16
`define INPUT_DEPTH 16
`define ADD_BIT_MAT 4
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

 endmodule

 module vecmat_add_x #(parameter varraysize=1600,vectwidth=100) 
 (
 input clk,reset,
 input [varraysize-1:0] mulout,
 output reg [15:0] data_out
 );
          
 	wire [15:0] tmp0, tmp1 ,tmp2 ,tmp3 ,tmp4 ,tmp5 ,tmp6 ,tmp7; 



	qadd2 Add_u0(.a(mulout[16*0+:16]),.b(mulout[16*1+:16]),.c(tmp0));
	qadd2 Add_u2(.a(mulout[16*2+:16]),.b(mulout[16*3+:16]),.c(tmp1));
	qadd2 Add_u4(.a(mulout[16*4+:16]),.b(mulout[16*5+:16]),.c(tmp2));
	qadd2 Add_u6(.a(mulout[16*6+:16]),.b(mulout[16*7+:16]),.c(tmp3));
	qadd2 Add_u8(.a(mulout[16*8+:16]),.b(mulout[16*9+:16]),.c(tmp4));
	
	
		
	qadd2 Add_u1(.a(tmp0),.b(tmp1),.c(tmp5));
	qadd2 Add_u3(.a(tmp2),.b(tmp3),.c(tmp6));

	
	qadd2 Add_u51(.a(tmp5),.b(tmp6),.c(tmp7));
	qadd2 Add_u52(.a(tmp7),.b(tmp4),.c(data_out));
			
		
									
	   
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

reg [15:0] a_ff;
reg [15:0] b_ff;
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

defparam u_single_port_ram.ADDR_WIDTH = `ADD_BIT_MAT;
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



