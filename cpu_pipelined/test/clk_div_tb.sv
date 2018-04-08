`timescale 1ns / 1ps

// CLK DIV TESTBENCH
module clk_div_tb;

	// Inputs
	logic clk;
    logic reset;

	//Outputs
    logic clk_mem;
	logic clk_cpu;

	// Instantiate the Device Under Test (DUT)
	clk_div DUT(
        .RESET( reset ),
        .MASTER_CLK( clk ),
        .CLK_MEM( clk_mem ),
        .CLK_CPU( clk_cpu )
    );

	//Initialize clock
	initial begin
		clk = 1'b1;
			forever begin
			#5;
			clk = ~clk;
		end
	end
	
	//Stimulus 
	
	initial begin
		// Initialize Inputs
		reset = 1'b1;
        #25;
        reset = 1'b0;
        #25;
		// Wait 20 ns for global reset to finish
		
		// Add stimulus here

	end
	
endmodule

