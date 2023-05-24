/*
 * @Author: haozhang haozhang@mail.sdu.edu.cn
 * @Date: 2022-08-16 21:47:09
 * @LastEditors: haozhang haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2022-08-17 22:11:40
 * @FilePath: /Smokescreen/mytest/Circuit/t2.v
 * @Description: Test Pim lib by using a some autom atom opeartions
 *
 * 
 * Copyright (c) 2022 by haozhang haozhang@mail.sdu.edu.cn, All Rights Reserved. 
 */
 
`define WIDTH_BIT 40
`define ADD_BIT 9
`define OUT_BIT 8

`define ATOM_ADDR 7 //atom address width

module splitter(clk, data, addr, we, out);
    parameter ADDR_WIDTH = 7;
    parameter IN_WIDTH = 40;
    parameter OUT_WIDTH = 8;

    input clk;
    input we;
    input [ADDR_WIDTH - 1:0] addr;
    input [IN_WIDTH - 1:0] data;
    
    output reg [OUT_WIDTH - 1:0] out;    


    // split in depth
    if (ADDR_WIDTH > `ATOM_ADDR)
    begin
        
        wire [ADDR_WIDTH-2:0] new_addr = addr[ADDR_WIDTH-2:0];
        wire [OUT_WIDTH-1:0] out_h, out_l;


        defparam uut_h.ADDR_WIDTH = ADDR_WIDTH-1;
        defparam uut_h.IN_WIDTH = IN_WIDTH;
        defparam uut_h.OUT_WIDTH = OUT_WIDTH;
        splitter uut_h (
            .clk(clk), 
            .we(we), 
            .addr(new_addr), 
            .data(data), 
            .out(out_h)
        );

        defparam uut_l.ADDR_WIDTH = ADDR_WIDTH-1;
        defparam uut_h.IN_WIDTH = IN_WIDTH;
        defparam uut_h.OUT_WIDTH = OUT_WIDTH;
        splitter uut_l (
            .clk(clk), 
            .we(we), 
            .addr(new_addr), 
            .data(data), 
            .out(out_l)
        );

        reg additional_bit;
        always @(posedge clk) additional_bit <= addr[ADDR_WIDTH-1];
        assign out = (additional_bit) ? out_h : out_l;

    end	else begin
            // defparam new_ram.ADDR_WIDTH = ADDR_WIDTH;
            // defparam new_ram.DATA_WIDTH = DATA_WIDTH;
            bram_pim new_ram(
                .data(data),
                .addr(addr),
                .we(we),
                .out(out),
                .clk(clk)
            );
    end
endmodule


module top_splitter(clk, data, addr, we, out);
    parameter ADDR_WIDTH = `ADD_BIT;
    parameter IN_WIDTH = `WIDTH_BIT;
    parameter OUT_WIDTH = `WIDTH_BIT;

    input clk;
    input we;
    input [ADDR_WIDTH - 1:0] addr;
    input [IN_WIDTH - 1:0] data;
    
    output reg [OUT_WIDTH - 1:0] out;    

    defparam new_ram.ADDR_WIDTH = ADDR_WIDTH;
    defparam new_ram.IN_WIDTH = IN_WIDTH;
    defparam new_ram.OUT_WIDTH = OUT_WIDTH;
    splitter new_ram(
        .data(data),
        .addr(addr),
        .we(we),
        .out(out),
        .clk(clk)
    );
endmodule




module top(clk, data, addr, we, out);
    parameter ADDR_WIDTH = `ADD_BIT;
    parameter IN_WIDTH = `WIDTH_BIT;
    parameter OUT_WIDTH = `WIDTH_BIT;

    input clk;
    input we;
    input [ADDR_WIDTH - 1:0] addr;
    input [IN_WIDTH - 1:0] data;
    
    output reg [OUT_WIDTH - 1:0] out;    

    
    if (ADDR_WIDTH>1)
    begin
    wire [OUT_WIDTH-1:0] out_h, out_l;
    defparam pim_h.ADDR_WIDTH = ADDR_WIDTH-1;
    defparam pim_h.IN_WIDTH = IN_WIDTH;
    defparam pim_h.OUT_WIDTH = OUT_WIDTH;
    top_splitter pim_h(
        .data(data),
        .addr(addr),
        .we(we),
        .out(out_h),
        .clk(clk)
    );

    defparam pim_h.ADDR_WIDTH = ADDR_WIDTH-1;
    defparam pim_h.IN_WIDTH = IN_WIDTH;
    defparam pim_h.OUT_WIDTH = OUT_WIDTH;
    top_splitter pim_l(
        .data(data),
        .addr(addr),
        .we(we),
        .out(out_l),
        .clk(clk)
    );
    assign out = (data[0]) ? out_h : out_l;

    end
    




endmodule



