/*This is the testbench file which can be used to verify the functionality of the algorithm.
Everything is already set. So, you don't need to change the things in the file.

IMPORTANT: Only change the values where "CHANGE HERE" is mentioned.

HOW TO USE:
	Since the data will be very huge, it would be difficult to write that all here.
	The best is to generate the data file in 1 column using the C code provided of Trivia.
	So, follow these:
	1- Generate Associated data file in text format using Trivia Code. 
		1.a- Enter the filename at the place CHANGE HERE AD FILE		
	2- Generate Ciphered data file in text format using Trivia Code.
		2.a- Enter the filename at the place CHANGE HERE MSG FILE
	3- Copy the files and paste them in current project directory
	4- Run the simulations and enjoy. :)
	5- At the end, and output file will be generated with the required deciphered data.
	
	*/




module tb;

reg clk;
reg reset;

reg [63:0] adLen;
reg [63:0] msgLen;

wire [63:0] ad;
wire [63:0] msg;

reg [7:0] Nsec;
reg [63:0] Npub;
reg [127:0] key;

wire [63:0] ct;
wire [63:0] clen;
reg start_core;
reg encDec;



reg writeToMem_reg;

wire shift_data_in_block;
wire writeToMem;
wire debug_dataMode;

integer ct_file;

// memories to hold data.
reg [63:0] memRead [0:10000];	// CHANGE HERE
reg [63:0] adMem [0:10000];		//CHANGE HERE 


// counters to generate memory addresses
reg [11:0] adMemcount;	// CHANGE HERE
reg [11:0] rdMemcount;	// CHANGE HERE

wire [63:0] dataFromMem ; 
wire [63:0] dataFromAdMem ; 


 trivia_top top (
		.clk (clk)
		,.reset (reset)
		
		,.key (key)
		,.msg (msg)	// message
		,.ad (ad)		// associated data
		,.adLen	(adLen)// associated data length
		,.msgLen (msgLen)	// message length
		,.Nsec (Nsec)
		,.Npub	(Npub)// nonce public msg
		,.cipher_text (ct)
		,.clen (clen)
		,.shift_data_in_block (shift_data_in_block)
		,.encDec(encDec)
		,.debug_dataMode (debug_dataMode)
		
		//debug
		,.start_core (start_core)
		,.writeToMem (writeToMem)
	);


assign ad = dataFromAdMem;
assign msg = dataFromMem;
assign dataFromMem = memRead[rdMemcount];
assign dataFromAdMem = adMem [adMemcount];



initial
begin

//	 Files which are read and written
	ct_file = $fopen ("output.txt");
	
	$readmemh("myMsg.txt", memRead);	// CHANGE HERE MSG FILE
	$readmemh("myAd.txt", adMem);		// CHANGE HERE AD FILE
	clk = 0;
	reset = 0;
	key = 0;
	start_core = 0;
	
	encDec = 0;
	#10 reset = 1;
	
	
	
	// Total data lengths
	#10 adLen =16;		// CHANGE HERE
		msgLen =16;	// CHANGE HERE
		Npub = 0;
		encDec = 1;

		
	#40 reset = 0;
	#10 start_core = 1;
	#40 start_core = 0;
	
	#10000000	$fclose(ct_file); 
	
end




always
begin
	#10 clk = ~clk;
end


	always @ (posedge clk or posedge reset)
	if (reset)
		writeToMem_reg <= 0;
	else
		writeToMem_reg <= writeToMem;
	
	always @ (posedge clk )
		if (writeToMem) $fwriteh(ct_file,"\n",ct);
	


	always @ (posedge clk or posedge reset)
	if (reset)
	begin
		rdMemcount <= 0;
		adMemcount <= 0;
	end
	else
	begin
		if (debug_dataMode & shift_data_in_block)
			rdMemcount <= rdMemcount + 1;
		else
			rdMemcount <= rdMemcount;
			
		if (shift_data_in_block & ~debug_dataMode)
			adMemcount <= adMemcount + 1;
		else
			adMemcount <= adMemcount;
	end		
			
endmodule
