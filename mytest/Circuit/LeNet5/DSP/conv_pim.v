module conv_pim #(parameter BIT_WIDTH = 8, OUT_WIDTH = 8, KERNEL_SIZE = 5, CHANNEL = 6, DEPTH = 8) (
		input clk, 
		input rst,
		input en,	// whether to latch or not
		input [(BIT_WIDTH*KERNEL_SIZE*CHANNEL)-1:0] input_feature,
        // input [(BIT_WIDTH*KERNEL_SIZE*KERNEL_SIZE*CHANNEL)-1:0] filter,	// 5x5x3 filter
		input [5:0] address,
        output [OUT_WIDTH-1:0] convValue	// size should increase to hold the sum of products
);


	reg [BIT_WIDTH*KERNEL_SIZE*KERNEL_SIZE-1:0] res [CHANNEL];
    genvar i;
    generate
	    for (i = 0; i < CHANNEL; i = i+1) begin : gen_input_reg
			conv55_input_reg #(.BIT_WIDTH(BIT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) input_reg(
				.clk(clk),
				.en(en),
				.in1(input_feature[(i*BIT_WIDTH*KERNEL_SIZE + 1 * BIT_WIDTH )-1: (i*BIT_WIDTH*KERNEL_SIZE + 0 * BIT_WIDTH )]),
				.in2(input_feature[(i*BIT_WIDTH*KERNEL_SIZE + 2 * BIT_WIDTH )-1: (i*BIT_WIDTH*KERNEL_SIZE + 1 * BIT_WIDTH )]),
				.in3(input_feature[(i*BIT_WIDTH*KERNEL_SIZE + 3 * BIT_WIDTH )-1: (i*BIT_WIDTH*KERNEL_SIZE + 2 * BIT_WIDTH )]),
				.in4(input_feature[(i*BIT_WIDTH*KERNEL_SIZE + 4 * BIT_WIDTH )-1: (i*BIT_WIDTH*KERNEL_SIZE + 3 * BIT_WIDTH )]),
				.in5(input_feature[(i*BIT_WIDTH*KERNEL_SIZE + 5 * BIT_WIDTH )-1: (i*BIT_WIDTH*KERNEL_SIZE + 4 * BIT_WIDTH )]),
				.res(res[i])	// size should increase to hold the sum of products
			);
		end
	endgenerate

	reg [KERNEL_SIZE*KERNEL_SIZE*CHANNEL-1:0] input_feature_reg_H;
	reg [KERNEL_SIZE*KERNEL_SIZE*CHANNEL-1:0] input_feature_reg_L;
    reg [5:0] count;
    always @(posedge clk) begin
        if (count == 4) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
        case(count)
            0: begin	
				input_feature_reg_H <= {res[0]};
				input_feature_reg_L <= {res[1]};
			end
			1:	begin	
				input_feature_reg_H <= {res[2]};
				input_feature_reg_L <= {res[3]};
			end
			2:	begin	
				input_feature_reg_H <= {res[4]};
				input_feature_reg_L <= {res[5]};
			end
			
			3:	begin	
				input_feature_reg_H <= {res[0]};
				input_feature_reg_L <= {res[1]};
			end

        endcase
    end

	wire [BIT_WIDTH-1:0] conv_out_1;
	wire [BIT_WIDTH-1:0] conv_out_2;	
	pim_conv_line_s #(.SIZE(KERNEL_SIZE*KERNEL_SIZE*CHANNEL),.DEPTH(DEPTH)) pim_conv_line_s_inst_H(
		.clk(clk),
		.rst(rst),
		.en(en),
		.input_feature(input_feature_reg_H),
		.address(address),
		.convValue(conv_out_1) 
	);
		
	pim_conv_line_s #(.SIZE(KERNEL_SIZE*KERNEL_SIZE*CHANNEL),.DEPTH(DEPTH)) pim_conv_line_s_inst_L(
		.clk(clk),
		.rst(rst),
		.en(en),
		.input_feature(input_feature_reg_L),
		.address(address),
		.convValue(conv_out_2) 
	);

	qadd #(.BIT_WIDTH(8), .OUT_WIDTH(8)) qadd_inst(
		.a(conv_out_1),
		.b(conv_out_2),
		.c(convValue)
	);

	
endmodule
