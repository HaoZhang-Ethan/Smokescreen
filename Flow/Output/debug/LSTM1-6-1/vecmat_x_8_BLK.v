module vecmat_x_8_BLK #( parameter varraysize=1600, vectwidth=100)
(
	input clk,
	input reset,
	input [varraysize-1:0] data_x,
	input [varraysize-1:0] W_x,

	output reg [15:0] data_out_x
);


	assign data_out_h = data_x[7:0] | data_x[23:16] | data_x[39:32]| data_x[55:48]| data_x[71:64]| data_x[87:80]| data_x[103:96]| data_x[119:112]| data_x[135:128]| data_x[151:144]| data_x[167:160]| data_x[183:176]| data_x[199:192]| data_x[215:208]| data_x[231:224]| data_x[247:240]| data_x[263:256]| data_x[279:272]| data_x[295:288]| data_x[311:304]| data_x[327:320]| data_x[343:336]| data_x[359:352]| data_x[375:368]| data_x[391:384]| data_x[407:400]| data_x[423:416]| data_x[439:432]| data_x[455:448]| data_x[471:464]| data_x[487:480]| data_x[503:496]| data_x[519:512]| data_x[535:528]| data_x[551:544]| data_x[567:560]| data_x[583:576]| data_x[599:592]| data_x[615:608]| data_x[631:624]| data_x[647:640]| data_x[663:656]| data_x[679:672]| data_x[695:688]| data_x[711:704]| data_x[727:720]| data_x[743:736]| data_x[759:752]| data_x[775:768]| data_x[791:784]| data_x[807:800]| data_x[823:816]| data_x[839:832]| data_x[855:848]| data_x[871:864]| data_x[887:880]| data_x[903:896]| data_x[919:912]| data_x[935:928]| data_x[951:944]| data_x[967:960]| data_x[983:976]| data_x[999:992]| data_x[1015:1008]| data_x[1031:1024] | data_x[1039:1032]| data_x[1055:1048]| data_x[1071:1064]| data_x[1087:1080]| data_x[1103:1096]| data_x[1119:1112]| data_x[1135:1128]| data_x[1151:1144]| data_x[1167:1160]| data_x[1183:1176]| data_x[1199:1192]| data_x[1215:1208]| data_x[1231:1224]| data_x[1247:1240]| data_x[1263:1256]| data_x[1279:1272]| data_x[1295:1288]| data_x[1311:1304]| data_x[1327:1320]| data_x[1343:1336]| data_x[1359:1352]| data_x[1375:1368]| data_x[1391:1384]| data_x[1407:1400]| data_x[1423:1416]| data_x[1439:1432]| data_x[1455:1448]| data_x[1471:1464]| data_x[1487:1480]| data_x[1503:1496]| data_x[1519:1512]| data_x[1535:1528]| data_x[1551:1544]| data_x[1567:1560]| data_x[1583:1576]| data_x[1599:1592];


endmodule
