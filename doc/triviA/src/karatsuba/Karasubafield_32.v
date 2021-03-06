`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////

// Company:

// Engineer:

//

// Create Date:    15:34:59 08/28/2013

// Design Name:

// Module Name:    Karasuba_field16

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

module Karasubafield_32(

// port declaration

input [31:0] A_in, B_in,

//input clk,

output [31:0] C_out

);

//reg[31:0] A, B;

//reg [31:0] C_out;

//wire [31:0] C;

wire [15:0] AHL, BHL;

wire [31:0] c_1, c_2, c_3, c_4, D;


/*
always@(posedge clk)

begin

A = A_in;

B = B_in;

//C_out = C;

end
*/

assign AHL = A_in[31:16] ^ A_in[15:0];

assign BHL = B_in[31:16] ^ B_in[15:0];


Karasubapoly_16 N0(A_in[31:16],B_in[31:16],c_1[30:0]); //a_high * b_high =z2

Karasubapoly_16 N1(A_in[15:0],B_in[15:0],c_3[30:0]); //a_low * b_low = z0

Karasubapoly_16 N2(AHL,BHL,D[30:0]);

assign c_1[31]=0;

assign c_3[31]=0;

assign D[31]=0;

assign c_2 = c_1 ^ c_3 ^ D; //z1

assign c_4[31]= (c_1[9]^c_1[19]^c_1[30]^c_1[31])^(c_2[15]^c_2[25]);

assign c_4[30]= (c_1[8]^c_1[18]^c_1[29]^c_1[30])^(c_2[14]^c_2[24]);

assign c_4[29]= (c_1[7]^c_1[17]^c_1[28]^c_1[29])^(c_2[13]^c_2[23]);

assign c_4[28]= (c_1[6]^c_1[16]^c_1[27]^c_1[28])^(c_2[12]^c_2[22]);

assign c_4[27]= (c_1[5]^c_1[15]^c_1[26]^c_1[27])^(c_2[11]^c_2[21]^c_2[31]);

assign c_4[26]= (c_1[4]^c_1[14]^c_1[25]^c_1[26])^(c_2[10]^c_2[20]^c_2[30]);

assign c_4[25]= (c_1[3]^c_1[13]^c_1[24]^c_1[25])^(c_2[9]^c_2[19]^c_2[29]);

assign c_4[24]= (c_1[2]^c_1[12]^c_1[23]^c_1[24])^(c_2[8]^c_2[18]^c_2[28]);

assign c_4[23]= (c_1[1]^c_1[11]^c_1[22]^c_1[23]^c_1[31])^(c_2[7]^c_2[17]^c_2[27]);

assign c_4[22]= (c_1[0]^c_1[10]^c_1[21]^c_1[22]^c_1[30])^(c_2[6]^c_2[16]^c_2[26]);

assign c_4[21]= (c_1[19]^c_1[20]^c_1[21]^c_1[29]^c_1[30]^c_1[31])^(c_2[5]);

assign c_4[20]= (c_1[18]^c_1[19]^c_1[20]^c_1[28]^c_1[29]^c_1[30])^(c_2[4]);

assign c_4[19]= (c_1[17]^c_1[18]^c_1[19]^c_1[27]^c_1[28]^c_1[29])^(c_2[3]);

assign c_4[18]= (c_1[16]^c_1[17]^c_1[18]^c_1[26]^c_1[27]^c_1[28])^(c_2[2]);

assign c_4[17]= (c_1[15]^c_1[16]^c_1[17]^c_1[25]^c_1[26]^c_1[27])^(c_2[1]^c_2[31]);

assign c_4[16]= (c_1[14]^c_1[15]^c_1[16]^c_1[24]^c_1[25]^c_1[26])^(c_2[0]^c_2[30]^c_2[31]);

assign c_4[15]= (c_1[13]^c_1[14]^c_1[15]^c_1[23]^c_1[24]^c_1[25])^(c_2[29]^c_2[30]^c_2[31]);

assign c_4[14]= (c_1[12]^c_1[13]^c_1[14]^c_1[22]^c_1[23]^c_1[24])^(c_2[28]^c_2[29]^c_2[30]);

assign c_4[13]= (c_1[11]^c_1[12]^c_1[13]^c_1[21]^c_1[22]^c_1[23]^c_1[31])^(c_2[27]^c_2[28]^c_2[29]);

assign c_4[12]= (c_1[10]^c_1[11]^c_1[12]^c_1[20]^c_1[21]^c_1[22]^c_1[30]^c_1[31])^(c_2[26]^c_2[27]^c_2[28]);

assign c_4[11]= (c_1[9]^c_1[10]^c_1[11]^c_1[19]^c_1[20]^c_1[21]^c_1[29]^c_1[30]^c_1[31])^(c_2[25]^c_2[26]^c_2[27]);

assign c_4[10]= (c_1[8]^c_1[9]^c_1[10]^c_1[18]^c_1[19]^c_1[20]^c_1[28]^c_1[29]^c_1[30])^(c_2[24]^c_2[25]^c_2[26]);

assign c_4[9]= (c_1[7]^c_1[8]^c_1[9]^c_1[17]^c_1[18]^c_1[19]^c_1[27]^c_1[28]^c_1[29])^(c_2[23]^c_2[24]^c_2[25]);

assign c_4[8]= (c_1[6]^c_1[7]^c_1[8]^c_1[16]^c_1[17]^c_1[18]^c_1[26]^c_1[27]^c_1[28])^(c_2[22]^c_2[23]^c_2[24]);

assign c_4[7]= (c_1[5]^c_1[6]^c_1[7]^c_1[15]^c_1[16]^c_1[17]^c_1[25]^c_1[26]^c_1[27])^(c_2[21]^c_2[22]^c_2[23]^c_2[31]);

assign c_4[6]= (c_1[4]^c_1[5]^c_1[6]^c_1[14]^c_1[15]^c_1[16]^c_1[24]^c_1[25]^c_1[26])^(c_2[20]^c_2[21]^c_2[22]^c_2[30]^c_2[31]);

assign c_4[5]= (c_1[3]^c_1[4]^c_1[5]^c_1[13]^c_1[14]^c_1[15]^c_1[23]^c_1[24]^c_1[25])^(c_2[19]^c_2[20]^c_2[21]^c_2[29]^c_2[30]^c_2[31]);

assign c_4[4]= (c_1[2]^c_1[3]^c_1[4]^c_1[12]^c_1[13]^c_1[14]^c_1[22]^c_1[23]^c_1[24])^(c_2[18]^c_2[19]^c_2[20]^c_2[28]^c_2[29]^c_2[30]);

assign c_4[3]= (c_1[1]^c_1[2]^c_1[3]^c_1[11]^c_1[12]^c_1[13]^c_1[21]^c_1[22]^c_1[23])^(c_2[17]^c_2[18]^c_2[19]^c_2[27]^c_2[28]^c_2[29]);

assign c_4[2]= (c_1[0]^c_1[1]^c_1[2]^c_1[10]^c_1[11]^c_1[12]^c_1[20]^c_1[21]^c_1[22]^c_1[31])^(c_2[16]^c_2[17]^c_2[18]^c_2[26]^c_2[27]^c_2[28]);

assign c_4[1]= (c_1[0]^c_1[1]^c_1[10]^c_1[11]^c_1[20]^c_1[21]^c_1[31])^(c_2[16]^c_2[17]^c_2[26]^c_2[27]);

assign c_4[0]= (c_1[0]^c_1[10]^c_1[20]^c_1[31])^(c_2[16]^c_2[26]);

assign C_out = c_4 ^ c_3;

endmodule

