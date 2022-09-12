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
    input   [KERNEL_SIZE*KERNEL_SIZE*IN_WIDTH-1:0] bram_data_f,
    input   [BRAM_NUM_C-1:0]  bram_select_c,
    input   [8:0] bram_addr_c,
    input   [KERNEL_SIZE*KERNEL_SIZE-1:0] bram_data_c,
    // input  [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_wdata_ext,
    // input  [`MAT_MUL_SIZE-1:0] bram_we_ext,
    // output [3:0] out	// the predicted digit
    output  [128:0] out
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
    wire [KERNEL_SIZE*KERNEL_SIZE*IN_WIDTH-1:0] read_feature_out_1;
    wire [KERNEL_SIZE*KERNEL_SIZE*IN_WIDTH-1:0] read_feature_out_2;
    dual_port_ram #(.ADDR_WIDTH(clogb2(IMAGE)), .DATA_WIDTH(KERNEL_SIZE*KERNEL_SIZE*IN_WIDTH)) ram_input_feature (
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
    rom_params #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE)) rom_kernel_551_6 (
        .clk(clk),
        .addr(bram_addr_f[2:0]),
        .out(tmp_out_551_6)
    );

    // KERNEL C3 553 6 
    wire [CONV_SIZE_3*IN_WIDTH-1:0] tmp_out_553_6;
    rom_params #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE_3)) rom_kernel_553_6 (
        .clk(clk),
        .addr(bram_addr_f[2:0]),
        .out(tmp_out_553_6)
    );

    // KERNEL C3 554 3
    wire [CONV_SIZE_3*IN_WIDTH-1:0] tmp_out_554_3;
    rom_params #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE_4)) rom_kernel_554_3 (
        .clk(clk),
        .addr(bram_addr_f[2:0]),
        .out(tmp_out_554_3)
    );

    // KERNEL C5 554 3
    wire [CONV_SIZE_3*IN_WIDTH-1:0] tmp_out_5516_120;
    rom_params #(.BIT_WIDTH(IN_WIDTH), .SIZE(CONV_SIZE_16)) rom_kernel_5516_120 (
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
    wire c1_en;
    convn #(.BIT_WIDTH(IN_WIDTH),.OUT_WIDTH(OUT_WIDTH),.KERNEL_SIZE(KERNEL_SIZE),.CHANNEL(1)) (
        .clk(clk),
        .en(c1_en),
        .input_feature(read_feature_out_2),
        .filter(tmp_out_551_6)
);
    integer cyc_i;
    reg e;
    always @(posedge clk) begin
        if (start) begin
            for (cyc_i = 0; cyc_i < C1_STAGE; cyc_i = cyc_i+1) begin
                e = 1;
                #1;
                e = 0;
                #1;
            end
        end
    end
    // if (start == 1'b1) begin
    //     // for (cyc_i = 0; cyc_i < BRAM_NUM_F; cyc_i = cyc_i+1) begin : genbit
    //         e <= 1;
    //     // we_en_f[cyc_i] = ( bram_select_f == cyc_i) ? 1 : 0;
    //     // end
    // end

    /*/------------------ S2: 6 feature maps; max pooling, stride = 2  ------------------/*/

    /*/------------------ C3: 16 feature maps; convolution, stride = 1  ------------------/*/

    /*/------------------ S4: 16 feature maps; max pooling, stride = 2  ------------------/*/

    /*/------------------ C5: 120 feature maps; convolution, stride = 1  ------------------/*/

    /*/------------------ F6: 84 feature maps; fully connected  ------------------/*/

    /*/------------------ F7: 10 feature maps; fully connected  ------------------/*/

    /*/------------------ OUTPUT: 10 feature maps; fully connected  ------------------/*/


endmodule

/*/------------------ SOME MOUDLE  ------------------/*/
module rom_params #(parameter BIT_WIDTH = 8, SIZE = 26) (
	input clk,
    input [clogb2(SIZE)-1:0] addr,
	output [BIT_WIDTH*SIZE-1:0] out
);
    defparam weight_single_port_ram.ADDR_WIDTH = clogb2(SIZE);
    defparam weight_single_port_ram.DATA_WIDTH = BIT_WIDTH*SIZE;
    single_port_ram weight_single_port_ram(
    .addr(addr),
    .we(1'b0),
    .data(BIT_WIDTH*SIZE'b0),
    .out(out),
    .clk(clk)
    );
endmodule
