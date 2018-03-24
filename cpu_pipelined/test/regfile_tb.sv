`timescale 1ns / 1ps
module instruction_rom_tb;

    parameter AMOUNT_REG = 4;
    parameter SIZE = 32;

	// Inputs
	bit clk;
    bit we3;
    logic [AMOUNT_REG-1:0] ra1;
    logic [AMOUNT_REG-1:0] ra2;
    logic [AMOUNT_REG-1:0] ra3;
    logic [SIZE-1:0] wd3;
    logic [SIZE-1:0] r15;
	
	//Outputs
    logic [SIZE-1:0] rd1;
    logic [SIZE-1:0] rd2;

	// Instantiate the Device Under Test (DUT)
    regfile #(SIZE, AMOUNT_REG) DUT( .CLK( clk ),
                 .WE3( we3 ),
                 .RA1( ra1 ),
                 .RA2( ra2 ),
                 .RA3( ra3 ),
                 .WD3( wd3 ),
                 .R15( r15 ),
                 .RD1( rd1 ),
                 .RD2( rd2 ) );

    //Initialize clock
	initial begin
		clk = 1'b1;
		forever begin
			#5;
			clk = ~clk;
		end
	end

	initial begin
		// Initialize Inputs
		ra1 = 4'bxxxx;
        ra2 = 4'bxxxx;
        ra3 = 4'bxxxx;
        wd3 = 4'bxxxx;
        r15 = 4'bxxxx;

		// Wait 100 ns for global reset to finish
		//#10;
    
		// Add stimulus here
        ra3 = 4'b0000;
        we3 = 1'b1;
        wd3 = 32'd32;
        for( int i=0; i<14; i++ ) begin
            #10;
            ra3 = ra3 + 1'b1;    
            wd3 = wd3 + 32'd1;
        end

        we3 = 1'b0;
        ra3 = 4'bxxxx;
        wd3 = 32'bx;

        #20;
        ra1 = 4'b0000;
        ra2 = 4'b0001;
        for( int j=0; j<7; j++ ) begin    
            #10;
            ra1 = ra1 + 2'b10;
            ra2 = ra2 + 2'b10;
        end

        $stop;

	end
endmodule

