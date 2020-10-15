module spaceinvaders

    (

        CLOCK_50,                        //    On Board 50 MHz

        // Your inputs and outputs here

        KEY,

        SW,
		  
		  HEX0,

        // The ports below are for the VGA output.  Do not change.

        VGA_CLK,                           //    VGA Clock

        VGA_HS,                            //    VGA H_SYNC

        VGA_VS,                            //    VGA V_SYNC

        VGA_BLANK_N,                        //    VGA BLANK

        VGA_SYNC_N,                        //    VGA SYNC

        VGA_R,                           //    VGA Red[9:0]

        VGA_G,                             //    VGA Green[9:0]

        VGA_B                           //    VGA Blue[9:0]

    );


    input            CLOCK_50;                //    50 MHz

    input   [9:0]   SW;

    input   [3:0]   KEY;
	 
	 output [6:0] HEX0;


    // Declare your inputs and outputs here

    // Do not change the following outputs

    output            VGA_CLK;                   //    VGA Clock

    output            VGA_HS;                    //    VGA H_SYNC

    output            VGA_VS;                    //    VGA V_SYNC

    output            VGA_BLANK_N;                //    VGA BLANK

    output            VGA_SYNC_N;                //    VGA SYNC

    output    [9:0]    VGA_R;                   //    VGA Red[9:0]

    output    [9:0]    VGA_G;                     //    VGA Green[9:0]

    output    [9:0]    VGA_B;                   //    VGA Blue[9:0]


    wire resetn;

    assign resetn = KEY[3];


    // Create the colour, x, y and writeEn wires that are inputs to the controller.

    wire [2:0] colour;

    wire [8:0] x;

    wire [8:0] y;

    wire writeEn;

    wire ld_player, ld_enemy, ld_enemy1, ld_enemy2, ld_enemy3, ld_enemy4, draw, draw_enemy, erase, move_l, move_r, init_bullet, shooting, ld_bullet, move_b, move_e, check;
	 
	 wire endgame;
	 
	 wire draw_board;
	 
	 wire [2:0] score_out;
	 
	 wire dead, dead1, dead2, dead3, dead4;


    // Create an Instance of a VGA controller - there can be only one!

    // Define the number of colours as well as the initial background

    // image file (.MIF) for the controller.

    vga_adapter VGA(

            .resetn(resetn),

            .clock(CLOCK_50),

            .colour(colour),

            .x(x),

            .y(y),

            .plot(writeEn),

            /* Signals for the DAC to drive the monitor. */

            .VGA_R(VGA_R),

            .VGA_G(VGA_G),

            .VGA_B(VGA_B),

            .VGA_HS(VGA_HS),

            .VGA_VS(VGA_VS),

            .VGA_BLANK(VGA_BLANK_N),

            .VGA_SYNC(VGA_SYNC_N),

            .VGA_CLK(VGA_CLK));

        defparam VGA.RESOLUTION = "160x120";

        defparam VGA.MONOCHROME = "FALSE";

        defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;

        defparam VGA.BACKGROUND_IMAGE = "black.mif";


    // Put your code here. Your code should produce signals x,y,colour and writeEn/plot

    // for the VGA controller, in addition to any other functionality your design may require.
	 
	 decoder hex(
					.VALUE(score_out),
					.HEX0(HEX0)
					
	);


    // Instansiate datapath

    datapath d0(

            .clk(CLOCK_50),

            .resetn(resetn),

            .pos(SW[6:0]),

            .ld_player(ld_player),

            .ld_enemy(ld_enemy),
				
				.ld_enemy1(ld_enemy1),
				
				.ld_enemy2(ld_enemy2),
				
				.ld_enemy3(ld_enemy3),
				
				.ld_enemy4(ld_enemy4),

            .draw(draw),
				
				.draw_enemy(draw_enemy),

            .erase(erase),
				
				.init_bullet(init_bullet),
				
				.ld_bullet(ld_bullet),

            .out_x(x),

            .out_y(y),

            .out_color(colour),
    
				.move_l(move_l),
    
				.move_r(move_r),
				
				.move_b(move_b),
				
				.move_e(move_e),
				
				.check(check),
				
				.dead(dead),
				
				.dead1(dead1),
				
				.dead2(dead2),
				
				.dead3(dead3),
				
				.dead4(dead4),
				
				.endgame(endgame),
				
				.score_out(score_out),
				
				.draw_board(draw_board)

    );


    // Instansiate FSM control

    control c0(

        .clk(CLOCK_50),

        .resetn(resetn),

        .move_left(SW[1]),

        .move_right(SW[0]),
    
			.enable(SW[9]),
			
			.shoot(SW[2]),

        .ld_player(ld_player),

        .ld_enemy(ld_enemy),
		  
		  .ld_enemy1(ld_enemy1),
				
		  .ld_enemy2(ld_enemy2),
			
		  .ld_enemy3(ld_enemy3),
				
		  .ld_enemy4(ld_enemy4),

        .draw(draw),

        .erase(erase),

        .writeEn(writeEn),
    
		  .move_l(move_l),
    
		  .move_r(move_r),
		  
		  .init_bullet(init_bullet),
		  
		  .ld_bullet(ld_bullet),
		  
		  .move_b(move_b),
		  
		  .move_e(move_e),
		  
		  .check(check),
		  
		  .draw_enemy(draw_enemy),
		  
		  .endgame(endgame),
		  
		  .dead(dead),
		  
		  .dead1(dead1),
		  
		  .dead2(dead2),
		  
		  .dead3(dead3),
		  
		  .dead4(dead4),
		  
		  .draw_board(draw_board)
		  


    );


