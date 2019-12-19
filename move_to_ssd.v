`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:37:03 11/26/2019 
// Design Name: 
// Module Name:    move_to_ssd 
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
module move_to_ssd(
	input clk,
	input start,
    input [4:0] move,
    output reg [31:0] ssd_digits,
	output reg ready
    );

reg [2:0] disp_st_counter;
reg [4:0] move_reg;
	
always @(posedge clk) begin
	if (start) begin
		disp_st_counter <= 3'b0;
		ready <= 1'b0;
		move_reg <= move;
		ssd_digits <= 0;
	end
	else begin
		if (move_reg[4]) begin
			move_reg[4] <= 1'b0;
			ssd_digits <= {"r", ssd_digits[31:8]};
		end
		else if (move_reg[3]) begin
			move_reg[3] <= 1'b0;
			ssd_digits <= {"d", ssd_digits[31:8]};
		end
		else if (move_reg[2]) begin
			move_reg[2] <= 1'b0;
			ssd_digits <= {"l", ssd_digits[31:8]};
		end
		else if (move_reg[1]) begin
			move_reg[1] <= 1'b0;
			ssd_digits <= {"u", ssd_digits[31:8]};
		end
		else if (move_reg[0]) begin
			move_reg[0] <= 1'b0;
			ssd_digits <= {"c", ssd_digits[31:8]};
		end
		else
			ssd_digits <= ssd_digits;

		if (disp_st_counter == 5) begin
			ready <= 1'b1;
		end
		else
			disp_st_counter <= disp_st_counter + 1;
	end

end
endmodule
