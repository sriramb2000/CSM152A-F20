`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:37:28 11/23/2020
// Design Name:   parking_meter
// Module Name:   C:/Users/srira/Desktop/Books/UCLA/Fall 2020/CS M152A/lab3/testbench_805167463.v
// Project Name:  lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: parking_meter
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
	reg add1;
	reg add2;
	reg add3;
	reg add4;
	reg rst1;
	reg rst2;
	reg clk;
	reg rst;
	reg [10:0] i;
	// Outputs
	wire [6:0] led_seg;
	wire a0;
	wire a1;
	wire a2;
	wire a3;
	wire [3:0] val0;
	wire [3:0] val1;
	wire [3:0] val2;
	wire [3:0] val3;

	// Instantiate the Unit Under Test (UUT)
	parking_meter uut (
		.add1(add1), 
		.add2(add2), 
		.add3(add3), 
		.add4(add4), 
		.rst1(rst1), 
		.rst2(rst2), 
		.clk(clk), 
		.rst(rst), 
		.led_seg(led_seg), 
		.a0(a0), 
		.a1(a1), 
		.a2(a2), 
		.a3(a3), 
		.val0(val0), 
		.val1(val1), 
		.val2(val2), 
		.val3(val3)
	);

	initial begin
		// Initialize Inputs
		add1 = 0;
		add2 = 0;
		add3 = 0;
		add4 = 0;
		rst1 = 0;
		rst2 = 0;
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 1;
		clk = 1;
		
		#20;
		
		clk = 0;
		rst = 0;
		
		#20;
		
		i = 200;
		add4 = 1;
		while (i > 0) begin
			clk = ~clk;
			#10000000;
			i = i - 1;
		end
		add4 = 0;
		// Add stimulus here
		while (1) begin
			clk = ~clk;
			#10000000; // Frequency of 100Hz		
		end

	end
      
endmodule