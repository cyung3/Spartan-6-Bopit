`timescale 1ns / 1ps

module check_move(
    input [28:0] play_freq,
    input clk,
    input start,
	input [12:0] move,
	input [7:0] sw,
	input [4:0] btn,
		
    output reg halfway,
    output reg ready,
    output reg correct
    );

reg [31:0] counter;
reg [7:0] sw_prev;
reg [4:0] btn_press;
reg [12:0] move_reg;

always@(posedge clk) begin
	if (start) begin
		sw_prev <= sw;
		counter <= 0;
		btn_press <= 0;
		ready <= 1'b0;
		correct <= 1'b0;
        halfway <= 1'b0;
        move_reg <= move;
	end
	else if (counter == play_freq) begin
		ready <= 1;
		//interval for move is up, go to next state
		if (((sw ^ sw_prev) == move_reg[12:5]) && (move_reg[4:0] == btn_press)) begin
			//correct move
			correct <= 1'b1;
		end
		else begin
			//wrong move!
			correct <= 1'b0;
		end
	end
	else begin //increment counter
		//if (timeout_cntr > ((play_freq / 5) << 2))
			//ssd_digits <= 0;
		ready <= 0;
		counter <= counter + 28'b1;
		btn_press <= btn_press | btn;
        if (counter == play_freq >> 1)
            halfway <= 1'b1;
	end
end
endmodule
