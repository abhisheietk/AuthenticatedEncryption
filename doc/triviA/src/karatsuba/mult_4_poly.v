`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:47 08/29/2013 
// Design Name: 
// Module Name:    mult-4-poly 
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
module mult_4_poly(
    input [3:0] A,
    input [3:0] B,
    output [6:0] C
    );

assign C[0] = A[0] & B[0];
assign C[0] = A[0] & B[0];
assign C[1] = ( A[0] & B[1]) ^ (A[1] & B[0]);
assign C[2] = ( A[0] & B[2]) ^ (A[1] & B[1]) ^ ( A[2] & B[0]);
assign C[3] = ( A[0] & B[3]) ^ (A[1] & B[2]) ^ ( A[2] & B[1]) ^ (A[3] & B[0]);
assign C[4] = (A[1] & B[3]) ^ ( A[2] & B[2]) ^ ( A[3] & B[1]);
assign C[5] = ( A[2] & B[3]) ^ (A[3] & B[2]);
assign C[6] = A[3] & B[3];

endmodule