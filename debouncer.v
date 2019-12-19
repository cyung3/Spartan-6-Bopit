`timescale 1ns / 1ps

module debouncer(
    input btn,
    input clk,
    output btn_d
    );

wire slow_clk;
wire q1, q2;	

clock_divider clk_div(
	.clk(clk),
	.freq(125000),
	.reset(0),
	.clk_out(slow_clk) 
	);
	


dff d1(slow_clk, btn, q1);
dff d2(slow_clk, q1, q2);
assign btn_d = q1 & ~q2;

endmodule

module dff (input dff_clk, d, output reg q);
	always @(posedge dff_clk) begin
		q <= d;
	end
endmodule

module debounce5 (
	input [4:0] btns,
	input clk,
	output [4:0] btns_d
	);
	
debouncer d0(
    .btn(btns[0]),
    .clk(clk),
    .btn_d(btns_d[0])
    );	
debouncer d1(
    .btn(btns[1]),
    .clk(clk),
    .btn_d(btns_d[1])
    );	
debouncer d2(
    .btn(btns[2]),
    .clk(clk),
    .btn_d(btns_d[2])
    );	
debouncer d3(
    .btn(btns[3]),
    .clk(clk),
    .btn_d(btns_d[3])
    );	
debouncer d4(
    .btn(btns[4]),
    .clk(clk),
    .btn_d(btns_d[4])
    );	

	
endmodule
