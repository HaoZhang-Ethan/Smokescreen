function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction

// `define IMAGE_COLS 32
// `define AWIDTH clogb2(IMAGE_COLS)
// `define SP_BRAM 4
// `define BRAM_SEL IMAGE_COLS/SP_BRAM
module lenet5 #(parameter IN_WIDTH = 8, OUT_WIDTH = 8, IMAGE = 32, SP_BRAM = 4, KERNEL_SIZE = 5,  BRAM_NUM_C = 8 , BRAM_NUM_F = 1) (
	input clk, rst,
    input start,
	input signed[IN_WIDTH-1:0] nextPixel,
    input clk_mem,
    input load_down,
    output reg done,
    input   bram_select_en,
    input   [clogb2(IMAGE)-1:0] bram_addr_f,
    input   [KERNEL_SIZE*IN_WIDTH-1:0] bram_data_f,
    input   [BRAM_NUM_C-1:0]  bram_select_c,
    input   [8:0] bram_addr_c,
    input   [KERNEL_SIZE*KERNEL_SIZE-1:0] bram_data_c,
    input   C1_en,
    input   S2_en,
    input   C3_en,
    input   S4_en,
    input   C5_en,

    // input  [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_wdata_ext,
    // input  [`MAT_MUL_SIZE-1:0] bram_we_ext,
    output [3:0] out,	// the predicted digit
    output  [8-1:0] tmp_out
    );
 
/*/----parameters----/*/
    parameter HALF_WIDTH = 8;	// fixed-8 precision

    parameter C1_SIZE = 28; //10;	//28;
    parameter S2_SIZE = 14; //5;	//14;
    parameter C3_SIZE = 10; //1;	//10;
    parameter S4_SIZE = 5; //0; //5;
    parameter F6_OUT = 84;
    parameter LAST_OUT = 10;	// no. outputs

    parameter C1_MAPS = 6;
    parameter C1_STAGE = 6;
    parameter C3_MAPS = 16;
    parameter C5_MAPS = 120;

    parameter CONV_SIZE = 25;	// all convolutions are 5x5 filters, bias not counted
    parameter CONV_SIZE_3 = 3*CONV_SIZE;	// no. params in 5x5x3 filters, bias not counted
    parameter CONV_SIZE_4 = 4*CONV_SIZE;	// no. params in 5x5x4 filters, bias not counted
    parameter CONV_SIZE_6 = 6*CONV_SIZE;	// no. params in 5x5x6 filters, bias not counted
    parameter CONV_SIZE_16 = 16*CONV_SIZE;	// no. params in 5x5x6 filters, bias not counted


/*/------------------ LOAD FEATURE MAP AND WEIGHT TO BRAM  ------------------/*/
    // load the feature map to bram
    wire [KERNEL_SIZE*IN_WIDTH-1:0] read_feature_out_1;
    wire [KERNEL_SIZE*IN_WIDTH-1:0] read_feature_out_2;
    dual_port_ram #(.ADDR_WIDTH(clogb2(IMAGE)), .DATA_WIDTH(KERNEL_SIZE*IN_WIDTH)) ram_input_feature (
        .clk(clk_mem),
        .we1(bram_select_en),
        .we2(bram_select_en),
        .addr1(bram_addr_f),
        .addr2(bram_addr_f),
        .data1(bram_data_f),
        .data2(bram_data_f),
        .out1(read_feature_out_1),
        .out2(read_feature_out_2)
    );

    // KERNEL C1 551 6
    wire [CONV_SIZE*IN_WIDTH-1:0] tmp_out_551_6;
    rom_params_bram #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE)) rom_kernel_551_6 (
        .clk(clk),
        .addr(bram_addr_f[2:0]),
        .out(tmp_out_551_6)
    );

    // KERNEL C3 553 6 
    wire [CONV_SIZE_3*IN_WIDTH-1:0] tmp_out_553_6;
    rom_params_bram #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE_3)) rom_kernel_553_6 (
        .clk(clk),
        .addr(bram_addr_f[2:0]),
        .out(tmp_out_553_6)
    );

    // KERNEL C3 554 6
    wire [CONV_SIZE_4*IN_WIDTH-1:0] tmp_out_554_6;
    rom_params_bram #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE_4)) rom_kernel_554_6 (
        .clk(clk),
        .addr(bram_addr_f[2:0]),
        .out(tmp_out_554_6)
    );

    // KERNEL C3 554 3
    wire [CONV_SIZE_4*IN_WIDTH-1:0] tmp_out_554_3;
    rom_params_bram #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE_4)) rom_kernel_554_3 (
        .clk(clk),
        .addr(bram_addr_f[2:0]),
        .out(tmp_out_554_3)
    );

    // KERNEL C3 556 1
    wire [CONV_SIZE_6*IN_WIDTH-1:0] tmp_out_556_1;
    rom_params_bram #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE_6)) rom_kernel_556_1 (
        .clk(clk),
        .addr(bram_addr_f[2:0]),
        .out(tmp_out_556_1)
    );

    // KERNEL C5 5516 120
    wire [CONV_SIZE_16*IN_WIDTH-1:0] tmp_out_5516_120;
    rom_params_bram #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE_16)) rom_kernel_5516_120 (
        .clk(clk),
        .addr(bram_addr_f[2:0]),
        .out(tmp_out_5516_120)
    );

