function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction
/*/------------------ SOME MOUDLE  ------------------/*/
module rom_params_bram #(parameter BIT_WIDTH = 8, SIZE = 26) (
	input clk,
    input read,
    // input [clogb2(SIZE)-1:0] addr,
	output reg[BIT_WIDTH*SIZE-1:0] read_out
);

    wire [BIT_WIDTH-1:0] bram_out;
    reg [clogb2(SIZE-1)-1:0] add_counter;
    defparam weight_single_port_ram.ADDR_WIDTH = clogb2(SIZE-1);
    defparam weight_single_port_ram.DATA_WIDTH = BIT_WIDTH;
    single_port_ram weight_single_port_ram(
    .addr(add_counter),
    .we(!read),
    .data(BIT_WIDTH'b0),
    .out(bram_out),
    .clk(clk)
    );
    


    reg[clogb2(SIZE)-1:0] i;	// 2^16 = 65536
    always @ (posedge clk) begin
        for (i = 0; i < SIZE; i = i+1) begin
            if (read)
                add_counter <= i;
                //read_out[BIT_WIDTH*(i+1)-1 : BIT_WIDTH*i] <= weights[i];
                read_out[i*BIT_WIDTH +: BIT_WIDTH] <= bram_out;
        end
    end




endmodule