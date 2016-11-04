`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:21:11 06/26/2014 
// Design Name: 
// Module Name:    Mult_by_alpha_power 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Mult_by_alpha_power(
	in
	,out
    );
	 
	 parameter [31:0] CONST_alpha_32 =  32'h00400007;              // The primitive polynomial for GF(2^32) 
	 
	 
	 input [31:0] in;
	 output [31:0] out;
	 
	 assign out = in[31]? {in[30:0],1'b0} ^ CONST_alpha_32 : {in[30:0],1'b0};


endmodule
