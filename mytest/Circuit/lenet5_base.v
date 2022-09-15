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
    input S2_en,
    // input  [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_wdata_ext,
    // input  [`MAT_MUL_SIZE-1:0] bram_we_ext,
    // output [3:0] out	// the predicted digit
    output  [128:0] out,
    output  [8-1:0] tmp_out,
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
    // genvar i;
    // generate
    //     for (i = 0; i < BRAM_NUM_F; i = i+1) begin : genbit
    //         assign we_en[i] = ( bram_select_f == i) ? 1 : 0;
    //         dual_port_ram #(.ADDR_WIDTH(clogb2(IMAGE)), .DATA_WIDTH(KERNEL_SIZE*KERNEL_SIZE*IN_WIDTH)) ram_input_feature (
    //             .clk(clk_mem),
    //             .we1(we_en_f[i]),
    //             .we2(tmp_en_f),
    //             .addr1(bram_addr_f),
    //             .addr2(bram_addr_f),
    //             .data1(bram_data_f),
    //             .data2(bram_data_f),
    //             .out1(tmp_out_1[i]),
    //             .out2(tmp_out_2[i])
    //         );
    //     end
    // endgenerate

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

    // KERNEL C3 554 3
    wire [CONV_SIZE_3*IN_WIDTH-1:0] tmp_out_554_3;
    rom_params_bram #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE_4)) rom_kernel_554_3 (
        .clk(clk),
        .addr(bram_addr_f[2:0]),
        .out(tmp_out_554_3)
    );

    // KERNEL C5 554 3
    wire [CONV_SIZE_3*IN_WIDTH-1:0] tmp_out_5516_120;
    rom_params_bram #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE_16)) rom_kernel_5516_120 (
        .clk(clk),
        .addr(bram_addr_f[2:0]),
        .out(tmp_out_5516_120)
    );

    // load the conv kernel weight to bram
    // wire we_en_c[BRAM_NUM_C];
    // wire tmp_en_c;
    // wire [IN_WIDTH*SP_BRAM-1:0] tmp_out_1[BRAM_NUM_C];
    // wire [IN_WIDTH*SP_BRAM-1:0] tmp_out_2[BRAM_NUM_C];
    // generate
    //     for (i = 0; i < BRAM_NUM_C; i = i+1) begin : genbit
    //         assign we_en[i] = ( bram_select_c[i] == 1) ? 1 : 0;
    //         dual_port_ram #(.ADDR_WIDTH(clogb2(IMAGE)), .DATA_WIDTH(KERNEL_SIZE*KERNEL_SIZE)) ram_input_feature (
    //             .clk(clk_mem),
    //             .we1(we_en_c[i]),
    //             .we2(tmp_en_c),
    //             .addr1(bram_addr_f),
    //             .addr2(bram_addr_f),
    //             .data1(bram_data_f),
    //             .data2(bram_data_f),
    //             .out1(tmp_out_1[i]),
    //             .out2(tmp_out_2[i])
    //         );
    //     end



    // assign out = tmp_out_1[0]&tmp_out_2[0]&tmp_out;

    


/*/------------------ CALCULATE  ------------------/*/


    /*/------------------ C1: 6 feature maps; convolution, stride = 1  ------------------/*/
    // wire c1_en;
    wire [IN_WIDTH-1:0] c1_out_1;
    wire [IN_WIDTH-1:0] c1_relu_out_1;
    convn #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .KERNEL_SIZE(KERNEL_SIZE), .CHANNEL(1)) C1_DSP(
        // .clk(clk),
        // .en(c1_en),
        .input_feature(read_feature_out_2),
        .filter(tmp_out_551_6),
        .convValue(c1_out_1) 
    );
    // assign C1_convPlusBias[g] = C1_convOut[g] + rom_c1[IN_WIDTH*((g+1)*SIZE)-1 : IN_WIDTH*((g+1)*SIZE-1)];

    // // C1 activation layer (ReLU)

    relu #(.BIT_WIDTH(IN_WIDTH)) C1_RELU (
        .in(c1_out_1), .out(tmp_out)
    );


    reg [IN_WIDTH-1:0] C1_relu [C1_MAPS];
    
    always @(posedge clk) begin

    end

    
    // holds output of rowbuffer for C1 -> S2
    wire signed[HALF_WIDTH-1:0] rb_C1S2[0:C1_MAPS-1];	// 6 maps * 1 row - 1 = 5

    // C1 feature map; next pixel to buffer for S2
    generate
        for (g = 0; g < C1_MAPS; g = g+1) begin : C1_rb	// 6 feature maps
            rowbuffer #(.COLS(C1_SIZE), .BIT_WIDTH(HALF_WIDTH)) C1_RB (
                .clk(clk), .rst(rst),
                .rb_in(C1_relu[g]),
                .en(S2_en),
                .rb_out(rb_C1S2[g])
            );
        end
    endgenerate

  

    /*/------------------ S2: 6 feature maps; max pooling, stride = 2  ------------------/*/

    /*/------------------ C3: 16 feature maps; convolution, stride = 1  ------------------/*/

    /*/------------------ S4: 16 feature maps; max pooling, stride = 2  ------------------/*/

    /*/------------------ C5: 120 feature maps; convolution, stride = 1  ------------------/*/

    /*/------------------ F6: 84 feature maps; fully connected  ------------------/*/

    /*/------------------ F7: 10 feature maps; fully connected  ------------------/*/

    /*/------------------ OUTPUT: 10 feature maps; fully connected  ------------------/*/


endmodule


