`timescale 1ns / 1ps

module bop_it(
	input clk,
	//input sw,
	input [7:0] sw,
	input [4:0] btns,
	
	output [7:0] leds,
	output [6:0] ssd_digit,
	output [3:0] ssd_select
    );
	
parameter 
	INIT_ST = 0,
	IDLE_ST = 1,
	RNG_ST =  2,
	PLAY_ST = 3,
	DISP_ST = 4,
	CHK_ST =  5,
	LVLUP_ST = 6,
	DISP_LVLUP_ST = 7,
	LOSE_ST = 8,
	WIN_ST = 9;

	
reg [3:0] state;
reg [3:0] level;
wire [3:0] play_elements;
wire [2:0] move_elements;
reg [31:0] points_won;
wire [31:0] max_points;
wire [28:0] play_freq;
reg [31:0] ssd_digits;
reg [4:0] rng_counter;
reg [31:0] rng_reg;
reg rng_en;
reg [12:0] move;
reg [4:0] btn_req;
reg [4:0] btn_press;
reg [2:0] disp_st_counter;
reg [7:0] sw_prev;
reg [27:0] timeout_cntr;

wire clk_ssd;
wire clk_slow;
wire rng_rst;
wire rng_num;

wire [4:0] btns_d;

reg mts_start;
wire mts_ready;
wire [31:0] mts_ssd_digits;

reg rtm_start;
wire rtm_ready;
wire [12:0] rtm_move;

reg cm_start;
wire cm_ready;
wire cm_correct;
wire cm_half;

reg [28:0] timer;
reg [3:0] points_100;
reg [3:0] points_10;
reg [3:0] points_1;

assign leds = move[12:5];
//assign leds[3:0] = state;
//assign leds[7:4] = 4'b0;

clock_divider ssd_clk (
    .clk(clk),
	.freq(125000),
	.reset(0),
    .clk_out(clk_ssd)
    );
    
clock_divider slow_clk (
    .clk(clk),
	.freq(5000),
	.reset(0),
    .clk_out(clk_slow)
    );

seven_seg_display ssd (
	.clk(clk_ssd),
	.digit_values(ssd_digits),
    .ssd_digit(ssd_digit),
    .ssd_select(ssd_select)
	);
	
RN_JESUS rng (
	.clk(clk), 
	.i_en(rng_en), 
	.rst(rng_rst), 
	.o_rand(rng_num)
);

move_to_ssd mts(
	.clk(clk),
	.start(mts_start),
    .move(move[4:0]),
    .ssd_digits(mts_ssd_digits),
	.ready(mts_ready)
    );
	
rng_to_move rtm(
    .rng(rng_reg),
    .num_play(play_elements),
	.num_elements(move_elements),
    .move(rtm_move),
    .clk(clk),
    .ready(rtm_ready),
    .start(rtm_start)
    );
	
check_move cm(
    .play_freq(play_freq),
    .clk(clk),
    .start(cm_start),
	.move(move),
	.sw(sw),
	.btn(btns_d),
	.halfway(cm_half),	
    .ready(cm_ready),
    .correct(cm_correct)
    );
	
level_up lu(
	.clk(clk),
    .level(level),
    .play_freq(play_freq),
    .play_elements(play_elements),
    .move_elements(move_elements),
    .max_points(max_points)
    );

assign btns_d = btns;

initial begin
	state = INIT_ST; // TODO: Test this!
end


always @(posedge clk_slow)
begin

	case(state)
	INIT_ST: begin
			state <= IDLE_ST;
			sw_prev <= sw;
			ssd_digits <= "----";
		end
	IDLE_ST: begin
		if (sw[7] == ~sw_prev[7]) begin
			rng_en <= 1; 
			state <= RNG_ST;
		end
		sw_prev <= sw;
		//ssd_digits <= "1234";
        level <= 1;
        points_won <= 0;
        points_1 <= 0;
        points_10 <= 0;
        points_100 <= 0;
		move <= 0;
	end
	RNG_ST:
	begin
		rng_reg[rng_counter] <= rng_num;
		if (rng_counter == 5'b11111)
		begin
			rng_en <= 0;
			state <= PLAY_ST;
			rng_counter <= 0;
			rtm_start <= 1;
		end
		else
			rng_counter <= rng_counter + 1;
	end
	PLAY_ST:
	begin
		rtm_start <= 1'b0;
		if (rtm_ready) begin
			mts_start <= 1'b1;
			sw_prev <= sw;
			ssd_digits <= 32'b0;
			state <= DISP_ST;
			move <= rtm_move;
			//move <= 1;
		end
	end
	
	DISP_ST:
	begin
		if (mts_start)
			mts_start <= 1'b0;
		else if (mts_ready) begin
			ssd_digits <= mts_ssd_digits;
			state <= CHK_ST;
			cm_start <= 1'b1;
		end
	end
		
	CHK_ST: begin
		if (cm_start)
			cm_start <= 1'b0;
		else if (cm_ready)
		begin
			sw_prev <= sw;
			if (cm_correct) begin
                points_won <= points_won + 1;
                if (points_1 == 9) begin
                    points_1 <= 0;
                    if (points_10 == 9) begin
                        points_100 <= points_100 + 1;
                        points_10 <= 0;
                    end
                    else
                        points_10 <= points_10 + 1;
                end
                else
                    points_1 <= points_1 + 1;
                    
				if (points_won == max_points - 1) begin
				//move to next level
				level <= level + 1;
				state <= LVLUP_ST;
                timer <= 0;
				end
				else begin
					// next move
					state <= RNG_ST;
					rng_en <= 1;
					rng_reg <= 0;
				end
			end
			else begin
				// lose
				state <= LOSE_ST;
			end
		end
		else begin
			state <= CHK_ST;
            if (cm_half) begin
                ssd_digits <= 0;
                move <= 0;
            end
        end
	end

	LVLUP_ST:
	begin
		if (level == 9) begin
			state <= WIN_ST;
            timer <= 0;
            move[12:5] <= 8'hFF;
        end
		else
			state <= DISP_LVLUP_ST;
	end
	
	DISP_LVLUP_ST:
	begin
		if (timer == 100000) begin
			state <= RNG_ST;
		end
        else if (timer == 0)
		begin
			ssd_digits <= {"lul", ("0" + level)};
			move[12:5] <= (1 << level) - 1;
            timer <= timer + 1;
		end
        else
            timer <= timer + 1;
	end

	LOSE_ST:
	begin
		ssd_digits[31:24] <= 8'b0;
        ssd_digits[23:16] <= 8'b0;
        ssd_digits[15:8] <= (points_10 + "0");
        ssd_digits[7:0] <= (points_1 + "0");
        sw_prev <= sw;
		state <= IDLE_ST; // TODO: change!
	end

	WIN_ST: 
	begin
        timer <= timer + 1;
        
        ssd_digits[31:24] <= 8'b0;
        ssd_digits[23:16] <= 8'b0;
        ssd_digits[15:8] <= (points_10 + "0");
        ssd_digits[7:0] <= (points_1 + "0");
        
		if (timer == 15000 || timer == 30000 || timer == 45000 ||
            timer == 60000 || timer == 75000 || timer == 90000)
            move[12:5] <= ~move[12:5];
        else if (timer == 100000) begin
            state <= IDLE_ST; // TODO: change!
            sw_prev <= sw;
        end
	end


	default: begin
		ssd_digits <= "nooo";
		end
	endcase
	


end

endmodule


