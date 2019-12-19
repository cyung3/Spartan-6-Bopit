`timescale 1ns / 1ps


module check_move_tb;

	// Inputs
	reg [28:0] play_freq;
	reg clk;
	reg start;
	reg [12:0] move;
	reg [7:0] sw;
	reg [4:0] btn;

	// Outputs
	wire ready;
	wire correct;

	// Instantiate the Unit Under Test (UUT)
	check_move uut (
		.play_freq(play_freq), 
		.clk(clk), 
		.start(start), 
		.move(move), 
		.sw(sw), 
		.btn(btn), 
		.ready(ready), 
		.correct(correct)
	);

	initial begin
		// Initialize Inputs
		play_freq = 0;
		clk = 0;
		start = 0;
		move = 0;
		sw = 0;
		btn = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		start = 1;
		move = 13'b1;
		play_freq = 20;
		#10
		start = 0;
		#40
		btn = 1;
		#20
		btn = 0;
		#500
		
		start = 1;
		move = 13'b1;
		#10
		start = 0;
		#40
		btn = 2;
		#20;
		btn = 0;
		#50;
		

	end
	
	always #5 clk <= ~clk;
      
endmodule