/*/------------------ CALCULATE  ------------------/*/


    /*/------------------ C1: 6 feature maps; convolution, stride = 1  ------------------/*/
    // wire c1_en;
    wire [IN_WIDTH-1:0] c1_out_1;
    wire [IN_WIDTH-1:0] c1_relu_out_1;
    convn #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .KERNEL_SIZE(KERNEL_SIZE), .CHANNEL(1)) C1_DSP(
        .clk(clk),
        .en(C1_en),
        .input_feature(read_feature_out_2),
        .filter(tmp_out_551_6),
        .convValue(c1_out_1) 
    );
    // assign C1_convPlusBias[g] = C1_convOut[g] + rom_c1[IN_WIDTH*((g+1)*SIZE)-1 : IN_WIDTH*((g+1)*SIZE-1)];

    // // C1 activation layer (ReLU)
    wire [IN_WIDTH-1:0] c1_out_2;
    relu #(.BIT_WIDTH(IN_WIDTH)) C1_RELU (
        .in(c1_out_1), .out(c1_out_2)
    );

    
    reg [IN_WIDTH-1:0] C1_relu_1 [C1_MAPS];
    reg [IN_WIDTH-1:0] C1_relu_2 [C1_MAPS];
    reg [5:0] c1_buf_count;
    always @(posedge clk) begin
        if (c1_buf_count == 12) begin
            c1_buf_count <= 0;
        end else begin
            c1_buf_count <= c1_buf_count + 1;
        end
        case(c1_buf_count)
            0:	C1_relu_1[0] <= c1_out_2;
			1:	C1_relu_1[1] <= c1_out_2;
			2:	C1_relu_1[2] <= c1_out_2;
			3:	C1_relu_1[3] <= c1_out_2;
			4:	C1_relu_1[4] <= c1_out_2;
			5:	C1_relu_1[5] <= c1_out_2;
            6:	C1_relu_2[0] <= c1_out_2;
			7:	C1_relu_2[1] <= c1_out_2;
			8:	C1_relu_2[2] <= c1_out_2;
			9:	C1_relu_2[3] <= c1_out_2;
			10:	C1_relu_2[4] <= c1_out_2;
			11:	C1_relu_2[5] <= c1_out_2;
        endcase
    end

    
    // holds output of rowbuffer for C1 -> S2
    wire [IN_WIDTH-1:0] rb_C1S2_1[0:C1_MAPS-1];	// 6 maps * 1 row - 1 = 5
    wire [IN_WIDTH-1:0] rb_C1S2_2[0:C1_MAPS-1];	// 6 maps * 1 row - 1 = 5
    // C1 feature map; next pixel to buffer for S2
    genvar g;
    generate
        for (g = 0; g < C1_MAPS; g = g+1) begin : C1_rb_1	// 6 feature maps
            rowbuffer #(.COLS(C1_SIZE), .BIT_WIDTH(IN_WIDTH)) C1_RB_1 (
                .clk(clk), .rst(rst),
                .rb_in(C1_relu_1[g]),
                .en(S2_en),
                .rb_out(rb_C1S2_1[g])
            );
        end
    endgenerate

    generate
        for (g = 0; g < C1_MAPS; g = g+1) begin : C1_rb_2	// 6 feature maps
            rowbuffer #(.COLS(C1_SIZE), .BIT_WIDTH(IN_WIDTH)) C1_RB_2 (
                .clk(clk), .rst(rst),
                .rb_in(C1_relu_2[g]),
                .en(S2_en),
                .rb_out(rb_C1S2_2[g])
            );
        end
    endgenerate

  
    /*/------------------ S2: 6 feature maps; max pooling, stride = 2  ------------------/*/

    // S2: 6 feature maps; max pooling, stride = 2
    wire signed[IN_WIDTH-1:0] S2_poolOut[0:C1_MAPS-1];	// outputs of pooling

    // max pooling modules
    generate
        for (g = 0; g < 6; g = g+1) begin : S2_op
            maxpool22 #(.BIT_WIDTH(HALF_WIDTH)) S2_POOL (
                .clk(clk), //.rst(rst),
                .en(S2_en),
                .in1(rb_C1S2_1[g]), .in2(rb_C1S2_2[g]),
                .maxOut(S2_poolOut[g])
            );
        end
    endgenerate
      

    // use S2_en for end-of-S2 rowbuffer as well as max pooling modules

    // holds output of rowbuffer for S2 -> C3
    wire signed[IN_WIDTH-1:0] rb_S2C3[0:C1_MAPS*4-1];	// 6 maps * 4 rows - 1 = 23
    generate
        for (g = 0; g < C1_MAPS; g = g+1) begin : S2_rb	// 6 feature maps
            row4buffer #(.COLS(S2_SIZE), .BIT_WIDTH(IN_WIDTH)) S2_RB (
                .clk(clk), .rst(rst),
                .rb_in(S2_poolOut[g]),
                .en(C3_en),
                .rb_out0(rb_S2C3[g*4]), .rb_out1(rb_S2C3[g*4+1]), .rb_out2(rb_S2C3[g*4+2]), .rb_out3(rb_S2C3[g*4+3])
            );
        end
    endgenerate
