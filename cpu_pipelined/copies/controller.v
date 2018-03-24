`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:22:20 11/24/2017
// Design Name:   controller_v
// Module Name:   D:/Escritorio/proyecto_final_tdd/controller.v
// Project Name:  Proyecto_Final
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: controller_v
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module controller;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] Instr;

	wire MemWrite;
	wire PCSrc ;
	wire MemtoReg;
	wire PCS ;
	

	// Instantiate the Unit Under Test (UUT)
	controller_v uut (
		.clk(clk), .reset(reset), .Instr(Instr[31:12]), .MemWrite(MemWrite), .PCSrc(PCSrc), .MemtoReg(MemtoReg), .PCS_test(PCS)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		// Add stimulus here
		reset = 1;
		#10;
		reset = 0;
		Instr = 32'H0A00000C;
	end
	always@(*) begin
		#10;
	   clk = ~clk;
	end
      
endmodule

