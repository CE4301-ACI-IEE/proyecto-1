`timescale 1ns / 1ps


module mem_pic_tb;

	// Inputs
	logic [18:0] addr;
	logic clk;
	logic [47:0] data;
	logic enable_write;

	//Outputs
	logic [47:0] output_q;

	// Instantiate the Device Under Test (DUT)
	mem_pic DUT (
		.address( addr ),
		.clock( clk ),
		.data( data ),
		.wren( enable_write ),
		.q( output_q )
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
		addr = 32'bx;
		
		// Wait 20 ns for global reset to finish
		#20;
		
		addr = 32'H0;
		// Add stimulus here
		for( int i=0; i<9; i++ ) begin
			#20;
			addr = addr + 32'H1;
		end

	end
	
endmodule
