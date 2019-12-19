`timescale 1ns / 1ps


module clk_div_tb;

	// Inputs
	reg clk;
	reg [26:0] freq;

	// Outputs
	wire clk_out;

	// Instantiate the Unit Under Test (UUT)
	clock_divider uut (
		.clk(clk), 
		.freq(freq),
		.reset(0),
		.clk_out(clk_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		freq = 10;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		freq = 5;

	end
	
	always
	#5 clk = ~clk;
      
endmodule

