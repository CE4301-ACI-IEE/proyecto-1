`timescale 1ns / 1ps

// Resettable flip-flop with enable module testbench
module flopenr_tb;

    parameter WIDTH = 8;

	// Inputs
	bit clk;
    bit reset;
    bit enable;
    logic [WIDTH-1:0] data;

	//Outputs
	logic [WIDTH-1:0] q;

	// Instantiate the Device Under Test (DUT)
	flopenr DUT(
        .CLK( clk ),
        .Reset( reset ),
        .EN( enable ),
        .D( data ),
        .Q( q )
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
        enable = 1'bx;
        data = 8'bx;

		// Wait 20 ns for global reset to finish
		#20;
		
		// Add stimulus here
		reset = 1'b0;
		enable = 1'b0;
		data = 8'd10;
		#20;

		enable = 1'b1;
		#20;

		enable = 1'b0;
		data = 8'd12;
		#20;

		reset = 1'b1;
		#20;

		$stop;
	end
	
endmodule

