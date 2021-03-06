module datapath (
   input clk,
   input resetn,
	
	//____Control Signals___//
   input start, 
	input draw_ghost,
	input draw_ghost_2,
	input draw_spirit,
	input rand_spirit,
	input move_right,
	input move_left,
	input move_up,
	input move_down,
	input move_right2,
	input move_left2,
	input move_up2,
	input move_down2,
	input erase_ghost_right,
	input erase_ghost_left,
	input erase_ghost_up,
	input erase_ghost_down,
	input erase_ghost_right2,
	input erase_ghost_left2,
	input erase_ghost_up2,
	input erase_ghost_down2,
	input spirit_caught,
	input spirit_erase,
	input draw_end,
//	input animate_map00,
//	input animate_map01,
//	input animate_map02,
//	input animate_map1,
//	input animate_map2,
//	input animate_map3,
//	input animate_map4,
//	input animate_maplast,
	
	 //_______________________//
   output reg valid,
	output reg [8:0] colour,
	output reg [6:0] ypos,
	output reg [7:0] xpos,

	//________Control Feedback__________//
	output reg ghost_done,
	output reg ghost_done_2,
	output reg spirit_done,
	output reg erase_ghost_done,
//	output reg erase_ghost_done2,
//	output reg erase_ghost_done3,
//	output reg erase_ghost_done4,
//	output reg erase_ghost_done5,
//	output reg erase_ghost_done6,
//	output reg erase_ghost_done7,
//	output reg erase_ghost_done8,
//	output reg erase_ghost_done9,
	output reg erase_spirit_done,
	output reg erased_spirit_done,
	output reg endgame,
	output reg counterdone,
	output reg counterdone2,
	output reg counterdone3,
	output reg [6:0] scorep1,
	output reg [6:0] scorep2,
	output reg [6:0] gameclk
);


	/*____________Map Related Registers___________*/
	reg [7:0] counter_x_map; //counter to access map memory
	reg [6:0] counter_y_map; //counter to access map memory
//	reg [7:0] counter_x_map2; //counter to access map memory
//	reg [6:0] counter_y_map2; //counter to access map memory
//	reg [7:0] counter_x_map3; //counter to access map memory
//	reg [6:0] counter_y_map3; //counter to access map memory
//	reg [7:0] counter_x_map4; //counter to access map memory
//	reg [6:0] counter_y_map4; //counter to access map memory
//	reg [7:0] counter_x_map5; //counter to access map memory
//	reg [6:0] counter_y_map5; //counter to access map memory
//	reg [7:0] counter_x_map6; //counter to access map memory
//	reg [6:0] counter_y_map6; //counter to access map memory
//	reg [7:0] counter_x_map7; //counter to access map memory
//	reg [6:0] counter_y_map7; //counter to access map memory
//	reg [7:0] counter_x_map8; //counter to access map memory
//	reg [6:0] counter_y_map8; //counter to access map memory
//	reg [7:0] counter_x_map9; //counter to access map memory
//	reg [6:0] counter_y_map9; //counter to access map memory
	reg [14:0] memory_address_map; //need 15 bits to access map.mif (19200 addresses - 160 x 120)
