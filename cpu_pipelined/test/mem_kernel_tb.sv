`timescale 1ns / 1ps

//Copy this content to create a testbech file
module mem_kernel_tb;

    parameter SIZE = 16 ;

	// Inputs
	logic clk;
    logic [SIZE-1:0] addr;

	//Outputs
	logic [SIZE-1:0] read;

	// Instantiate the Device Under Test (DUT)
	mem_kernel #(SIZE) DUT (
        .CLK( clk ),
		.ADDRESS( addr ),
		.READ( read )
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
		addr = 16'bx;
		
		// Wait 20 ns for global reset to finish
		#20;
		
		addr = 16'H0;
		// Add stimulus here
		for( int i=0; i<9; i++ ) begin
			#20;
			addr = addr + 16'H4;
		end

	end
	
endmodule

