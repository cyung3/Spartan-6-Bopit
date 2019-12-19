`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:04:23 11/12/2019
// Design Name:   RN_JESUS
// Module Name:   E:/152A/Project/BopIt/rng_tb.v
// Project Name:  BopIt
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RN_JESUS
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module rng_tb;

	// Inputs
	reg clk;
	reg i_en;
	reg rst;

	// Outputs
	wire o_rand;

	// Instantiate the Unit Under Test (UUT)
	RN_JESUS uut (
		.clk(clk), 
		.i_en(i_en), 
		.rst(rst), 
		.o_rand(o_rand)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		i_en = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		i_en = 1;

	end
	
	always
	#5 clk = ~clk;
      
endmodule

