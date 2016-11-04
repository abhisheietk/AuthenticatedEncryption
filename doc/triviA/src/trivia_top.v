/*
This is the top module of Trivia-ck encryption core.
Main Functions:
	- Module instantiations
	- I/O port declaration
	- Tag update
	- Checksum update
	
	- Debug signals
	- Signals to get data from memory for decrypting.
	- Signals to write data to the memory.


*/

	//-----------------------------------------------------------------------------
	
	
module trivia_top (
		clk
		,reset
		,key

		,msg	// message
		,ad		// associated data
		,adLen	// associated data length
		,msgLen	// message length
		,Nsec
		,Npub	// nonce public msg
		,cipher_text
		,clen
		,shift_data_in_block
		,encDec			// 0: Encrypt, 1: Decrypt
		,debug_dataMode
		
		// debug
		,writeToMem
		,start_core
	);
	
	// -----------------------------------------------------------------
	//	IOs
	//-----------------------------------------------------------------
	
	input clk;
	input reset;
	
	
	input [127:0] key;	// 128bit key
	input [63:0] msg;
	
	input [63:0] ad;	// byte wide
	input [63:0] adLen;	//64 bit wide

	input [63:0] msgLen;
	input [7:0] Nsec;
	input [63:0] Npub;
	input encDec;
	
	output [63:0] cipher_text;
	output [63:0] clen;
	output shift_data_in_block;
	output debug_dataMode;
	
	
	// for testing
	input start_core;
	output writeToMem;
	
	//--------------------------------------------------------------------
	//		INTERNAL REGISTERS
	//-------------------------------------------------------------------
	
	reg [127:0] tag;
	reg [191:0] checkSum;
	
	reg [63:0] clen;
	

	reg [63:0] block;	// 64 bits data block extracted from associated data.
	
	reg [63:0] block_to_process;	// 
	
	
	wire [31:0] word_upper;
	wire [31:0] word_lower;
	
	wire [31:0] stateKey_upper;
	wire [31:0] stateKey_lower;
	
	/*------------------------------------------------------------------
				WIRES
	--------------------------------------------------------------------*/
	wire [383:0] SC_state_out;
	wire [31:0]	PDP;
	wire [31:0] to_mul_32_a;
	wire [31:0] to_mul_32_b;
	wire [31:0] from_mul_32;
	
	wire [127:0] Tag_out;
	wire [127:0] new_tag;
	wire [2:0] chksum_count;
	wire load_chkSum_in_block;

	
	wire shift_data_in_block;

	wire [63:0] Z;
	wire updateTag;
	
	wire [191:0] checksum_out;
	
	wire dataMode;
	wire [63:0] adLen_reg;
	

		
	
	
	wire load_SC64;
	wire process_data;
	wire pre_writeToMem;
	
	
	wire reset_tag;
	wire final_block;
	wire pre_process_data;
	
	//-----------------------------------------------------------------------------
	//			ASSIGNMENTS
	//-----------------------------------------------------------------------------
	
	assign writeToMem = dataMode & pre_writeToMem;
	assign pre_writeToMem = final_block ? (adLen_reg[3:0] !=0) & process_data : process_data ;
	

	// process block variables
	assign to_mul_32_a  = 	word_upper ^ stateKey_upper;
	assign to_mul_32_b  = 	word_lower ^ stateKey_lower;

	assign PDP = from_mul_32;

	assign cipher_text = Z ^ block ;
	assign debug_dataMode = dataMode;
	
	
	// -------------------------------------------------------------------------------
	
	load_SC  load_state(
				.clk  (clk)
				,.rst (reset)
				,.Npub (Npub)
				,.key (key)
				,.tag (tag)
				,.load_SC64 (load_SC64)
				
				
				,.insertSC (updateTag & (~dataMode) )
				
				,.SC_state (SC_state_out)
				,.Z (Z)


	);

	
	
	// PDP - pseudo dot product
	// Taking 32 cycles
	field_mult_32 mul32(

					.input_a (to_mul_32_a)
					,.input_b (to_mul_32_b)					
					,.out (from_mul_32)
					);
	

	
	/* Horner's Multiplication for 32-bit Vandermonde Matrix Multiplication 
   When FULL is 1 (for AD) we process 160 bit tags, otherwise (for message) 128 bit 
   - Takes 1 cycle
   ----------------------------------------------------------------------*/
	v_horner_32 horner_32(
					.PDP (PDP)
					,.Tag (tag)
					,.FULL (~dataMode)
					,.Tag_out (Tag_out)
					);
	
	
	
	/* Horner's Multiplication for 64-bit Vandermonde Matrix Multiplcaition
   When FULL is 1 (for AD) we process 4 checksum blocks, otheriwse (for message) 3 blocks 
   - Takes 1 cycle
   --------------------------------------------------------------------*/


	V_Horner_64 horner_64(
					.block(block_to_process)
					,.checksum (checkSum)
					,.FULL (~dataMode)
					,.checksum_out (checksum_out)
					);
	
	
	//----------------------------------------------------------------------------
	
	
		// process block variables
		
	assign	word_upper = {block_to_process[63:48], block_to_process[31:16]};
	assign	word_lower = {block_to_process[47:32], block_to_process[15:00]};
		
	assign	stateKey_upper = {SC_state_out[63:48], SC_state_out[31:16]};
	assign	stateKey_lower = {SC_state_out[47:32], SC_state_out[15:00]};	
	
	assign	new_tag [031:000] 	= (chksum_count == 0) ? Tag_out [031:000] ^ Z[63:32] : Tag_out [31:00];
	assign 	new_tag [063:032] 	= (chksum_count == 0) ? Tag_out [063:032] ^ Z[31:00] : Tag_out [63:32];
	assign	new_tag [095:064] 	= (chksum_count == 2) ? Tag_out [095:064] ^ Z[63:32] : Tag_out [95:64];
	assign 	new_tag [127:096] 	= (chksum_count == 2) ? Tag_out [127:096] ^ Z[31:00] : Tag_out [127:96];
	
	
	
	// Tag is only updated here. It is calculated in VHORNER32
	always @ (posedge clk or posedge reset)
	if (reset)
		tag <= 128'd0;
	else if (reset_tag)
		tag <= 128'd0;
	else if (load_chkSum_in_block)//updateTag)
	begin
		tag [031:000] 	<= new_tag [031:0];
		tag [063:032] 	<= new_tag [063:032];
		tag [095:064] 	<= new_tag [095:064];
		tag [127:096] 	<= new_tag [127:096];
		
		
	end
	else if (process_data)
		tag <= Tag_out;
	else
		tag <= tag;
		

	
		
	// CHECKSUM is only updated here. It is calculated in VHORNER64	
	always @ (posedge clk or posedge reset)
	if (reset)
		checkSum <= 192'd0;
	else if (reset_tag)
		checkSum <= 192'd0;
	else if (process_data)
		checkSum <= checksum_out;
	else
		checkSum <= checkSum;

	

	
	
	
	always @ (posedge clk or posedge reset)
	if (reset)
		block <= 64'd0;
	else
		if (dataMode & (pre_process_data | process_data))
			block <= msg;			
		else if (pre_process_data | process_data)
			block <= ad;
		else
			block <= 0;
	
	
	always@ (*)
	begin
		block_to_process = 0;
		
		if ((chksum_count == 0) & load_chkSum_in_block)
			block_to_process = checkSum[63:0];
		else if ( (chksum_count == 1) & load_chkSum_in_block)
			block_to_process = checkSum[127:64];
		else if  ((chksum_count == 2) & load_chkSum_in_block)
			block_to_process = checkSum[191:128];
		else
			block_to_process = (encDec && dataMode)? cipher_text : block;
	end

	
	
	// Output length
	always @ (posedge clk or posedge reset)
	if (reset)
		clen <= 64'd0;
	else if (process_data & final_block & dataMode)
		clen <= clen + adLen_reg[4:0];
	else if (process_data & dataMode)
		clen <= clen + 8;
	else if ( updateTag & dataMode)
		clen <= clen + 16;
	else
		clen <= clen;
	
	
	/*
			CONTROL 
	*/
	
	trivia_fsm control(
					.clk (clk)
					,.rst (reset)
					,.start (start_core)
					,.adlen (adLen)
					,.clen	(clen)
					,.msgLen (msgLen)
					,.present_state ()
					,.shift_data_in_block (shift_data_in_block)
					,.final_block (final_block)
				
					,.load_SC64 (load_SC64)
					,.load_chkSum_in_block (load_chkSum_in_block)
					,.chksum_count (chksum_count)
					
					,.updateTag (updateTag)
								
					,.dataMode (dataMode)
					
					
					
					
					,.adLen_reg (adLen_reg)
					,.process_data (process_data)
					,.reset_tag (reset_tag)
					,.pre_process_data (pre_process_data)
					);
	
	
	
	
	
	
	
	endmodule
	