`timescale 1ns / 1ps

// Kernel memory testbench module
module mem_kernel_tb;

	// Inputs
	logic clk;
    logic [3:0] addr;
	logic [15:0] data;
	logic enable;

	//Outputs
	logic [15:0] read_q;

	// Instantiate the Device Under Test (DUT)
	mem_kernel DUT (
		.address( addr ),
		.clock( clk ),
		.data( data ),
		.wren( enable ),
		.q( read_q )
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
		addr = 4'bx;
		data = 16'bx;
		enable = 1'b0;
		
		// Wait 20 ns for global reset to finish
		#20;

		// Add stimulus here
		addr = 4'b0;
		for( int i=0; i<9; i++ ) begin
			#20;
			addr = ( i==8 ) ? addr : addr + 1'b1;
		end

	end
	
endmodule

