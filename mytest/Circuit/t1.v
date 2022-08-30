/*
 * @Author: haozhang haozhang@mail.sdu.edu.cn
 * @Date: 2022-08-13 19:34:15
 * @LastEditors: haozhang haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2022-08-17 22:09:07
 * @FilePath: /Smokescreen/mytest/Circuit/t1.v
 * @Description: used for debug yosys flow 
 * 
 * Copyright (c) 2022 by haozhang haozhang@mail.sdu.edu.cn, All Rights Reserved. 
 */


`define WIDTH_BIT 8
`define ADD_BIT 9
 
 module top(clk, data, addr, we, out);
    input	clk;
    input	[`WIDTH_BIT-1:0]	data;
    input	[`ADD_BIT:0]	addr;
    input	we;
    output	[`WIDTH_BIT-1:0]	out;


    wire	[`WIDTH_BIT-1:0]	tmp_data;
    wire	[`ADD_BIT:0]	tmp_addr;
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

  my_pim new_ram(
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



(* blackbox *)
module my_pim(clk, data, addr, we, out);

    localparam ADDR_WIDTH = 8;
    localparam DATA_WIDTH = 8;

    input clk;
    input we;
    input [ADDR_WIDTH-1:0] addr;
    input [DATA_WIDTH-1:0] data;
    
    output reg [DATA_WIDTH-1:0] out;
    /*
    reg [DATA_WIDTH-1:0] RAM [(1<<ADDR_WIDTH)-1:0];

    always @(posedge clk)
    begin
        if (we)
                RAM[addr] <= data;
                
        out <= RAM[addr];
    end
    */
endmodule

