`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:18:38 12/07/2020
// Design Name:   vending_machine
// Module Name:   C:/Users/srira/Desktop/Books/UCLA/Fall 2020/CS M152A/lab4/testbench_805167463.v
// Project Name:  lab4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vending_machine
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
	reg CLK;
	reg RESET;
	reg RELOAD;
	reg CARD_IN;
	reg [3:0] ITEM_CODE;
	reg KEY_PRESS;
	reg VALID_TRAN;
	reg DOOR_OPEN;

	// Outputs
	wire VEND;
	wire INVALID_SEL;
	wire [2:0] COST;
	wire FAILED_TRAN;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		.CLK(CLK), 
		.RESET(RESET), 
		.RELOAD(RELOAD), 
		.CARD_IN(CARD_IN), 
		.ITEM_CODE(ITEM_CODE), 
		.KEY_PRESS(KEY_PRESS), 
		.VALID_TRAN(VALID_TRAN), 
		.DOOR_OPEN(DOOR_OPEN), 
		.VEND(VEND), 
		.INVALID_SEL(INVALID_SEL), 
		.COST(COST), 
		.FAILED_TRAN(FAILED_TRAN)
	);

	initial begin
		// Initialize Inputs
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		CLK = 0;
		RESET = 0;
		
		/*
		 * Successful vending
		 */
		#10;
      CLK = 0;
		RESET = 0;
		#10
		CLK = 1;
		RESET = 1;
		#10
		CLK = 0;	
		#10
		CLK = 1;
		RESET = 0;
		#10
		CLK = 0;	
		#10
		CLK = 1;
		#10
		CLK = 0;
		RELOAD = 1; 
		#10
		CLK = 1;
		#10
		CLK = 0;
		RELOAD = 0; 
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1; 
		ITEM_CODE = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10 
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 3;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		VALID_TRAN = 1; 
		#10
		CLK = 1;
		#10
		CLK = 0;
		VALID_TRAN = 0;
		DOOR_OPEN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		DOOR_OPEN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		/*
		 * Unsuccessful purchase due to lack of key press
		 */
		#10
		CLK = 0;
		CARD_IN = 1; 
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1; 
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		/*
		 * Invalid item number
		 */
		CLK = 0;
		CARD_IN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 2;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 7;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		/*
		 * Transaction was not validated
		 */
		CARD_IN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 7;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		/*
		 * Unsuccessful purchase due to missing second digit of item code
		 */
		#10
		CLK = 0;
		CARD_IN = 1; 
		#10
		CLK = 1; 
		#10
		CLK = 0;
		#10
		CLK = 1; 
		#10
		CLK = 0;
		KEY_PRESS = 1; 
		ITEM_CODE = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1; 
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1;
		#10;
	end
	
      
endmodule

