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
			