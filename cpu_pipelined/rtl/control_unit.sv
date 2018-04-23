`timescale 1ns / 1ps

// Control unit module
module control_unit (
input logic CLK,
input logic Reset,
input logic [31:12] Instr,
input logic [3:0] ALUFlags,
output logic [1:0] RegSrc,
output logic RegWrite,
output logic [1:0] ImmSrc,
output logic ALUSrc,
output logic [2:0] ALUControl,
output logic MemWrite,
output logic MemtoReg,
output logic PCSrc
);

logic [1:0] FlagW;
logic PCS, RegW, MemW;

decoder dec( .Op(Instr[27:26]), 
				.Funct(Instr[25:20]), 
				.Rd(Instr[15:12]),
				.FlagW(FlagW), 
				.PCS(PCS), 
				.RegW(RegW), 
				.MemW(MemW),
				.MemtoReg(MemtoReg), 
				.ALUSrc(ALUSrc), 
				.ImmSrc(ImmSrc), 
				.RegSrc(RegSrc), 
				.ALUControl(ALUControl) );

condlogic cl( .CLK(CLK), 
				 .Reset(Reset), 
				 .Cond(Instr[31:28]), 
				 .ALUFlags(ALUFlags),
				 .FlagW(FlagW), 
				 .PCS(PCS), 
				 .RegW(RegW), 
				 .MemW(MemW), 
				 .PCSrc(PCSrc), 
				 .RegWrite(RegWrite), 
				 .MemWrite(MemWrite) );

endmodule
