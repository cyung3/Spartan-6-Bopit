`timescale 1ns / 1ps

module level_up(
	input clk,
    input [3:0] level,
    output reg [28:0] play_freq,
    output reg [3:0] play_elements,
    output reg [2:0] move_elements,
    output reg [31:0] max_points
    );

always @(posedge clk)
begin
	case (level) 
	1: begin
		play_freq <= 200000000;
		play_elements <= 5;
		move_elements <= 1;
		max_points <= 8;
	end
	2: begin
		play_freq <= 200000000;
		play_elements <= 5;
		move_elements <= 2;
		max_points <= 16;
	end
	3: begin
		play_freq <= 200000000;
		play_elements <= 9;
		move_elements <= 2;
		max_points <= 24;
	end
	4: begin
		play_freq <= 200000000;
		play_elements <= 9;
		move_elements <= 3;
		max_points <= 32;
	end
	5: begin
		play_freq <= 150000000;
		play_elements <= 9;
		move_elements <= 3;
		max_points <= 40;
	end
	6: begin
		play_freq <= 150000000;
		play_elements <= 13;
		move_elements <= 3;
		max_points <= 48;
	end
	7: begin
		play_freq <= 100000000;
		play_elements <= 13;
		move_elements <= 4;
		max_points <= 56;
	end
	8: begin
		play_freq <= 100000000;
		play_elements <= 13;
		move_elements <= 4;
		max_points <= 64;
	end
	default: begin
		play_freq <= 200000000;
		play_elements <= 5;
		move_elements <= 1;
		max_points <= 8;
	end
	endcase


end


endmodule
