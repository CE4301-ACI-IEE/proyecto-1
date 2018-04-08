`timescale 1ns / 1ps

// Memory controller module testbench
module memory_controller_tb;

    parameter SIZE = 48;

	// Inputs
    logic clk_cpu;
	logic clk;
    logic clk_mem;
    logic [SIZE-1:0] address;
    logic enable;
    logic ctrl;

	//Outputs
    logic [SIZE-1:0] read;
    logic [1:0] state;
	
	// Instantiate the Device Under Test (DUT)
	memory_controller DUT(
        .CLK( clk ),
        .CLK_MEM( clk_mem ),
        .ADDRESS( address ),
        .ENABLE( enable ),
        .CTRL( ctrl ),
        .READ( read ),
        .state( state )
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
    logic reset;
    clk_div clk_div_1(
        .RESET( reset ),
        .MASTER_CLK( clk ),
        .CLK_MEM( clk_mem ),
        .CLK_CPU( clk_cpu )
    );
	initial begin
		// Initialize Inputs
		address = 48'bx;
        enable = 1'b0;
        ctrl = 2'bxx;
        reset = 1'b1;

		// Wait 20 ns for global reset to finish
		#20;
		
		// Add stimulus here
        reset = 1'b0;
        enable = 1'b0;
        #20;
        enable = 1'b1;


	end
	
endmodule

