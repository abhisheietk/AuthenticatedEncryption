/* Horner's Multiplication for 64-bit Vandermonde Matrix Multiplcaition
   When FULL is 1 (for AD) we process 4 checksum blocks, otheriwse (for message) 3 blocks 
	
	- 1 cyle operation
	- Calculates new checksum value. But updated in the Top module.
   --------------------------------------------------------------------*/


module V_Horner_64 (
					block
					,checksum
					,FULL
					,checksum_out
					);
					
	parameter [63:0] CONST_beta_64 = 64'h000000000000001B;       // The primitive polynomial for GF(2^64)				
	
	input [63:0] 	block;
	input [191:0]	checksum;
	input 			FULL;
	
	output [191:0] 	checksum_out;
	
	// ---------------------------------------------------------------------------
	
	wire [63:0] check_0;
	wire [63:0] check_1;
	wire [63:0] check_2;

	
	wire [63:0] pre_check_2;

	
	// ---------------------------------------------------------------------------
	
	assign check_0 = checksum [63:0] ;
	assign check_1 = checksum[127]? {checksum[126:64],1'b0} ^ CONST_beta_64 : {checksum[126:64],1'b0};
	
	assign pre_check_2 = checksum[191]? {checksum[190:128],1'b0} ^ CONST_beta_64 : {checksum[190:128],1'b0};
	assign check_2 =  pre_check_2[63]? {pre_check_2[62:0],1'b0} ^ CONST_beta_64 : {pre_check_2[62:0],1'b0};
	
			
	assign checksum_out [063:000] = check_0 ^ block;
	assign checksum_out [127:064] = check_1 ^ block;
	assign checksum_out [191:128] = check_2 ^ block;
			
endmodule