//	reg [14:0] memory_address_map00; //need 15 bits to access map.mif (19200 addresses - 160 x 120)
//	reg [14:0] memory_address_map01; //need 15 bits to access map.mif (19200 addresses - 160 x 120)
//	reg [14:0] memory_address_map02; //need 15 bits to access map.mif (19200 addresses - 160 x 120)
//	reg [14:0] memory_address_map1; //need 15 bits to access map.mif (19200 addresses - 160 x 120)
//	reg [14:0] memory_address_map2; //need 15 bits to access map.mif (19200 addresses - 160 x 120)
//	reg [14:0] memory_address_map3; //need 15 bits to access map.mif (19200 addresses - 160 x 120)
//	reg [14:0] memory_address_map4; //need 15 bits to access map.mif (19200 addresses - 160 x 120)
//	reg [14:0] memory_address_mapfinal; //need 15 bits to access map.mif (19200 addresses - 160 x 120)
	
	/*____________Spirit Related Registers___________*/
	reg [7:0] counter_x_spirit; //counter to access map memory
	reg [6:0] counter_y_spirit; //counter to access map memory
	reg [7:0] counter_x_erases;
	reg [6:0] counter_y_erases;
	reg [7:0] memory_address_spirit; //need 15 bits to access map.mif (19200 addresses - 160 x 120)
	reg [8:0] xsinit;
	reg [7:0] ysinit;
	reg [8:0] xseinit;
	reg [7:0] yseinit;
	reg score1;
	reg score2;
	
	/*___________ghost Related Registers___________*/
	reg [7:0] counter_x_ghost; //coutner to acess ghost memory
	reg [6:0] counter_y_ghost; //coutner to acess ghost memory
	reg [7:0] memory_address_ghost; //need 8 bit to access ghost.mif (400 addresses - 20 x 20)
	reg [7:0] counter_x2_ghost; //coutner to acess ghost memory
	reg [6:0] counter_y2_ghost; //coutner to acess ghost memory
	reg [7:0] memory_address_ghost_2; //need 8 bit to access ghost.mif (400 addresses - 20 x 20)
	reg [8:0] xinit;
	reg [7:0] yinit;
	reg [8:0] x2init;
	reg [7:0] y2init;
	 	 
	/*___________Memory Accessing Wires___________*/
	wire [8:0] colour_map;
