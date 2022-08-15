(* blackbox *)

module memory_pim(clk, mydata, myaddr, mywe, myout);


    input clk;

    input mywe;

    input [9-1:0] myaddr;

    input [40-1:0] mydata;

    output reg [40-1:0] myout;


endmodule



