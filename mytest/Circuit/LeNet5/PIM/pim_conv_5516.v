function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2+1)
            bit_depth = bit_depth>>1;
    end
endfunction

// localparam WIDTH_SRL = 256; 
// localparam WIDTH_CNT = clogb2(WIDTH_SRL);

module pim_conv_5516 #(parameter KERNEL_SIZE = 5, CHANNEL = 1, DEPTH = 6, BIT_WIDTH = 8, OUT_WIDTH = 8) (
	input clk,
	input rst,
	input start,
	input [(KERNEL_SIZE*KERNEL_SIZE*CHANNEL)*BIT_WIDTH-1:0] feature,
	output done,
	output [OUT_WIDTH*DEPTH:0] out
	);

reg [5:0] stage;
assign ht_valid = (count>DEPTH)?1:0;
wire [3:0] res_addr;
wire weorca;
wire [OUT_WIDTH-1:0] tmp_out;

pim_splitter #(.INPUT_SIZE(KERNEL_SIZE*KERNEL_SIZE*CHANNEL), .ADDRS_WIDTH(clogb2(DEPTH-1)), .OUT_WIDTH(OUT_WIDTH)) splitter(.clk(clk), .weorca(weorca), .addr(res_addr), .data(feature), .out(tmp_out));

// pim_splitter #(.INPUT_SIZE(KERNEL_SIZE*KERNEL_SIZE*CHANNEL), .ADDRS_WIDTH(clogb2(DEPTH-1)), .OUT_WIDTH(OUT_WIDTH)) splitter(.clk(clk), .weorca(weorca), .addr(res_addr), .data(feature), .out(tmp_out));
// pim_splitter #(.INPUT_SIZE(KERNEL_SIZE*KERNEL_SIZE*CHANNEL), .ADDRS_WIDTH(clogb2(DEPTH-1)), .OUT_WIDTH(OUT_WIDTH)) splitter(.clk(clk), .weorca(weorca), .addr(res_addr), .data(feature), .out(tmp_out));
// pim_splitter #(.INPUT_SIZE(KERNEL_SIZE*KERNEL_SIZE*CHANNEL), .ADDRS_WIDTH(clogb2(DEPTH-1)), .OUT_WIDTH(OUT_WIDTH)) splitter(.clk(clk), .weorca(weorca), .addr(res_addr), .data(feature), .out(tmp_out));


// assign out = {tmp_out, out[OUT_WIDTH*DEPTH-1:OUT_WIDTH]};


integer i;
always @(posedge clk) begin
	if(rst == 1'b1 || start == 1'b0) 
		begin      
			count <= 0;
		end
	else begin	
		count <= count+1;
		for (i = 1; i < DEPTH+1; i = i+1) begin : GetRes
			if (count == i) begin
				// count <= 0;
				out[OUT_WIDTH*i-1:OUT_WIDTH*(i-1)] <= tmp_out;
			end
		end
		if (count == (DEPTH+1)) begin
			done <= 1'b1;
		end
	end
end

endmodule