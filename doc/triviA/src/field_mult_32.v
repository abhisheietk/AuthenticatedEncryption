

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
					
	 Karasubafield_32 INST0(

		.A_in (input_a),
		.B_in (input_b),
		.C_out (out)

	);
	
endmodule					

