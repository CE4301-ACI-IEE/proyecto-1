`timescale 1ns / 1ps

// Dynamic memory module testbench
module dmem_tb;

    parameter SIZE = 32;
    parameter MIN = 0;
    parameter MAX = 252;

	// Inputs
	bit clk;
    bit we;
    logic [SIZE-1:0] a, wd;

	//Outputs
    logic [SIZE-1:0] rd;

	// Instantiate the Device Under Test (DUT)
    dmem DUT(
        .CLK( clk ),
        .WE( we ),
        .A( a ),
        .WD( wd ),
        .RD( rd )
    );

    //Initialize clock
	initial begin
		clk = 1'b0;
		forever begin
			#5;
			clk = ~clk;
		end
	end

    //Stimulus 
	initial begin
		// Initialize Inputs
        we = 1'bx;
        a = 32'bx;
        wd = 32'bx;    

		// Wait 20 ns for global reset to finish
		#25;
        
        
		// Add stimulus here
        // set data in dynamic memory
        we = 1'b1;
        for( int i=MIN; i < MAX; i+=4 ) begin
            a = i;
            wd = i;
            #10;
        end

        // break 10 ns 
        we = 1'b0;
        a = 32'dx;
        wd = 32'dx;
        #10;

        // read data of dynamic memory
        for( int i=MIN; i < MAX; i+=4 ) begin
            a = i;
            #10;
        end

        $stop; //stop the simulation

	end
endmodule

