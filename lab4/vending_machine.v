`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCLA
// Engineer: Sriram Balachandran
// 
// Create Date:    17:17:16 12/07/2020 
// Design Name: 
// Module Name:    vending_machine 
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
module vending_machine(
    input CLK,
    input RESET,
    input RELOAD,
    input CARD_IN,
    input [3:0] ITEM_CODE,
    input KEY_PRESS,
    input VALID_TRAN,
    input DOOR_OPEN,
    output reg VEND,
    output reg INVALID_SEL,
    output reg [2:0] COST,
    output reg FAILED_TRAN
    );
	 parameter IDLE = 4'b0000;
	 parameter RELOADING = 4'b0001;
	 parameter AWAIT_DIGIT = 4'b0010;
	 parameter CHECK_CODE = 4'b0100;
	 parameter INVALID_INPUT = 4'b0101;
	 parameter AWAIT_VALIDATION = 4'b0110;
	 parameter TRANSACTION_FAILED = 4'b0111;
	 parameter VEND_STATE = 4'b1000;
	 parameter OPEN_DOOR = 4'b1001;
	 parameter RST = 4'b1010;
	 parameter WAIT = 4'b1011;
	 parameter CHECK_VALID = 4'b1100;
	 parameter WAIT_TRAN = 4'b1101;
	 parameter WAIT_VEND = 4'b1110;
	 
	 reg [3:0] current_state;
	 reg [3:0] next_state;
	 
	 reg [3:0] selections [20:0];
	 
	 reg [2:0] timeoutCounter;
	 reg clk_start;
	 reg awaitingTimeout;
	 
	 reg [3:0] digit1;
	 reg [3:0] digit2;
	 reg awaitingDigit2;
	 
	 always@(posedge CLK)
	 begin
		if(RESET)
			current_state <= RST;
		else
			current_state <= next_state;
	 end
	
	 // Handle timeout counter start
	 always@(posedge CLK)
	 begin
		if((current_state == AWAIT_DIGIT || current_state == AWAIT_VALIDATION || current_state == VEND_STATE) 
			&& clk_start == 0)	
			clk_start <= 1;
		else
			clk_start <= 0;
	 end
	 
	 // Timeout counter
	 always @ (posedge CLK)
    begin
		if (clk_start)
			timeoutCounter <= 3'b000;
		else if(awaitingTimeout)
			timeoutCounter <= timeoutCounter + 1;
	 end

	 // Inventory updater
	 integer i;
	 always @ (posedge CLK)
	 begin
		if (current_state == RST)
		begin
			for (i = 0; i < 20; i = i + 1) begin
				selections[i] <= 0;
			end
		end
		else if (current_state == RELOADING)
		begin
			for (i = 0; i < 20; i = i + 1) begin
				selections[i] <= 10;
			end
		end
		else if(current_state == VEND_STATE)
		begin
			selections[digit1*10 + digit2] <= selections[digit1*10 + digit2] - 1;
		end
	 end
	 
	 // State transitions
	 always @ (*) begin
		case(current_state)
			RST:
			begin
				next_state = IDLE;
				awaitingTimeout = 0;
			end
			IDLE:
				begin
					awaitingDigit2 = 0;
					awaitingTimeout = 0;
					if(RELOAD)
						next_state = RELOADING;
					else if(CARD_IN)
						next_state = AWAIT_DIGIT;
					else
						next_state = IDLE;
				end
			RELOADING:
				begin
					awaitingTimeout = 0;
					next_state = IDLE;
				end
			AWAIT_DIGIT:
				begin
					if(KEY_PRESS && ~awaitingDigit2)
					begin
						digit1 = ITEM_CODE;
						digit2 = digit2;
						awaitingDigit2 = 1;
						awaitingTimeout = 1;
						next_state = AWAIT_DIGIT;
					end
					else if(KEY_PRESS && awaitingDigit2)
					begin 
						digit2 = ITEM_CODE;
						digit1 = digit1;
						next_state = CHECK_VALID;
						awaitingTimeout = 0;
					end
					else
					begin
						digit1 = digit1;
						digit2 = digit2;
						next_state = WAIT;
						awaitingTimeout = 1;
					end
				end
			WAIT:
				begin 
					if(timeoutCounter == 2)
					begin
						next_state = INVALID_INPUT;
						awaitingTimeout = 0;
					end
					else if(KEY_PRESS && awaitingDigit2)
					begin
						digit2 = ITEM_CODE;
						digit1 = digit1;
						next_state = CHECK_VALID;
						awaitingTimeout = 0;
					end
					else if(KEY_PRESS && ~awaitingDigit2)
					begin
						digit1 = ITEM_CODE;
						digit2 = 0;
						next_state = AWAIT_DIGIT;
						awaitingDigit2 = 1;
						awaitingTimeout = 0;
					end
					else
					begin
						digit1 = digit1;
						digit2 = digit2;
						next_state = WAIT;
						awaitingTimeout = 1;
					end
				end
			CHECK_VALID:
				begin
					awaitingTimeout = 0;
					if((digit1 == 1 || digit1 == 0) && (digit2 >= 0) && (digit2 <= 9))
					begin
						if (selections[digit1*10 + digit2] > 0)
							next_state = AWAIT_VALIDATION;
						else
							next_state = INVALID_INPUT;
					end
					else
						next_state = INVALID_INPUT;
				end
			INVALID_INPUT:
			begin
				next_state = IDLE;
				awaitingTimeout = 0;
			end
			AWAIT_VALIDATION:
				begin
					if(VALID_TRAN)
					begin
						next_state = VEND_STATE;
						awaitingTimeout = 0;
					end
					else
					begin
						next_state = WAIT_TRAN;
						awaitingTimeout = 1;
					end
				end
			WAIT_TRAN:
				begin
					if(timeoutCounter == 2)
					begin
						next_state = TRANSACTION_FAILED;
						awaitingTimeout = 0;
					end
					else if(VALID_TRAN)
					begin
						next_state = VEND_STATE;
						awaitingTimeout = 0;
					end
					else
					begin
						next_state = WAIT_TRAN;
						awaitingTimeout = 1;
					end
				end
			TRANSACTION_FAILED:
			begin
				next_state = IDLE;
				awaitingTimeout = 0;
			end
			VEND_STATE:
				begin
					if(DOOR_OPEN)
					begin
						next_state = OPEN_DOOR;
						awaitingTimeout = 0;
					end
					else
					begin
						next_state = WAIT_VEND;
						awaitingTimeout = 1; 
					end
				end
			WAIT_VEND:
				begin
					if(timeoutCounter == 2)
					begin
						next_state = IDLE;
						awaitingTimeout = 0;
					end
					else if(DOOR_OPEN)
					begin
						next_state = OPEN_DOOR;
						awaitingTimeout = 0;
					end
					else
					begin
						next_state = WAIT_VEND;
						awaitingTimeout = 1;
					end
				end
			OPEN_DOOR:
				begin
					awaitingTimeout = 0;
					if(~DOOR_OPEN)
						next_state = IDLE;
					else
						next_state = OPEN_DOOR;
				end
			default: 
			begin
				next_state = IDLE;
				awaitingTimeout = 0;
			end
		endcase	
	end
	
	// Handle outputs
	always @(*) begin
		case(current_state)
			IDLE,
			AWAIT_DIGIT,
			CHECK_CODE,
			WAIT,
			CHECK_VALID,
			RST,
			RELOAD:
				begin
					VEND = 0;
					INVALID_SEL = 0;
					COST = 3'b000;
					FAILED_TRAN = 0;
				end
			INVALID_INPUT:
				begin
					VEND = 0;
					INVALID_SEL = 1;
					COST = 3'b000;
					FAILED_TRAN = 0;
				end
			AWAIT_VALIDATION:
				begin
					if((digit1 == 0) && (digit2 >= 0) && (digit2 <= 3))
						COST = 1;
					else if((digit1 == 0) && (digit2 >= 4) && (digit2 <= 7))
						COST = 2;
					else if(((digit1 == 0) && (digit2 >= 8) && (digit2 <= 9))
								|| ((digit1 == 1) && (digit2 >= 0) && (digit2 <= 1)))
						COST = 3;
					else if((digit1 == 1) && (digit2 >= 2) && (digit2 <= 5))
						COST = 4;
					else if((digit1 == 1) && (digit2 >= 6) && (digit2 <= 7))
						COST = 5;
					else if((digit1 == 1) && (digit2 >= 8) && (digit2 <= 9))
						COST = 6;
				end
			TRANSACTION_FAILED:
				FAILED_TRAN = 1;
			VEND_STATE:
				begin
					VEND = 1;
				end
		endcase
	end  
endmodule
