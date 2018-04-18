`timescale 1ns / 1ps

// Index matrix to memory address converter module testbench
module conv_index_to_mem_tb;

	// Inputs
	logic clk;
    logic reset;
    logic size_image;
    logic [31:0] index_address;

	//Outputs
    logic [31:0] mem_address;
	
	// Instantiate the Device Under Test (DUT)
	conv_index_to_mem DUT(
        .CLK( clk ),
        .RESET( reset ),
        .SIZE_IMAGE( 1'b0 ),
        .INDEX_ADDRESS( index_address ),
        .MEM_ADDRESS( mem_address )
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
		reset = 1'b1;
        index_address = 32'H00020001;

		// Wait 20 ns for global reset to finish
		#20;
		
		// Add stimulus here
        reset = 1'b0;

        #100;
        $stop;

	end
	
endmodule

