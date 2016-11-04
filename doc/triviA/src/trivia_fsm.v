
	//The control of Trivia. This FSM controls all the signals of the algorithm.
	
	// ---------------------------------------------------------------------------
	
    module trivia_fsm (
					clk
					,rst
					,start
					,adlen
					,clen
					,msgLen
					,present_state
					,shift_data_in_block
					,final_block

					,load_SC64
					,load_chkSum_in_block
					,chksum_count
					,set_chksum0
					,updateTag
					
					
					
					,dataMode
					
					,update_cLen
					
					
					,adLen_reg
					,process_data
					,reset_tag
					,pre_process_data
					);
				
	input clk;
	input rst;
	input start;
	input [63:0] adlen;
	input [63:0] clen;
	input [63:0] msgLen;
	output [4:0] present_state;
	
	output	shift_data_in_block;
	output	final_block;

	output	load_SC64;
	output	load_chkSum_in_block;
	output	[2:0] chksum_count;
	output	set_chksum0;
	output 	updateTag;
	




	output	dataMode;
	
	output 	update_cLen;
	

	output [63:0] adLen_reg;
	output 	process_data;
	output	reset_tag;
	output 	pre_process_data;
	
	// -------------------------------------------------------------------
	/*
			PARAMETERS
	*/
	parameter [31:0] CHUNK_SIZE = 32'h40000000;			// Process checksum after 2^30 blocks
	parameter [31:0] CHUNK_SIZE_MSG = 32'h40000000;
//'define CHUNK_SIZE 0x00000080			// Process checksum after 128 blocks(for TriviA-128 version)

	parameter [31:0] MAX_IT = 32'h20000000;          // Intermediate Tag (if any) upto 2^29 blocks (2^32 bytes) 
	
	
	// -----------------------------------------------------
	parameter 	state_idle = 0,
				state_SC_update64 = 1,
				state_init_fin 	= 2,
				state_process_data= 3,
				state_load_block  = 4,
				state_pad_128	  = 5,
				state_updateTag   = 7,
				state_insertSC	  = 8,
				state_proc_chksum = 9,
				state_pad_0		  = 6;
			
				
	// -------------------------------------------------------------------
	reg increment_block_count_reg;
	reg [4:0] round_count;
	reg [4:0] present_state;
	reg [4:0] next_state;
	reg [31:0] ck_counter;
	reg [63:0] adLen_reg;
	
	reg [3:0] block_count;
	//reg [2:0] chksum_count;
	reg dataMode ;	// determines the data mode for statemachine and input data to the process block.
						// 0 -> ad = associated data;
						// 1 -> msg = message
	
	reg reset_tag;
	
	// -------------------------------------------------------------------
	wire [4:0] round_count_next;
	wire reset_round_count;
	wire decrement_adLen_reg;
	wire [63:0] adLen_reg_next;
	wire reset_block_count;
	wire chksum_count_max ;
	
	wire increment_block_count;
	wire reset_adLen_reg;
	
	wire ck_counter_zero;
	wire process_data;
	wire init_fin_done;
	wire increment_round_count = (present_state == state_init_fin) |shift_data_in_block | load_chkSum_in_block ;
										 
	
	// -------------------------------------------------------------------
	assign reset_round_count 	= process_data | init_fin_done | updateTag;

	assign final_block 			= (adLen_reg == 8);
	
	assign decrement_adLen_reg =  process_data & ~final_block;
	assign shift_data_in_block = pre_process_data;//(present_state == state_load_block);

	
	
	assign load_SC64				=  process_data | (present_state == state_init_fin) | load_chkSum_in_block;
	assign process_data			= (present_state == state_process_data);
	assign pre_process_data		= (next_state == state_process_data);
	
	
	assign updateTag 				= (present_state == state_updateTag);
	assign load_chkSum_in_block = (present_state == state_proc_chksum);
	
	 
	
	assign chksum_count = round_count[2:0];
	
	assign round_count_next = round_count + 1'b1;	
	
	
	
	assign chksum_count_max = (chksum_count == 2) ;
	
	
	assign init_fin_done = (round_count == 17);
	assign reset_adLen_reg = 1'b0 ;
	
	// -------------------------------------------------------------------
	
	always @ (posedge clk or posedge rst)
	if (rst)
		present_state <= state_idle;
	else
		present_state <= next_state;
 				
				
	always @ (*)
	begin
		next_state = 0;
		
		case (present_state)
		state_idle	 	 :	if (start)		next_state = state_init_fin;
							else			next_state = state_idle;
				
		state_init_fin   :		if  (init_fin_done)					next_state = state_process_data;
										else 											next_state = state_init_fin;
						
		state_process_data : if (final_block)			next_state = state_proc_chksum;
									else							next_state = state_process_data;				
		
		state_updateTag : if (dataMode)		next_state = state_idle;
								else					next_state = state_init_fin;
								
		
		
		state_proc_chksum : if (chksum_count_max )next_state = state_updateTag;
									else 						next_state = state_proc_chksum;
							
		default: next_state = state_idle;
		endcase
	
	end
	
	
	// -------------------------------------------------------------------
	
	/*		
			COUNTERS
	*/


	always @(posedge clk or posedge rst)
	if (rst)
		round_count <= 5'd0;
	else
		if (reset_round_count)
			round_count <= 5'd0;
		else if (increment_round_count)	
			round_count <= round_count_next;
		else
			round_count  <= round_count;

	assign adLen_reg_next = (adLen_reg - 4'd8) ;
	
	always @ (posedge clk or posedge rst)
	if (rst)
		adLen_reg <= adlen;
	else

		if (decrement_adLen_reg)
			adLen_reg <= adLen_reg_next;
		else if (updateTag)
			adLen_reg <= msgLen;
		else
			adLen_reg <= adLen_reg;
			
		
	// Datamode choose mode of operation
	// 0- Associated data processing
	// 1- Message data processing
	always @ (posedge clk or posedge rst)
	if (rst)
		dataMode <= 1'b0;
	else if (updateTag)
		dataMode <= ~dataMode;
	else
		dataMode <= dataMode;
	
	
	always@ (posedge clk)
		reset_tag <= updateTag;
	
endmodule
