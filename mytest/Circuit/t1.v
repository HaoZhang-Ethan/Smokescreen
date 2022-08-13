 module  top(we, addr, datain, dataout, clk);

    input we; 
    input[10 - 1:0] addr; 
    input[32 - 1:0] datain; 
    output[32 - 1:0] dataout; 
    // output[32 - 1:0] dataout1; 
    wire[32 - 1:0] dataout;
    // wire[32 - 1:0] dataout1;
    input clk; 



// defparam new_ram.ADDR_WIDTH = 10;
// defparam new_ram.DATA_WIDTH = 32;
memory_pim new_ram(
  .clk (clk),
  .we(we),
  .data(datain),
  .out(dataout),
  .addr(addr)
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