`timescale 1ns / 1ps

module rng_to_move(
    input [31:0] rng,
    input [3:0] num_play,
	input [2:0] num_elements,
    output reg [12:0] move,
    input clk,
    output reg ready,
    input start
    );

wire clk_slow;
reg rst = 0;
reg [31:0] rng_reg;
reg [2:0] move_elements;
reg [3:0] play_elements;
reg a = 1;
reg b;

clock_divider clk_div(
	.clk(clk),
	.freq(32),
	.reset(rst),
    .clk_out(clk_slow));
	
	always@(posedge clk) begin
		if(start)begin
			rng_reg <= rng;
			move_elements <= num_elements;
			play_elements <= num_play;
			ready <= 0;
			b <= a;
		end	
		if (b == ~a) 
			ready <= 1;
	end
	
	always@(posedge clk_slow)begin
		case (move_elements)
		1:  begin
			move <= 1 << (rng_reg % play_elements);
			end
		2:  begin
			move <= (1 << ((rng_reg) % play_elements))
				  | (1 << ((rng_reg >> 4) % play_elements));
			end
		3:  begin
			move <= (1 << ((rng_reg) % play_elements))
				  | (1 << ((rng_reg >> 4) % play_elements))
				  | (1 << ((rng_reg >> 8) % play_elements));
			end
		4:  begin
			move <= (1 << ((rng_reg) % play_elements))
				  | (1 << ((rng_reg >> 4) % play_elements))
				  | (1 << ((rng_reg >> 8) % play_elements))
				  | (1 << ((rng_reg >> 16) % play_elements));
			end
		default:
			move <= 1 << (rng_reg % play_elements);
		endcase
		a <= ~a;
	end
	
endmodule
