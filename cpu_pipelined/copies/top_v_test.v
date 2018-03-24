`timescale 1ns / 1ps
module top_v_test;

	// Inputs
	reg CLK;
	reg RESET;
	
	//Outputs
	wire [31:0] DataAdr, WriteData, Instr, PC, PCNext_test;
	wire MemWrite;
	wire [31:0] PCPlus4_test;
	wire PCSrc_test;
	wire [3:0] AluFlags;
	wire [31:0] A,B;
	wire [3:0] R1, R2;
 
	// Instantiate the Unit Under Test (UUT)
	top_v uut (
		.CLK(CLK),
		.RESET(RESET),
		.DataAdr(DataAdr), 
		.WriteData(WriteData), 
		.MemWrite(MemWrite),
		.Instr_test(Instr),
		.PC_test(PC),
		.PCNext_test(PCNext_test),
		.PCSrc_test(PCSrc_test),
		.PCPlus4_test(PCPlus4_test),
		.AluFlags(AluFlags), .A(A), .B(B), .R1(R1), .R2(R2)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		RESET = 1;

		// Wait 100 ns for global reset to finish
		#5;
        
		// Add stimulus here
		RESET = 0;
	end
	
	always@(*) begin
		#5;
		CLK <= ~CLK;
		$display(Instr);
		$display(PC);
	end
	
endmodule

