`timescale 1ns / 1ps


module clk_div_tb2;

	// Inputs
	reg clk;
	reg [26:0] freq;
	reg reset;

	// Outputs
	wire clk_out;

	// Instantiate the Unit Under Test (UUT)
	clock_divider uut (
		.clk(clk), 
		.freq(freq), 
		.reset(reset), 
		.clk_out(clk_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		freq = 10;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always
	#5 clk = ~clk;
      
      
endmodule

