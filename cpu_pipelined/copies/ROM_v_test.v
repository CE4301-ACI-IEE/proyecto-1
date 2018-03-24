`timescale 1ns / 1ps
module ROM_v_test;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] Dir;

	// Outputs
	wire [31:0] Instruccion;

	// Instantiate the Unit Under Test (UUT)
	ROM_v uut (
		.clk(clk), 
		.reset(reset), 
		.Dir(Dir), 
		.Instruccion(Instruccion)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		Dir = 4;

		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
		reset = 0;
	end
	
	always@(*) begin
		#5;
		clk <= ~clk;
	end
	
	always@(negedge clk) begin
		if(!reset && Instruccion == 32'HE2802005) begin
			$display("Exitoso.");
			$stop;
		end 
	end
	
endmodule

