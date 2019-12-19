`timescale 1ns / 1ps

//DIFFERENT BIT LENGTHS NEED TO XOR DIFFERENT VALUES
//could implement a function to find the values
//OR could just stick with one size :)

module RN_JESUS (
	clk, 
	i_en,
	rst,
	o_rand
);
input clk;
input rst; 
input i_en; 
//enables random number generator
//Should one pulse == one random number generated? or  should continuous pulse (less //reliable, takes more clock cycles to produce longer input)?
//Currently set as need to be HIGH for whole duration to produce rand number
output reg o_rand;


parameter REG_LEN = 32;

//reg [OUT_LEN-1:0] o_rand;
reg [REG_LEN-1:0] shift_reg;
reg flag;

//OBTAIN SEED HERE?
reg [REG_LEN-1:0] seed; //ensures all values are 1 no matter the reg len


initial begin
  seed = 1;
  flag = 0;
end

//need to xor bits 32,22,2,1 for 32 bits


//reg [OUT_LEN-1:0] num_bits = 0; //used to count number of random bits generated 

wire feedback;

assign feedback = (shift_reg[31] ^ shift_reg[21] ^ shift_reg[1] ^ shift_reg[0]);

always@(posedge clk)
begin
	if(!flag) begin
		if (seed == 32'hFFFF)
			seed <= 1;
		else
			seed <= seed+1;
	end
end
	
	


always @(posedge clk or posedge rst)
begin
	if (rst) begin
		shift_reg <= seed;
		flag <= 0;
		//num_bits <= 0;
		//o_vld <= 0;
	end
	else if (i_en) begin
		if (!flag) begin
			shift_reg <= seed;
			flag <= 1;
			o_rand <= feedback;
		end
		else begin
			shift_reg <= {shift_reg[REG_LEN-2:0], feedback};
			o_rand <= feedback;
		end
		//num_bits <= num_bits + 1;	
	end 
end

//always @ (num_bits) //is this allowed?
//begin
//	if(num_bits == OUT_LEN)
//		o_vld <= 1;
//		num_bits <= 0;
//	else 
//		o_vld <= 0;
//end 

endmodule
