`timescale 1ns / 1ps

module dmem_tb;

    parameter SIZE = 32;

	// Inputs
	bit clk;
    bit we;
    logic [SIZE-1:0] a, wd;

	//Outputs
    logic [SIZE-1:0] rd;

	// Instantiate the Device Under Test (DUT)
    dmem DUT(
        .CLK( clk ),
        .WE( we ),
        .A( a ),
        .WD( wd ),
        .RD( rd )
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
        we = 1'bx;
        a = 32'bx;
        wd = 32'bx;    

		// Wait 20 ns for global reset to finish
		#20;
        
		// Add stimulus here
        we = 1'b1;
        a = 32'd0;
        wd = 32'd10;
        #10;

        we = 1'b1;
        a = a + 32'd252;
        wd = wd + 32'd1;
        #10;

        we = 1'b0;
        a = 32'dx;
        #10;

        a = 32'd0;
        #20;

        a = 32'd252;
        #20;

	end
endmodule

