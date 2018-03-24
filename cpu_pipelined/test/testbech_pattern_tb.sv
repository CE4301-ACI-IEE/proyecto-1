`timescale 1ns / 1ps

//Copy this content to create a testbech file
module testbech_pattern_tb;

	// Inputs
	
	//Outputs

	// Instantiate the Device Under Test (DUT)

    //Initialize clock
	/*initial begin
		clk = 1'b0;
		forever begin
			#5;
			clk = ~clk;
		end
	*/end

    //Stimulus 
	initial begin
		// Initialize Inputs

		// Wait 20 ns for global reset to finish
		#20;
        
		// Add stimulus here
		
	end
endmodule

