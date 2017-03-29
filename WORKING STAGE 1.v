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
		LEDR
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;
	
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
	reg [7:0] x ;
	reg [6:0] y;
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
	reg rightMove = 1'b0;
	reg blackOut = 1'b0;
	
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
			colour <= 3'b000;
			blackOut <= 1'b0;
		end
		
		else if(!KEY[1] || rightMove)begin
			if(x == 8'd80) begin
				
				if(rightMove)begin
					colour <= 3'b001;
					x <= 8'd130;
					rightMove <= 1'b0;
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
				end
				else begin
					blackOut <= 1'b1;
					rightMove <= 1'b1;
				end
			end
		end
		
		else if(!KEY[3] || leftMove)begin
			if(x == 8'd80) begin
				
				if(leftMove)begin
					colour <= 3'b001;
					x <= 8'd30;
					leftMove <= 1'b0;
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
				end
				else begin
					
					blackOut <= 1'b1;
					leftMove <= 1'b1;
				end
			end
		end
	end
endmodule

	


module RateDivider(clk, Q, clear, enable, d, ParLoad);
	input clk, enable, clear, ParLoad;
	input [27:0] d;
	output [27:0] Q;
	reg [27:0] Q;
	always @(posedge clk)
	begin
		if(clear == 1'b0)
			Q <= 0;
		else if(ParLoad == 1'b1)
			Q <= d;
		else if(Q == 28'b0000000000000000000000000000)
			Q <= d;
		else if(enable == 1'b1)
			Q <= Q - 1'b1;
		else if(enable == 1'b0)
			Q <= Q;
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
