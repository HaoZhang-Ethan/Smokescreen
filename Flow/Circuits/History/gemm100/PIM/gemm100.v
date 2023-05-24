`define varraysize 1600   //100x16
`define Size_H 100   
`define Size_W 100   
`define DATA_WIDTH 16
`define INPUT_DEPTH 16
`define ADD_BIT_MAT 7
`define ADD_BIT_VEC 1



function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction



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


reg [`ADD_BIT_MAT-1:0] waddr;
reg [`ADD_BIT_VEC-1:0] inaddr;
reg wren_a, inren_a;
wire [`varraysize-1:0] Wi_in;
wire [`varraysize-1:0] x_in;
wire [`DATA_WIDTH-1:0] macout_fx;
assign ht_out = macout_fx;
//BRAM of the input vectors to LSTM
spram_v Xi_mem(.clk(clk),.address_a(inaddr),.wren_a(inren_a),.data_a(dummyin_v),.out_a(x_in));
vecmat_mul_x #(`varraysize,`INPUT_DEPTH) f_gatex(.clk(clk),.reset(rst),.data(x_in),.Address(waddr),.tmp(macout_fx));




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
//  input [varraysize-1:0] W,
 //output reg [15:0] data_out
 input [`ADD_BIT_MAT-1:0] Address,
 output [`DATA_WIDTH-1:0] tmp
 );

 
// wire overflow [vectwidth-1:0];  


 //wire [15:0] tmp[vectwidth-1:0];


 reg [varraysize-1:0] vector;
 reg Flag;
 
   
 always @(posedge clk) begin
	if(~reset) begin
		vector <= data;
	end   
 end      


	conv_top #(.INPUT_SIZE(`varraysize/`DATA_WIDTH), .INPUT_P(`DATA_WIDTH), .DEPTH(`Size_W), .ADC_P(8), .OUT_P(`DATA_WIDTH)) PIM(
		.clk(clk), 
		.rst(rst),
		.Input_feature(vector),
		.Address(Address),
		.Output(tmp),	// size should increase to hold the sum of products
		.done_flag(Flag),
	);


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



// Parameter:
// INPUT_SIZE, the size of inpuit vector (default: 32), we use 64 for 32x32 crossbar
// DEPTH, the column of used crossbar
// ADC_P, ADC precision, we use 8 bits ADC
module conv_top #(parameter INPUT_SIZE = 32, INPUT_P = 8, DEPTH = 32, ADC_P = 4, OUT_P = 8) (
	input clk, 
	input rst,
	input [(INPUT_SIZE*INPUT_P)-1:0] Input_feature,
	input [clogb2(DEPTH)-1:0] Address,
	output [OUT_P-1:0] Output,	// size should increase to hold the sum of products
	output done_flag,
	);

	reg [INPUT_P/2-1:0] input_vector_H [INPUT_SIZE-1:0];
	reg [INPUT_P/2-1:0] input_vector_L [INPUT_SIZE-1:0];
	reg Compute_flag;
	// int i;
	genvar i;
	generate
		for (i = 0; i < INPUT_SIZE; i = i + 1) begin
			assign input_vector_H[i] = Input_feature[i*INPUT_P + (INPUT_P-1)  : i*INPUT_P + (INPUT_P/2-1)];
			assign input_vector_L[i] = Input_feature[i*INPUT_P + (INPUT_P/2-1) : i*INPUT_P + 0];
		end
	endgenerate

	wire [INPUT_SIZE-1:0] input_vector_bit_L;
	wire [INPUT_SIZE-1:0] input_vector_bit_H;
	reg done_flag;

	always @ (posedge clk) begin
		if (!rst) begin
			done_flag <= 1'b0;
			Compute_flag <= 1'b0;
		end else begin
			done_flag <= 1'b1;
			Compute_flag <= 1'b1;
		end
	end


	generate
		for (i = 0; i < INPUT_SIZE; i = i + 1) begin
			assign input_vector_bit_L[i] = input_vector_L[i][bit_counter];
			assign input_vector_bit_H[i] = input_vector_H[i][bit_counter];
		end
	endgenerate

//  HH Unit
	wire [ADC_P-1:0] resout_HH;
	conv #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(clogb2(DEPTH)), .ADC_P(ADC_P)) single_conv_HH(
		.Input_feature(input_vector_bit_H),
		.Address(Address),
		.en(Compute_flag),
		.Output(resout_HH),
		.clk(clk)
	);

//  HL Unit
	wire [ADC_P-1:0] resout_HL;
	conv #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(clogb2(DEPTH)), .ADC_P(ADC_P)) single_conv_HL(
		.Input_feature(input_vector_bit_H),
		.Address(Address),
		.en(Compute_flag),
		.Output(resout_HL),
		.clk(clk)
	);

//  LH Unit
	wire [ADC_P-1:0] resout_LH;
	conv #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(clogb2(DEPTH)), .ADC_P(ADC_P)) single_conv_LH(
		.Input_feature(input_vector_bit_L),
		.Address(Address),
		.en(Compute_flag),
		.Output(resout_LH),
		.clk(clk)
	);

//  LL Unit
	wire [ADC_P-1:0] resout_LL;
	conv #(.INPUT_SIZE(INPUT_SIZE), .DEPTH(clogb2(DEPTH)), .ADC_P(ADC_P)) single_conv_LL(
		.Input_feature(input_vector_bit_L),
		.Address(Address),
		.en(Compute_flag),
		.Output(resout_LL),
		.clk(clk)
	);

//  Adder Tree
	wire [ADC_P-1:0] tmp_out_1;
	wire [ADC_P-1:0] tmp_out_2;
	wire [ADC_P-1:0] tmp_out_3;
	qadd #(.BIT_WIDTH(ADC_P), .OUT_WIDTH(ADC_P)) qadd_inst_0(
	.a(resout_HH),
	.b(resout_HL),
	.c(tmp_out_1)
	);
	qadd #(.BIT_WIDTH(ADC_P), .OUT_WIDTH(ADC_P)) qadd_inst_1(
	.a(resout_LH),
	.b(resout_LL),
	.c(tmp_out_2)
	);
	qadd #(.BIT_WIDTH(ADC_P), .OUT_WIDTH(ADC_P)) qadd_inst_2(
	.a(tmp_out_1),
	.b(tmp_out_2),
	.c(tmp_out_3)
	);
	assign Output = tmp_out_3;
endmodule