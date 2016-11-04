
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
				,z0
				,z1
				,z2
				,z3
				

	);
		
		
		
	input clk;
	input rst;
	input load_SC64;
	input [63:0] Npub;
	input [127:0] key;
	input [159:0] tag;
	
	input insertSC;
	
	output [511:0] SC_state; 
	output [63:0]  Z;
	
	output [63:0] z0;	// 
	output [63:0] z1;	// 
	output [63:0] z2;	// 
	output [63:0] z3;	// 
	
		
		
	reg [511:0] SC_state_reg;	
	reg [63:0] z0;	// 
	reg [63:0] z1;	// 
	reg [63:0] z2;	// 
	reg [63:0] z3;	// 


	// param for Trivia_ck
	// trivia 0
	wire [63:0] param = 64'h0;
	
	//trivia 128
	//wire [63:0] param = 32'h00800000;
		
	wire [63:0] pre_t1;
	wire [63:0] pre_t2;
	wire [63:0] pre_t3;
	wire [63:0] t1;
	wire [63:0] t2;
	wire [63:0] t3;
	wire [63:0] Z;
	
	
	
	assign SC_state = SC_state_reg;

	assign pre_t1 = {SC_state_reg[61:0],SC_state_reg[127:126]} ^ {SC_state_reg[123:64],SC_state_reg[191:188]}	;
	assign pre_t2 = {SC_state_reg[250:192],SC_state_reg[319:315]} ^ {SC_state_reg[214:192], SC_state_reg[319:279]};	
	assign pre_t3 = {SC_state_reg[381:320],SC_state_reg[447:446]} ^ {SC_state_reg[428:384],SC_state_reg[511:493]};
	
	assign Z = pre_t1 ^ pre_t2 ^ pre_t3 ^ ({SC_state_reg[25:0],SC_state_reg[127:90]} & {SC_state_reg[253:192],SC_state_reg[319:318]});
	
	//Computing Updated Blocks
	
	
	assign t1 = pre_t1 ^ ({SC_state_reg[125:64],SC_state_reg[191:190]}  & {SC_state_reg[124:64],SC_state_reg[191:189]}) ^
				{SC_state_reg[223:192],SC_state_reg[319:288]};
	
	assign t2 = pre_t2 ^ ({SC_state_reg[216:192],SC_state_reg[319:281]} & {SC_state_reg[215:192],SC_state_reg[319:280]}) ^ 
				{SC_state_reg[327:320],SC_state_reg[447:392]};
	
	assign t3 = pre_t3 ^ ({SC_state_reg[430:384],SC_state_reg[511:495]} & {SC_state_reg[429:384],SC_state_reg[511:494]}) ^ 
				{SC_state_reg[52:0],SC_state_reg[127:117]};
	
	
	
	//Shifting and Inserting Updated Blocks
	
	always @ (posedge clk or posedge rst)
	if (rst)
		begin
		SC_state_reg[63:0] 		<= key [63:0];					//s0
		SC_state_reg[127:64] 	<= key [127:64];				//s1
		SC_state_reg[191:128] 	<= 64'hFFFF_FFFF_FFFF_FFFF;		//s2
		SC_state_reg[255:192] 	<= 64'hFFFF_FFFF_FFFF_FFFF;		//s3
		SC_state_reg[319:256] 	<= 64'hFFFF_FFFF_FFFF_FFFF;		//s4
		SC_state_reg[383:320] 	<= param;						//s5
		SC_state_reg[447:384] 	<= Npub;						//s6
		SC_state_reg[511:448] 	<= 64'hFFFF_FFFF_FFFF_FFFF;		//s7
		end
	else
		begin
			if ( load_SC64)
			begin
			SC_state_reg[63:0] 		<= t3;						//s0
			SC_state_reg[127:64] 	<= SC_state_reg[63:0];		//s1
			SC_state_reg[191:128] 	<= SC_state_reg[127:64];	//s2
			SC_state_reg[255:192] 	<= t1;						//s3
			SC_state_reg[319:256] 	<= SC_state_reg[255:192];	//s4
			SC_state_reg[383:320] 	<= t2;						//s5
			SC_state_reg[447:384] 	<= SC_state_reg[383:320];	//s6
			SC_state_reg[511:448] 	<= SC_state_reg[447:384];	//s7
			end
		   else if (insertSC)
		   begin
		   SC_state_reg[63:00] 		<=  SC_state_reg[63:0]  ^ {tag [31:0], tag[63:32]} ;	
			SC_state_reg[127:64] 	<= SC_state_reg[127:64] ^ {tag [95:64], tag[127:96]} ;
			SC_state_reg[191:128] 	<= SC_state_reg[191:128] ^ {tag [159:128], 32'd0};	//s2
			SC_state_reg[255:192] 	<= SC_state_reg[255:192] ^ {tag [156:128], 36'd0};						//s3
		   end
		end
		
	always@ (posedge clk or posedge rst)
	if (rst)
		begin
			z0 <= 64'd0;
			z1 <= 64'd0;
			z2 <= 64'd0;
			z3 <= 64'd0;
		end
	else
		begin			
			z0 <= z1;
			z1 <= z2;
			z2 <= z3;
			z3 <= Z;
		end
			
endmodule		
		