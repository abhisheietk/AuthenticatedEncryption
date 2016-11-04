

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


module Karasubapoly_8(
// port declaration
input [7:0] A, B,
//input clk,
output [14:0] C
);
wire [3:0] AHL, BHL;
wire [6:0] C_1, C_2, C_3, C_4;



assign AHL = A[7:4] ^ A[3:0];
assign BHL = B[7:4] ^ B[3:0];

mult_4_poly Q0(A[7:4], B[7:4], C_1);
mult_4_poly Q1(A[3:0], B[3:0], C_3);
mult_4_poly Q2(AHL, BHL, C_4);

assign C_2 = C_1 ^ C_3 ^ C_4;

assign C = (C_1 << 8) ^ (C_2 << 4) ^ C_3;
endmodule


