/*
 * @Author: haozhang haozhang@mail.sdu.edu.cn
 * @Date: 2022-09-7 09:52:11
 * @LastEditors: haozhang haozhang@mail.sdu.edu.cn
 * @LastEditTime: 2022-08-17 22:11:40
 * @FilePath: /Smokescreen/mytest/Circuit/pim_splitter.v
 * @Description: split the pim-mac operation 
 *
 * 
 * Copyright (c) 2022 by haozhang haozhang@mail.sdu.edu.cn, All Rights Reserved. 
 */

`define MAX_CXB_COL 7       //The max column of the crossbar 2^MAX_CXB_COL 
`define MAX_CXB_ROW 128     //The max row of the crossbar

// INPUT_SIZE 128      // The input size of the pim-mac operation
// ADDRS_WIDTH 9       // The address line width of the application's pim-mac operation, that means the clomn of the pim-mac operation is 2^ADDRS_WIDTH 
// OUT_WIDTH 8         // The out width of a single pim-mac operation
module pim_mac_col #(parameter INPUT_SIZE = 128, ADDRS_WIDTH = 9, OUT_WIDTH = 8) (
    input clk, 
    input we,
    input [INPUT_SIZE-1:0] data, 
    input [ADDRS_WIDTH-1:0] addr, 
    output [OUT_WIDTH-1:0] out
    );
    
    // split in depth
    if (ADDRS_WIDTH > `MAX_CXB_COL)
    begin
        
        wire [ADDRS_WIDTH-2:0] new_addr = addr[ADDRS_WIDTH-2:0];
        wire [OUT_WIDTH-1:0] out_h, out_l;


        // defparam uut_h.ADDRS_WIDTH = ADDRS_WIDTH-1;
        // defparam uut_h.INPUT_SIZE = INPUT_SIZE;
        // defparam uut_h.OUT_WIDTH = OUT_WIDTH;
        pim_mac_col #(.INPUT_SIZE(INPUT_SIZE), .ADDRS_WIDTH(ADDRS_WIDTH-1), .OUT_WIDTH(OUT_WIDTH)) uut_h (
            .clk(clk), 
            .we(we), 
            .addr(new_addr), 
            .data(data), 
            .out(out_h)
        );

        // defparam uut_l.ADDRS_WIDTH = ADDRS_WIDTH-1;
        // defparam uut_h.INPUT_SIZE = INPUT_SIZE;
        // defparam uut_h.OUT_WIDTH = OUT_WIDTH;
        pim_mac_col #(.INPUT_SIZE(INPUT_SIZE), .ADDRS_WIDTH(ADDRS_WIDTH-1), .OUT_WIDTH(OUT_WIDTH)) uut_l (
            .clk(clk), 
            .we(we), 
            .addr(new_addr), 
            .data(data), 
            .out(out_l)
        );

        reg additional_bit;
        always @(posedge clk) additional_bit <= addr[ADDRS_WIDTH-1];
        assign out = (additional_bit) ? out_h : out_l;
    end	else begin
            // defparam new_ram.ADDRS_WIDTH = ADDRS_WIDTH;
            // defparam new_ram.DATA_WIDTH = DATA_WIDTH;
            bram_pim pbram(
                .data(data),
                .addr(addr),
                .we(we),
                .out(out),
                .clk(clk)
            );
    end
endmodule



module pim_mac_row #(parameter INPUT_SIZE = 128, ADDRS_WIDTH = 9, OUT_WIDTH = 8) (
    input clk, 
    input we,
    input [INPUT_SIZE-1:0] data, 
    input [ADDRS_WIDTH-1:0] addr, 
    output [OUT_WIDTH-1:0] out
    );

    // split in depth
    if (INPUT_SIZE > `MAX_CXB_ROW)
    begin
        
        wire [OUT_WIDTH-1:0] out_1, out_2;

        pim_mac_row #(.INPUT_SIZE(INPUT_SIZE/2), .ADDRS_WIDTH(ADDRS_WIDTH), .OUT_WIDTH(OUT_WIDTH)) pim_mac_row_inst1 (
            .clk(clk), 
            .we(we), 
            .addr(addr), 
            .data(data), 
            .out(out_1)
        );

        // defparam uut_l.ADDRS_WIDTH = ADDRS_WIDTH-1;
        // defparam uut_h.INPUT_SIZE = INPUT_SIZE;
        // defparam uut_h.OUT_WIDTH = OUT_WIDTH;
        pim_mac_row #(.INPUT_SIZE(INPUT_SIZE/2), .ADDRS_WIDTH(ADDRS_WIDTH), .OUT_WIDTH(OUT_WIDTH)) pim_mac_row_inst2  (
            .clk(clk), 
            .we(we), 
            .addr(addr), 
            .data(data), 
            .out(out_2)
        );

        qadd #(.BIT_WIDTH(OUT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) qadd_inst(
        .a(out_1),
        .b(out_2),
        .c(out)
		);

    end	else begin
        pim_mac_col #(.INPUT_SIZE(INPUT_SIZE), .ADDRS_WIDTH(ADDRS_WIDTH), .OUT_WIDTH(OUT_WIDTH)) pim_mac_col_inst(
            .clk(clk), 
            .we(we),
            .data(data), 
            .addr(addr), 
            .out(out)
        );
    end
endmodule

module pim_splitter #(parameter INPUT_SIZE = 256, ADDRS_WIDTH = 8, OUT_WIDTH = 8) (
    input clk,
    input we,
    input [ADDRS_WIDTH - 1:0] addr,
    input [INPUT_SIZE - 1:0] data,
    output [OUT_WIDTH - 1:0] out
    );
    
    pim_mac_row #(.INPUT_SIZE(INPUT_SIZE), .ADDRS_WIDTH(ADDRS_WIDTH), .OUT_WIDTH(OUT_WIDTH)) pim_mac(
        .clk(clk),
        .we(we),
        .addr(addr),
        .data(data),
        .out(out)
    );
endmodule






