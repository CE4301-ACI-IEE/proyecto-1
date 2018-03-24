`timescale 1ns / 1ps
module controller_v(
input
	wire clk,
	wire reset,
	wire [31:12] Instr,
	wire [3:0] ALUFlags,
output
	wire [1:0] RegSrc,
	wire RegWrite,
	wire [1:0] ImmSrc,
	wire ALUSrc,
	wire [2:0] ALUControl,
	wire MemWrite,
	wire MemtoReg,
	wire PCSrc
);

wire [1:0] FlagW;
wire PCS, RegW, MemW;

decoder_v dec( .Op(Instr[27:26]), 
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

condlogic_v cl( .clk(clk), 
					 .reset(reset), 
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
