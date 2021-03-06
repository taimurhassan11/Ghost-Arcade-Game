module control(
		input clk,
		input resetn,
		input go_right, // ~SW[0]
		input go_left,
		input go_up,
		input go_down,
		input go_right2, // ~SW[0]
		input go_left2,
		input go_up2,
		input go_down2,
		input start_game,
		input valid,
      input ghost_done,
		input ghost_done_2,
		input spirit_done,
      input erase_ghost_done,
//		input erase_ghost_done2,
//		input erase_ghost_done3,
//		input erase_ghost_done4,
//		input erase_ghost_done5,
//		input erase_ghost_done6,
//		input erase_ghost_done7,
//		input erase_ghost_done8,
//		input erase_ghost_done9,
		input erase_spirit_done,
		input erased_spirit_done,
		input endgame,
 
      output reg move_right,
		output reg move_left,
		output reg move_up,
		output reg move_down,
		output reg move_right2,
		output reg move_left2,
		output reg move_up2,
		output reg move_down2,
      output reg draw_ghost,
		output reg draw_ghost_2,
		output reg draw_spirit,
		output reg rand_spirit,
      output reg start,
      output reg erase_ghost_right,
		output reg erase_ghost_left,
		output reg erase_ghost_up,
		output reg erase_ghost_down,
		output reg erase_ghost_right2,
		output reg erase_ghost_left2,
		output reg erase_ghost_up2,
		output reg erase_ghost_down2,
		output reg spirit_caught,
		output reg spirit_erase,
		output reg draw_end
//		output reg animate_map00,
//		output reg animate_map01,
//		output reg animate_map02,
//		output reg animate_map1,
//		output reg animate_map2,
//		output reg animate_map3,
//		output reg animate_map4,
//		output reg animate_maplast
   );
	
	wire counter;
	wire [25:0] w1;
	assign counter = (w1 == 26'b0)?1:0;
	
	rate_divider u4Hz(
				.clock(clk),
				.enable(1'b1),
				.load(26'd300000),
				.reset(~resetn),
				.count(w1)
				);
	
//	wire counter2;
//	wire [25:0] w2;
//	assign counter2 = (w2 == 26'b0)?1:0;
//	
//	rate_divider u4Hz2(
//				.clock(clk),
//				.enable(1'b1),
//				.load(26'd5000000),
//				.reset(~resetn),
//				.count(w2)
//				);
//	
//	wire counter3;
//	wire [25:0] w3;
//	assign counter3 = (w3 == 26'b0)?1:0;
//	
//	rate_divider u4Hz3(
//				.clock(clk),
//				.enable(1'b1),
//				.load(26'd5000000),
//				.reset(~resetn),
//				.count(w3)
//				);
//	
//	wire counter4;
//	wire [25:0] w4;
//	assign counter4 = (w4 == 26'b0)?1:0;
//	
//	rate_divider u4Hz4(
//				.clock(clk),
//				.enable(1'b1),
//				.load(26'd5000000),
//				.reset(~resetn),
//				.count(w4)
//				);
//	
//	wire counter5;
//	wire [25:0] w5;
//	assign counter5 = (w5 == 26'b0)?1:0;
//	
//	rate_divider u4Hz5(
//				.clock(clk),
//				.enable(1'b1),
//				.load(26'd5000000),
//				.reset(~resetn),
//				.count(w5)
//				);
//	
//	wire counter6;
//	wire [25:0] w6;
//	assign counter6 = (w6 == 26'b0)?1:0;
//	
//	rate_divider u4Hz6(
//				.clock(clk),
//				.enable(1'b1),
//				.load(26'd5000000),
//				.reset(~resetn),
//				.count(w6)
//				);
//	
//	wire counter7;
//	wire [25:0] w7;
//	assign counter7 = (w7 == 26'b0)?1:0;
//	
//	rate_divider u4Hz7(
//				.clock(clk),
//				.enable(1'b1),
//				.load(26'd5000000),
//				.reset(~resetn),
//				.count(w7)
//				);
//	
//	wire counter8;
//	wire [25:0] w8;
//	assign counter8 = (w8 == 26'b0)?1:0;
//	
//	rate_divider u4Hz8(
//				.clock(clk),
//				.enable(1'b1),
//				.load(26'd5000000),
//				.reset(~resetn),
//				.count(w8)
//				);
	
	reg [5:0] current_state, next_state; 
	 
	localparam  START        	    = 5'd0,
					MAIN_MENU          = 5'd1,
					DRAW_GAME			 = 5'd2,
					DRAW_GAME_1        = 5'd28,
//					ANIMATE_LOAD1      = 5'd36,
//					ANIMATE_LOAD2      = 5'd37,
//					ANIMATE_LOAD3      = 5'd38,
//					ANIMATE_LOAD4      = 5'd39,
//					ANIMATE_LOAD5      = 5'd40,
//					ANIMATE_LOAD6      = 5'd41,
//					ANIMATE_LOAD7      = 5'd42,
//					DRAW_GAME_2        = 5'd29,
//					DRAW_GAME_3        = 5'd30,
//					DRAW_GAME_4        = 5'd31,
//					DRAW_GAME_5        = 5'd32,
//					DRAW_GAME_6        = 5'd33,
//					DRAW_GAME_7        = 5'd34,
//					DRAW_GAME_8        = 5'd35,
					RAND_SPIRIT        = 5'd27,
					END_GAME           = 5'd29,
					DRAW_SPIRIT        = 5'd3,
					ERASE_SPIRIT       = 5'd4,
               DRAW_ghost         = 5'd5,
					DRAW_ghost_2       = 5'd6,
					WAITRD             = 5'd7,
					WAITRD2            = 5'd8,
               WAIT	             = 5'd9,
					WAIT2              = 5'd10,
               MOVE_RIGHT         = 5'd11,
					MOVE_LEFT          = 5'd12,
					MOVE_UP            = 5'd13,
					MOVE_DOWN          = 5'd14,
               ERASE_ghost_RIGHT  = 5'd15,
					ERASE_ghost_LEFT   = 5'd16,
					ERASE_ghost_UP     = 5'd17,
					ERASE_ghost_DOWN   = 5'd18,
					MOVE_RIGHT2        = 5'd19,
					MOVE_LEFT2         = 5'd20,
					MOVE_UP2           = 5'd21,
					MOVE_DOWN2         = 5'd22,
               ERASE_ghost_RIGHT2 = 5'd23,
					ERASE_ghost_LEFT2  = 5'd24,
					ERASE_ghost_UP2    = 5'd25,
					ERASE_ghost_DOWN2  = 5'd26;
	
	always @ (*)
   begin: state_table 
		case (current_state)
		
                START: next_state = MAIN_MENU;
					 
					 MAIN_MENU: begin
					 
						if (start_game == 1'b1)
							next_state = DRAW_GAME;
						else
							next_state = MAIN_MENU;
					 end
					 
					 DRAW_GAME: begin
                    if(erase_ghost_done == 1'b1)
                        next_state = DRAW_SPIRIT;
                    else
                        next_state = DRAW_GAME;
                end
					 
//					 DRAW_GAME_1: begin
//                    if(erase_ghost_done2 == 1'b1)
//                        next_state = ANIMATE_LOAD1;
//                    else
//                        next_state = DRAW_GAME_1;
//                end
//					 
//					 ANIMATE_LOAD1: begin
//                    next_state = counter2 ? DRAW_GAME_2 : ANIMATE_LOAD1;
//                end
//					 
//					 DRAW_GAME_2: begin
//                    if(erase_ghost_done3 == 1'b1)
//                        next_state = ANIMATE_LOAD2;
//                    else
//                        next_state = DRAW_GAME_2;
//                end
//					 
//					 ANIMATE_LOAD2: begin
//                    next_state = counter3 ? DRAW_GAME_3 : ANIMATE_LOAD2;
//                end
//					 
//					 DRAW_GAME_3: begin
//                    if(erase_ghost_done4 == 1'b1)
//                        next_state = ANIMATE_LOAD3;
//                    else
//                        next_state = DRAW_GAME_3;
//                end
//					 
//					 ANIMATE_LOAD3: begin
//                    next_state = counter4 ? DRAW_GAME_4 : ANIMATE_LOAD3;
//                end
//					 
//					 DRAW_GAME_4: begin
//                    if(erase_ghost_done5 == 1'b1)
//                        next_state = ANIMATE_LOAD4;
//                    else
//                        next_state = DRAW_GAME_4;
//                end
//					 
//					 ANIMATE_LOAD4: begin
//                    next_state = counter5 ? DRAW_GAME_5 : ANIMATE_LOAD4;
//                end
//					 
//					 DRAW_GAME_5: begin
//                    if(erase_ghost_done6 == 1'b1)
//                        next_state = ANIMATE_LOAD5;
//                    else
//                        next_state = DRAW_GAME_5;
//                end
//					 
//					 ANIMATE_LOAD5: begin
//                    next_state = counter6 ? DRAW_GAME_6 : ANIMATE_LOAD5;
//                end
//					 
//					 DRAW_GAME_6: begin
//                    if(erase_ghost_done7 == 1'b1)
//                        next_state = ANIMATE_LOAD6;
//                    else
//                        next_state = DRAW_GAME_6;
//                end
//					 
//					 ANIMATE_LOAD6: begin
//                    next_state = counter7 ? DRAW_GAME_7 : ANIMATE_LOAD6;
//                end
//					 
//					 DRAW_GAME_7: begin
//                    if(erase_ghost_done8 == 1'b1)
//                        next_state = ANIMATE_LOAD7;
//                    else
//                        next_state = DRAW_GAME_7;
//                end
//					 
//					 ANIMATE_LOAD7: begin
//                    next_state = counter8 ? DRAW_GAME_8 : ANIMATE_LOAD7;
//                end
//					 
//					 DRAW_GAME_8: begin
//                    if(erase_ghost_done9 == 1'b1)
//                        next_state = DRAW_SPIRIT;
//                    else
//                        next_state = DRAW_GAME_8;
//                end
					 
					 RAND_SPIRIT: begin
						if(endgame == 1'b1)
							next_state = END_GAME;
						else
							next_state = DRAW_SPIRIT;
					 end
					 
					 END_GAME: begin
					 end
					 
					 DRAW_SPIRIT: begin
						if(spirit_done == 1'b1)
							next_state = DRAW_ghost;
						else
							next_state = DRAW_SPIRIT;
					 end
					 
                DRAW_ghost: begin
                    if(ghost_done == 1'b1)
                        next_state = DRAW_ghost_2;
                    else
                        next_state = DRAW_ghost;
                end
					 
					 DRAW_ghost_2: begin
						if(ghost_done_2 == 1'b1)
								next_state = WAITRD;
						else
								next_state = DRAW_ghost_2;
					 end
					 
					 ERASE_SPIRIT: begin
						if(erase_spirit_done == 1'b1)
							   next_state = RAND_SPIRIT;
						else
								next_state = DRAW_SPIRIT;
					 end
					 
                WAIT: begin // wait for user keypress and then move to corresponding state
                    
						  if (go_right == 1'b1)
								next_state = ERASE_ghost_RIGHT;
						  else if (go_left == 1'b1)
								next_state = ERASE_ghost_LEFT;
						  else if (go_up == 1'b1)
								next_state = ERASE_ghost_UP;
						  else if (go_down == 1'b1)
								next_state = ERASE_ghost_DOWN;
						  else
								next_state = WAIT2;
					 end
					 
					 WAIT2: begin // wait for user keypress and then move to corresponding state
                    
						  if (go_right2 == 1'b1)
								next_state = ERASE_ghost_RIGHT2;
						  else if (go_left2 == 1'b1)
								next_state = ERASE_ghost_LEFT2;
						  else if (go_up2 == 1'b1)
								next_state = ERASE_ghost_UP2;
						  else if (go_down2 == 1'b1)
								next_state = ERASE_ghost_DOWN2;
						  else
								next_state = ERASE_SPIRIT;
					 end
					 		 
                MOVE_RIGHT: begin // continue moving right until the tile is valid
                    if(valid)
                        next_state = WAIT2;
                    else
                        next_state = MOVE_RIGHT;
                end
					 
					 MOVE_LEFT: begin // continue moving right until the tile is valid
                    if(valid)
                        next_state = WAIT2;
                    else
                        next_state = MOVE_LEFT;
                end
					 
					 MOVE_UP: begin // continue moving right until the tile is valid
                    if(valid)
                        next_state = WAIT2;
                    else
                        next_state = MOVE_UP;
                end
					 
					 MOVE_DOWN: begin // continue moving right until the tile is valid
                    if(valid)
                        next_state = WAIT2;
                    else
                        next_state = MOVE_DOWN;
                end
					 
					 MOVE_RIGHT2: begin // continue moving right until the tile is valid
                    if(valid)
                        next_state = ERASE_SPIRIT;
                    else
                        next_state = MOVE_RIGHT2;
                end
					 
					 MOVE_LEFT2: begin // continue moving right until the tile is valid
                    if(valid)
                        next_state = ERASE_SPIRIT;
                    else
                        next_state = MOVE_LEFT2;
                end
					 
					 MOVE_UP2: begin // continue moving right until the tile is valid
                    if(valid)
                        next_state = ERASE_SPIRIT;
                    else
                        next_state = MOVE_UP2;
                end
					 
					 MOVE_DOWN2: begin // continue moving right until the tile is valid
                    if(valid)
                        next_state = ERASE_SPIRIT;
                    else
                        next_state = MOVE_DOWN2;
                end
					 
                ERASE_ghost_RIGHT: begin //Erase current cell's sprite before moving right
                    if(erase_ghost_done)
                        next_state = MOVE_RIGHT;
                    else
                        next_state = ERASE_ghost_RIGHT;
                end
					 
					 ERASE_ghost_LEFT: begin //Erase current cell's sprite before moving right
                    if(erase_ghost_done)
                        next_state = MOVE_LEFT;
                    else
                        next_state = ERASE_ghost_LEFT;
                end
					 
					 ERASE_ghost_UP: begin //Erase current cell's sprite before moving right
                    if(erase_ghost_done)
                        next_state = MOVE_UP;
                    else
                        next_state = ERASE_ghost_UP;
                end
					 
					 ERASE_ghost_DOWN: begin //Erase current cell's sprite before moving right
                    if(erase_ghost_done)
                        next_state = MOVE_DOWN;
                    else
                        next_state = ERASE_ghost_DOWN;
                end
					 
					 ERASE_ghost_RIGHT2: begin //Erase current cell's sprite before moving right
                    if(erase_ghost_done)
                        next_state = MOVE_RIGHT2;
                    else
                        next_state = ERASE_ghost_RIGHT2;
                end
					 
					 ERASE_ghost_LEFT2: begin //Erase current cell's sprite before moving right
                    if(erase_ghost_done)
                        next_state = MOVE_LEFT2;
                    else
                        next_state = ERASE_ghost_LEFT2;
                end
					 
					 ERASE_ghost_UP2: begin //Erase current cell's sprite before moving right
                    if(erase_ghost_done)
                        next_state = MOVE_UP2;
                    else
                        next_state = ERASE_ghost_UP2;
                end
					 
					 ERASE_ghost_DOWN2: begin //Erase current cell's sprite before moving right
                    if(erase_ghost_done)
                        next_state = MOVE_DOWN2;
                    else
                        next_state = ERASE_ghost_DOWN2;
                end
					 
					 WAITRD: begin // wait for user keypress and then move to corresponding state
                    
							next_state = counter ? WAIT : WAITRD;
					 end
					 
					 WAITRD2: begin // wait for user keypress and then move to corresponding state
                    
							next_state = counter ? WAIT2 : WAITRD2;
					 end
					 
            default: next_state = START;
		endcase // state table
	end
	
	// Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0 to avoid latches.
		  
        start = 1'b0;
        draw_ghost = 1'b0;
		  draw_ghost_2 = 1'b0;
		  rand_spirit = 1'b0;
		  draw_spirit = 1'b0;
        move_right = 1'b0;
        erase_ghost_right = 1'b0;
		  move_left = 1'b0;
        erase_ghost_left = 1'b0;
		  move_up = 1'b0;
        erase_ghost_up = 1'b0;
		  move_down = 1'b0;
        erase_ghost_down = 1'b0;
		  move_right2 = 1'b0;
        erase_ghost_right2 = 1'b0;
		  move_left2 = 1'b0;
        erase_ghost_left2 = 1'b0;
		  move_up2 = 1'b0;
        erase_ghost_up2 = 1'b0;
		  move_down2 = 1'b0;
        erase_ghost_down2 = 1'b0;
		  spirit_caught = 1'b0;
		  spirit_erase = 1'b0;
		  draw_end = 1'b0;
//		  animate_map00 = 1'b0;
//		  animate_map01 = 1'b0;
//		  animate_map02 = 1'b0;
//		  animate_map1 = 1'b0;
//		  animate_map2 = 1'b0;
//		  animate_map3 = 1'b0;
//		  animate_map4 = 1'b0;
//		  animate_maplast = 1'b0;

        case (current_state)
         START: begin
                start = 1'b1;
            end
         DRAW_ghost: begin
                draw_ghost = 1'b1;
            end
			DRAW_ghost_2: begin
                draw_ghost_2 = 1'b1;
            end
			RAND_SPIRIT: begin
					 rand_spirit = 1'b1;
				end
			END_GAME: begin
					 draw_end = 1'b1;
				end
			DRAW_SPIRIT: begin
					 draw_spirit = 1'b1;
				end
			DRAW_GAME: begin
                erase_ghost_right = 1'b1;
            end
			MOVE_RIGHT: begin
                move_right = 1'b1;
            end
         ERASE_ghost_RIGHT: begin
                erase_ghost_right = 1'b1;
            end
			MOVE_LEFT: begin
                move_left = 1'b1;
            end
         ERASE_ghost_LEFT: begin
                erase_ghost_left = 1'b1;
            end
			MOVE_UP: begin
                move_up = 1'b1;
            end
         ERASE_ghost_UP: begin
                erase_ghost_up = 1'b1;
            end
			MOVE_DOWN: begin
                move_down = 1'b1;
            end
         ERASE_ghost_DOWN: begin
                erase_ghost_down = 1'b1;
            end
			MOVE_RIGHT2: begin
                move_right2 = 1'b1;
            end
         ERASE_ghost_RIGHT2: begin
                erase_ghost_right2 = 1'b1;
            end
			MOVE_LEFT2: begin
                move_left2 = 1'b1;
            end
         ERASE_ghost_LEFT2: begin
                erase_ghost_left2 = 1'b1;
            end
			MOVE_UP2: begin
                move_up2 = 1'b1;
            end
         ERASE_ghost_UP2: begin
                erase_ghost_up2 = 1'b1;
            end
			MOVE_DOWN2: begin
                move_down2 = 1'b1;
            end
         ERASE_ghost_DOWN2: begin
                erase_ghost_down2 = 1'b1;
            end
			ERASE_SPIRIT: begin
                spirit_caught = 1'b1;
            end
//			DRAW_GAME_1: begin
//                animate_map00 = 1'b1;
//            end
//			DRAW_GAME_2: begin
//                animate_map01 = 1'b1;
//            end
//			DRAW_GAME_3: begin
//                animate_map02 = 1'b1;
//            end
//			DRAW_GAME_4: begin
//                animate_map1 = 1'b1;
//            end
//			DRAW_GAME_5: begin
//                animate_map2 = 1'b1;
//            end
//			DRAW_GAME_6: begin
//                animate_map3 = 1'b1;
//            end
//			DRAW_GAME_7: begin
//                animate_map4 = 1'b1;
//            end
//			DRAW_GAME_8: begin
//                animate_maplast = 1'b1;
//            end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
	 
	 // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= START;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module rate_divider(clock, enable, load, reset, count);

	input [25:0] load;
	input clock, enable, reset;
	output reg [25:0] count;
	
	always @(posedge clock, posedge reset)
	begin
		if(reset == 1'b1)
			count <= load;
		else if(count == 26'b0 && enable == 1'b1)
			count <= load;
		else if(enable == 1'b1)
			count <= count - 1;
	end
endmodule