endmodule


module datapath(

    input clk,

    input resetn,

    input [6:0] pos,

    input ld_player, ld_enemy,ld_enemy1, ld_enemy2, ld_enemy3, ld_enemy4, draw, draw_enemy, erase,move_l, move_r, init_bullet, ld_bullet, move_b, move_e, check,
	 
	 input draw_board,

    output [8:0] out_x,

    output [8:0] out_y,

    output [2:0] out_color,
	 
	 output shooting,
	 
	 output dead, dead1, dead2, dead3, dead4,
	 
	 output endgame,
	 
	 output [2:0] score_out

     );

    // input registers

    reg [8:0] reg_x;

    reg [8:0] reg_y;

    reg [2:0] reg_color;
	
	
	 // player register
	 
	 reg[8:0] player_x;
	 
	 reg[8:0] player_y;
	 
	 reg[2:0] player_color;
	 
	 
	 // enemy registers
	 
	 reg[8:0] enemy_x;
	 
	 reg[8:0] enemy_y;
	 
	 reg[2:0] enemy_color;
	 
	 reg[1:0] enemy_direction; // 00 is right,   01 is left,  11 is down 
	 
	 reg enemy_hit;
	 
	 reg enemy_hit1;
	 
	 reg enemy_hit2;
	 
	 reg enemy_hit3;
	 
	 reg enemy_hit4;
	 
	 //bullet register
	 
	 reg[8:0] bullet_x;
	 
	 reg[8:0] bullet_y;
	 
	 reg[2:0] bullet_color;
	 
	 reg bullet_shooting;
	 
	 //enemy bullet registers
	 
	 reg[8:0] enemy_bullet_x;
	 
	 reg[8:0] enemy_bullet_y;
	 
	 reg[2:0] enemy_bullet_color;
	 
	 reg enemy_bullet_shooting;
	 
	 //board register
	 
	 reg[7:0] board_counter_x;
	 reg[7:0] board_counter_y;
	
    // counters to draw shapes

    reg [1:0] counter; // first bit keeps track of position of ship where it shoots, other 3 the bottom part of the ship
	 
	 reg [4:0] enemy_draw_counter;

	

    always @ (posedge clk) begin //reset case

        if (!resetn) begin

            reg_x <= 8'd80;

            reg_y <= 8'b01110110;

            reg_color <= 3'b011;
				
				player_x <= 8'd80;
				
				player_y <= 8'b01110110;
				
				player_color <= 3'b011;
				
				enemy_x <= 8'd10;
				
				enemy_y <= 8'd10;
				
				enemy_color <= 3'b100;
				
				enemy_direction <= 2'b00; 
				
				bullet_x <= 8'd80;
				
				bullet_y <= 8'b01110110;
				
				bullet_color <= 3'b111;
				
				bullet_shooting <= 1'b0;
				
				enemy_hit <= 1'b0;
				
				enemy_hit1 <= 1'b0;
				
				enemy_hit2 <= 1'b0;
				
				enemy_hit3 <= 1'b0;
				
				enemy_hit4 <= 1'b0;
				
				counter <= 2'b00;
				
				enemy_draw_counter <= 5'b00000;
				
				enemy_bullet_x <= 8'd0;
				
				enemy_bullet_y <= 8'd0;
				
				enemy_bullet_color <= 3'b100;
				
				enemy_bullet_shooting <= 1'b0;
				
				board_counter_x <= 8'd0;
				
				board_counter_y <= 8'd0;

				end
		  
		  else begin 
		  
				if (ld_player) begin //selects player register to output register when appropriate
      
						reg_x <= player_x;
      
						reg_y <= player_y;
      
						reg_color <= player_color;

						end
				else begin
				
					if(ld_bullet && (bullet_shooting == 1'b1)) begin
					
						reg_x <= bullet_x;
						
						reg_y <= bullet_y;
						
						reg_color <= bullet_color;
						
						end
					else begin
					
						if(ld_enemy4) begin
						
							reg_x <= enemy_x+ 8'd120;
							
							reg_y <= enemy_y;
							
							reg_color <= enemy_color;
							
							end
							
						if(ld_enemy3) begin
						
							reg_x <= enemy_x+ 8'd90;
							
							reg_y <= enemy_y;
							
							reg_color <= enemy_color;
							
							end
							
						if(ld_enemy2) begin
						
							reg_x <= enemy_x+ 8'd60;
							
							reg_y <= enemy_y;
							
							reg_color <= enemy_color;
							
							end
							
						if(ld_enemy1) begin
						
							reg_x <= enemy_x + 8'd30;
							
							reg_y <= enemy_y;
							
							reg_color <= enemy_color;
							
							end
							
						if(ld_enemy) begin
						
							reg_x <= enemy_x;
							
							reg_y <= enemy_y;
							
							reg_color <= enemy_color;
							
							end

						
					
						end
				
					end

				if(init_bullet && (bullet_shooting == 1'b0)) begin //when we begin shooting, set bullet to player location
						
						bullet_x <= player_x;
						
						bullet_y <= player_y - 2'b1;
						
						bullet_shooting <= 1'b1;
						
				end
				
						
				//updates player registers as required
				
					if(move_l && (player_x > 8'd9)) begin
		
						player_x <= player_x - 8'd3;
			
						end
		
					if(move_r && (player_x < 8'd151)) begin
		
						player_x <= player_x + 8'd3;
		
						end
					// updates bullet registers as required
						
					if((move_b && (bullet_y > 8'd0)) && (bullet_shooting == 1'b1)) begin
						
						bullet_y <= bullet_y - 8'd4;
					end

					if((move_b && (bullet_y <= 8'd10)) && (bullet_shooting == 1'b1)) begin
					
						bullet_shooting <= 1'b0;
						bullet_x <= player_x;
						bullet_y <= player_y;
							
					end
						

					
					// updates enemy registers as required
					
					//if on right threshold, move down then move left.
					//if on left threshold, move down then move right.
					

					
					if(move_e && (enemy_x == 8'd30) && (enemy_direction == 2'b00)) begin
						
						enemy_y <= enemy_y + 8'd2;
						enemy_direction <= 2'b01;
						
						//if(enemy_bullet_shooting == 1'b0)
							
						//	enemy_bullet_shooting <= 1'b1;
					
						end
					else begin
						
					if(move_e && ((enemy_x == 8'd10) && (enemy_direction == 2'b01))) begin
						
						enemy_y <= enemy_y + 1'b1;
						enemy_direction <= 2'b00;
					
					end
					
					else begin
						if(move_e && (enemy_direction == 2'b00)) begin
						
							enemy_x <= enemy_x + 1'b1;
							end
						else begin
							if(move_e && (enemy_direction == 2'b01))begin
							
								enemy_x <= enemy_x - 1'b1;
							
							end
							end

					
						end
					end
						
						
					if(draw) begin // draws the shape of the player, requires draw to be high for 4 clk cycles.
						
						if(counter == 2'b00) begin
						
						reg_x <= reg_x - 1'b1;
						reg_y <= reg_y + 1'b1;
						counter <= counter+1'b1;
						
						end
						
						else begin
						
						if(counter == 2'b11) begin
						reg_x <= reg_x + 1'b1;
						reg_y <= reg_y;
						counter <= 2'b00;
						
						end
						
						else begin
						
						reg_x<= reg_x +1'b1;
						counter<= counter+1'b1;
						end
						
						end

					end
					
					
					if(draw_enemy) begin
						
						if( (5'b01110 > enemy_draw_counter) &&   (enemy_draw_counter != 5'b00010) && (enemy_draw_counter != 5'b00111))begin
							
							reg_x <= reg_x +1'b1;
							enemy_draw_counter <= enemy_draw_counter + 1'b1;
						
						end
						
						else begin
						
							if(enemy_draw_counter == 5'b00010) begin
								
								reg_y <= reg_y + 1'b1;
								reg_x<= reg_x - 8'd3;
								enemy_draw_counter <= enemy_draw_counter + 1'b1;
							
							end
							
							if(enemy_draw_counter == 5'b00111) begin
								
								reg_y <= reg_y + 1'b1;
								reg_x <= reg_x - 8'd5;
								enemy_draw_counter <= enemy_draw_counter + 1'b1;
							
							end
							
							if(enemy_draw_counter == 5'b10000) begin
								reg_x <= reg_x - 8'd3;
								reg_y <= reg_y - 8'd3;
								enemy_draw_counter <= 5'b00000;
								
							end
							
							if(enemy_draw_counter == 5'b01111) begin
							
								reg_x <= reg_x + 8'd4;
								enemy_draw_counter <= enemy_draw_counter + 1'b1;
							
							end
							
							if(enemy_draw_counter == 5'b01110) begin
								
								reg_y <= reg_y + 1'b1;
								reg_x <= reg_x - 8'd5;
								enemy_draw_counter <= enemy_draw_counter + 1'b1;
							end
							
							
							
							
							
						end
					
					
					end
				
						
		end
		
		if(check && (bullet_shooting == 1'b1)) begin
			
			if((bullet_x >= enemy_x - 8'd2) && (enemy_x + 8'd4 >= bullet_x) && (bullet_y >= enemy_y) && (enemy_y + 8'd3 >= bullet_y) && (enemy_hit == 1'b0)) begin
			
					enemy_hit <= 1'b1;
					
					bullet_shooting <= 1'b0;
			
			end
			
			if((bullet_x >= enemy_x + 8'd28) && (enemy_x + 8'd34 >= bullet_x) && (bullet_y >= enemy_y) && (enemy_y + 8'd3 >= bullet_y) && (enemy_hit1 == 1'b0)) begin
			
					enemy_hit1 <= 1'b1;
					
					bullet_shooting <= 1'b0;
			
			end
			
			if((bullet_x >= enemy_x + 8'd58) && (enemy_x + 8'd64 >= bullet_x) && (bullet_y >= enemy_y) && (enemy_y + 8'd3 >= bullet_y) && (enemy_hit2 == 1'b0)) begin
			
					enemy_hit2 <= 1'b1;
					
					bullet_shooting <= 1'b0;
			
			end
			
			if((bullet_x >= enemy_x + 8'd88) && (enemy_x + 8'd94 >= bullet_x) && (bullet_y >= enemy_y) && (enemy_y + 8'd3 >= bullet_y) && (enemy_hit3 == 1'b0)) begin
			
					enemy_hit3 <= 1'b1;
					
					bullet_shooting <= 1'b0;
			
			end
			
			if((bullet_x >= enemy_x + 8'd118) && (enemy_x + 8'd124 >= bullet_x) && (bullet_y >= enemy_y) && (enemy_y + 8'd3 >= bullet_y) && (enemy_hit4 == 1'b0)) begin
			
					enemy_hit4 <= 1'b1;
					
					bullet_shooting <= 1'b0;
			
			end
			

			
		
		end
		
		if(draw_board) begin
		
			if(8'd160 > board_counter_x) begin
			
				reg_x <= reg_x +1'b1;
				board_counter_x <= board_counter_x + 1'b1;
			
			end
		
			else begin
			
				reg_x <= 8'd0;
				reg_y <= reg_y + 1'b1;
				board_counter_x <= 8'd0;
		
			end
		
		end
		



		if (erase)

				reg_color <= 3'b000;		  
		  
		  
		end
	
	 assign score_out = enemy_hit + enemy_hit1 + enemy_hit2 + enemy_hit3 + enemy_hit4;
	
	 assign dead = enemy_hit;
	 
	 assign dead1 = enemy_hit1;
	 
	 assign dead2 = enemy_hit2;
	 
	 assign dead3 = enemy_hit3;
	  
	 assign dead4 = enemy_hit4;
	 
	 assign endgame = (enemy_hit && enemy_hit1 && enemy_hit2 && enemy_hit3 && enemy_hit4);
	
	 assign shooting = bullet_shooting;

    assign out_x = reg_x;

    assign out_y = reg_y;

    assign out_color = reg_color;


endmodule


module control(

		input clk,

		input resetn,
  
		input move_left,
  
		input move_right,
  
		input enable,
		
		input shoot,
		
		input shooting,
		
		input dead,
		
		input dead1,
		
		input dead2,
		
		input dead3,
		
		input dead4,
		
		input endgame,


		output reg ld_player, ld_enemy, ld_enemy1, ld_enemy2, ld_enemy3, ld_enemy4, draw, draw_enemy, erase, writeEn, move_l, move_r, init_bullet, ld_bullet, move_b, move_e, check,
		
		output reg draw_board

    );
	 
	 
	reg start_frame;
	
	reg reset_enemy, enable_enemy;
	
	reg enable_board;
	
	wire delay_out, frame_out, next, start;
  
	frame_counter f0(delay_out, clk, resetn, enable);
	
	enemy_counter e0(next, clk, reset_enemy, enable_enemy);
	
	board_counter b0(start, clk, resetn, enable_board);
  
	//delay_counter c0(delay_out, frame_out, resetn, start_frame);


    reg [6:0] current_state, next_state;
	 

	


    localparam ERASE_BOARD = 7'd79,
	 
					S_LOAD_INIT = 7'd0,

               S_DRAW_INIT = 7'd1,
										
					S_LOAD_ENEMY = 7'd24,
					
					S_DRAW_ENEMY = 7'd25,
					
					S_LOAD_ENEMY1 = 7'd34,
					
					S_DRAW_ENEMY1 = 7'd35,
					
					S_LOAD_ENEMY2 = 7'd36,
					
					S_DRAW_ENEMY2 = 7'd37,
					
					S_LOAD_ENEMY3 = 7'd38,
					
					S_DRAW_ENEMY3 = 7'd39,
					
					S_LOAD_ENEMY4 = 7'd40,
					
					S_DRAW_ENEMY4 = 7'd41,
					
					WAIT = 7'd2,  //signifies the start of the game cycle, no enable cycles in order to improve clarity
     
					MOVE_L = 7'd3,
     
					MOVE_R = 7'd4,
     
					ERASE = 7'd5,
     
					DRAW_ERASE = 7'd6,
					
					LOAD_PLAYER = 7'd7,
					
					DRAW_PLAYER = 7'd8,
					
					S_DRAW_INIT1 = 7'd9,
					
					S_DRAW_INIT2 = 7'd10,
					
					S_DRAW_INIT3 = 7'd11,
					
					DRAW_ERASE1 = 7'd12,
					
					DRAW_ERASE2 = 7'd13,
					
					DRAW_ERASE3 = 7'd14,
					
					DRAW_PLAYER1 = 7'd15,
					
					DRAW_PLAYER2 = 7'd16,
					
					DRAW_PLAYER3 = 7'd17,
					
					INIT_BULLET = 7'd18,
					
					LOAD_BULLET = 7'd19,
					
					DRAW_BULLET = 7'd20,
					
					ERASE_BULLET = 7'd21,
					
					DRAW_ERASE_BULLET = 7'd22,
					
					MOVE_BULLET = 7'd23,
					
					ERASE_ENEMY = 7'd26,
					
					DRAW_ERASE_ENEMY = 7'd27,
					
					ERASE_ENEMY1 = 7'd42,
					
					DRAW_ERASE_ENEMY1 = 7'd43,
					
					ERASE_ENEMY2 = 7'd44,
					
					DRAW_ERASE_ENEMY2 = 7'd45,
					
					ERASE_ENEMY3 = 7'd46,
					
					DRAW_ERASE_ENEMY3 = 7'd47,
					
					ERASE_ENEMY4 = 7'd48,
					
					DRAW_ERASE_ENEMY4 = 6'd49,
					
					MOVE_ENEMY = 7'd28,
					
					LOAD_ENEMY = 7'd29,
					
					DRAW_ENEMY = 7'd30,
					
					LOAD_ENEMY1 = 7'd50,
					
					DRAW_ENEMY1 = 7'd51,
					
					LOAD_ENEMY2 = 7'd52,
					
					DRAW_ENEMY2 = 7'd53,
					
					LOAD_ENEMY3 = 7'd54,
					
					DRAW_ENEMY3 = 7'd55,
					
					LOAD_ENEMY4 = 7'd56,
					
					DRAW_ENEMY4 = 7'd57,
					
					CHECK = 7'd31,
					
					START = 7'd32,
					
					LOAD_ERASE_BULLET = 7'd33,
					
					ENDGAME = 7'd58,
					
					ERASE_ENEMY_BULLET = 7'd59,
					
					ERASE_DRAW_ENEMY_BULLET = 7'd60,
					
					ERASE_ENEMY_BULLET1 = 7'd61,
					
					ERASE_DRAW_ENEMY_BULLET1 = 7'd62,
					
					ERASE_ENEMY_BULLET2 = 7'd63,
					
					ERASE_DRAW_ENEMY_BULLET2 = 7'd64,
					
					ERASE_ENEMY_BULLET3 = 7'd65,
					
					ERASE_DRAW_ENEMY_BULLET3 = 7'd66,
					
					ERASE_ENEMY_BULLET4 = 7'd67,
					
					ERASE_DRAW_ENEMY_BULLET4 = 7'd68,
					
					LOAD_ENEMY_BULLET = 7'd69,
						
					DRAW_ENEMY_BULLET = 7'd70,
					
					LOAD_ENEMY_BULLET1 = 7'd71,
						
					DRAW_ENEMY_BULLET1 = 7'd72,
					
					LOAD_ENEMY_BULLET2 = 7'd73,
						
					DRAW_ENEMY_BULLET2 = 7'd74,
					
					LOAD_ENEMY_BULLET3 = 7'd75,
						
					DRAW_ENEMY_BULLET3 = 7'd76,
					
					LOAD_ENEMY_BULLET4 = 7'd77,
					
					DRAW_ENEMY_BULLET4 = 7'd78;


    // state table

    always@(*)

    begin: state_table

            case (current_state)
    
				ERASE_BOARD: next_state = (start)?S_LOAD_INIT : ERASE_BOARD;
				
				START: next_state = S_LOAD_INIT;
				
				S_LOAD_INIT: next_state = S_DRAW_INIT;
     
				S_DRAW_INIT: next_state = S_DRAW_INIT1;  
				
				S_DRAW_INIT1: next_state = S_DRAW_INIT2;  
				
				S_DRAW_INIT2: next_state = S_DRAW_INIT3;  
				
				S_DRAW_INIT3: next_state = S_LOAD_ENEMY;
				
				
				
				
				S_LOAD_ENEMY: next_state = S_DRAW_ENEMY;
				
				S_DRAW_ENEMY: next_state = (next)?S_LOAD_ENEMY1 : S_DRAW_ENEMY;
				
				S_LOAD_ENEMY1: next_state = S_DRAW_ENEMY1;
				
				S_DRAW_ENEMY1: next_state = (next)?S_LOAD_ENEMY2 : S_DRAW_ENEMY1;
				
				S_LOAD_ENEMY2: next_state = S_DRAW_ENEMY2;
				
				S_DRAW_ENEMY2: next_state = (next)?S_LOAD_ENEMY3: S_DRAW_ENEMY2;
				
				S_LOAD_ENEMY3: next_state = S_DRAW_ENEMY3;
				
				S_DRAW_ENEMY3: next_state = (next)?S_LOAD_ENEMY4 : S_DRAW_ENEMY3;
				
				S_LOAD_ENEMY4: next_state = S_DRAW_ENEMY4;
				
				S_DRAW_ENEMY4: next_state = (next)?WAIT: S_DRAW_ENEMY4;
				
				
				
     
				WAIT:next_state = ERASE;
     
				ERASE: next_state = (delay_out)? DRAW_ERASE : ERASE;
				
				DRAW_ERASE: next_state = DRAW_ERASE1;
				
				DRAW_ERASE1: next_state = DRAW_ERASE2;
				
				DRAW_ERASE2: next_state = DRAW_ERASE3;

				DRAW_ERASE3: begin
					
					next_state = LOAD_PLAYER;
     
					if(move_left)
       
						next_state = MOVE_L;
         
       
					else if(move_right)
       
						next_state = MOVE_R;
					
					else if(shoot)
					
						next_state = INIT_BULLET;
					


					end
					
				INIT_BULLET: next_state = LOAD_PLAYER;
     
				MOVE_L: next_state = LOAD_PLAYER;
     
				MOVE_R: next_state = LOAD_PLAYER;
				
				LOAD_PLAYER : next_state = DRAW_PLAYER;
				
				DRAW_PLAYER : next_state = DRAW_PLAYER1;
				
				DRAW_PLAYER1 : next_state = DRAW_PLAYER2;
				
				DRAW_PLAYER2 : next_state = DRAW_PLAYER3;
				
				DRAW_PLAYER3 : next_state = LOAD_ERASE_BULLET;
				
				LOAD_ERASE_BULLET : next_state = ERASE_BULLET;
				
				ERASE_BULLET:  next_state = DRAW_ERASE_BULLET;
				
				DRAW_ERASE_BULLET: next_state = MOVE_BULLET;
				
				MOVE_BULLET: next_state = LOAD_BULLET;
				
				LOAD_BULLET: next_state = DRAW_BULLET;
				
				DRAW_BULLET: next_state = ERASE_ENEMY;
				
				
				
				ERASE_ENEMY: next_state = DRAW_ERASE_ENEMY;
					
				DRAW_ERASE_ENEMY: next_state = (next)?ERASE_ENEMY1 : DRAW_ERASE_ENEMY;
				
				ERASE_ENEMY1: next_state = DRAW_ERASE_ENEMY1;
					
				DRAW_ERASE_ENEMY1: next_state = (next)?ERASE_ENEMY2 : DRAW_ERASE_ENEMY1;
				
				ERASE_ENEMY2: next_state = DRAW_ERASE_ENEMY2;
					
				DRAW_ERASE_ENEMY2: next_state = (next)?ERASE_ENEMY3 : DRAW_ERASE_ENEMY2;
				
				ERASE_ENEMY3: next_state = DRAW_ERASE_ENEMY3;
					
				DRAW_ERASE_ENEMY3: next_state = (next)?ERASE_ENEMY4 : DRAW_ERASE_ENEMY3;
				
				ERASE_ENEMY4: next_state = DRAW_ERASE_ENEMY4;
					
				DRAW_ERASE_ENEMY4: next_state = (next)?MOVE_ENEMY : DRAW_ERASE_ENEMY4;
				
				
				
					
				MOVE_ENEMY: next_state = LOAD_ENEMY;
				
				
				
					
				LOAD_ENEMY: next_state = (dead != 1'b1)?DRAW_ENEMY: LOAD_ENEMY1;
				
				DRAW_ENEMY: next_state = (next)?LOAD_ENEMY1 : DRAW_ENEMY;
				
				LOAD_ENEMY1: next_state = (dead1!= 1'b1)?DRAW_ENEMY1 : LOAD_ENEMY2;
				
				DRAW_ENEMY1: next_state = (next)?LOAD_ENEMY2 : DRAW_ENEMY1;
				
				LOAD_ENEMY2: next_state = (dead2 != 1'b1)?DRAW_ENEMY2 : LOAD_ENEMY3;
				
				DRAW_ENEMY2: next_state = (next)?LOAD_ENEMY3: DRAW_ENEMY2;
				
				LOAD_ENEMY3: next_state = (dead3 != 1'b1)?DRAW_ENEMY3 : LOAD_ENEMY4;
				
				DRAW_ENEMY3: next_state = (next)?LOAD_ENEMY4 : DRAW_ENEMY3;
				
				LOAD_ENEMY4: next_state = (dead4 != 1'b1)?DRAW_ENEMY4 : CHECK;
				
				DRAW_ENEMY4: next_state = (next)?CHECK: DRAW_ENEMY4;
				
				
				
					
				CHECK: next_state = (!endgame)?WAIT : ENDGAME;
				
				ENDGAME: next_state = ENDGAME;
				

				default: next_state = ERASE_BOARD;   

				endcase

    end // state_table


    always @(*)

    begin: enable_signals

        // By default make all our signals 0

        ld_player = 1'b0;

        ld_enemy = 1'b0;
		  
		  ld_enemy1 = 1'b0;

		  ld_enemy2 = 1'b0;

		  ld_enemy3 = 1'b0;

		  ld_enemy4 = 1'b0;

        draw = 1'b0; //draws shape for player
		  
		  draw_enemy = 1'b0; //draws shape for the enemy

        erase = 1'b0; //deletes color (i.e makes it black) when high

        writeEn  = 1'b0; //plots in the VGA
    
		  move_l = 1'b0;
    
		  move_r = 1'b0;
		  
		  start_frame = 1'b0; // enable for 16/60 s delay before erasing and redrawing
		  
		  init_bullet = 1'b0;
		  
		  ld_bullet = 1'b0;
		  
		  move_b = 1'b0;
		  
		  move_e = 1'b0;
		  
		  reset_enemy = 1'b0;
		  
		  enable_enemy = 1'b0;
		  
		  check = 1'b0;
		  
		  draw_board = 1'b0;
		  
		  enable_board = 1'b0;


        case (current_state)

            S_LOAD_INIT: begin

					ld_player = 1'b1;

					end


            S_DRAW_INIT: begin

                draw = 1'b1;

                writeEn = 1'b1;

					end
					
				S_DRAW_INIT1: begin

                draw = 1'b1;

                writeEn = 1'b1;

					end
					
				
				S_DRAW_INIT2: begin

                draw = 1'b1;

                writeEn = 1'b1;

					end
					
				S_DRAW_INIT3: begin

                draw = 1'b1;

                writeEn = 1'b1;

					end
					
					
					
					
					
					
				S_LOAD_ENEMY: begin
					
					ld_enemy = 1'b1;
					
					reset_enemy = 1'b1;
					

				
					end
					
				S_DRAW_ENEMY: begin
					
					draw_enemy = 1'b1;
				
					writeEn = 1'b1;
					
					enable_enemy =1'b1;
					

				
					end
					
				S_LOAD_ENEMY1: begin
					
					ld_enemy1 = 1'b1;
					
					reset_enemy = 1'b1;
					
				
					end
					
				S_DRAW_ENEMY1: begin
					
					draw_enemy = 1'b1;
				
					writeEn = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
				S_LOAD_ENEMY2: begin
					
					ld_enemy2 = 1'b1;
					
					reset_enemy = 1'b1;
				
					end
					
				S_DRAW_ENEMY2: begin
					
					draw_enemy = 1'b1;
				
					writeEn = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
				S_LOAD_ENEMY3: begin
					
					ld_enemy3 = 1'b1;
					
					reset_enemy = 1'b1;
				
					end
					
				S_DRAW_ENEMY3: begin
					
					draw_enemy = 1'b1;
				
					writeEn = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
				S_LOAD_ENEMY4: begin
					
					ld_enemy4 = 1'b1;
					
					reset_enemy = 1'b1;
				
					end
					
				S_DRAW_ENEMY4: begin
					
					draw_enemy = 1'b1;
				
					writeEn = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
					
					
					
					
					
					
    
				ERASE: begin
				
					start_frame = 1'b1;
					
    				ld_player = 1'b1;
					
					erase = 1'b1;

					end
    
				DRAW_ERASE: begin
     
					draw = 1'b1;
     
					writeEn = 1'b1;
     
					end 
				
				DRAW_ERASE1: begin
     
					draw = 1'b1;
     
					writeEn = 1'b1;
     
					end 
				
				DRAW_ERASE2: begin
     
					draw = 1'b1;
     
					writeEn = 1'b1;
     
					end 
				
				DRAW_ERASE3: begin
     
					draw = 1'b1;
     
					writeEn = 1'b1;
     
					end 
    
				MOVE_L: begin 
     
					move_l = 1'b1;

					end
    
				MOVE_R: begin 
     
					move_r = 1'b1;
     
					end
					
				INIT_BULLET: begin
					
					init_bullet = 1'b1;
					
					end
				
				LOAD_PLAYER: begin
					
					ld_player = 1'b1;
					
					end
				
				DRAW_PLAYER: begin
				
					draw = 1'b1;
					
					writeEn = 1'b1;
					
					end
					
				DRAW_PLAYER1: begin
				
					draw = 1'b1;
					
					writeEn = 1'b1;
					
					end
					
				DRAW_PLAYER2: begin
				
					draw = 1'b1;
					
					writeEn = 1'b1;
					
					end
					
				DRAW_PLAYER3: begin
				
					draw = 1'b1;
					
					writeEn = 1'b1;
					
					end
				
				LOAD_ERASE_BULLET: begin
				
					//writeEn = 1'b1;
				
					ld_bullet = 1'b1;
				
					end
					
				ERASE_BULLET: begin
					
					ld_bullet = 1'b1;
					
					erase = 1'b1;
					
					end
					
				DRAW_ERASE_BULLET: begin
					
					writeEn = 1'b1;
					
					end
					
				MOVE_BULLET: begin
					
					move_b = 1'b1;
					
					end
					
				LOAD_BULLET: begin
					
					ld_bullet = 1'b1;
					
					end
					
				DRAW_BULLET: begin
					
					writeEn = 1'b1;
					
				end
				
				
				
				
				
				
				
				
				
				
				ERASE_ENEMY: begin
					
					ld_enemy = 1'b1;
					
					reset_enemy = 1'b1;
					
					erase = 1'b1;
				
					end
					
				DRAW_ERASE_ENEMY: begin
					
					writeEn = 1'b1;
					
					draw_enemy = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
				
				ERASE_ENEMY1: begin
					
					ld_enemy1 = 1'b1;
					
					reset_enemy = 1'b1;
					
					erase = 1'b1;
				
					end
					
				DRAW_ERASE_ENEMY1: begin
					
					writeEn = 1'b1;
					
					draw_enemy = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
				ERASE_ENEMY2: begin
					
					ld_enemy2 = 1'b1;
					
					reset_enemy = 1'b1;
					
					erase = 1'b1;
				
					end
					
				DRAW_ERASE_ENEMY2: begin
					
					writeEn = 1'b1;
					
					draw_enemy = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
				ERASE_ENEMY3: begin
					
					ld_enemy3 = 1'b1;
					
					reset_enemy = 1'b1;
					
					erase = 1'b1;
				
					end
					
				DRAW_ERASE_ENEMY3: begin
					
					writeEn = 1'b1;
					
					draw_enemy = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
				ERASE_ENEMY4: begin
					
					ld_enemy4 = 1'b1;
					
					reset_enemy = 1'b1;
					
					erase = 1'b1;
				
					end
					
				DRAW_ERASE_ENEMY4: begin
					
					writeEn = 1'b1;
					
					draw_enemy = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
					
					
					
					
					
					
					
					
				
					
				MOVE_ENEMY: begin
					
					move_e = 1'b1;
				
					end
					
					
					
					
					
					
					
					
					
					
					
					
				LOAD_ENEMY: begin
					
					reset_enemy = 1'b1;
					
					ld_enemy = 1'b1;
					
					end
					
				DRAW_ENEMY: begin
					
					writeEn = 1'b1;
					
					draw_enemy = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
				
				LOAD_ENEMY1: begin
					
					ld_enemy1 = 1'b1;
					
					reset_enemy = 1'b1;
				
					end
					
				DRAW_ENEMY1: begin
					
					draw_enemy = 1'b1;
				
					writeEn = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
				LOAD_ENEMY2: begin
					
					ld_enemy2 = 1'b1;
					
					reset_enemy = 1'b1;
				
					end
					
				DRAW_ENEMY2: begin
					
					draw_enemy = 1'b1;
				
					writeEn = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
				LOAD_ENEMY3: begin
					
					ld_enemy3 = 1'b1;
					
					reset_enemy = 1'b1;
				
					end
					
				DRAW_ENEMY3: begin
					
					draw_enemy = 1'b1;
				
					writeEn = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
				LOAD_ENEMY4: begin
					
					ld_enemy4 = 1'b1;
					
					reset_enemy = 1'b1;
				
					end
					
				DRAW_ENEMY4: begin
					
					draw_enemy = 1'b1;
				
					writeEn = 1'b1;
					
					enable_enemy = 1'b1;
				
					end
					
					
					
					
					
					
				CHECK: begin
					
					check = 1'b1;
				
					end
					
					
				ERASE_BOARD: begin
				
					enable_board = 1'b1;
				
					draw_board = 1'b1;
					
					erase = 1'b1;
					
					writeEn = 1'b1;
					
				
					end

        endcase

    end // enable_signals


    // current_state registers

    always@(posedge clk)

    begin: state_FFs

        if(!resetn)

            current_state <= ERASE_BOARD;

        else

            current_state <= next_state;

    end // state_FFS

endmodule




module frame_counter(output out, input clk, input resetn, input enable);


 reg[22:0] q;
 

 always@(posedge clk)
 
  begin 
  
    if(!resetn)
	 
     q<= 23'b10111110101111000010000; //500000000/60 = 800
     
    else if(enable== 1'b1)
    
	 
    begin
	 
      if(q == 23'd0)
		
        q<= 23'b10111110101111000010000;
		  
      else
		
        q<= q-1'b1;
		  
    end
	 
  end
  
  assign out = (q== 23'b000000000000000000000000)? 1'b1 : 1'b0;
  
endmodule


module enemy_counter(output next, input clk, input resetn, input enable);
	
	reg[4:0] q;
	
	always @ (posedge clk) begin
		
		if(resetn) begin
			q<= 5'b00000;
		
		end
		
		else begin
			
			if(enable == 1'b1) begin
			
				q <= q +1'b1;
			
			end
		
		end
	
	end
	
	assign next = (q == 5'b10000)? 1'b1 : 1'b0;

endmodule


module board_counter(output start, input clk, input resetn, input enable);
	
	reg[14:0] q;
	
	always @ (posedge clk) begin
		
		if(!resetn) begin
			q<= 15'b0000000000000000;
		
		end
		
		else begin
			
			if(enable == 1'b1) begin
			
				q <= q +1'b1;
			
			end
		
		end
	
	end
	
	assign start = (q == 15'b110010000000000)? 1'b1 : 1'b0;
	


endmodule



module decoder(HEX0,VALUE);

    input [8:0] VALUE;
    output [6:0] HEX0;

    segment0 a(
    .c0(VALUE[0]),
    .c1(VALUE[1]),
    .c2(VALUE[2]),
    .c3(VALUE[3]),
    .h0(HEX0[0])
    );

    segment1 b(
    .c0(VALUE[0]),
    .c1(VALUE[1]),
    .c2(VALUE[2]),
    .c3(VALUE[3]),
    .h1(HEX0[1])
    );

    segment2 c(
    .c0(VALUE[0]),
    .c1(VALUE[1]),
    .c2(VALUE[2]),
    .c3(VALUE[3]),
    .h2(HEX0[2])
    );

    segment3 d(
    .c0(VALUE[0]),
    .c1(VALUE[1]),
    .c2(VALUE[2]),
    .c3(VALUE[3]),
    .h3(HEX0[3])
    );

    segment4 e(
    .c0(VALUE[0]),
    .c1(VALUE[1]),
    .c2(VALUE[2]),
    .c3(VALUE[3]),
    .h4(HEX0[4])
    );

    segment5 f(
    .c0(VALUE[0]),
    .c1(VALUE[1]),
    .c2(VALUE[2]),
    .c3(VALUE[3]),
    .h5(HEX0[5])
    );

    segment6 g(
    .c0(VALUE[0]),
    .c1(VALUE[1]),
    .c2(VALUE[2]),
    .c3(VALUE[3]),
    .h6(HEX0[6])
    );

endmodule


module segment0(c0, c1, c2, c3, h0);

    input c0; 
    input c1; 
    input c2; 
    input c3;
    output h0; 
    assign h0 = ~c1&c0&~c3&~c2|~c1&~c0&~c3&c2|~c1&c0&c3&c2|c1&c0&c3&~c2;

endmodule

module segment1(c0, c1, c2, c3, h1);

    input c0; 
    input c1; 
    input c2; 
    input c3;
    output h1; 
    assign h1 = ~c1&c0&~c3&c2|c1&~c0&c2|c1&c0&c3|~c0&c3&c2;

endmodule

module segment2(c0, c1, c2, c3, h2);

    input c0; 
    input c1; 
    input c2; 
    input c3;
    output h2; 
    assign h2 = c1&~c0&~c3&~c2|c1&c3&c2|~c0&c3&c2;

endmodule

module segment3(c0, c1, c2, c3, h3);

    input c0; 
    input c1; 
    input c2; 
    input c3;
    output h3; 
    assign h3 = ~c1&c0&~c2|c1&c0&c2|~c1&~c0&~c3&c2|~c0&c1&c3&~c2;

endmodule

module segment4(c0, c1, c2, c3, h4);

    input c0; 
    input c1; 
    input c2; 
    input c3;
    output h4; 
    assign h4 = ~c3&c2&~c1|~c3&c0&~c2|~c2&c0&~c1|c0&c1&~c3;

endmodule

module segment5(c0, c1, c2, c3, h5);

    input c0; 
    input c1; 
    input c2; 
    input c3;
    output h5; 
    assign h5 = c0&~c3&~c2|c1&~c3&~c2|c1&c0&~c3|c0&~c1&c3&c2;

endmodule

module segment6(c0, c1, c2, c3, h6);

    input c0; 
    input c1; 
    input c2; 
    input c3;
    output h6; 
    assign h6 = c3&c2&~c1&~c0|~c1&~c3&~c2|c1&c0&~c3&c2;

endmodule

////module delay_counter(output out, input clk, input resetn, input enable);
////
// reg[3:0] q;
//  
//  always@(posedge clk)
//  
//   begin
//   
//    if(!resetn)
//    
//     q<= 4'b1111;
//     
//    else if (enable == 1'b1)
//     begin
//       if (q == 4'b0000)
//       
//         q<= 4'b1111;
//         
//       else
//         q<= q-1'b1;
//     end
//     
//   end
//   
//   assign out = (q== 4'b0000)? 1'b1 : 1'b0;
//   
//endmodule
