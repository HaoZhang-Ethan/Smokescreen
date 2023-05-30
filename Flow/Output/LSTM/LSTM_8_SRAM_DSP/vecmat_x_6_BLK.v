`define ARRAY_DEPTH 64      //Number of Hidden neurons
`define INPUT_DEPTH 100	    //LSTM input vector dimensions
`define DATA_WIDTH 8		//16 bit representation
`define INWEIGHT_DEPTH 6400 //100x64
`define HWEIGHT_DEPTH 4096  //64x64
`define varraysize 1600   //100x16
`define uarraysize 1024  //64x16


module vecmat_x_6_BLK #( parameter varraysize=1600, vectwidth=100)
(
	input clk,
	input reset,
	input [varraysize-1:0] data_x,
	input [varraysize-1:0] W_x,

	output reg [15:0] data_out_x
);

	wire [15:0] tmp_1, tmp_2;
	assign tmp_1 = data_x[5:0] | data_x[11:6] | data_x[17:12]| data_x[23:18]| data_x[29:24]|  data_x[35:30]| data_x[41:36]| data_x[47:42]| data_x[53:48]| data_x[59:54]| data_x[65:60]| data_x[71:66]| data_x[77:72]| data_x[83:78]| data_x[89:84]| data_x[95:90]| data_x[101:96]| data_x[107:102]| data_x[113:108]| data_x[119:114]| data_x[125:120]| data_x[131:126]| data_x[137:132]| data_x[143:138]| data_x[149:144]| data_x[155:150]| data_x[161:156]| data_x[167:162]| data_x[173:168]| data_x[179:174]| data_x[185:180]| data_x[191:186]| data_x[197:192]| data_x[203:198]| data_x[209:204]| data_x[215:210]| data_x[221:216]| data_x[227:222]| data_x[233:228]| data_x[239:234]| data_x[245:240]| data_x[251:246]| data_x[257:252]| data_x[263:258]| data_x[269:264]| data_x[275:270]| data_x[281:276]| data_x[287:282]| data_x[293:288]| data_x[299:294]| data_x[305:300]| data_x[311:306]| data_x[317:312]| data_x[323:318]| data_x[329:324]| data_x[335:330]| data_x[341:336]| data_x[347:342]| data_x[353:348]| data_x[359:354]| data_x[365:360]| data_x[371:366]| data_x[377:372]| data_x[383:378]| data_x[389:384]| data_x[395:390]| data_x[401:396]| data_x[407:402]| data_x[413:408]| data_x[419:414]| data_x[425:420]| data_x[431:426]| data_x[437:432]| data_x[443:438]| data_x[449:444]| data_x[455:450]| data_x[461:456]| data_x[467:462]| data_x[473:468]| data_x[479:474]| data_x[485:480]| data_x[491:486]| data_x[497:492]| data_x[503:498]| data_x[509:504]| data_x[515:510]| data_x[521:516]| data_x[527:522]| data_x[533:528]| data_x[539:534]| data_x[545:540]| data_x[551:546]| data_x[557:552]| data_x[563:558]| data_x[569:564]| data_x[575:570]| data_x[581:576]| data_x[587:582]| data_x[593:588]| data_x[599:594];
	assign tmp_2 = W_x[5:0] | W_x[11:6] | W_x[17:12]| W_x[23:18]| W_x[29:24]|  W_x[35:30]| W_x[41:36]| W_x[47:42]| W_x[53:48]| W_x[59:54]| W_x[65:60]| W_x[71:66]| W_x[77:72]| W_x[83:78]| W_x[89:84]| W_x[95:90]| W_x[101:96]| W_x[107:102]| W_x[113:108]| W_x[119:114]| W_x[125:120]| W_x[131:126]| W_x[137:132]| W_x[143:138]| W_x[149:144]| W_x[155:150]| W_x[161:156]| W_x[167:162]| W_x[173:168]| W_x[179:174]| W_x[185:180]| W_x[191:186]| W_x[197:192]| W_x[203:198]| W_x[209:204]| W_x[215:210]| W_x[221:216]| W_x[227:222]| W_x[233:228]| W_x[239:234]| W_x[245:240]| W_x[251:246]| W_x[257:252]| W_x[263:258]| W_x[269:264]| W_x[275:270]| W_x[281:276]| W_x[287:282]| W_x[293:288]| W_x[299:294]| W_x[305:300]| W_x[311:306]| W_x[317:312]| W_x[323:318]| W_x[329:324]| W_x[335:330]| W_x[341:336]| W_x[347:342]| W_x[353:348]| W_x[359:354]| W_x[365:360]| W_x[371:366]| W_x[377:372]| W_x[383:378]| W_x[389:384]| W_x[395:390]| W_x[401:396]| W_x[407:402]| W_x[413:408]| W_x[419:414]| W_x[425:420]| W_x[431:426]| W_x[437:432]| W_x[443:438]| W_x[449:444]| W_x[455:450]| W_x[461:456]| W_x[467:462]| W_x[473:468]| W_x[479:474]| W_x[485:480]| W_x[491:486]| W_x[497:492]| W_x[503:498]| W_x[509:504]| W_x[515:510]| W_x[521:516]| W_x[527:522]| W_x[533:528]| W_x[539:534]| W_x[545:540]| W_x[551:546]| W_x[557:552]| W_x[563:558]| W_x[569:564]| W_x[575:570]| W_x[581:576]| W_x[587:582]| W_x[593:588]| W_x[599:594];
	assign data_out_x = tmp_1 | tmp_2;

	
endmodule