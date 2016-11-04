
 // Load State Blocks with Nonce and key
 // SC_update64
	/* It Updates the Streamcipher state (64 rounds together) and also generates the 64 bit key. */


module load_SC  (
				clk 
				,rst 
				,Npub
				,key
				,load_SC64				
				,insertSC								
				,tag
				,SC_state
				,Z
	);
		
		
		
	input clk;
	input rst;
	input load_SC64;
	input [63:0] Npub;
	input [127:0] key;
	input [127:0] tag;
	
	input insertSC;
	
	output [383:0] SC_state; 
	output [63:0]  Z;
				
	reg [383:0] SC_state_reg;	

	// param for Trivia_ck
	// trivia 0
	wire [63:0] param = 64'h0;
	
	//trivia 128
	//wire [63:0] param = 32'h00800000;
		

	wire [63:0] t1;
	wire [63:0] t2;
	wire [63:0] t3;
	wire [63:0] Z;
	wire [63:0] Z_inv;
	
	wire [131:0] A;
	wire [104:0] B;
	wire [146:0] C;
	
	wire [127:0] tag_inv;
	
	wire [383:0] SC_state_inv;	//  flipped SC_state connected here. MSB is connected to LSB. We will flip it to work with other modules.
	
	assign A = SC_state_reg[131:000];
	assign B = SC_state_reg[236:132];
	assign C = SC_state_reg[383:237];
	
	assign t1 = A[65:2] ^ A[131:68] ^ (A[129:66] & A[130:67]) ^ B[95:32];
	assign t2 = B[68:5] ^ B[104:41] ^ (B[102:39] & B[103:40]) ^ C[119:56];
	assign t3 = C[65:2] ^ C[146:83] ^ (C[144:81] & C[145:82]) ^ A[74:11];
	
	assign Z_inv = A[65:2] ^ A[131:68] ^ B[68:5] ^ B[104:41] ^ C[65:2] ^ C[146:83] ^ (A[101:38] & B[65:2]);
	
	assign Z = {Z_inv[0],Z_inv[1],Z_inv[2],Z_inv[3],Z_inv[4],Z_inv[5],Z_inv[6],Z_inv[7],Z_inv[8],Z_inv[9],
Z_inv[10],Z_inv[11],Z_inv[12],Z_inv[13],Z_inv[14],Z_inv[15],Z_inv[16],Z_inv[17],Z_inv[18],Z_inv[19],
Z_inv[20],Z_inv[21],Z_inv[22],Z_inv[23],Z_inv[24],Z_inv[25],Z_inv[26],Z_inv[27],Z_inv[28],Z_inv[29],
Z_inv[30],Z_inv[31],Z_inv[32],Z_inv[33],Z_inv[34],Z_inv[35],Z_inv[36],Z_inv[37],Z_inv[38],Z_inv[39],
Z_inv[40],Z_inv[41],Z_inv[42],Z_inv[43],Z_inv[44],Z_inv[45],Z_inv[46],Z_inv[47],Z_inv[48],Z_inv[49],
Z_inv[50],Z_inv[51],Z_inv[52],Z_inv[53],Z_inv[54],Z_inv[55],Z_inv[56],Z_inv[57],Z_inv[58],Z_inv[59],
Z_inv[60],Z_inv[61],Z_inv[62],Z_inv[63]};
	
	
	assign SC_state[63:0] = {SC_state_inv[0],SC_state_inv[1],SC_state_inv[2],SC_state_inv[3],SC_state_inv[4],SC_state_inv[5],SC_state_inv[6],SC_state_inv[7],SC_state_inv[8],SC_state_inv[9],
SC_state_inv[10],SC_state_inv[11],SC_state_inv[12],SC_state_inv[13],SC_state_inv[14],SC_state_inv[15],SC_state_inv[16],SC_state_inv[17],SC_state_inv[18],SC_state_inv[19],
SC_state_inv[20],SC_state_inv[21],SC_state_inv[22],SC_state_inv[23],SC_state_inv[24],SC_state_inv[25],SC_state_inv[26],SC_state_inv[27],SC_state_inv[28],SC_state_inv[29],
SC_state_inv[30],SC_state_inv[31],SC_state_inv[32],SC_state_inv[33],SC_state_inv[34],SC_state_inv[35],SC_state_inv[36],SC_state_inv[37],SC_state_inv[38],SC_state_inv[39],
SC_state_inv[40],SC_state_inv[41],SC_state_inv[42],SC_state_inv[43],SC_state_inv[44],SC_state_inv[45],SC_state_inv[46],SC_state_inv[47],SC_state_inv[48],SC_state_inv[49],
SC_state_inv[50],SC_state_inv[51],SC_state_inv[52],SC_state_inv[53],SC_state_inv[54],SC_state_inv[55],SC_state_inv[56],SC_state_inv[57],SC_state_inv[58],SC_state_inv[59],
SC_state_inv[60],SC_state_inv[61],SC_state_inv[62],SC_state_inv[63]}; 

	assign SC_state[127:64] = {SC_state_inv[64],SC_state_inv[65],SC_state_inv[66],SC_state_inv[67],SC_state_inv[68],SC_state_inv[69],
SC_state_inv[70],SC_state_inv[71],SC_state_inv[72],SC_state_inv[73],SC_state_inv[74],SC_state_inv[75],SC_state_inv[76],SC_state_inv[77],SC_state_inv[78],SC_state_inv[79],
SC_state_inv[80],SC_state_inv[81],SC_state_inv[82],SC_state_inv[83],SC_state_inv[84],SC_state_inv[85],SC_state_inv[86],SC_state_inv[87],SC_state_inv[88],SC_state_inv[89],
SC_state_inv[90],SC_state_inv[91],SC_state_inv[92],SC_state_inv[93],SC_state_inv[94],SC_state_inv[95],SC_state_inv[96],SC_state_inv[97],SC_state_inv[98],SC_state_inv[99],
SC_state_inv[100],SC_state_inv[101],SC_state_inv[102],SC_state_inv[103],SC_state_inv[104],SC_state_inv[105],SC_state_inv[106],SC_state_inv[107],SC_state_inv[108],SC_state_inv[109],
SC_state_inv[110],SC_state_inv[111],SC_state_inv[112],SC_state_inv[113],SC_state_inv[114],SC_state_inv[115],SC_state_inv[116],SC_state_inv[117],SC_state_inv[118],SC_state_inv[119],
SC_state_inv[120],SC_state_inv[121],SC_state_inv[122],SC_state_inv[123],SC_state_inv[124],SC_state_inv[125],SC_state_inv[126],SC_state_inv[127]};

	assign SC_state[191:128] = {SC_state_inv[128],SC_state_inv[129],
SC_state_inv[130],SC_state_inv[131],SC_state_inv[132],SC_state_inv[133],SC_state_inv[134],SC_state_inv[135],SC_state_inv[136],SC_state_inv[137],SC_state_inv[138],SC_state_inv[139],
SC_state_inv[140],SC_state_inv[141],SC_state_inv[142],SC_state_inv[143],SC_state_inv[144],SC_state_inv[145],SC_state_inv[146],SC_state_inv[147],SC_state_inv[148],SC_state_inv[149],
SC_state_inv[150],SC_state_inv[151],SC_state_inv[152],SC_state_inv[153],SC_state_inv[154],SC_state_inv[155],SC_state_inv[156],SC_state_inv[157],SC_state_inv[158],SC_state_inv[159],
SC_state_inv[160],SC_state_inv[161],SC_state_inv[162],SC_state_inv[163],SC_state_inv[164],SC_state_inv[165],SC_state_inv[166],SC_state_inv[167],SC_state_inv[168],SC_state_inv[169],
SC_state_inv[170],SC_state_inv[171],SC_state_inv[172],SC_state_inv[173],SC_state_inv[174],SC_state_inv[175],SC_state_inv[176],SC_state_inv[177],SC_state_inv[178],SC_state_inv[179],
SC_state_inv[180],SC_state_inv[181],SC_state_inv[182],SC_state_inv[183],SC_state_inv[184],SC_state_inv[185],SC_state_inv[186],SC_state_inv[187],SC_state_inv[188],SC_state_inv[189],
SC_state_inv[190],SC_state_inv[191]};

	assign SC_state[255:192] = {SC_state_inv[192],SC_state_inv[193],SC_state_inv[194],SC_state_inv[195],SC_state_inv[196],SC_state_inv[197],SC_state_inv[198],SC_state_inv[199],
SC_state_inv[200],SC_state_inv[201],SC_state_inv[202],SC_state_inv[203],SC_state_inv[204],SC_state_inv[205],SC_state_inv[206],SC_state_inv[207],SC_state_inv[208],SC_state_inv[209],
SC_state_inv[210],SC_state_inv[211],SC_state_inv[212],SC_state_inv[213],SC_state_inv[214],SC_state_inv[215],SC_state_inv[216],SC_state_inv[217],SC_state_inv[218],SC_state_inv[219],
SC_state_inv[220],SC_state_inv[221],SC_state_inv[222],SC_state_inv[223],SC_state_inv[224],SC_state_inv[225],SC_state_inv[226],SC_state_inv[227],SC_state_inv[228],SC_state_inv[229],
SC_state_inv[230],SC_state_inv[231],SC_state_inv[232],SC_state_inv[233],SC_state_inv[234],SC_state_inv[235],SC_state_inv[236],SC_state_inv[237],SC_state_inv[238],SC_state_inv[239],
SC_state_inv[240],SC_state_inv[241],SC_state_inv[242],SC_state_inv[243],SC_state_inv[244],SC_state_inv[245],SC_state_inv[246],SC_state_inv[247],SC_state_inv[248],SC_state_inv[249],
SC_state_inv[250],SC_state_inv[251],SC_state_inv[252],SC_state_inv[253],SC_state_inv[254],SC_state_inv[255]};

	assign SC_state[319:256] = {SC_state_inv[256],SC_state_inv[257],SC_state_inv[258],SC_state_inv[259],
SC_state_inv[260],SC_state_inv[261],SC_state_inv[262],SC_state_inv[263],SC_state_inv[264],SC_state_inv[265],SC_state_inv[266],SC_state_inv[267],SC_state_inv[268],SC_state_inv[269],
SC_state_inv[270],SC_state_inv[271],SC_state_inv[272],SC_state_inv[273],SC_state_inv[274],SC_state_inv[275],SC_state_inv[276],SC_state_inv[277],SC_state_inv[278],SC_state_inv[279],
SC_state_inv[280],SC_state_inv[281],SC_state_inv[282],SC_state_inv[283],SC_state_inv[284],SC_state_inv[285],SC_state_inv[286],SC_state_inv[287],SC_state_inv[288],SC_state_inv[289],
SC_state_inv[290],SC_state_inv[291],SC_state_inv[292],SC_state_inv[293],SC_state_inv[294],SC_state_inv[295],SC_state_inv[296],SC_state_inv[297],SC_state_inv[298],SC_state_inv[299],
SC_state_inv[300],SC_state_inv[301],SC_state_inv[302],SC_state_inv[303],SC_state_inv[304],SC_state_inv[305],SC_state_inv[306],SC_state_inv[307],SC_state_inv[308],SC_state_inv[309],
SC_state_inv[310],SC_state_inv[311],SC_state_inv[312],SC_state_inv[313],SC_state_inv[314],SC_state_inv[315],SC_state_inv[316],SC_state_inv[317],SC_state_inv[318],SC_state_inv[319]};


	assign SC_state[383:320] = {SC_state_inv[320],SC_state_inv[321],SC_state_inv[322],SC_state_inv[323],SC_state_inv[324],SC_state_inv[325],SC_state_inv[326],SC_state_inv[327],SC_state_inv[328],SC_state_inv[329],
SC_state_inv[330],SC_state_inv[331],SC_state_inv[332],SC_state_inv[333],SC_state_inv[334],SC_state_inv[335],SC_state_inv[336],SC_state_inv[337],SC_state_inv[338],SC_state_inv[339],
SC_state_inv[340],SC_state_inv[341],SC_state_inv[342],SC_state_inv[343],SC_state_inv[344],SC_state_inv[345],SC_state_inv[346],SC_state_inv[347],SC_state_inv[348],SC_state_inv[349],
SC_state_inv[350],SC_state_inv[351],SC_state_inv[352],SC_state_inv[353],SC_state_inv[354],SC_state_inv[355],SC_state_inv[356],SC_state_inv[357],SC_state_inv[358],SC_state_inv[359],
SC_state_inv[360],SC_state_inv[361],SC_state_inv[362],SC_state_inv[363],SC_state_inv[364],SC_state_inv[365],SC_state_inv[366],SC_state_inv[367],SC_state_inv[368],SC_state_inv[369],
SC_state_inv[370],SC_state_inv[371],SC_state_inv[372],SC_state_inv[373],SC_state_inv[374],SC_state_inv[375],SC_state_inv[376],SC_state_inv[377],SC_state_inv[378],SC_state_inv[379],
SC_state_inv[380],SC_state_inv[381],SC_state_inv[382],SC_state_inv[383]};

	assign SC_state_inv = SC_state_reg;	
	
	
	assign tag_inv = {tag[0],tag[1],tag[2],tag[3],tag[4],tag[5],tag[6],tag[7],tag[8],tag[9],
tag[10],tag[11],tag[12],tag[13],tag[14],tag[15],tag[16],tag[17],tag[18],tag[19],
tag[20],tag[21],tag[22],tag[23],tag[24],tag[25],tag[26],tag[27],tag[28],tag[29],
tag[30],tag[31],tag[32],tag[33],tag[34],tag[35],tag[36],tag[37],tag[38],tag[39],
tag[40],tag[41],tag[42],tag[43],tag[44],tag[45],tag[46],tag[47],tag[48],tag[49],
tag[50],tag[51],tag[52],tag[53],tag[54],tag[55],tag[56],tag[57],tag[58],tag[59],
tag[60],tag[61],tag[62],tag[63],tag[64],tag[65],tag[66],tag[67],tag[68],tag[69],
tag[70],tag[71],tag[72],tag[73],tag[74],tag[75],tag[76],tag[77],tag[78],tag[79],
tag[80],tag[81],tag[82],tag[83],tag[84],tag[85],tag[86],tag[87],tag[88],tag[89],
tag[90],tag[91],tag[92],tag[93],tag[94],tag[95],tag[96],tag[97],tag[98],tag[99],
tag[100],tag[101],tag[102],tag[103],tag[104],tag[105],tag[106],tag[107],tag[108],tag[109],
tag[110],tag[111],tag[112],tag[113],tag[114],tag[115],tag[116],tag[117],tag[118],tag[119],
tag[120],tag[121],tag[122],tag[123],tag[124],tag[125],tag[126],tag[127]};
	
	//Shifting and Inserting Updated Blocks
	
	always @ (posedge clk or posedge rst)
	if (rst)
		begin
		SC_state_reg[131:0] 		<= {4'h0,key};					//A
		SC_state_reg[236:132] 	<= {{3{1'b1}},{102{1'b0}}};				//B
		SC_state_reg[383:237] 	<= {{19{1'b0}},param,param};		//C		
		end
	else
		begin
			if ( load_SC64)
			begin
			SC_state_reg[131:000] 	<= {A[67:0],t3};						//s0
			SC_state_reg[236:132] 	<= {B[40:0],t1};		//s1
			SC_state_reg[383:237] 	<= {C[82:0],t2};	//s2			
			end
		   else if (insertSC)
		   begin
		   SC_state_reg[063:000] 		<=  SC_state_reg[63:0]  ^ {tag_inv[95:64],tag_inv[127:96]} ;	
			SC_state_reg[127:064] 		<=  SC_state_reg[127:64]  ^ {tag_inv[31:00],tag_inv[63:32]} ;	
						
		   end
		end
		
			
endmodule		
		