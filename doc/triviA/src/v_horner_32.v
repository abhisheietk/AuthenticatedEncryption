

/* Horner's Multiplication for 32-bit Vandermonde Matrix Multiplcaition 
   When FULL is 1 (for AD) we process 160 bit tags, otheriwse (for message) 128 bit 
	
	- Calculates new Tag and output it to Top module, where it is updated.


-----------------------------------------------------------------------*/	
	

module v_horner_32 (
					PDP
					,Tag
					,FULL
					,Tag_out
					);
			

	parameter [31:0] CONST_alpha_32  = 32'h00400007;              // The primitive polynomial for GF(2^32) 

	
	input [31:0] 	PDP;
	input [127:0]	Tag;
	input			FULL;
	
	output [127:0] Tag_out;
	
	// ---------------------------------------------------------------------------
	
	wire [31:0] tag_0;
	wire [31:0] tag_1;
	wire [31:0] tag_2;
	wire [31:0] tag_3;
	
	
	wire [31:0] pre_tag_2;
	wire [31:0] pre_tag_3;
	wire [31:0] pre_tag_3_b;
	
	
	// ------------------------------------------------------------------------------
	
	assign tag_0 = Tag [31:0] ;
	assign tag_1 = Tag[63]? {Tag[62:32],1'b0} ^ CONST_alpha_32 : {Tag[62:32],1'b0};
	
	assign pre_tag_2 = Tag[95]? {Tag[94:64],1'b0} ^ CONST_alpha_32 : {Tag[94:64],1'b0};
	assign tag_2 =  pre_tag_2[31]? {pre_tag_2[30:0],1'b0} ^ CONST_alpha_32 : {pre_tag_2[30:0],1'b0};
	
	assign pre_tag_3 = Tag[127]? {Tag[126:96],1'b0} ^ CONST_alpha_32 : {Tag[126:96],1'b0};
	assign pre_tag_3_b =  pre_tag_3[31]? {pre_tag_3[30:0],1'b0} ^ CONST_alpha_32 : {pre_tag_3[30:0],1'b0};
	assign tag_3 =  pre_tag_3_b[31]? {pre_tag_3_b[30:0],1'b0} ^ CONST_alpha_32 : {pre_tag_3_b[30:0],1'b0};
	
		
	assign Tag_out [31:0] 		= tag_0 ^ PDP;
	assign Tag_out [63:32]  	= tag_1 ^ PDP;
	assign Tag_out [95:64]  	= tag_2 ^ PDP;
	assign Tag_out [127:96] 	= tag_3 ^ PDP;
	
	
					
endmodule