//   assign tmp_out = S2_poolOut[0];
    /*/------------------ C3: 16 feature maps; convolution, stride = 1  ------------------/*/
    // C3: 16 feature maps; convolution, stride = 1
    wire signed[IN_WIDTH-1:0] C3_convOut[0:C3_MAPS-1];	// 16 outputs of convolution from layer C1
    wire signed[IN_WIDTH-1:0] C3_relu_1[0:C3_MAPS-1];	// 16 outputs of ReLU function
    wire signed[IN_WIDTH-1:0] C3_relu_2[0:C3_MAPS-1];	// 16 outputs of ReLU function

    
    reg [3*KERNEL_SIZE*IN_WIDTH-1:0] read_feature_from_s2_5536;
    wire [IN_WIDTH-1:0] c3_out_5536;
    reg [4*KERNEL_SIZE*IN_WIDTH-1:0] read_feature_from_s2_5546;
    wire [IN_WIDTH-1:0] c3_out_5546;
    reg [3*KERNEL_SIZE*IN_WIDTH-1:0] read_feature_from_s2_5543;
    wire [IN_WIDTH-1:0] c3_out_5543;
    reg [4*KERNEL_SIZE*IN_WIDTH-1:0] read_feature_from_s2_5561;
    wire [IN_WIDTH-1:0] c3_out_5561;

    reg signed[IN_WIDTH-1:0] C3_relu_1[0:C3_MAPS-1];	// 16 outputs of ReLU function

    wire [IN_WIDTH-1:0] tmp[4];
    reg [3:0] counter;
    reg [3:0] counter1;
    always @(posedge clk) begin
        if (counter == 11 || rst == 0)  begin
            counter <= 0;
            counter1 <= 0;
            if (counter1 == 6) begin
                counter1 <= 0;
            end else begin
                counter1 <= counter1 + 1;
                counter <= counter + 1;
                case(counter1)
                    0:	begin
                        read_feature_from_s2_5536 <= {rb_S2C3[0*4+3], rb_S2C3[0*4+2], rb_S2C3[0*4+1], rb_S2C3[0*4+0], S2_poolOut[0], rb_S2C3[1*4+3], rb_S2C3[1*4+2], rb_S2C3[1*4+1], rb_S2C3[1*4+0], S2_poolOut[1], rb_S2C3[2*4+3], rb_S2C3[2*4+2], rb_S2C3[2*4+1], rb_S2C3[2*4+0], S2_poolOut[2]};
                        read_feature_from_s2_5546 <= {rb_S2C3[0*4+3], rb_S2C3[0*4+2], rb_S2C3[0*4+1], rb_S2C3[0*4+0], S2_poolOut[0], rb_S2C3[1*4+3], rb_S2C3[1*4+2], rb_S2C3[1*4+1], rb_S2C3[1*4+0], S2_poolOut[1], rb_S2C3[2*4+3], rb_S2C3[2*4+2], rb_S2C3[2*4+1], rb_S2C3[2*4+0], S2_poolOut[2], rb_S2C3[3*4+3], rb_S2C3[3*4+2], rb_S2C3[3*4+1], rb_S2C3[3*4+0], S2_poolOut[3]};
                        read_feature_from_s2_5543 <= {rb_S2C3[0*4+3], rb_S2C3[0*4+2], rb_S2C3[0*4+1], rb_S2C3[0*4+0], S2_poolOut[0], rb_S2C3[1*4+3], rb_S2C3[1*4+2], rb_S2C3[1*4+1], rb_S2C3[1*4+0], S2_poolOut[1], rb_S2C3[2*4+3], rb_S2C3[2*4+2], rb_S2C3[2*4+1], rb_S2C3[2*4+0], S2_poolOut[2], rb_S2C3[3*4+3], rb_S2C3[3*4+2], rb_S2C3[3*4+1], rb_S2C3[3*4+0], S2_poolOut[3]};
                        read_feature_from_s2_5561 <= {rb_S2C3[0*4+3], rb_S2C3[0*4+2], rb_S2C3[0*4+1], rb_S2C3[0*4+0], S2_poolOut[0], rb_S2C3[1*4+3], rb_S2C3[1*4+2], rb_S2C3[1*4+1], rb_S2C3[1*4+0], S2_poolOut[1], rb_S2C3[2*4+3], rb_S2C3[2*4+2], rb_S2C3[2*4+1], rb_S2C3[2*4+0], S2_poolOut[2], rb_S2C3[3*4+3], rb_S2C3[3*4+2], rb_S2C3[3*4+1], rb_S2C3[3*4+0], S2_poolOut[3], rb_S2C3[4*4+3], rb_S2C3[4*4+2], rb_S2C3[4*4+1], rb_S2C3[4*4+0], S2_poolOut[4], rb_S2C3[5*4+3], rb_S2C3[5*4+2], rb_S2C3[5*4+1], rb_S2C3[5*4+0], S2_poolOut[5]};
                        if (counter <6 ) begin
                            C3_relu_1[0] <= c3_relu_out_5536;
                            C3_relu_1[6] <= c3_relu_out_5546;
                            C3_relu_1[12] <= c3_relu_out_5543; 
                            C3_relu_1[15] <= c3_relu_out_5561; 
                        end else begin 
                            C3_relu_2[0] <= c3_relu_out_5536;
                            C3_relu_2[6] <= c3_relu_out_5546;
                            C3_relu_2[12] <= c3_relu_out_5543; 
                            C3_relu_2[15] <= c3_relu_out_5561; 
                        end
                    end
                    1:	begin
                        read_feature_from_s2_5536 <= {rb_S2C3[1*4+3], rb_S2C3[1*4+2], rb_S2C3[1*4+1], rb_S2C3[1*4+0], S2_poolOut[1], rb_S2C3[2*4+3], rb_S2C3[2*4+2], rb_S2C3[2*4+1], rb_S2C3[2*4+0], S2_poolOut[2], rb_S2C3[3*4+3], rb_S2C3[3*4+2], rb_S2C3[3*4+1], rb_S2C3[3*4+0], S2_poolOut[3]};
                        read_feature_from_s2_5546 <= {rb_S2C3[1*4+3], rb_S2C3[1*4+2], rb_S2C3[1*4+1], rb_S2C3[1*4+0], S2_poolOut[1], rb_S2C3[2*4+3], rb_S2C3[2*4+2], rb_S2C3[2*4+1], rb_S2C3[2*4+0], S2_poolOut[2], rb_S2C3[3*4+3], rb_S2C3[3*4+2], rb_S2C3[3*4+1], rb_S2C3[3*4+0], S2_poolOut[3], rb_S2C3[4*4+3], rb_S2C3[4*4+2], rb_S2C3[4*4+1], rb_S2C3[4*4+0], S2_poolOut[4]};
                        read_feature_from_s2_5543 <= {rb_S2C3[1*4+3], rb_S2C3[1*4+2], rb_S2C3[1*4+1], rb_S2C3[1*4+0], S2_poolOut[1], rb_S2C3[2*4+3], rb_S2C3[2*4+2], rb_S2C3[2*4+1], rb_S2C3[2*4+0], S2_poolOut[2], rb_S2C3[3*4+3], rb_S2C3[3*4+2], rb_S2C3[3*4+1], rb_S2C3[3*4+0], S2_poolOut[3], rb_S2C3[4*4+3], rb_S2C3[4*4+2], rb_S2C3[4*4+1], rb_S2C3[4*4+0], S2_poolOut[4]};
                        if (counter <6 ) begin
                            C3_relu_1[1] <= c3_relu_out_5536;
                            C3_relu_1[7] <= c3_relu_out_5546;
                            C3_relu_1[13] <= c3_relu_out_5543; 
                        end else begin 
                            C3_relu_2[1] <= c3_relu_out_5536;
                            C3_relu_2[7] <= c3_relu_out_5546;
                            C3_relu_2[13] <= c3_relu_out_5543; 
                        end
                    end
                    2:  begin	
                        read_feature_from_s2_5536 <= {rb_S2C3[2*4+3], rb_S2C3[2*4+2], rb_S2C3[2*4+1], rb_S2C3[2*4+0], S2_poolOut[2], rb_S2C3[3*4+3], rb_S2C3[3*4+2], rb_S2C3[3*4+1], rb_S2C3[3*4+0], S2_poolOut[3], rb_S2C3[4*4+3], rb_S2C3[4*4+2], rb_S2C3[4*4+1], rb_S2C3[4*4+0], S2_poolOut[4]};
                        read_feature_from_s2_5546 <= {rb_S2C3[2*4+3], rb_S2C3[2*4+2], rb_S2C3[2*4+1], rb_S2C3[2*4+0], S2_poolOut[2], rb_S2C3[3*4+3], rb_S2C3[3*4+2], rb_S2C3[3*4+1], rb_S2C3[3*4+0], S2_poolOut[3], rb_S2C3[4*4+3], rb_S2C3[4*4+2], rb_S2C3[4*4+1], rb_S2C3[4*4+0], S2_poolOut[4], rb_S2C3[5*4+3], rb_S2C3[5*4+2], rb_S2C3[5*4+1], rb_S2C3[5*4+0], S2_poolOut[5]};
                        read_feature_from_s2_5543 <= {rb_S2C3[2*4+3], rb_S2C3[2*4+2], rb_S2C3[2*4+1], rb_S2C3[2*4+0], S2_poolOut[2], rb_S2C3[3*4+3], rb_S2C3[3*4+2], rb_S2C3[3*4+1], rb_S2C3[3*4+0], S2_poolOut[3], rb_S2C3[4*4+3], rb_S2C3[4*4+2], rb_S2C3[4*4+1], rb_S2C3[4*4+0], S2_poolOut[4], rb_S2C3[5*4+3], rb_S2C3[5*4+2], rb_S2C3[5*4+1], rb_S2C3[5*4+0], S2_poolOut[5]};
                        if (counter <6 ) begin
                            C3_relu_1[2] <= c3_relu_out_5536;
                            C3_relu_1[8] <= c3_relu_out_5546;
                            C3_relu_1[14] <= c3_relu_out_5543; 
                        end else begin
                            C3_relu_2[2] <= c3_relu_out_5536;
                            C3_relu_2[8] <= c3_relu_out_5546;
                            C3_relu_2[14] <= c3_relu_out_5543; 
                        end
                    end
                    3:  begin	
                        read_feature_from_s2_5536 <= {rb_S2C3[3*4+3], rb_S2C3[3*4+2], rb_S2C3[3*4+1], rb_S2C3[3*4+0], S2_poolOut[3], rb_S2C3[4*4+3], rb_S2C3[4*4+2], rb_S2C3[4*4+1], rb_S2C3[4*4+0], S2_poolOut[4], rb_S2C3[5*4+3], rb_S2C3[5*4+2], rb_S2C3[5*4+1], rb_S2C3[5*4+0], S2_poolOut[5]};
                        read_feature_from_s2_5546 <= {rb_S2C3[3*4+3], rb_S2C3[3*4+2], rb_S2C3[3*4+1], rb_S2C3[3*4+0], S2_poolOut[3], rb_S2C3[4*4+3], rb_S2C3[4*4+2], rb_S2C3[4*4+1], rb_S2C3[4*4+0], S2_poolOut[4], rb_S2C3[5*4+3], rb_S2C3[5*4+2], rb_S2C3[5*4+1], rb_S2C3[5*4+0], S2_poolOut[5], rb_S2C3[0*4+3], rb_S2C3[0*4+2], rb_S2C3[0*4+1], rb_S2C3[0*4+0], S2_poolOut[0]};
                        if (counter <6 ) begin
                            C3_relu_1[3] <= c3_relu_out_5536;
                            C3_relu_1[9] <= c3_relu_out_5546;
                        end else begin
                            C3_relu_2[3] <= c3_relu_out_5536;
                            C3_relu_2[9] <= c3_relu_out_5546;
                        end
                    end
                    4:  begin	
                        read_feature_from_s2_5536 <= {rb_S2C3[4*4+3], rb_S2C3[4*4+2], rb_S2C3[4*4+1], rb_S2C3[4*4+0], S2_poolOut[4], rb_S2C3[5*4+3], rb_S2C3[5*4+2], rb_S2C3[5*4+1], rb_S2C3[5*4+0], S2_poolOut[5], rb_S2C3[0*4+3], rb_S2C3[0*4+2], rb_S2C3[0*4+1], rb_S2C3[0*4+0], S2_poolOut[0]};
                        read_feature_from_s2_5546 <= {rb_S2C3[4*4+3], rb_S2C3[4*4+2], rb_S2C3[4*4+1], rb_S2C3[4*4+0], S2_poolOut[4], rb_S2C3[5*4+3], rb_S2C3[5*4+2], rb_S2C3[5*4+1], rb_S2C3[5*4+0], S2_poolOut[5], rb_S2C3[0*4+3], rb_S2C3[0*4+2], rb_S2C3[0*4+1], rb_S2C3[0*4+0], S2_poolOut[0], rb_S2C3[1*4+3], rb_S2C3[1*4+2], rb_S2C3[1*4+1], rb_S2C3[1*4+0], S2_poolOut[1]};
                        if (counter <6 ) begin
                            C3_relu_1[4] <= c3_relu_out_5536;
                            C3_relu_1[10] <= c3_relu_out_5546;
                        end else begin
                            C3_relu_2[4] <= c3_relu_out_5536;
                            C3_relu_2[10] <= c3_relu_out_5546;
                        end
                    end
                    5:  begin	
                        read_feature_from_s2_5536 <= {rb_S2C3[5*4+3], rb_S2C3[5*4+2], rb_S2C3[5*4+1], rb_S2C3[5*4+0], S2_poolOut[5], rb_S2C3[0*4+3], rb_S2C3[0*4+2], rb_S2C3[0*4+1], rb_S2C3[0*4+0], S2_poolOut[0], rb_S2C3[1*4+3], rb_S2C3[1*4+2], rb_S2C3[1*4+1], rb_S2C3[1*4+0], S2_poolOut[1]};
                        read_feature_from_s2_5546 <= {rb_S2C3[5*4+3], rb_S2C3[5*4+2], rb_S2C3[5*4+1], rb_S2C3[5*4+0], S2_poolOut[5], rb_S2C3[0*4+3], rb_S2C3[0*4+2], rb_S2C3[0*4+1], rb_S2C3[0*4+0], S2_poolOut[0], rb_S2C3[1*4+3], rb_S2C3[1*4+2], rb_S2C3[1*4+1], rb_S2C3[1*4+0], S2_poolOut[1], rb_S2C3[2*4+3], rb_S2C3[2*4+2], rb_S2C3[2*4+1], rb_S2C3[2*4+0], S2_poolOut[2]};
                        if (counter <6 ) begin
                            C3_relu_1[5] <= c3_relu_out_5536;
                            C3_relu_1[11] <= c3_relu_out_5546;
                        end else begin
                            C3_relu_2[5] <= c3_relu_out_5536;
                            C3_relu_2[11] <= c3_relu_out_5546;
                        end
                    end
                endcase
            end
        end
    end
    convn #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .KERNEL_SIZE(KERNEL_SIZE), .CHANNEL(3)) C3_DSP_5536(
        .clk(clk),
        .en(C3_en),
        .input_feature(read_feature_from_s2_5536),
        .filter(tmp_out_553_6),
        .convValue(c3_out_5536) 
    );
    
    // // C3 activation layer (ReLU)
    wire [IN_WIDTH-1:0] c3_relu_out_5536;
    relu #(.BIT_WIDTH(IN_WIDTH)) C3_RELU_5536 (
        .in(c3_out_5536), .out(c3_relu_out_5536)
    );

    

    convn #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .KERNEL_SIZE(KERNEL_SIZE), .CHANNEL(4)) C3_DSP_5546(
        .clk(clk),
        .en(C3_en),
        .input_feature(read_feature_from_s2_5546),
        .filter(tmp_out_554_6),
        .convValue(c3_out_5546) 
    );
    
    // // C1 activation layer (ReLU)
    wire [IN_WIDTH-1:0] c3_relu_out_5546;
    relu #(.BIT_WIDTH(IN_WIDTH)) C3_RELU_5546 (
        .in(c3_out_5546), .out(c3_relu_out_5546)
    );



    convn #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .KERNEL_SIZE(KERNEL_SIZE), .CHANNEL(4)) C3_DSP_5543(
        .clk(clk),
        .en(C3_en),
        .input_feature(read_feature_from_s2_5543),
        .filter(tmp_out_554_3),
        .convValue(c3_out_5543) 
    );
    
    // // C1 activation layer (ReLU)
    wire [IN_WIDTH-1:0] c3_relu_out_5543;
    relu #(.BIT_WIDTH(IN_WIDTH)) C3_RELU_5543 (
        .in(c3_out_5543), .out(c3_relu_out_5543)
    );

    convn #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .KERNEL_SIZE(KERNEL_SIZE), .CHANNEL(6)) C3_DSP_5561(
        .clk(clk),
        .en(C3_en),
        .input_feature(read_feature_from_s2_5561),
        .filter(tmp_out_556_1),
        .convValue(c3_out_5561) 
    );
    
    // // C1 activation layer (ReLU)
    wire [IN_WIDTH-1:0] c3_relu_out_5561;
    relu #(.BIT_WIDTH(IN_WIDTH)) C1_RELU_5561 (
        .in(c3_out_5561), .out(c3_relu_out_5561)
    );



    // holds output of rowbuffer for C3 -> S4
    wire [OUT_WIDTH-1:0] rb_C3S4_1[0:C3_MAPS-1];	// 16 * 1 rows - 1 = 15

    // C3 feature map; next pixel to buffer for S4
    generate
        for (g = 0; g < C3_MAPS; g = g+1) begin : C3_rb_1	// 16 feature maps
            rowbuffer #(.COLS(C3_SIZE), .BIT_WIDTH(OUT_WIDTH)) C3_RB_1 (
                .clk(clk), .rst(rst),
                .rb_in(C3_relu_1[g]),
                .en(S4_en),
                .rb_out(rb_C3S4_1[g])
            );
        end
    endgenerate

    // holds output of rowbuffer for C3 -> S4
    wire [OUT_WIDTH-1:0] rb_C3S4_2[0:C3_MAPS-1];	// 16 * 1 rows - 1 = 15

    // C3 feature map; next pixel to buffer for S4
    generate
        for (g = 0; g < C3_MAPS; g = g+1) begin : C3_rb_2	// 16 feature maps
            rowbuffer #(.COLS(C3_SIZE), .BIT_WIDTH(OUT_WIDTH)) C3_RB_2 (
                .clk(clk), .rst(rst),
                .rb_in(C3_relu_2[g]),
                .en(S4_en),
                .rb_out(rb_C3S4_2[g])
            );
        end
    endgenerate


    /*/------------------ S4: 16 feature maps; max pooling, stride = 2  ------------------/*/

    // S4: 16 feature maps; max pooling, stride = 2
    wire signed[OUT_WIDTH-1:0] S4_poolOut[0:C3_MAPS-1];	// outputs of pooling

    // max pooling modules
    generate
        for (g = 0; g < 16; g = g+1) begin : S4_op
            maxpool22 #(.BIT_WIDTH(OUT_WIDTH)) S4_POOL (
                .clk(clk), //.rst(rst),
                .en(S4_en),
                .in1(rb_C3S4_1[g]), .in2(rb_C3S4_2[g]),
                .maxOut(S4_poolOut[g])
            );
        end
    endgenerate

    // use S4_en for end-of-S4 rowbuffer as well as max pooling modules

    // holds output of rowbuffer for S4 -> C5
    // 16 maps; 16*4 rows of 32-bit wires in total
    wire [OUT_WIDTH-1:0] rb_S4C5_r0[0:C3_MAPS-1], rb_S4C5_r1[0:C3_MAPS-1], rb_S4C5_r2[0:C3_MAPS-1], rb_S4C5_r3[0:C3_MAPS-1];
    generate
        for (g = 0; g < C3_MAPS; g = g+1) begin : S4_rb
            row4buffer #(.COLS(S4_SIZE), .BIT_WIDTH(OUT_WIDTH)) S4_RB (
                .clk(clk), .rst(rst),
                .rb_in(S4_poolOut[g]),
                .en(C5_en),
                .rb_out0(rb_S4C5_r0[g]), .rb_out1(rb_S4C5_r1[g]), .rb_out2(rb_S4C5_r2[g]), .rb_out3(rb_S4C5_r3[g])
            );
        end
    endgenerate


    /*/------------------ C5: 120 feature maps; convolution, stride = 1  ------------------/*/


    // C5: 120 feature maps, convolution, stride = 1
    parameter C5_HALF = 60;	// half no. feature maps
    // C5 feature maps: take inputs from all 16 feature maps
    wire [OUT_WIDTH-1:0] C5_convOut[0:C5_MAPS-1];	// outputs of convolution from layer C1
    reg [OUT_WIDTH-1:0] C5C6_reg[0:C5_MAPS-1];	// outputs of ReLU function
    reg [8:0] counter_C5 = 0;	// counter for C5 feature maps
    always @(posedge clk) begin
        if (counter_C5 == 120 || rst == 0)  begin
            counter_C5 <= 0;
        end else begin
            counter_C5 <= counter_C5 + 1;
            case(counter_C5)
                0:	C5C6_reg[0] <= c5_relu_out_5516_120;
                1:	C5C6_reg[1] <= c5_relu_out_5516_120;
                2:	C5C6_reg[2] <= c5_relu_out_5516_120; 
                3:	C5C6_reg[3] <= c5_relu_out_5516_120;
                4:	C5C6_reg[4] <= c5_relu_out_5516_120;
                5:	C5C6_reg[5] <= c5_relu_out_5516_120;
                6:	C5C6_reg[6] <= c5_relu_out_5516_120;
                7:	C5C6_reg[7] <= c5_relu_out_5516_120;
                8:	C5C6_reg[8] <= c5_relu_out_5516_120;
                9:	C5C6_reg[9] <= c5_relu_out_5516_120;
                10:	C5C6_reg[10] <= c5_relu_out_5516_120;
                11:	C5C6_reg[11] <= c5_relu_out_5516_120;
                12:	C5C6_reg[12] <= c5_relu_out_5516_120;
                13:	C5C6_reg[13] <= c5_relu_out_5516_120;
                14:	C5C6_reg[14] <= c5_relu_out_5516_120;
                15:	C5C6_reg[15] <= c5_relu_out_5516_120;
                16:	C5C6_reg[16] <= c5_relu_out_5516_120;
                17:	C5C6_reg[17] <= c5_relu_out_5516_120;
                18:	C5C6_reg[18] <= c5_relu_out_5516_120;
                19:	C5C6_reg[19] <= c5_relu_out_5516_120;
                20:	C5C6_reg[20] <= c5_relu_out_5516_120;
                21:	C5C6_reg[21] <= c5_relu_out_5516_120;
                22:	C5C6_reg[22] <= c5_relu_out_5516_120;
                23:	C5C6_reg[23] <= c5_relu_out_5516_120;
                24:	C5C6_reg[24] <= c5_relu_out_5516_120;
                25:	C5C6_reg[25] <= c5_relu_out_5516_120;
                26:	C5C6_reg[26] <= c5_relu_out_5516_120;
                27:	C5C6_reg[27] <= c5_relu_out_5516_120;
                28:	C5C6_reg[28] <= c5_relu_out_5516_120;
                29:	C5C6_reg[29] <= c5_relu_out_5516_120;
                30:	C5C6_reg[30] <= c5_relu_out_5516_120;
                31:	C5C6_reg[31] <= c5_relu_out_5516_120;
                32:	C5C6_reg[32] <= c5_relu_out_5516_120;
                33:	C5C6_reg[33] <= c5_relu_out_5516_120;
                34:	C5C6_reg[34] <= c5_relu_out_5516_120;
                35:	C5C6_reg[35] <= c5_relu_out_5516_120;
                36:	C5C6_reg[36] <= c5_relu_out_5516_120;
                37:	C5C6_reg[37] <= c5_relu_out_5516_120;
                38:	C5C6_reg[38] <= c5_relu_out_5516_120;
                39:	C5C6_reg[39] <= c5_relu_out_5516_120;
                40:	C5C6_reg[40] <= c5_relu_out_5516_120;
                41:	C5C6_reg[41] <= c5_relu_out_5516_120;
                42:	C5C6_reg[42] <= c5_relu_out_5516_120;
                43:	C5C6_reg[43] <= c5_relu_out_5516_120;
                44:	C5C6_reg[44] <= c5_relu_out_5516_120;
                45:	C5C6_reg[45] <= c5_relu_out_5516_120;
                46:	C5C6_reg[46] <= c5_relu_out_5516_120;
                47:	C5C6_reg[47] <= c5_relu_out_5516_120;
                48:	C5C6_reg[48] <= c5_relu_out_5516_120;
                49:	C5C6_reg[49] <= c5_relu_out_5516_120;
                50:	C5C6_reg[50] <= c5_relu_out_5516_120;
                51:	C5C6_reg[51] <= c5_relu_out_5516_120;
                52:	C5C6_reg[52] <= c5_relu_out_5516_120;
                53:	C5C6_reg[53] <= c5_relu_out_5516_120;
                54:	C5C6_reg[54] <= c5_relu_out_5516_120;
                55:	C5C6_reg[55] <= c5_relu_out_5516_120;
                56:	C5C6_reg[56] <= c5_relu_out_5516_120;
                57:	C5C6_reg[57] <= c5_relu_out_5516_120;
                58:	C5C6_reg[58] <= c5_relu_out_5516_120;
                59:	C5C6_reg[59] <= c5_relu_out_5516_120;
                60:	C5C6_reg[60] <= c5_relu_out_5516_120;
                61:	C5C6_reg[61] <= c5_relu_out_5516_120;
                62:	C5C6_reg[62] <= c5_relu_out_5516_120;
                63:	C5C6_reg[63] <= c5_relu_out_5516_120;
                64:	C5C6_reg[64] <= c5_relu_out_5516_120;
                65:	C5C6_reg[65] <= c5_relu_out_5516_120;
                66:	C5C6_reg[66] <= c5_relu_out_5516_120;
                67:	C5C6_reg[67] <= c5_relu_out_5516_120;
                68:	C5C6_reg[68] <= c5_relu_out_5516_120;
                69:	C5C6_reg[69] <= c5_relu_out_5516_120;
                70:	C5C6_reg[70] <= c5_relu_out_5516_120;
                71:	C5C6_reg[71] <= c5_relu_out_5516_120;
                72:	C5C6_reg[72] <= c5_relu_out_5516_120;
                73:	C5C6_reg[73] <= c5_relu_out_5516_120;
                74:	C5C6_reg[74] <= c5_relu_out_5516_120;
                75:	C5C6_reg[75] <= c5_relu_out_5516_120;
                76:	C5C6_reg[76] <= c5_relu_out_5516_120;
                77:	C5C6_reg[77] <= c5_relu_out_5516_120;
                78:	C5C6_reg[78] <= c5_relu_out_5516_120;
                79:	C5C6_reg[79] <= c5_relu_out_5516_120;
                80:	C5C6_reg[80] <= c5_relu_out_5516_120;
                81:	C5C6_reg[81] <= c5_relu_out_5516_120;
                82:	C5C6_reg[82] <= c5_relu_out_5516_120;
                83:	C5C6_reg[83] <= c5_relu_out_5516_120;
                84:	C5C6_reg[84] <= c5_relu_out_5516_120;
                85:	C5C6_reg[85] <= c5_relu_out_5516_120;
                86:	C5C6_reg[86] <= c5_relu_out_5516_120;
                87:	C5C6_reg[87] <= c5_relu_out_5516_120;
                88:	C5C6_reg[88] <= c5_relu_out_5516_120;
                89:	C5C6_reg[89] <= c5_relu_out_5516_120;
                90:	C5C6_reg[90] <= c5_relu_out_5516_120;
                91:	C5C6_reg[91] <= c5_relu_out_5516_120;
                92:	C5C6_reg[92] <= c5_relu_out_5516_120;
                93:	C5C6_reg[93] <= c5_relu_out_5516_120;
                94:	C5C6_reg[94] <= c5_relu_out_5516_120;
                95:	C5C6_reg[95] <= c5_relu_out_5516_120;
                96:	C5C6_reg[96] <= c5_relu_out_5516_120;
                97:	C5C6_reg[97] <= c5_relu_out_5516_120;
                98:	C5C6_reg[98] <= c5_relu_out_5516_120;
                99:	C5C6_reg[99] <= c5_relu_out_5516_120;
                100:	C5C6_reg[100] <= c5_relu_out_5516_120;
                101:	C5C6_reg[101] <= c5_relu_out_5516_120;
                102:	C5C6_reg[102] <= c5_relu_out_5516_120;
                103:	C5C6_reg[103] <= c5_relu_out_5516_120;
                104:	C5C6_reg[104] <= c5_relu_out_5516_120;
                105:	C5C6_reg[105] <= c5_relu_out_5516_120;
                106:	C5C6_reg[106] <= c5_relu_out_5516_120;
                107:	C5C6_reg[107] <= c5_relu_out_5516_120;
                108:	C5C6_reg[108] <= c5_relu_out_5516_120;
                109:	C5C6_reg[109] <= c5_relu_out_5516_120;
                110:	C5C6_reg[110] <= c5_relu_out_5516_120;
                111:	C5C6_reg[111] <= c5_relu_out_5516_120;
                112:	C5C6_reg[112] <= c5_relu_out_5516_120;
                113:	C5C6_reg[113] <= c5_relu_out_5516_120;
                114:	C5C6_reg[114] <= c5_relu_out_5516_120;
                115:	C5C6_reg[115] <= c5_relu_out_5516_120;
                116:	C5C6_reg[116] <= c5_relu_out_5516_120;
                117:	C5C6_reg[117] <= c5_relu_out_5516_120;
                118:	C5C6_reg[118] <= c5_relu_out_5516_120;
                119:	C5C6_reg[119] <= c5_relu_out_5516_120;
            endcase
        end
    end
    //                     // 1:	C5C6_reg[1] <= c5_relu_out_5516_120;

    // flatten the rb_S4C5_rX arrays into vectors
    wire [C3_MAPS*OUT_WIDTH-1:0] C5_in1, C5_in2, C5_in3, C5_in4, C5_in5;	// 16 maps * 32-bit cell
    generate
        for (g = 0; g < C3_MAPS; g = g+1) begin : flatten_C5_in
            assign C5_in1[OUT_WIDTH*(g+1)-1 : OUT_WIDTH*g] = rb_S4C5_r3[g];//rb_S4C5_r4[i];
            assign C5_in2[OUT_WIDTH*(g+1)-1 : OUT_WIDTH*g] = rb_S4C5_r2[g];//rb_S4C5_r3[i];
            assign C5_in3[OUT_WIDTH*(g+1)-1 : OUT_WIDTH*g] = rb_S4C5_r1[g];//rb_S4C5_r2[i];
            assign C5_in4[OUT_WIDTH*(g+1)-1 : OUT_WIDTH*g] = rb_S4C5_r0[g];//rb_S4C5_r1[i];
            assign C5_in5[OUT_WIDTH*(g+1)-1 : OUT_WIDTH*g] = S4_poolOut[g];//rb_S4C5_r0[i];
        end
    endgenerate
    wire [16*KERNEL_SIZE*IN_WIDTH-1:0] read_feature_from_s4_55_16;
    assign read_feature_from_s4_55_16 = {C5_in1, C5_in2, C5_in3, C5_in4, C5_in5};
    wire [IN_WIDTH-1:0] c5_out_5516_120;

                      

    // convolution modules
    convn #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .KERNEL_SIZE(KERNEL_SIZE), .CHANNEL(16)) C5_DSP_5516_120(
        .clk(clk),
        .en(C5_en),
        .input_feature(read_feature_from_s4_55_16),
        .filter(tmp_out_5516_120),
        .convValue(c5_out_5516_120) 
    );
    
    wire [IN_WIDTH-1:0] c5_relu_out_5516_120;
    relu #(.BIT_WIDTH(OUT_WIDTH)) C5_RELU (
        .in(c5_out_5516_120), .out(c5_relu_out_5516_120)
    );
    // assign tmp_out = c5_relu_out_5516_120;

   
    
    /*/------------------ F6: 84 feature maps; fully connected  ------------------/*/
    // F6: fully-connected layer, 120 inputs, 84 outputs
    wire signed[OUT_WIDTH-1:0] F6_fcOut[0:F6_OUT-1];	// array of outputs
    wire signed[OUT_WIDTH-1:0] F6_relu[0:F6_OUT-1];	// outputs after activation function
    wire signed[OUT_WIDTH*F6_OUT*(C5_MAPS+1)-1:0] rom_f6;	// F6 parameters stored in memory

    // parameters for neuron weights
    rom_params #(.BIT_WIDTH(OUT_WIDTH), .SIZE(F6_OUT*(C5_MAPS+1)),	// (no. neurons) * (no. inputs + bias)
            .FILE("weights_f6.list")) ROM_F6 (
        .clk(clk),
        .read(read),
        .read_out(rom_f6)
    );

    // flatten input vector
    wire signed[C5_MAPS*OUT_WIDTH-1:0] F6_invec;	// 120 * 32-bits; C5 feature maps as a flattened vector
    generate
        for (g = 0; g < C5_MAPS; g = g+1) begin : flatten_F6_in
            assign F6_invec[OUT_WIDTH*(g+1)-1 : OUT_WIDTH*g] = C5C6_reg[g]; //C5C6_reg[g];
        end
    endgenerate

    // FC modules
    generate
        for (g = 0; g < F6_OUT; g = g+1) begin : F6_op	// 84 neurons
            localparam SIZE = C5_MAPS + 1;	// 120 inputs + 1 bias
            /*fc_out #(.BIT_WIDTH(OUT_WIDTH), .NUM_INPUTS(120), .OUT_WIDTH(OUT_WIDTH)) F6_FC (
                .in(F6_invec),
                .in_weights( rom_f6[OUT_WIDTH*((g+1)*SIZE-1)-1 : OUT_WIDTH*g*SIZE] ),
                .bias( rom_f6[OUT_WIDTH*((g+1)*SIZE)-1 : OUT_WIDTH*((g+1)*SIZE-1)] ),
                .out(F6_fcOut[g])
            );*/
            fc_120 #(.BIT_WIDTH(OUT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) F6_FC (
                .in(F6_invec),
                .in_weights( rom_f6[OUT_WIDTH*((g+1)*SIZE-1)-1 : OUT_WIDTH*g*SIZE] ),
                .bias( rom_f6[OUT_WIDTH*((g+1)*SIZE)-1 : OUT_WIDTH*((g+1)*SIZE-1)] ),
                .out(F6_fcOut[g])
            );


            // F6 activation layer (ReLU)
            relu #(.BIT_WIDTH(OUT_WIDTH)) F6_RELU (
                .in(F6_fcOut[g]), .out(F6_relu[g])
            );
        end
    endgenerate
    
    // PIPELINE REGISTERS FOR F6->OUT
    reg signed[OUT_WIDTH-1:0] F6OUT_reg[0:F6_OUT-1];
    reg[6:0] j;	// range: 0 to 83
    // latch values for next clock cycle
    always @ (posedge clk) begin
        for (j = 0; j < F6_OUT; j = j+1)
            F6OUT_reg[j] <= F6_relu[j];
    end

    // OUT: fully-connected layer, 84 inputs, 10 outputs
    wire signed[OUT_WIDTH-1:0] LAST_fcOut[0:LAST_OUT-1];	// array of outputs
    wire signed[OUT_WIDTH*LAST_OUT*(F6_OUT+1)-1:0] rom_out7;	// layer OUT parameters stored in memory

    // parameters for neuron weights
    rom_params #(.BIT_WIDTH(OUT_WIDTH), .SIZE(LAST_OUT*(F6_OUT+1)),	// (no. neurons) * (no. inputs + bias)
            .FILE("weights_out7.list")) ROM_OUT7 (
        .clk(clk),
        .read(read),
        .read_out(rom_out7)
    );

    // flatten input vector
    wire signed[F6_OUT*OUT_WIDTH-1:0] LAST_invec;	// 84 * 32-bit inputs from F6 as a flattened vector
    generate
        for (g = 0; g < F6_OUT; g = g+1) begin : flatten_FCOUT_in	// 84 inputs
            assign LAST_invec[OUT_WIDTH*(g+1)-1 : OUT_WIDTH*g] = F6OUT_reg[g]; //F6_relu[g];
        end
    endgenerate

    // FC modules
    generate
        for (g = 0; g < LAST_OUT; g = g+1) begin : OUT_op	// 10 neurons
            localparam SIZE = F6_OUT + 1;	// 84 inputs + 1 bias
            /*fc_out #(.BIT_WIDTH(OUT_WIDTH), .NUM_INPUTS(F6_OUT), .OUT_WIDTH(OUT_WIDTH)) LAST_FC (
                .in(LAST_invec),
                .in_weights( rom_out7[OUT_WIDTH*((g+1)*SIZE-1)-1 : OUT_WIDTH*g*SIZE] ),
                .bias( rom_out7[OUT_WIDTH*((g+1)*SIZE)-1 : OUT_WIDTH*((g+1)*SIZE-1)] ),
                .out(LAST_fcOut[g])
            );*/
            fc_84 #(.BIT_WIDTH(OUT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) LAST_FC (
                .in(LAST_invec),
                .in_weights( rom_out7[OUT_WIDTH*((g+1)*SIZE-1)-1 : OUT_WIDTH*g*SIZE] ),
                .bias( rom_out7[OUT_WIDTH*((g+1)*SIZE)-1 : OUT_WIDTH*((g+1)*SIZE-1)] ),
                .out(LAST_fcOut[g])
            );
        end
    endgenerate


    // PIPELINE REGISTERS FOR OUT->prediction
    reg signed[OUT_WIDTH-1:0] OUTpred_reg[0:LAST_OUT-1];
    reg[3:0] k;	// range: 0 to 9
    // latch values for next clock cycle
    always @ (posedge clk) begin
        for (k = 0; k < LAST_OUT; k = k+1)
        OUTpred_reg[k] <= LAST_fcOut[k];
    end

    // find output (largest amongst FC outputs)
    // flatten input vectorma
    wire signed[LAST_OUT*OUT_WIDTH-1:0] OUT_invec;	// 10 * 128-bit outputs as a flattened vector
    generate
        for (g = 0; g < LAST_OUT; g = g+1) begin : flatten_OUT10_in	// 10 outputs
            assign OUT_invec[OUT_WIDTH*(g+1)-1 : OUT_WIDTH*g] = OUTpred_reg[g]; //LAST_fcOut[g];
        end
    endgenerate

    // find largest output
    max_index_10 #(.BIT_WIDTH(OUT_WIDTH), .INDEX_WIDTH(4)) FIND_MAX (
        .in(OUT_invec),
        .max(out)	// LeNet-5 output
    );

    /*/------------------ F7: 10 feature maps; fully connected  ------------------/*/



    /*/------------------ OUTPUT: 10 feature maps; fully connected  ------------------/*/


endmodule
