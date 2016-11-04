`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:12:28 08/28/2013 
// Design Name: 
// Module Name:    Karasuba_poly_8 
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
module Karasubapoly_16(
// port declaration
input [15:0] A, B,
//input clk,
output [30:0] C
);
wire [7:0] AHL, BHL;
wire [14:0] C_1, C_2, C_3, C_4;






//assign tmp_1 = A[7:4];
//assign tmp_2 = A[3:0];
//assign tmp_3 = B[7:4];
//assign tmp_4 = B[3:0];

assign AHL = A[15:8] ^ A[7:0];
assign BHL = B[15:8] ^ B[7:0];
//Mult_4 M0(C, tmp_1, tmp_3);
Karasubapoly_8 M0(A[15:8], B[15:8], C_1);
Karasubapoly_8 M1(A[7:0], B[7:0], C_3);
Karasubapoly_8 M2(AHL, BHL, C_4);
//assign E = C_1 ^ C_3;
assign C_2 = C_1 ^ C_3 ^ C_4;
// assign F = C_1 << 8;
// assign G = C_2 << 4;
//assign H = F ^ G;

assign C = (C_1 << 16) ^ (C_2 << 8) ^ C_3;
endmodule

