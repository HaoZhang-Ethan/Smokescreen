function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction

module conv_55_bo #(parameter IN_WIDTH = 8, OUT_WIDTH = 8, IMAGE = 32, SP_BRAM = 4, KERNEL_SIZE = 5,  BRAM_NUM_C = 8 , BRAM_NUM_F = 1) (
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
    output  [8-1:0] tmp_out,
    output [IN_WIDTH-1:0] c1_out_2
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

/*/------------------ CALCULATE  ------------------/*/


    /*/------------------ 553 6 feature maps; convolution, stride = 1  ------------------/*/
    wire [IN_WIDTH-1:0] c3_out_5536;
    conv_pim #(.BIT_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH), .KERNEL_SIZE(KERNEL_SIZE), .CHANNEL(16)) C3_DSP_5536(
        .clk(clk),
        .rst(rst),
        .en(C3_en),
        .input_feature(read_feature_out_1),
        .address(bram_addr_f), // TODO:
        .convValue(c3_out_5536)
    );



    // assign C1_convPlusBias[g] = C1_convOut[g] + rom_c1[IN_WIDTH*((g+1)*SIZE)-1 : IN_WIDTH*((g+1)*SIZE-1)];

    // // C1 activation layer (ReLU)
  
    relu #(.BIT_WIDTH(IN_WIDTH)) C1_RELU (
        .in(c3_out_5536), .out(c1_out_2)
    );

    
 
endmodule
