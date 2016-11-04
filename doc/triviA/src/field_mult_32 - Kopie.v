

/* Multiplications of two 32 bit field elements */

// The operation is taking 32 cycles.
// Each bit is processed in 1 cycle.
// It can be changed to 32 bits processed in parallel. Depends on your final goal (high speed or low area)
//

module field_mult_32 (

					input_a
					,input_b	
					,out
					);
					
	//------------------------------------------------

	



	//-----------------------------------------------
					
				
	input 	[31:0] 	input_a;
	input 	[31:0] 	input_b;
	
	output 	[31:0]	out;					
					
	// ---------------------------------------------------------------------------
	
	wire [31:0] result_alpha_pwr;
	wire [31:0] result_to_mul32;
	
	// ---------------------------------------------------------------------------	
	wire [31:0] result_b0_in;
	wire [31:0] result_b1_in;
	wire [31:0] result_b2_in;
	wire [31:0] result_b3_in;
	wire [31:0] result_b4_in;
	wire [31:0] result_b5_in;
	wire [31:0] result_b6_in;
	wire [31:0] result_b7_in;
	wire [31:0] result_b8_in;
	wire [31:0] result_b9_in;
	wire [31:0] result_b10_in;
	wire [31:0] result_b11_in;
	wire [31:0] result_b12_in;
	wire [31:0] result_b13_in;
	wire [31:0] result_b14_in;
	wire [31:0] result_b15_in;
	wire [31:0] result_b16_in;
	wire [31:0] result_b17_in;
	wire [31:0] result_b18_in;
	wire [31:0] result_b19_in;
	wire [31:0] result_b20_in;
	wire [31:0] result_b21_in;
	wire [31:0] result_b22_in;
	wire [31:0] result_b23_in;
	wire [31:0] result_b24_in;
	wire [31:0] result_b25_in;
	wire [31:0] result_b26_in;
	wire [31:0] result_b27_in;
	wire [31:0] result_b28_in;
	wire [31:0] result_b29_in;
	wire [31:0] result_b30_in;
	wire [31:0] result_b31_in;
	
	wire [31:0] result_b0_out;
	wire [31:0] result_b1_out;
	wire [31:0] result_b2_out;
	wire [31:0] result_b3_out;
	wire [31:0] result_b4_out;
	wire [31:0] result_b5_out;
	wire [31:0] result_b6_out;
	wire [31:0] result_b7_out;
	wire [31:0] result_b8_out;
	wire [31:0] result_b9_out;
	wire [31:0] result_b10_out;
	wire [31:0] result_b11_out;
	wire [31:0] result_b12_out;
	wire [31:0] result_b13_out;
	wire [31:0] result_b14_out;
	wire [31:0] result_b15_out;
	wire [31:0] result_b16_out;
	wire [31:0] result_b17_out;
	wire [31:0] result_b18_out;
	wire [31:0] result_b19_out;
	wire [31:0] result_b20_out;
	wire [31:0] result_b21_out;
	wire [31:0] result_b22_out;
	wire [31:0] result_b23_out;
	wire [31:0] result_b24_out;
	wire [31:0] result_b25_out;
	wire [31:0] result_b26_out;
	wire [31:0] result_b27_out;
	wire [31:0] result_b28_out;
	wire [31:0] result_b29_out;
	wire [31:0] result_b30_out;
	
	
	
	wire	[31:0] rev_input_b;
	
	// ---------------------------------------------------------------------------
	
	
	
	
		
	assign rev_input_b ={input_b [0],input_b [1],input_b [2],input_b [3],input_b [4],input_b [5],input_b [6],
								input_b [7],input_b [8],input_b [9],input_b [10],input_b [11],input_b [12],input_b [13],
								input_b [14],input_b [15],input_b [16],input_b [17],input_b [18],input_b [19],input_b [20],
								input_b [21],input_b [22],input_b [23],input_b [24],input_b [25],input_b [26],input_b [27],
								input_b [28],input_b [29],input_b [30],input_b [31]};
								
   assign result_b0_in = rev_input_b[0] ? input_a: 32'd0;
	assign result_b1_in = rev_input_b[1] ? result_b0_out ^ input_a : result_b0_out;
	assign result_b2_in = rev_input_b[2] ? result_b1_out ^ input_a : result_b1_out;
	assign result_b3_in = rev_input_b[3] ? result_b2_out ^ input_a : result_b2_out;
	assign result_b4_in = rev_input_b[4] ? result_b3_out ^ input_a : result_b3_out;
	assign result_b5_in = rev_input_b[5] ? result_b4_out ^ input_a : result_b4_out;
	assign result_b6_in = rev_input_b[6] ? result_b5_out ^ input_a : result_b5_out;
	assign result_b7_in = rev_input_b[7] ? result_b6_out ^ input_a : result_b6_out;
	assign result_b8_in = rev_input_b[8] ? result_b7_out ^ input_a : result_b7_out;
	assign result_b9_in = rev_input_b[9] ? result_b8_out ^ input_a : result_b8_out;
	assign result_b10_in = rev_input_b[10] ? result_b9_out ^ input_a : result_b9_out;
	assign result_b11_in = rev_input_b[11] ? result_b10_out ^ input_a : result_b10_out;
	assign result_b12_in = rev_input_b[12] ? result_b11_out ^ input_a : result_b11_out;
	assign result_b13_in = rev_input_b[13] ? result_b12_out ^ input_a : result_b12_out;
	assign result_b14_in = rev_input_b[14] ? result_b13_out ^ input_a : result_b13_out;
	assign result_b15_in = rev_input_b[15] ? result_b14_out ^ input_a : result_b14_out;
	assign result_b16_in = rev_input_b[16] ? result_b15_out ^ input_a : result_b15_out;
	assign result_b17_in = rev_input_b[17] ? result_b16_out ^ input_a : result_b16_out;
	assign result_b18_in = rev_input_b[18] ? result_b17_out ^ input_a : result_b17_out;
	assign result_b19_in = rev_input_b[19] ? result_b18_out ^ input_a : result_b18_out;
	assign result_b20_in = rev_input_b[20] ? result_b19_out ^ input_a : result_b19_out;
	assign result_b21_in = rev_input_b[21] ? result_b20_out ^ input_a : result_b20_out;
	assign result_b22_in = rev_input_b[22] ? result_b21_out ^ input_a : result_b21_out;
	assign result_b23_in = rev_input_b[23] ? result_b22_out ^ input_a : result_b22_out;
	assign result_b24_in = rev_input_b[24] ? result_b23_out ^ input_a : result_b23_out;
	assign result_b25_in = rev_input_b[25] ? result_b24_out ^ input_a : result_b24_out;
	assign result_b26_in = rev_input_b[26] ? result_b25_out ^ input_a : result_b25_out;
	assign result_b27_in = rev_input_b[27] ? result_b26_out ^ input_a : result_b26_out;
	assign result_b28_in = rev_input_b[28] ? result_b27_out ^ input_a : result_b27_out;
	assign result_b29_in = rev_input_b[29] ? result_b28_out ^ input_a : result_b28_out;
	assign result_b30_in = rev_input_b[30] ? result_b29_out ^ input_a : result_b29_out;
	assign result_b31_in = rev_input_b[31] ? result_b30_out ^ input_a : result_b30_out;
	
	

