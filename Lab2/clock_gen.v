`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:32:36 11/02/2020 
// Design Name: 
// Module Name:    clock_gen 
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
module clock_gen(
    input clk_in,
    input rst,
    output clk_div_2,
    output clk_div_4,
    output clk_div_8,
    output clk_div_16,
    output clk_div_28,
    output clk_div_5,
    output [7:0] toggle_counter
    );
	reg [3:0] counter = 4'b0000;
	assign clk_div_2 = counter[0];
	assign clk_div_4 = counter[1];
	assign clk_div_8 = counter[2];
	assign clk_div_16 = counter[3];
	
	subclk_28 lab2_clk_div_28(clk_in, rst, clk_div_28);
	subclk_5 lab2_clk_div_5(clk_in, rst, clk_div_5);
	
	strobe_counter strobe(clk_in, rst, toggle_counter);
	
	always @ (posedge clk_in or posedge rst) begin
		if (rst) begin
			counter <= 4'b0000;
		end else begin
			counter <= counter + 1;
		end
	end

endmodule

module subclk_28(
    input clk_in,
    input rst,
    output clk_out
    );
	reg [3:0] counter = 4'b0000;
	// toggle after (28/2 = 14) positive edges
	reg [3:0] toggle_val = 4'b1101;
	
	reg clk_out_state = 0;	
	assign clk_out = clk_out_state;
	
	always @ (posedge clk_in or posedge rst) begin
		if (rst) begin
			counter <= 4'b0000;
			clk_out_state <= 0;
		end else begin
			counter <= counter + 1;
			if (counter == toggle_val) begin
				counter <= 4'b0000;
				clk_out_state <= ~clk_out_state;
			end
		end
	end

endmodule

module subclk_5(
    input clk_in,
    input rst,
    output clk_out
    );
	reg [2:0] counter_even = 3'b000;
	reg [2:0] counter_odd = 3'b000;
	// toggle value 5 - 1
	reg [2:0] reset_val = 3'b100;
	reg [2:0] toggle_val = 3'b010;
	
	reg clk_out_state_even = 0;
	reg clk_out_state_odd = 0;
	assign clk_out = (clk_out_state_even || clk_out_state_odd);
	
	always @ (posedge clk_in or posedge rst) begin
		if (rst) begin
			counter_even <= 3'b000;
			clk_out_state_even <= 0;
		end else begin
			counter_even <= counter_even + 1;
			if (counter_even == toggle_val) begin
				clk_out_state_even <= ~clk_out_state_even;
			end else if (counter_even == reset_val) begin
				clk_out_state_even <= ~clk_out_state_even;
				counter_even <= 3'b000;
			end
		end
	end

	always @ (negedge clk_in or posedge rst) begin
		if (rst) begin
			counter_odd <= 3'b000;
			clk_out_state_odd <= 0;
		end else begin
			counter_odd <= counter_odd + 1;
			if (counter_odd == toggle_val) begin
				clk_out_state_odd <= ~clk_out_state_odd;
			end else if (counter_odd == reset_val) begin
				clk_out_state_odd <= ~clk_out_state_odd;
				counter_odd <= 3'b000;
			end
		end
	end
endmodule

module strobe_counter(
    input clk_in,
    input rst,
    output [7:0] toggle_counter
    );
	reg [1:0] counter = 2'b00;
	
	reg [1:0] reset_val = 2'b11; // 3 (4 0 indexed)
	reg [1:0] toggle_val = 2'b10; // 2 (3 0 indexed)
	
	reg [7:0] counter_out_state = 8'b00000000;	
	reg clk_duty_cycle_25 = 0;
	
	assign toggle_counter = counter_out_state;
	
	always @ (posedge clk_in or posedge rst) begin
		if (rst) begin
			counter <= 2'b00;
			clk_duty_cycle_25 <= 0;
		end else begin
			counter <= counter + 1;
			if (counter == toggle_val) begin
				clk_duty_cycle_25 <= ~clk_duty_cycle_25;
			end else if (counter == reset_val) begin
				clk_duty_cycle_25 <= ~clk_duty_cycle_25;
				counter <= 2'b00;
			end
		end
	end
	
	always @ (posedge clk_in or posedge rst) begin
		if (rst) begin
			counter_out_state <= 8'b00000000;
		end else if (clk_duty_cycle_25 == 1) begin
			counter_out_state <= counter_out_state - 5;
		end else begin
			counter_out_state <= counter_out_state + 2;
		end
	end

endmodule
