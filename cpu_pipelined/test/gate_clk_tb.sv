`timescale 1ns / 1ps

// Gate Clock Module Testbench
module gate_clk_tb;

	// Inputs
    logic clk;
    logic wait_signal;
    logic handshake;

	//Outputs
	logic clk_cpu;

	// Instantiate the Device Under Test (DUT)
	gate_clk DUT(
        .MASTER_CLK( clk ),
        .WAIT_SIGNAL( wait_signal ),
        .HANDSHAKE( handshake ),
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
        wait_signal = 1'b0;
        handshake = 1'b0;
		
		// Wait 20 ns for global reset to finish
		#40;
		
		// Add stimulus here
        wait_signal = 1'b1;
        #20;

        handshake = 1'b1;
        #40;
        $stop;

	end
	
endmodule

