// Part 2 skeleton

module display
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  		//	VGA Blue[9:0]
		LEDR,
		HEX0,
		HEX1,
		HEX2,
		HEX3
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;
	output[6:0] HEX0;
	output[6:0] HEX1;
	output[6:0] HEX2;
	output[6:0] HEX3;
	
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	output [17:0] LEDR;
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	reg [2:0] colour;
	reg [2:0] colour2;
	reg [7:0] x ;
	reg [6:0] y;
	
	reg [7:0] a;
	reg [6:0] b;
	
	wire [7:0] allowed;
	wire [2:0] out_colour;
	wire [2:0] out_colour2;
	wire [7:0] out_x;
	reg [6:0] out_y1 = 7'b0000000;
	reg [6:0] out_y2 = 7'b0000000;
	reg plotPlayer = 1'b0;
	reg plotSig;
	wire clock = CLOCK_50;
	reg leftMove = 1'b0;
	reg middleMove = 1'b0;
	reg rightMove = 1'b0;
	reg blackOut = 1'b0;
	reg drawPlayer;
	reg [15:0] score = 16'd0;
	reg [19:0]scoreCounter = 20'd0;
	reg createCar;
	reg createCarCounter = 4'd0;
	
	reg [3:0] score1 = 4'd0;
	reg [3:0] score2 = 4'd0;
	reg [3:0] score3 = 4'd0;
	reg [3:0] score4 = 4'd0;
	
	reg score1Add = 1'd1;
	reg score2Add = 1'd1;
	reg score3Add = 1'd1;
	reg score4Add = 1'd1;
	
	reg speed1 = 1'b0;
	reg speed2 = 1'b0;
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y), 
			.plot(plotSig),
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
    
    // Instansiate datapath
	// datapath d0(...);
		/*datapath d0(
		.clk3(KEY[3]),
		.clk1(KEY[1]),
		.resetn(resetn),
		//input ld_x, ld_y, ld_colour,
		.data_in(SW[9:0]),
		.out_colour(colour),
		.out_x(x),
		.out_y(y)
	);*/
    
	 
	 // Instansiate FSM control
    // control c0(...);
    /*control c0(
		.clk(KEY[1]),
		.resetn(resetn),
		.x(x),
		.y(y),
		.colour(colour),
		.ld_alu_out_colour1(out_colour1),
		.ld_alu_out_colour2(out_colour2),
	    .ld_alu_out_x(out_x),
		.ld_alu_out_y(out_y)
	);*/
