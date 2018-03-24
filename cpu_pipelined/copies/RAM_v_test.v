`timescale 1ns / 1ps
module RAM_v_test;
	
	// Inputs
	reg clk;
	reg we;
	reg [31:0] a;
	reg [31:0] wd;
	
	//Outputs
	wire [31:0] rd;
	
	// Instantiate the Unit Under Test (UUT)
	RAM_v uut (
		.clk(clk),
		.we(we),
		.a(a),
		.wd(wd),
		.rd(rd)
	);
	
	reg finish_test;
	initial begin
		// Initialize Inputs
		clk = 0;
		we = 0;
		a = 0;
		wd = 0;
		
		finish_test = 0;

		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
		
		//Escribe en a=0
		we = 1;
		a = 0;
		wd = 32'd24;
		
		
		we = 0;
		a = 25;
		wd = 32'd128;
		
		//Escribe en a=25
		
		we = 1;
		
		we = 0;
		a = 32'bx;
		wd = 32'bx;
		finish_test = 1;
	end
	
	always@(*) begin
		#5;
		clk = ~clk;
	end
	
	always@(posedge clk) begin
		if(finish_test) begin
			we = 0;
			a = 0;
			if( rd == 32'd24 )
				$display("	OK.");
			else
				$display("	Falla.");
			
			#10;
			a = 25;
			if( rd == 32'd128 )
				$display("	OK.");
			else
				$display("	Falla");
			
			$stop;
		end
	end
	
endmodule

