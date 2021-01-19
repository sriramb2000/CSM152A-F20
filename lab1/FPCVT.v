`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCLA
// Engineer: Sriram Balachandran
// 
// Create Date:    13:42:53 10/19/2020 
// Design Name: 
// Module Name:    FPCVT 
// Project Name:   FPCVT
// Target Devices: 
// Tool versions: 
// Description: Convert a 13-bit linear encoding of an analog signal
// 				 into a compounded 9-bit Floating Point (FP) representation
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FPCVT(
    input [12:0] D,
    output S,
    output reg [2:0] E,
    output reg [4:0] F
    );
	 
	 reg [12:0] absolute_value;
	 reg significand_msb;
	 
	 assign S = D[12];
	 
	 always @ (D) begin
		if (D[12] == 1'b0)
			absolute_value = D[11:0];
		else
			absolute_value = (~D[12:0] + 1'b1);
		
		casex(absolute_value[12:5])
			{8'b01xxxxxx}: begin E=3'b111; F=absolute_value[11:7]; significand_msb=absolute_value[6]; end
			{8'b001xxxxx}: begin E=3'b110; F=absolute_value[10:6]; significand_msb=absolute_value[5]; end
			{8'b0001xxxx}: begin E=3'b101; F=absolute_value[9:5]; significand_msb=absolute_value[4]; end
			{8'b00001xxx}: begin E=3'b100; F=absolute_value[8:4];  significand_msb=absolute_value[3]; end
			{8'b000001xx}: begin  E=3'b011;  F=absolute_value[7:3];  significand_msb=absolute_value[2]; end
			{8'b0000001x}: begin  E=3'b010;  F=absolute_value[6:2];  significand_msb=absolute_value[1]; end
			{8'b00000001}: begin  E=3'b001;  F=absolute_value[5:1];  significand_msb=absolute_value[0]; end
			{8'b00000000}: begin  E=3'b000;  F=absolute_value[4:0];  significand_msb=1'b0; end
			default: begin  E=3'b111;  F=5'b11111;  significand_msb=1'b0; end
		endcase
	
		// rounding
		if (significand_msb == 1'b1) begin
			 F = F + 1;
			// handle significand overflow
			if (F[4:0] == 5'b00000) begin
				 F = 5'b10000;
				 E = E + 1;
				// handle exponent overflow
				if (E[2:0] == 3'b000) begin
					 F = 5'b11111;
					 E = 3'b111;
				end
			end
		end
	 end

endmodule
