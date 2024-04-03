module vecmat_h_8_BLK #( parameter uarraysize=1024, vectwidth=64)
(
	input clk,
	input reset,
	input [uarraysize-1:0] data_h,
	input [uarraysize-1:0] W_h,

	output reg [15:0] data_out_h
);

	assign data_out_h = data_h[7:0] | data_h[23:16] | data_h[39:32]| data_h[55:48]| data_h[71:64]| data_h[87:80]| data_h[103:96]| data_h[119:112]| data_h[135:128]| data_h[151:144]| data_h[167:160]| data_h[183:176]| data_h[199:192]| data_h[215:208]| data_h[231:224]| data_h[247:240]| data_h[263:256]| data_h[279:272]| data_h[295:288]| data_h[311:304]| data_h[327:320]| data_h[343:336]| data_h[359:352]| data_h[375:368]| data_h[391:384]| data_h[407:400]| data_h[423:416]| data_h[439:432]| data_h[455:448]| data_h[471:464]| data_h[487:480]| data_h[503:496]| data_h[519:512]| data_h[535:528]| data_h[551:544]| data_h[567:560]| data_h[583:576]| data_h[599:592]| data_h[615:608]| data_h[631:624]| data_h[647:640]| data_h[663:656]| data_h[679:672]| data_h[695:688]| data_h[711:704]| data_h[727:720]| data_h[743:736]| data_h[759:752]| data_h[775:768]| data_h[791:784]| data_h[807:800]| data_h[823:816]| data_h[839:832]| data_h[855:848]| data_h[871:864]| data_h[887:880]| data_h[903:896]| data_h[919:912]| data_h[935:928]| data_h[951:944]| data_h[967:960]| data_h[983:976]| data_h[999:992]| data_h[1015:1008]| data_h[1031:1024];


	
endmodule