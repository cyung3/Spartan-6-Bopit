`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:43:59 11/26/2019
// Design Name:   move_to_ssd
// Module Name:   E:/152A/Project/BopIt/move_to_ssd_tb.v
// Project Name:  BopIt
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: move_to_ssd
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module move_to_ssd_tb;

	// Inputs
	reg clk;
	reg start;
	reg [4:0] move;

	// Outputs
	wire [31:0] ssd_digits;
	wire ready;

	// Instantiate the Unit Under Test (UUT)
	move_to_ssd uut (
		.clk(clk), 
		.start(start), 
		.move(move), 
		.ssd_digits(ssd_digits), 
		.ready(ready)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		start = 0;
		move = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		move = 5'b00100;
		start = 1;
		#10
		start = 0;
		#100
		move = 5'b01010;
		start = 1;
		#10
		start = 0;
		

	end
	always #5 clk <= ~clk;
      
endmodule

