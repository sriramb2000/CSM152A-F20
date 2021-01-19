`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:42:14 11/02/2020
// Design Name:   clock_gen
// Module Name:   C:/Users/srira/Desktop/Books/UCLA/Fall 2020/CS M152A/Lab2/testbench_805167463.v
// Project Name:  Lab2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_gen
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
	reg clk_in;
	reg rst;

	// Outputs
	wire clk_div_2;
	wire clk_div_4;
	wire clk_div_8;
	wire clk_div_16;
	wire clk_div_28;
	wire clk_div_5;
	wire [7:0] toggle_counter;

	// Instantiate the Unit Under Test (UUT)
	clock_gen uut (
		.clk_in(clk_in), 
		.rst(rst), 
		.clk_div_2(clk_div_2), 
		.clk_div_4(clk_div_4), 
		.clk_div_8(clk_div_8), 
		.clk_div_16(clk_div_16), 
		.clk_div_28(clk_div_28), 
		.clk_div_5(clk_div_5), 
		.toggle_counter(toggle_counter)
	);

	integer i;
	integer num_cycles = 5000;

	initial begin
		// Initialize Inputs
		clk_in = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		rst = 1;
		#100;
		rst = 0;
		#20;
        
		// Add stimulus here
		for (i = 0; i < num_cycles; i = i + 1) begin
			clk_in = ~clk_in;
			#20;
			clk_in = ~clk_in;
			#20;
	end

	end
      
endmodule

