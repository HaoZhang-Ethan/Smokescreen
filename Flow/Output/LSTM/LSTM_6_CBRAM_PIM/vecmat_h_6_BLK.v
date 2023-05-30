`define ARRAY_DEPTH 64      //Number of Hidden neurons
`define INPUT_DEPTH 100	    //LSTM input vector dimensions
`define DATA_WIDTH 8		//16 bit representation
`define INWEIGHT_DEPTH 6400 //100x64
`define HWEIGHT_DEPTH 4096  //64x64
`define varraysize 1600   //100x16
`define uarraysize 1024  //64x16


module vecmat_h_6_BLK #( parameter uarraysize=1024, vectwidth=64)
(
	input clk,
	input reset,
	input [uarraysize-1:0] data_h,
	input [uarraysize-1:0] W_h,

	output [15:0] data_out_h
);

	wire [15:0] tmp_1, tmp_2;
	assign tmp_1 = data_h[5:0] | data_h[11:6] | data_h[17:12]| data_h[23:18]| data_h[29:24]| data_h[35:30]| data_h[41:36]| data_h[47:42]| data_h[53:48]| data_h[59:54]| data_h[65:60]| data_h[71:66]| data_h[77:72]| data_h[83:78]| data_h[89:84]| data_h[95:90]| data_h[101:96]| data_h[107:102]| data_h[113:108]| data_h[119:114]| data_h[125:120]| data_h[131:126]| data_h[137:132]| data_h[143:138]| data_h[149:144]| data_h[155:150]| data_h[161:156]| data_h[167:162]| data_h[173:168]| data_h[179:174]| data_h[185:180]| data_h[191:186]| data_h[197:192]| data_h[203:198]| data_h[209:204]| data_h[215:210]| data_h[221:216]| data_h[227:222]| data_h[233:228]| data_h[239:234]| data_h[245:240]| data_h[251:246]| data_h[257:252]| data_h[263:258]| data_h[269:264]| data_h[275:270]| data_h[281:276]| data_h[287:282]| data_h[293:288]| data_h[299:294]| data_h[305:300]| data_h[311:306]| data_h[317:312]| data_h[323:318]| data_h[329:324]| data_h[335:330]| data_h[341:336]| data_h[347:342]| data_h[353:348]| data_h[359:354]| data_h[365:360]| data_h[371:366]| data_h[377:372]| data_h[383:378];
	assign tmp_2 = W_h[5:0] | W_h[11:6] | W_h[17:12]| W_h[23:18]| W_h[29:24]| W_h[35:30]| W_h[41:36]| W_h[47:42]| W_h[53:48]| W_h[59:54]| W_h[65:60]| W_h[71:66]| W_h[77:72]| W_h[83:78]| W_h[89:84]| W_h[95:90]| W_h[101:96]| W_h[107:102]| W_h[113:108]| W_h[119:114]| W_h[125:120]| W_h[131:126]| W_h[137:132]| W_h[143:138]| W_h[149:144]| W_h[155:150]| W_h[161:156]| W_h[167:162]| W_h[173:168]| W_h[179:174]| W_h[185:180]| W_h[191:186]| W_h[197:192]| W_h[203:198]| W_h[209:204]| W_h[215:210]| W_h[221:216]| W_h[227:222]| W_h[233:228]| W_h[239:234]| W_h[245:240]| W_h[251:246]| W_h[257:252]| W_h[263:258]| W_h[269:264]| W_h[275:270]| W_h[281:276]| W_h[287:282]| W_h[293:288]| W_h[299:294]| W_h[305:300]| W_h[311:306]| W_h[317:312]| W_h[323:318]| W_h[329:324]| W_h[335:330]| W_h[341:336]| W_h[347:342]| W_h[353:348]| W_h[359:354]| W_h[365:360]| W_h[371:366]| W_h[377:372]| W_h[383:378];
	assign data_out_h = tmp_1 | tmp_2;


endmodule
