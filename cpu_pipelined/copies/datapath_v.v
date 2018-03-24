`timescale 1ns / 1ps
module datapath_v(
input
	wire clk,
	wire reset,
	wire [1:0] RegSrc,
	wire RegWrite,
	wire [1:0] ImmSrc,
	wire ALUSrc,
	wire [2:0] ALUControl,
	wire MemtoReg,
	wire PCSrc,
	wire [31:0] Instr,
	wire [31:0] ReadData,
output
	wire [3:0] ALUFlags,
	wire [31:0] PC,
	wire [31:0] ALUResult,
	wire [31:0] WriteData
);

wire [31:0] PCNext, PCPlus4, PCPlus8;
wire [31:0] ExtImm, SrcA, SrcB, Result;
wire [3:0] RA1, RA2;

//Logica de siguiente PC
mux2x1_v #(32) pcmux(PCSrc, PCPlus4, Result, PCNext);
flopr_v #(32) pcreg(clk, reset, PCNext, PC);
adder_v #(32) pcadd1(clk, PC, 32'd4, PCPlus4);
adder_v #(32) pcadd2(clk, PCPlus4, 32'd4, PCPlus8);

//Logica Register file
mux2x1_v #(4) ra1mux(RegSrc[0], Instr[19:16], 4'b1111, RA1);
mux2x1_v #(4) ra2mux(RegSrc[1], Instr[3:0], Instr[15:12], RA2);
regfile_v rf(clk, RegWrite, RA1, RA2, 
			  Instr[15:12], Result, PCPlus8,
			  SrcA, WriteData);
mux2x1_v #(32) resmux(MemtoReg, ALUResult, ReadData, Result);
extend_v ext(Instr[23:0], ImmSrc, ExtImm);

//Logica ALU
mux2x1_v #(32) srcBmux(ALUSrc, WriteData, ExtImm, SrcB);
alu_v ALU(clk, SrcA, SrcB, ALUControl, ALUResult, ALUFlags);

endmodule
