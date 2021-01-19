`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:36:38 11/23/2020 
// Design Name: 
// Module Name:    parking_meter 
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
module parking_meter(
    input add1,
    input add2,
    input add3,
    input add4,
    input rst1,
    input rst2,
    input clk,
    input rst,
    output [6:0] led_seg,
    output a0,
    output a1,
    output a2,
    output a3,
    output [3:0] val0,
    output [3:0] val1,
    output [3:0] val2,
    output [3:0] val3
    );
	// State
	parameter ZERO = 2'b00;
	parameter LESSTHAN180 = 2'b01;
	parameter GREATERTHAN180 = 2'b10;
	
	reg [1:0] current_state;
	reg [1:0] next_state;
	
	// Clocks
	reg OneHzClk;
	reg HalfHzClk;
	reg DisplayClk;
	// Clock counters
	reg [13:0] counter;
	reg [4:0] clkCounter;
	reg [1:0] digitCounter;

	reg [3:0] valReg[0:3];
	assign val0 = valReg[0];
	assign val1 = valReg[1];
	assign val2 = valReg[2];
	assign val3 = valReg[3];
	
	reg [3:0] aReg;
	assign a0 = aReg[0];
	assign a1 = aReg[1];
	assign a2 = aReg[2];
	assign a3 = aReg[3];
	
	reg [6:0] sevenSeg;
	assign led_seg = sevenSeg;
	
	// Clock management
	always@(posedge clk) begin
		if (rst) begin
			clkCounter <= 0;
			OneHzClk <= 0;
			HalfHzClk <= 0;
			DisplayClk <= 0;
		end
		else begin
			DisplayClk <= ~DisplayClk;
			if (clkCounter == 24) begin
				OneHzClk <= ~OneHzClk;
				clkCounter <= 0;
				if (OneHzClk == 0)
					HalfHzClk <= ~HalfHzClk;
			end
			else
				clkCounter <= clkCounter + 1;

		end
	end
	
	// State transitions
	always @(*) begin
		if (counter == 0)
			next_state = ZERO;
		else if (counter <= 180)
			next_state = LESSTHAN180;
		else
			next_state = GREATERTHAN180;
	end
	
	function [13:0] min (input [13:0] a, input [13:0] b);
		begin
			if (a < b)
				min = a;
			else
				min = b;
		end
	endfunction
	
	// Counter increment/decrement handling
	always@(posedge OneHzClk or posedge rst or posedge rst1 or posedge rst2) begin
		if (rst) begin
			current_state <= ZERO;
			counter <= 0;
		end 
		else if (rst1)
			counter <= 15;
		else if (rst2)
			counter <= 149;
		else begin
			current_state <= next_state;
			if (add1) begin
				counter <= min(counter+59, 9999);
			end
			else if (add2) begin
				counter <= min(counter+119, 9999);
			end
			else if (add3) begin
				counter <= min(counter+179, 9999);
			end
			else if (add4) begin
				counter <= min(counter+299, 9999);
			end
			else if (counter != 0)
				counter <= counter - 1;
		end
	end
	
	function [6:0] numToSegment (input [3:0] a);
		begin
			 case(a)  
				 4'b0001: numToSegment = 7'b1001111; // "1" 
				 4'b0010: numToSegment = 7'b0010010; // "2" 
				 4'b0011: numToSegment = 7'b0000110; // "3" 
				 4'b0100: numToSegment = 7'b1001100; // "4" 
				 4'b0101: numToSegment = 7'b0100100; // "5" 
				 4'b0110: numToSegment = 7'b0100000; // "6" 
				 4'b0111: numToSegment = 7'b0001111; // "7" 
				 4'b1000: numToSegment = 7'b0000000; // "8"  
				 4'b1001: numToSegment = 7'b0000100; // "9" 
				 default: numToSegment = 7'b0000001; // "0"
			endcase
		end
	endfunction
	
	function [3:0] stateToAVal(input [1:0] state);
		begin
			case (state)
				2'b00: stateToAVal = 4'b0001;
				2'b01: stateToAVal = 4'b0010;
				2'b10: stateToAVal = 4'b0100;
				2'b11: stateToAVal = 4'b1000;
				default: stateToAVal = 0;
			endcase
		end	
	endfunction
	
	// Cycling through 7-segment display digits
	always@(posedge DisplayClk or posedge rst) begin
		if (rst) begin
			digitCounter <= 0;
		end
		else begin
			digitCounter <= digitCounter + 1;
		end
	end
	
	// Outputting to 7-segment display
	always @(*) begin 
		valReg[0] <= (((counter % 1000) % 100) % 10);
		valReg[1] <= ((counter % 1000) % 100) / 10;
		valReg[2] <= (counter % 1000) / 100;
		valReg[3] <= counter / 1000;
		case(current_state)
			ZERO : begin
				if (OneHzClk) begin
					aReg <= stateToAVal(digitCounter);
					sevenSeg <= numToSegment(valReg[digitCounter]);
				end else begin
					aReg <= 4'b0000;
					sevenSeg <= 0;
				end
			end
			LESSTHAN180 : begin
				if (HalfHzClk) begin
					aReg <= stateToAVal(digitCounter);
					sevenSeg <= numToSegment(valReg[digitCounter]);
				end else begin
					aReg <= 0;
					sevenSeg <= 0;
				end
			end
			GREATERTHAN180 : begin
				aReg <= stateToAVal(digitCounter);
				sevenSeg <= numToSegment(valReg[digitCounter]);
			end
		endcase
	end

endmodule