/*
	
	always@(*) begin
		
		if(plotPlayer == 1'b0) begin
			b <= 7'd100;
			a <= 8'd80;
			colour2 <= 3'b001;
			plotPlayer <= 1'b1;
			/////
			speed1 <= 1'b1;
			speed2 <= 1'b1;
			/////
			
			
		end
		else if(blackOut) begin
			colour2 <= 3'b000;
			blackOut <= 1'b0;
		end
		
		else if(!KEY[1] || rightMove)begin
			if(a == 8'd80) begin
				
				if(rightMove)begin
					colour2 <= 3'b001;
					a <= 8'd130;
					rightMove <= 1'b0;
				end
				else begin
					blackOut <= 1'b1;
					rightMove <= 1'b1;
					drawPlayer
				end
			end
			else if(a == 8'd30) begin
				
				if(rightMove)begin
					colour2 <= 3'b001;
					a <= 8'd80;
					rightMove <= 1'b0;
				end
				else begin
					blackOut <= 1'b1;
					rightMove <= 1'b1;
				end
			end
		end
		
		else if(!KEY[3] || leftMove)begin
			if(a == 8'd80) begin
				
				if(leftMove)begin
					colour2 <= 3'b001;
					a <= 8'd30;
					leftMove <= 1'b0;
				end
				else begin
					blackOut <= 1'b1;
					leftMove <= 1'b1;
				end

			end
			else if(a == 8'd130) begin
				
				if(leftMove)begin
					colour2 <= 3'b001;
					a <= 8'd80;
					leftMove <= 1'b0;
				end
				else begin
					
					blackOut <= 1'b1;
					leftMove <= 1'b1;
				end
			end
		end
	end
	
	
	
	*/
	wire [27:0] rd3_out;
	reg Enable;
	wire [3:0] dc0_out;
	
	//RateDivider rd1(CLOCK_50, rd3_out, speed1, 1'b1, 28'b1011111010111100000111111111, 1);
	always@(posedge CLOCK_50) begin	
		//Enable = (rd3_out == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;
		if (scoreCounter != 20'd500000) begin
			scoreCounter <= scoreCounter + 20'd1;
			end
		else begin
			
			//score <= score + 16'd1;
			scoreCounter <= 20'd0;
			
			if(score4 == 4'b1001)begin
				score4Add <= 1'b0;
				end
			if(score3 == 4'b1001 && score4Add == 1'b0)begin
				score3Add <= 1'b0;
				end
			if(score2 == 4'b1001 && score3Add == 1'b0 && score4Add == 1'b0)begin
				score2Add <= 1'b0;
				end
			if(score1 == 4'b1001 && score2Add == 1'b0 && score3Add == 1'b0 && score4Add == 1'b0)begin
				score1Add <= 1'b0;
				score1 <= 4'b1001;
				end
			else if(score1Add)begin
				score1 <= score1 + 4'd1;
			end
			
			if(score1 == 4'b1010 && score2Add)begin
				score2 <= score2 + 4'd1;
				score1 <= 4'd0;
				end
			if(score2 == 4'b1010 && score3Add)begin
				score3 <= score3 + 4'd1;
				score2 <= 4'd0;
				end
			if(score3 == 4'b1010 && score4Add)begin
				score4 <= score4 + 4'd1;
				score3 <= 4'd0;
				end
		end
		
	end
	//DisplayCounter dc0(CLOCK_50, dc0_out, 1'b1, Enable);
	hex_decoder(score1,HEX0);
	
	hex_decoder(score2,HEX1);
	
	hex_decoder(score3,HEX2);
	
	hex_decoder(score4,HEX3);
	
	

	
	
	
	always@(posedge clock) begin
		/*begin
			RateDivider rd1(CLOCK_50, clock, speed1, 1'b1, 28'b1011111010111100000111111111, speed2);
		end*/
		if(out_y1 <= 7'd120) begin
			plotSig <= 1'b1;
			x <= 8'd53;
			colour <= 3'b111;
			out_y1 <= out_y1 + 7'b0000001;
			y <= out_y1;
		end
		
		else if(out_y2 <= 7'd120) begin
			x <= 8'd106;
			colour <= 3'b111;
			out_y2 <= out_y2 + 7'b0000001;
			y <= out_y2;
		end
		
		
		else if(plotPlayer == 1'b0) begin
			y <= 7'd100;
			x <= 8'd80;
			colour <= 3'b001;
			plotPlayer <= 1'b1;
			speed1 <= 1'b1;
			speed2 <= 1'b1;
			
		end
		else if(blackOut) begin
			
			if(createCarCounter == 4'd0)begin
				colour <= 3'b000;
				x <= x + 0;
				y <= y + 0;
				createCarCounter <= createCarCounter + 4'd1;
			end
			/*else if(createCarCounter == 4'd1)begin
				colour <= 3'b000;
				x <= x - 8'd1;
				y <= y + 0;
				createCarCounter <= createCarCounter + 4'd1;

			end
			else if(createCarCounter == 4'd2)begin
				colour <= 3'b000;
				x <= x + 8'd2;
				y <= y + 0;
				createCarCounter <= createCarCounter + 4'd1;

			end
			else if(createCarCounter == 4'd3)begin
				colour <= 3'b000;
				x <= x - 8'd3;
				y <= y - 7'd1;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd4)begin
				colour <= 3'b000;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd5)begin
				colour <= 3'b000;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd6)begin
				colour <= 3'b000;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd7)begin
				colour <= 3'b000;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd8)begin
				colour <= 3'b000;
				x <= x - 8'd4;
				y <= y + 7'd2;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd9)begincreateCarCounter <= 4'd0;
				createCar <= 1'b0;
				colour <= 3'b000;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd10)begin
				colour <= 3'b000;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd11)begin
				colour <= 3'b000;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd12)begin
				colour <= 3'b000;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= creassteCarCounter + 4'd1;
			end*/
			else begin
				createCarCounter <= 4'd0;
				blackOut <= 1'b0;
			end
		end
		
		else if(createCar == 1'b1) begin
			if(createCarCounter == 4'd0)begin
				colour <= 3'b001;
				x <= x + 0;
				y <= y + 0;
				createCarCounter <= createCarCounter + 4'd1;
			end
			/*else if(createCarCounter == 4'd1)begin
				colour <= 3'b001;
				x <= x - 8'd1;
				y <= y + 0;
				createCarCounter <= createCarCounter + 4'd1;

			end
			else if(createCarCounter == 4'd2)begin
				colour <= 3'b001;
				x <= x + 8'd2;
				y <= y + 0;
				createCarCounter <= createCarCounter + 4'd1;

			end
			else if(createCarCounter == 4'd3)begin
				colour <= 3'b011;
				x <= x - 8'd3;
				y <= y - 7'd1;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd4)begin
				colour <= 3'b001;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd5)begin
				colour <= 3'b001;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd6)begin
				colour <= 3'b001;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd7)begin
				colour <= 3'b011;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd8)begin
				colour <= 3'b011;
				x <= x - 8'd4;
				y <= y + 7'd2;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd9)begin
				colour <= 3'b001;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd10)begin
				colour <= 3'b001;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd11)begin
				colour <= 3'b001;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= createCarCounter + 4'd1;
			end
			else if(createCarCounter == 4'd12)begin
				colour <= 3'b011;
				x <= x + 8'd1;
				y <= y;
				createCarCounter <= creassteCarCounter + 4'd1;
			end*/
			else begin
				createCarCounter <= 4'd0;
				createCar <= 1'b0;
			end
		end
		
		else if(!KEY[1] || rightMove)begin
			if(rightMove)begin
				colour <= 3'b001;
				x <= 8'd130;
				rightMove <= 1'b0;
				createCar <= 1'b1;
				createCarCounter <= 4'd0;
			end
			else begin
				blackOut <= 1'b1;
				rightMove <= 1'b1;
				createCarCounter <=4'd0;
			end
			/*
			if(x == 8'd80) begin
				
				if(rightMove)begin
					colour <= 3'b001;
					x <= 8'd130;
					rightMove <= 1'b0;
					createCar <= 1'b1;
				end
				else begin
					blackOut <= 1'b1;
					rightMove <= 1'b1;
				end
			end
			else if(x == 8'd30) begin
				
				if(rightMove)begin
					colour <= 3'b001;
					x <= 8'd80;
					rightMove <= 1'b0;
					createCar <= 1'b1;
				end
				else begin
					blackOut <= 1'b1;
					rightMove <= 1'b1;
				end
			end*/
		end
		
		else if(!KEY[3] || leftMove)begin
			if(leftMove)begin
				colour <= 3'b001;
				x <= 8'd30;
				leftMove <= 1'b0;
				createCar <= 1'b1;
				createCarCounter <=4'd0;
			end
			else begin
				blackOut <= 1'b1;
				leftMove <= 1'b1;
				createCarCounter <=4'd0;
			end

			
			/*if(x == 8'd80) begin
				
				if(leftMove)begin
					colour <= 3'b001;
					x <= 8'd30;
					leftMove <= 1'b0;
					createCar <= 1'b1;
				end
				else begin
					blackOut <= 1'b1;
					leftMove <= 1'b1;
				end

			end
			else if(x == 8'd130) begin
				
				if(leftMove)begin
					colour <= 3'b001;
					x <= 8'd80;
					leftMove <= 1'b0;
					createCar <= 1'b1;
				end
				else begin
					
					blackOut <= 1'b1;
					leftMove <= 1'b1;
				end
			end*/
		end
		
		else if(!KEY[2] || middleMove)begin
			if(middleMove)begin
				colour <= 3'b001;
				x <= 8'd30;
				middleMove <= 1'b0;
				createCar <= 1'b1;
				createCarCounter <=4'd0;
			end
			else begin
				blackOut <= 1'b1;
				middleMove <= 1'b1;
				createCarCounter <=4'd0;
			end
		end
		
		
	end
endmodule



module datapath(
	input clk3,
	input clk1,
	input resetn,
   //input ld_x, ld_y, ld_colour,
   input [9:0] data_in,
	output reg[2:0]  out_colour,
   output reg[7:0]  out_x,
	output reg[6:0]  out_y
   );
    
   // output of the alu//////////////////////
   //assign out_x 	 	= 7'b0000000;
	//assign out_y 	 	= 6'b000000;
	//assign out_colour 	= 3'b000;
   	
	// Register x  is set with respective input logic
   always@(posedge clk3) begin
		if(!resetn) begin
			out_x 		<= 8'b00000000;
		end
		else begin
			out_x <= {1'b0, data_in[6:0]};
		end
	end

   // Register y and colour are set with respective input logic
   always@(posedge clk1) begin
		if(!resetn) begin
			out_y 		<= 7'b0000000;
			out_colour 	<= 3'b000;
		end
		else begin
			out_y 		<= data_in[6:0];
			out_colour 	<= data_in[9:7];
		end
	end
endmodule

module control(
	input clk,
   input resetn,
   input [7:0] x,
	input [6:0] y,
	input [2:0] colour,
	output reg[2:0]  ld_alu_out_colour1,
	output reg[2:0]  ld_alu_out_colour2,
   output reg[7:0]  ld_alu_out_x,
	output reg[6:0]  ld_alu_out_y
    );

    // Output logic aka all of our datapath control signals
	// By default make all our signals 0
	/////////////////////////////////////////////
	//assign ld_alu_out_x = 2'b0;
	//assign ld_alu_out_y = 2'b0;
	//assign ld_alu_out_colour = 2'b0;
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
			begin
				ld_alu_out_x <= 8'b00000000;
				ld_alu_out_y <= 7'b0000000;
				ld_alu_out_colour1 <= 3'b000;
				ld_alu_out_colour2 <= ld_alu_out_colour1;
			end
        else
            begin
				ld_alu_out_x <= {1'b0,x};
				ld_alu_out_y <= y;
				ld_alu_out_colour1 <= colour;
				ld_alu_out_colour2 <= ld_alu_out_colour1;
			end
    end // state_FFS
endmodule


module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
