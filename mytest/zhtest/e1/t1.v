`define WIDTH_BIT 5
 
 module top(clk, data, addr, we, out);
    input	clk;
    input	[`WIDTH_BIT-1:0]	data;
    input	[4:0]	addr;
    input	we;
    output	[`WIDTH_BIT-1:0]	out;


    wire	[`WIDTH_BIT-1:0]	tmp_data;
    wire	[4:0]	tmp_addr;
    wire	tmp_we;
    wire	[`WIDTH_BIT-1:0]	tmp_out;


    assign tmp_data = data;
    assign tmp_addr = addr;
    assign tmp_we = we;
    assign out = tmp_out;

// defparam new_ram.ADDR_WIDTH = 9;
// defparam new_ram.DATA_WIDTH = 40;
// single_port_ram new_ram(
//   .data(tmp_data),
//   .addr(tmp_addr),
//   .we(tmp_we),
//   .out(tmp_out),
//   .clk(clk)
//   );

  single_port_ram new_ram(
    .data(tmp_data),
    .addr(tmp_addr),
    .we(tmp_we),
    .out(tmp_out),
    .clk(clk)
  );

// defparam new_ram1.ADDR_WIDTH = 10;
// defparam new_ram1.DATA_WIDTH = 32;
// single_port_ram new_ram1(
//   .clk (clk),
//   .we(we),
//   .data(datain),
//   .out(dataout1),
//   .addr(addr)
//   );


 endmodule