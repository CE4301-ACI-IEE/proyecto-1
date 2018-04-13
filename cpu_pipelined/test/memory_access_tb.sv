// Date: 04/12/18

`timescale 1ns / 1ps

// Memory access testbench module
module memory_access_tb;

	// Inputs
	logic clk;
    logic clk_mem;
    logic reset;
    logic enable;
    logic [2:0] ctrl;
    logic [31:0] address_input;

	//Outputs
    logic [47:0] read_output;
	
	// Instantiate the Device Under Test (DUT)
	memory_access DUT(
        .CLK( clk ),
        .CLK_MEM(  clk_mem),
        .RESET( reset ),
        .ENABLE( enable ),
        .CTRL( ctrl ),
        .ADDRESS( address_input ),
        .READ( read_output )
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
	clk_div ck(
        .RESET( reset ),
        .MASTER_CLK( clk ),
        .CLK_MEM( clk_mem ),
        .CLK_CPU(  )
    );
	initial begin
		// Initialize Inputs
        enable = 1'b0;
        ctrl = 3'bx;
        reset = 1'b1;
		
		// Wait 50 ns for global reset to finish
		#50;
		
		// Add stimulus here
        reset = 1'b0;
        ctrl = 3'b100;
        address_input = 32'H00010002;

        #20;
        enable = 1'b1;

        #100;
        //$stop;

	end
	
endmodule

