`timescale 1ns / 1ps
module RAM_v(
	input [31:0] ArmData, KeyData,
	input [31:0] ArmAddr, KeyAddr,
	input ArmWe, KeyWe, clk,
	output [31:0] ArmRead, KeyRead
);

	// Declare the RAM variable
	reg [31:0] ram[63:0];
	
	// Variable to hold the registered read address
	reg [31:0] addr_regArm;
	reg [31:0] addr_regKey;
	
	always @ (posedge clk)
	begin
	// Write
			if(KeyWe) ram[KeyAddr] <= KeyData;	
	end
	
	always @ (posedge clk)
	begin
	// Write
			if (ArmWe) ram[ArmAddr] <= ArmData;
	end
		
	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign ArmRead = ram[ArmAddr];
	assign KeyRead = ram[KeyAddr];

endmodule
