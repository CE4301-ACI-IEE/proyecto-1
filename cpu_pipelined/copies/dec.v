`timescale 1ns / 1ps


module dec;

	// Inputs
	reg [1:0] Op;
	reg [5:0] Funct;
	//Output
	wire MemW;

	// Instantiate the Unit Under Test (UUT)
	decoder_v uut (
		.Op(Op), .Funct(Funct), .MemW(MemW)
	);

	initial begin
		// Initialize Inputs
		Op = 2'b01;
		Funct = 6'b000010;

		// Wait 100 ns for global reset to finish
		#100;
       $display(MemW);
		// Add stimulus here

	end
      
endmodule

