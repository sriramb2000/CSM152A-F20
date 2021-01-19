`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:20:38 10/25/2020
// Design Name:   FPCVT
// Module Name:   C:/Users/srira/Desktop/Books/UCLA/Fall 2020/CS M152A/lab1/testbench_805167463.v
// Project Name:  lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPCVT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_805167463;

	// Inputs
	reg [12:0] D;

	// Outputs
	wire S;
	wire [2:0] E;
	wire [4:0] F;

	// Instantiate the Unit Under Test (UUT)
	FPCVT uut (
		.D(D), 
		.S(S), 
		.E(E), 
		.F(F)
	);

	initial begin
		// Initialize Inputs
		D = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		D = 13'b0000000000000;
		
		#20;
		
		if (S == 1'b0 && E == 3'b000 && F == 5'b00000) begin
			$display("Testcase 01 passed.");
		end else begin
			$display("Testcase 01 failed.");
		end
		
		// 420 should be 416 (rounding)
		D = 420;
		#20;
		if (S == 0 && E == 3'b100 && F == 5'b11010) begin
			$display("Testcase 02 passed.");
		end else begin
			$display("Testcase 02 failed.");
		end
		
		// -420 should be -416 (rounding)
		D = -420;
		#20;
		if (S == 1 && E == 3'b100 && F == 5'b11010) begin
			$display("Testcase 03 passed.");
		end else begin
			$display("Testcase 03 failed.");
		end
		
		// Rounding causes significand overflow
		D = 13'b0000011111101;
		#20;
		if (S == 0 && E == 3'b100 && F == 5'b10000) begin
			$display("Testcase 04 passed.");
		end else begin
			$display("Testcase 04 failed.");
		end
		
		// Largest floating point encoding
		D = 13'b0111111111111;
		#20;
		if (S == 0 && E == 3'b111 && F == 5'b11111) begin
			$display("Testcase 05 passed.");
		end else begin
			$display("Testcase 05 failed.");
		end
		
		// Most negative number
		D = 13'b1000000000000;
		#20;
		if (S == 1 && E == 3'b111 && F == 5'b11111) begin
			$display("Testcase 06 passed.");
		end else begin
			$display("Testcase 06 failed.");
		end
		
		// Check 416 should be 416
		D = 416;
		#20;
		if (S == 0 && E == 3'b100 && F == 5'b11010) begin
			$display("Testcase 07 passed.");
		end else begin
			$display("Testcase 07 failed.");
		end
		
		// Check -416 should be -416
		D = -416;
		#20;
		if (S == 1 && E == 3'b100 && F == 5'b11010) begin
			$display("Testcase 08 passed.");
		end else begin
			$display("Testcase 08 failed.");
		end
		
		// Check round down
		D = 13'b0000001101100;
		#20;
		if (S == 0 && E == 3'b010 && F == 5'b11011) begin
			$display("Testcase 09 passed.");
		end else begin
			$display("Testcase 09 failed.");
		end
		
		// Check round up
		D = 13'b0000001101110;
		#20;
		if (S == 0 && E == 3'b010 && F == 5'b11100) begin
			$display("Testcase 10 passed.");
		end else begin
			$display("Testcase 10 failed.");
		end

	end
      
endmodule

