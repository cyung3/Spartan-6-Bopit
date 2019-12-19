`timescale 1ns / 1ps

module clock_divider(
    input clk,
	input [26:0] freq,
	input reset,
    output clk_out
    );

reg [26:0] counter;
//reg [26:0] max_val;

initial begin
	counter = 0;
	//max_val = 100000000 / freq;
end

assign clk_out = (counter == 0)? 1'b1 : 1'b0;
//assign max_val = 100000000 + freq;

always @ (posedge clk)
begin
	if (reset) begin
		counter <= 0;
		//max_val <= 100000000 / freq;
	end
	else if (counter == freq - 1)
		counter <= 0;
	else
		counter <= (counter + 1);// % freq;
end

endmodule