//	wire [8:0] colour_map00;
//	wire [8:0] colour_map01;
//	wire [8:0] colour_map02;
//	wire [8:0] colour_map1;
//	wire [8:0] colour_map2;
//	wire [8:0] colour_map3;
//	wire [8:0] colour_map4;
//	wire [8:0] colour_maplast;
	wire [8:0] colour_ghost;
	wire [8:0] colour_ghost_2;
	wire [8:0] colour_spirit;
	
	ram_background b(
					.address(memory_address_map),
					.clock(clk),
					.data(9'b0),
					.wren(1'b0),
					.q(colour_map)
					);
	
//	house00 h1(
//					.address(memory_address_map),
//					.clock(clk),
//					.data(9'b0),
//					.wren(1'b0),
//					.q(colour_map00)
//					);
//	
//	house01 h2(
//					.address(memory_address_map),
//					.clock(clk),
//					.data(9'b0),
//					.wren(1'b0),
//					.q(colour_map01)
//					);
//	
//	house02 h3(
//					.address(memory_address_map),
//					.clock(clk),
//					.data(9'b0),
//					.wren(1'b0),
//					.q(colour_map02)
//					);
//	
//	house1 h4(
//					.address(memory_address_map),
//					.clock(clk),
//					.data(9'b0),
//					.wren(1'b0),
//					.q(colour_map1)
//					);
//					
//	house2 h5(
//					.address(memory_address_map),
//					.clock(clk),
//					.data(9'b0),
//					.wren(1'b0),
//					.q(colour_map2)
//					);
//	house3 h6(
//					.address(memory_address_map),
//					.clock(clk),
//					.data(9'b0),
//					.wren(1'b0),
//					.q(colour_map3)
//					);
//	house4 h7(
//					.address(memory_address_map),
//					.clock(clk),
//					.data(9'b0),
//					.wren(1'b0),
//					.q(colour_map4)
//					);
//					
//	housefinal h8(
//					.address(memory_address_map),
//					.clock(clk),
//					.data(9'b0),
//					.wren(1'b0),
//					.q(colour_maplast)
//					);
							
	ram_sprite s(
					.address(memory_address_ghost),
					.clock(clk),
					.data(9'b0),
					.wren(1'b0),
					.q(colour_ghost)
					);
	
	ram_sprite_2 s2(
					.address(memory_address_ghost_2),
					.clock(clk),
					.data(9'b0),
					.wren(1'b0),
					.q(colour_ghost_2)
					);
					
	ram_spirit s3(
					.address(memory_address_spirit),
					.clock(clk),
					.data(9'b0),
					.wren(1'b0),
					.q(colour_spirit)
					);
	
	wire counterend;
	wire [25:0] wend;
	assign counterend = (wend == 26'b0)?1:0;
	
	rate_divider u4Hz2(
				.clock(clk),
				.enable(1'b1),
				.load(26'd50000000),
				.reset(~resetn),
				.count(wend)
				);
				
	always @(posedge counterend) begin
		gameclk <= gameclk + 1;
	end
	
	
	wire [6:0] xrand;
	wire [6:0] yrand;
	
	dice d1(
			.clk(clk),
			.rand_spirit(rand_spirit),
			.coordinate(xrand)
			  );
	
	dice d2(
			.clk(clk),
			.rand_spirit(rand_spirit),
			.coordinate(yrand)
			  );
	
	
	always @ (posedge clk) begin
	
		if (!resetn) begin
			valid <= 0;
			counter_x_map <= 0;
	 		counter_y_map <= 0;
//			counter_x_map2 <= 0;
//	 		counter_y_map2 <= 0;
//			counter_x_map3 <= 0;
//	 		counter_y_map3 <= 0;
//			counter_x_map4 <= 0;
//	 		counter_y_map4 <= 0;
//			counter_x_map5 <= 0;
//	 		counter_y_map5 <= 0;
//			counter_x_map6 <= 0;
//	 		counter_y_map6 <= 0;
//			counter_x_map7 <= 0;
//	 		counter_y_map7 <= 0;
//			counter_x_map8 <= 0;
//	 		counter_y_map8 <= 0;
//			counter_x_map9 <= 0;
//	 		counter_y_map9 <= 0;
			memory_address_map <= 0;
//			memory_address_map00 <= 0;
//			memory_address_map01 <= 0;
//			memory_address_map02 <= 0;
//			memory_address_map1 <= 0;
//			memory_address_map2 <= 0;
//			memory_address_map3 <= 0;
//			memory_address_map4 <= 0;
//			memory_address_mapfinal <= 0;

			counter_x_ghost <= 0;
			counter_y_ghost <= 0;
			memory_address_ghost <= 0;
			counter_x2_ghost <= 0;
			counter_y2_ghost <= 0;
			memory_address_ghost_2 <= 0;
			
			counter_x_spirit <= 0;
			counter_y_spirit <= 0;
			memory_address_spirit <= 0;
			
			counter_x_erases <= 0;
			counter_y_erases <= 0;
			
			score1 <= 0;
			score2 <= 0;

			ghost_done <= 0;
			ghost_done_2 <= 0;
			spirit_done <= 0;
			erase_ghost_done <= 0;
			erase_spirit_done <= 0;
			endgame <= 0;
			scorep1 <= 0;
			scorep2 <= 0;
			xinit <= 8'd0;
			yinit <= 8'd0;
			xsinit <= 8'd0;
			ysinit <= 7'd0;
			xseinit <= 8'd0;
			yseinit <= 7'd0;
			x2init <= 8'd0;
			y2init <= 7'd0;
			counterdone <= 0;
			counterdone2 <= 0;
			counterdone3 <= 0;
		end
		
		else if (start) begin
			valid <= 0;
			counter_x_map <= 0;
	 		counter_y_map <= 0;
//			counter_x_map2 <= 0;
//	 		counter_y_map2 <= 0;
//			counter_x_map3 <= 0;
//	 		counter_y_map3 <= 0;
//			counter_x_map4 <= 0;
//	 		counter_y_map4 <= 0;
//			counter_x_map5 <= 0;
//	 		counter_y_map5 <= 0;
//			counter_x_map6 <= 0;
//	 		counter_y_map6 <= 0;
//			counter_x_map7 <= 0;
//	 		counter_y_map7 <= 0;
//			counter_x_map8 <= 0;
//	 		counter_y_map8 <= 0;
//			counter_x_map9 <= 0;
//	 		counter_y_map9 <= 0;
			memory_address_map <= 0;
//			memory_address_map00 <= 0;
//			memory_address_map01 <= 0;
//			memory_address_map02 <= 0;
//			memory_address_map1 <= 0;
//			memory_address_map2 <= 0;
//			memory_address_map3 <= 0;
//			memory_address_map4 <= 0;
//			memory_address_mapfinal <= 0;

			counter_x_ghost <= 0;
			counter_y_ghost <= 0;
			memory_address_ghost <= 0;
			counter_x2_ghost <= 0;
			counter_y2_ghost <= 0;
			memory_address_ghost_2 <= 0;

			counter_x_spirit <= 0;
			counter_y_spirit <= 0;
			memory_address_spirit <= 0;
			
			counter_x_erases <= 0;
			counter_y_erases <= 0;
			
			score1 <= 0;
			score2 <= 0;

			ghost_done <= 0;
			ghost_done_2 <= 0;
			spirit_done <= 0;
			erase_ghost_done <= 0;
			erase_spirit_done <= 0;
			endgame <= 0;
			scorep1 <= 0;
			scorep2 <= 0;
			xinit <= 8'd6;
			yinit <= 7'd110;
			xsinit <= 8'd30;
			ysinit <= 7'd30;
			xseinit <= 8'd30;
			yseinit <= 7'd30;
			x2init <= 8'd144;
			y2init <= 7'd110;
			counterdone <= 0;
			counterdone2 <= 0;
			counterdone3 <= 0;
		end
		
//		else if(animate_map00) begin 
//		
//			//Reset the flag for next use
//
//			//Erase current cell's suqare
//			colour <= colour_map00;
//			
//			memory_address_map00 <= memory_address_map00 + 1;
//			
//			if (counter_x_map2 < 8'd159) begin
//				counter_x_map2 <= counter_x_map2 + 1;
//			end
//			
//			if (counter_x_map2 >= 8'd159 && counter_y_map2 < 8'd120) begin
//				counter_y_map2 <= counter_y_map2 + 1;
//				counter_x_map2 <= 0;
//			end
//			
//			if ({counter_x_map2, counter_y_map2} <= 16'b1001111101111000) begin
//				counterdone <= 1;
//			end
//			
//			if ({counter_x_map2, counter_y_map2} == 15'b100111101111000) begin
//				erase_ghost_done2 <= 1;
//			end
//			
//			
//			xpos <= counter_x_map2;
//			ypos <= counter_y_map2;
//			
//		end
//		
//		else if(animate_map01) begin 
//		
//			//Reset the flag for next use
//
//			//Erase current cell's suqare
//			colour <= colour_map01;
//			
//			memory_address_map01 <= memory_address_map01 + 1;
//			
//			if (counter_x_map3 < 8'd159) begin
//				counter_x_map3 <= counter_x_map3 + 1;
//			end
//			
//			if (counter_x_map3 >= 8'd159 && counter_y_map3 < 8'd120) begin
//				counter_y_map3 <= counter_y_map3 + 1;
//				counter_x_map3 <= 0;
//			end
//			
//			if ({counter_x_map3, counter_y_map3} <= 16'b1001111101111000) begin
//				counterdone <= 1;
//			end
//			
//			if ({counter_x_map3, counter_y_map3} == 15'b100111101111000) begin
//				erase_ghost_done3 <= 1;
//			end
//			
//			
//			xpos <= counter_x_map3;
//			ypos <= counter_y_map3;
//			
//		end
//		
//		else if(animate_map02) begin 
//		
//			//Reset the flag for next use
//
//			//Erase current cell's suqare
//			colour <= colour_map02;
//			
//			memory_address_map02 <= memory_address_map02 + 1;
//			
//			if (counter_x_map4 < 8'd159) begin
//				counter_x_map4 <= counter_x_map4 + 1;
//			end
//			
//			if (counter_x_map4 >= 8'd159 && counter_y_map4 < 8'd120) begin
//				counter_y_map4 <= counter_y_map4 + 1;
//				counter_x_map4 <= 0;
//			end
//			
//			if ({counter_x_map4, counter_y_map4} <= 16'b1001111101111000) begin
//				counterdone <= 1;
//			end
//			
//			if ({counter_x_map4, counter_y_map4} == 15'b100111101111000) begin
//				erase_ghost_done4 <= 1;
//			end
//			
//			
//			xpos <= counter_x_map4;
//			ypos <= counter_y_map4;
//			
//		end
//		
//		else if(animate_map1) begin 
//		
//			//Reset the flag for next use
//
//			//Erase current cell's suqare
//			colour <= colour_map1;
//			
//			memory_address_map1 <= memory_address_map1 + 1;
//			
//			if (counter_x_map5 < 8'd159) begin
//				counter_x_map5 <= counter_x_map5 + 1;
//			end
//			
//			if (counter_x_map5 >= 8'd159 && counter_y_map5 < 8'd120) begin
//				counter_y_map5 <= counter_y_map5 + 1;
//				counter_x_map5 <= 0;
//			end
//			
//			if ({counter_x_map5, counter_y_map5} <= 16'b1001111101111000) begin
//				counterdone <= 1;
//			end
//			
//			if ({counter_x_map5, counter_y_map5} == 15'b100111101111000) begin
//				erase_ghost_done5 <= 1;
//			end
//			
//			
//			xpos <= counter_x_map5;
//			ypos <= counter_y_map5;
//			
//		end
//		
//		else if(animate_map2) begin 
//		
//			//Reset the flag for next use
//
//			//Erase current cell's suqare
//			colour <= colour_map2;
//			
//			memory_address_map2 <= memory_address_map2 + 1;
//			
//			if (counter_x_map6 < 8'd159) begin
//				counter_x_map6 <= counter_x_map6 + 1;
//			end
//			
//			if (counter_x_map6 >= 8'd159 && counter_y_map6 < 8'd120) begin
//				counter_y_map6 <= counter_y_map6 + 1;
//				counter_x_map6 <= 0;
//			end
//			
//			if ({counter_x_map6, counter_y_map6} <= 16'b1001111101111000) begin
//				counterdone <= 1;
//			end
//			
//			if ({counter_x_map6, counter_y_map6} == 15'b100111101111000) begin
//				erase_ghost_done6 <= 1;
//			end
//			
//			
//			xpos <= counter_x_map6;
//			ypos <= counter_y_map6;
//			
//		end
//		
//		else if(animate_map3) begin 
//		
//			//Reset the flag for next use
//
//			//Erase current cell's suqare
//			colour <= colour_map3;
//			
//			memory_address_map3 <= memory_address_map3 + 1;
//			
//			if (counter_x_map7 < 8'd159) begin
//				counter_x_map7 <= counter_x_map7 + 1;
//			end
//			
//			if (counter_x_map7 >= 8'd159 && counter_y_map7 < 8'd120) begin
//				counter_y_map7 <= counter_y_map7 + 1;
//				counter_x_map7 <= 0;
//			end
//			
//			if ({counter_x_map7, counter_y_map7} <= 16'b1001111101111000) begin
//				counterdone <= 1;
//			end
//			
//			if ({counter_x_map7, counter_y_map7} == 15'b100111101111000) begin
//				erase_ghost_done7 <= 1;
//			end
//			
//			
//			xpos <= counter_x_map7;
//			ypos <= counter_y_map7;
//			
//		end
//		
//		else if(animate_map4) begin 
//		
//			//Reset the flag for next use
//
//			//Erase current cell's suqare
//			colour <= colour_map4;
//			
//			memory_address_map4 <= memory_address_map4 + 1;
//			
//			if (counter_x_map8 < 8'd159) begin
//				counter_x_map8 <= counter_x_map8 + 1;
//			end
//			
//			if (counter_x_map8 >= 8'd159 && counter_y_map8 < 8'd120) begin
//				counter_y_map8 <= counter_y_map8 + 1;
//				counter_x_map8 <= 0;
//			end
//			
//			if ({counter_x_map8, counter_y_map8} <= 16'b1001111101111000) begin
//				counterdone <= 1;
//			end
//			
//			if ({counter_x_map8, counter_y_map8} == 15'b100111101111000) begin
//				erase_ghost_done8 <= 1;
//			end
//			
//			
//			xpos <= counter_x_map8;
//			ypos <= counter_y_map8;
//			
//		end
//		
//		else if(animate_maplast) begin 
//		
//			//Reset the flag for next use
//
//			//Erase current cell's suqare
//			colour <= colour_maplast;
//			
//			memory_address_mapfinal <= memory_address_mapfinal + 1;
//			
//			if (counter_x_map9 < 8'd159) begin
//				counter_x_map9 <= counter_x_map9 + 1;
//			end
//			
//			if (counter_x_map9 >= 8'd159 && counter_y_map9 < 8'd120) begin
//				counter_y_map9 <= counter_y_map9 + 1;
//				counter_x_map9 <= 0;
//			end
//			
//			if ({counter_x_map9, counter_y_map9} <= 16'b1001111101111000) begin
//				counterdone <= 1;
//			end
//			
//			if ({counter_x_map9, counter_y_map9} == 15'b100111101111000) begin
//				erase_ghost_done9 <= 1;
//			end
//			
//			
//			xpos <= counter_x_map9;
//			ypos <= counter_y_map9;
//			
//		end
		
		else if (draw_ghost) begin
		
			counter_x_erases <= 0;
			counter_y_erases <= 0;
			counterdone3 <= 0;
		
			colour <= colour_ghost;
			
			memory_address_ghost <= memory_address_ghost + 1;
			
			if (counter_x_ghost < 8'd9) begin
				counter_x_ghost <= counter_x_ghost + 1;
			end
			
			if (counter_x_ghost >= 8'd9 && counter_y_ghost < 8'd9) begin
				counter_y_ghost <= counter_y_ghost + 1;
				counter_x_ghost <= 0;
			end
			
			if ({counter_x_ghost, counter_y_ghost} < 16'b0000100100001001) begin
				counterdone <= 1;
			end
			
			if ({counter_x_ghost, counter_y_ghost} == 15'b000010010001001) begin
				ghost_done <= 1;
			end
			
			if ((xsinit >= xinit && xsinit <= xinit + 9) && (ysinit >= yinit && ysinit <= yinit + 9)) begin
				erase_spirit_done <= 1'b1;
				score1 <= 1;
				
			end
			
			xpos <= xinit + counter_x_ghost;
			ypos <= yinit + counter_y_ghost;

		end
		
		else if (draw_ghost_2) begin
		
			//Reset the flag for next use
			ghost_done <= 0;
			spirit_done <= 0;
			counterdone <= 0;
			counter_x_ghost <= 0;
			counter_y_ghost <= 0;
			memory_address_ghost <= 0;
			counter_x_spirit <= 0;
			counter_y_spirit <= 0;
			memory_address_spirit <= 0;
			
			colour <= colour_ghost_2;
			
			memory_address_ghost_2 <= memory_address_ghost_2 + 1;
			
			if (counter_x2_ghost < 8'd9) begin
				counter_x2_ghost <= counter_x2_ghost + 1;
			end
			
			if (counter_x2_ghost >= 8'd9 && counter_y2_ghost < 8'd9) begin
				counter_y2_ghost <= counter_y2_ghost + 1;
				counter_x2_ghost <= 0;
			end
			
			if ({counter_x2_ghost, counter_y2_ghost} < 16'b0000100100001001) begin
				counterdone2 <= 1;
			end
			
			if ({counter_x2_ghost, counter_y2_ghost} == 15'b000010010001001) begin
				ghost_done_2 <= 1;
			end
			
			if ((xsinit >= x2init && xsinit <= x2init + 9) && (ysinit >= y2init && ysinit <= y2init + 9)) begin
				erase_spirit_done <= 1'b1;
				score2 <= 1;
			end
			
			xpos <= x2init + counter_x2_ghost;
			ypos <= y2init + counter_y2_ghost;

		end
		
		else if (rand_spirit) begin
		
			erase_spirit_done <= 0;
			
			if (gameclk == 90) begin
				endgame <= 1'b1;
			end
			
			if (score1 == 1'b1) begin
				scorep1 <= scorep1 + 1;
			end
			
			if (score2 == 1'b1) begin
				scorep2 <= scorep2 + 1;
			end
			
			xsinit <= xsinit + xrand;
			ysinit <= ysinit + yrand;
		
		end
		
		else if (draw_end) begin
			
			colour <= 9'b111111111;
			
			if (counter_x_map < 8'd159) begin
				counter_x_map <= counter_x_map + 1;
			end
			
			if (counter_x_map >= 8'd159 && counter_y_map < 8'd120) begin
				counter_y_map <= counter_y_map + 1;
				counter_x_map <= 0;
			end
			
			if ({counter_x_map, counter_y_map} <= 16'b1001111101111000) begin
				counterdone <= 1;
			end
			
			if ({counter_x_map, counter_y_map} == 15'b100111101111000) begin
				erase_ghost_done <= 1;
			end
			
			
			xpos <= counter_x_map;
			ypos <= counter_y_map;
			
		end
		
		else if (draw_spirit) begin
		
			erase_ghost_done <= 0;
			counter_x_map <= 0;
			counter_y_map <= 0;
			counter_x_erases <= 0;
			counter_y_erases <= 0;
			erase_spirit_done <= 0;
			memory_address_map <= 0;
			score1 <= 0;
			score2 <= 0;
		
			colour <= colour_spirit;
			
			memory_address_spirit <= memory_address_spirit + 1;
			
			if (counter_x_spirit < 8'd2) begin
				counter_x_spirit <= counter_x_spirit + 1;
			end
			
			if (counter_x_spirit >= 8'd2 && counter_y_spirit < 8'd2) begin
				counter_y_spirit <= counter_y_spirit + 1;
				counter_x_spirit <= 0;
			end
			
			if ({counter_x_spirit, counter_y_spirit} < 16'b0000001000000010) begin
				counterdone <= 1;
			end
			
			if ({counter_x_spirit, counter_y_spirit} == 15'b000000100000010) begin
				spirit_done <= 1;
			end
			
			if(xsinit >= 8'd120) begin
				xsinit <= 8'd40;
			end
			
			if(ysinit >= 7'd100) begin
				ysinit <= 7'd20;
			end
	
	
			xpos <= xsinit + counter_x_spirit;
			ypos <= ysinit + counter_y_spirit;

		end
		
		else if(erase_ghost_right | erase_ghost_left | erase_ghost_up | erase_ghost_down | erase_ghost_right2 | erase_ghost_left2 | erase_ghost_up2 | erase_ghost_down2) begin 
		
			//Reset the flag for next use
			ghost_done <= 0;
			ghost_done_2 <= 0;
			counterdone <= 0;
			counterdone2 <= 0;
			counter_x_ghost <= 0;
			counter_y_ghost <= 0;
			memory_address_ghost <= 0;
			counter_x2_ghost <= 0;
			counter_y2_ghost <= 0;
			memory_address_ghost_2 <= 0;
			//Erase current cell's suqare
			colour <= colour_map;
			
			memory_address_map <= memory_address_map + 1;
			
			if (counter_x_map < 8'd159) begin
				counter_x_map <= counter_x_map + 1;
			end
			
			if (counter_x_map >= 8'd159 && counter_y_map < 8'd120) begin
				counter_y_map <= counter_y_map + 1;
				counter_x_map <= 0;
			end
			
			if ({counter_x_map, counter_y_map} <= 16'b1001111101111000) begin
				counterdone <= 1;
			end
			
			if ({counter_x_map, counter_y_map} == 15'b100111101111000) begin
				erase_ghost_done <= 1;
			end
			
			
			xpos <= counter_x_map;
			ypos <= counter_y_map;
			
		end
		
		else if (spirit_caught) begin
		
		end
		
		else if (move_right) begin
		
			//Reset the flag for next use
			erase_ghost_done <= 0;
			counter_x_map <= 0;
			counter_y_map <= 0;
			memory_address_map <= 0;
			counter_x_spirit <= 0;
			counter_y_spirit <= 0;
			memory_address_spirit <= 0;

			if (xinit < 8'd150) begin
				xinit <= xinit + 1;
				xpos <= xinit;
			end
			
			valid <= 1'b1;
			
		end
		
		else if (move_left) begin
		
			//Reset the flag for next use
			erase_ghost_done <= 0;
			counter_x_map <= 0;
			counter_y_map <= 0;
			memory_address_map <= 0;
			counter_x_spirit <= 0;
			counter_y_spirit <= 0;
			memory_address_spirit <= 0;

			if (xinit > 8'd0) begin
				xinit <= xinit - 1;
				xpos <= xinit;
			end
			
			valid <= 1'b1;
			
		end
		
		else if (move_up) begin
		
			//Reset the flag for next use
			erase_ghost_done <= 0;
			counter_x_map <= 0;
			counter_y_map <= 0;
			memory_address_map <= 0;
			counter_x_spirit <= 0;
			counter_y_spirit <= 0;
			memory_address_spirit <= 0;

			if (yinit > 8'd0) begin
				yinit <= yinit - 1;
				ypos <= yinit;
			end
			
			valid <= 1'b1;
			
		end
		
		else if (move_down) begin
		
			//Reset the flag for next use
			erase_ghost_done <= 0;
			counter_x_map <= 0;
			counter_y_map <= 0;
			memory_address_map <= 0;
			counter_x_spirit <= 0;
			counter_y_spirit <= 0;
			memory_address_spirit <= 0;

			if (yinit < 8'd110) begin
				yinit <= yinit + 1;
				ypos <= yinit;
			end
			
			valid <= 1'b1;
			
		end
		
		else if (move_right2) begin
		
			//Reset the flag for next use
			erase_ghost_done <= 0;
			counter_x_map <= 0;
			counter_y_map <= 0;
			memory_address_map <= 0;
			counter_x_spirit <= 0;
			counter_y_spirit <= 0;
			memory_address_spirit <= 0;

			if (x2init < 8'd150) begin
				x2init <= x2init + 1;
				xpos <= x2init;
			end
			
			valid <= 1'b1;
			
		end
		
		else if (move_left2) begin
		
			//Reset the flag for next use
			erase_ghost_done <= 0;
			counter_x_map <= 0;
			counter_y_map <= 0;
			memory_address_map <= 0;
			counter_x_spirit <= 0;
			counter_y_spirit <= 0;
			memory_address_spirit <= 0;

			if (x2init > 8'd0) begin
				x2init <= x2init - 1;
				xpos <= x2init;
			end
			
			valid <= 1'b1;
			
		end
		
		else if (move_up2) begin
		
			//Reset the flag for next use
			erase_ghost_done <= 0;
			counter_x_map <= 0;
			counter_y_map <= 0;
			memory_address_map <= 0;
			counter_x_spirit <= 0;
			counter_y_spirit <= 0;
			memory_address_spirit <= 0;
	
			if (y2init > 8'd0) begin
				y2init <= y2init - 1;
				ypos <= y2init;
			end
			
			valid <= 1'b1;
			
		end
		
		else if (move_down2) begin
		
			//Reset the flag for next use
			erase_ghost_done <= 0;
			counter_x_map <= 0;
			counter_y_map <= 0;
			memory_address_map <= 0;
			counter_x_spirit <= 0;
			counter_y_spirit <= 0;
			memory_address_spirit <= 0;
			
			if (y2init < 8'd110) begin
				y2init <= y2init + 1;
				ypos <= y2init;
			end
			
			valid <= 1'b1;
			
		end
		
		
		
	end
	
endmodule

module dice(input clk, input rand_spirit, output reg[6:0] coordinate);
		
		reg [6:0] count = 7'd0;
		
		
		always @(posedge clk) begin
			
			if (count == 7'd60)
				count <= 7'd1;
			else
				count <= count + 7'd1;
		end
		
		always @(posedge rand_spirit) begin
			coordinate <= count;
		end
		
endmodule