`timescale 1ns / 1ps

// Datapath module
module datapath (
    input logic CLK,
    input logic Reset,
	input logic [1:0] RegSrc,
	input logic RegWrite,
	input logic [1:0] ImmSrc,
	input logic ALUSrc,
	input logic [2:0] ALUControl,
	input logic MemtoReg,
	input logic PCSrc,
	input logic [31:0] Instr,
	input logic [31:0] ReadData,
	output logic [3:0] ALUFlags,
	output logic [31:0] PC,
	output logic [31:0] ALUResult,
	output logic [31:0] WriteData
);

logic [31:0] PCNext, PCPlus4, PCPlus8;
logic [31:0] ExtImm, SrcA, SrcB, Result;
logic [3:0] RA1, RA2;

// Next PC logic
mux2x1 #(32) pcmux(PCSrc, PCPlus4, Result, PCNext);
flopr #(32) pcreg(CLK, Reset, PCNext, PC);
adder #(32) pcadd1(CLK, PC, 32'd4, PCPlus4);
adder #(32) pcadd2(CLK, PCPlus4, 32'd4, PCPlus8);

// Register file logic
mux2x1 #(4) ra1mux(RegSrc[0], Instr[19:16], 4'b1111, RA1);
mux2x1 #(4) ra2mux(RegSrc[1], Instr[3:0], Instr[15:12], RA2);
regfile rf(CLK, RegWrite, RA1, RA2, 
			  Instr[15:12], Result, PCPlus8,
			  SrcA, WriteData);
mux2x1 #(32) resmux(MemtoReg, ALUResult, ReadData, Result);
extend ext(Instr[23:0], ImmSrc, ExtImm);

// ALU logic
mux2x1 #(32) srcBmux(ALUSrc, WriteData, ExtImm, SrcB);
alu ALU(CLK, SrcA, SrcB, ALUControl, ALUResult, ALUFlags);

endmodule