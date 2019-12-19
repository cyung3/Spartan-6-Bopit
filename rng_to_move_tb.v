`timescale 1ns / 1ps


module rng_to_move_tb;

	// Inputs
	reg [31:0] rng;
	reg [3:0] num_play;
	reg [2:0] num_elements;
	reg clk;
	reg start;

	// Outputs
	wire [12:0] move;
	wire ready;

	// Instantiate the Unit Under Test (UUT)
	rng_to_move uut (
		.rng(rng), 
		.num_play(num_play), 
		.num_elements(num_elements), 
		.move(move), 
		.clk(clk), 
		.ready(ready), 
		.start(start)
	);

	initial begin
		// Initialize Inputs
		rng = 32'hAF7920CB;
		num_play = 13;
		num_elements = 4;
		clk = 1;
		start = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		start <= 1;
		#5
		start <= 0;

	end
	always #5 clk <= ~clk;
      
endmodule