/* Multiplication by alpha power m. */
	
	Mult_by_alpha_power bit0(	.in (result_b0_in)	, .out(result_b0_out)    );
	Mult_by_alpha_power bit1(	.in (result_b1_in)	, .out(result_b1_out)    );
	Mult_by_alpha_power bit2(	.in (result_b2_in)	, .out(result_b2_out)    );
	Mult_by_alpha_power bit3(	.in (result_b3_in)	, .out(result_b3_out)    );
	Mult_by_alpha_power bit4(	.in (result_b4_in)	, .out(result_b4_out)    );
	Mult_by_alpha_power bit5(	.in (result_b5_in)	, .out(result_b5_out)    );
	Mult_by_alpha_power bit6(	.in (result_b6_in)	, .out(result_b6_out)    );
	Mult_by_alpha_power bit7(	.in (result_b7_in)	, .out(result_b7_out)    );
	Mult_by_alpha_power bit8(	.in (result_b8_in)	, .out(result_b8_out)    );
	Mult_by_alpha_power bit9(	.in (result_b9_in)	, .out(result_b9_out)    );
	Mult_by_alpha_power bit10(	.in (result_b10_in)	, .out(result_b10_out)    );
	Mult_by_alpha_power bit11(	.in (result_b11_in)	, .out(result_b11_out)    );
	Mult_by_alpha_power bit12(	.in (result_b12_in)	, .out(result_b12_out)    );
	Mult_by_alpha_power bit13(	.in (result_b13_in)	, .out(result_b13_out)    );
	Mult_by_alpha_power bit14(	.in (result_b14_in)	, .out(result_b14_out)    );
	Mult_by_alpha_power bit15(	.in (result_b15_in)	, .out(result_b15_out)    );
	Mult_by_alpha_power bit16(	.in (result_b16_in)	, .out(result_b16_out)    );
	Mult_by_alpha_power bit17(	.in (result_b17_in)	, .out(result_b17_out)    );
	Mult_by_alpha_power bit18(	.in (result_b18_in)	, .out(result_b18_out)    );
	Mult_by_alpha_power bit19(	.in (result_b19_in)	, .out(result_b19_out)    );
	Mult_by_alpha_power bit20(	.in (result_b20_in)	, .out(result_b20_out)    );
	Mult_by_alpha_power bit21(	.in (result_b21_in)	, .out(result_b21_out)    );
	Mult_by_alpha_power bit22(	.in (result_b22_in)	, .out(result_b22_out)    );
	Mult_by_alpha_power bit23(	.in (result_b23_in)	, .out(result_b23_out)    );
	Mult_by_alpha_power bit24(	.in (result_b24_in)	, .out(result_b24_out)    );
	Mult_by_alpha_power bit25(	.in (result_b25_in)	, .out(result_b25_out)    );
	Mult_by_alpha_power bit26(	.in (result_b26_in)	, .out(result_b26_out)    );
	Mult_by_alpha_power bit27(	.in (result_b27_in)	, .out(result_b27_out)    );
	Mult_by_alpha_power bit28(	.in (result_b28_in)	, .out(result_b28_out)    );
	Mult_by_alpha_power bit29(	.in (result_b29_in)	, .out(result_b29_out)    );
	Mult_by_alpha_power bit30(	.in (result_b30_in)	, .out(result_b30_out)    );
	
	assign out = result_b31_in;
	
	
endmodule					

