`timescale 1ns / 1ps
module arm_v(
input
	wire clk,
	wire reset,
	wire [31:0] Instr,
	wire [31:0] ReadData,
output
	wire MemWrite,
	wire [31:0] PC,
	wire [31:0] DataAdr,
	wire [31:0] WriteData
);

wire [3:0] ALUFlags;
wire RegWrite, ALUSrc, MemtoReg, PCSrc;
wire [1:0] RegSrc, ImmSrc;
wire [2:0] ALUControl;

controller_v c( .clk(clk), 
					 .reset(reset), 
					 .Instr(Instr[31:12]), 
					 .ALUFlags(ALUFlags),
					 .RegSrc(RegSrc), 
					 .RegWrite(RegWrite),
					 .ImmSrc(ImmSrc), 
					 .ALUSrc(ALUSrc),
					 .ALUControl(ALUControl), 
					 .MemWrite(MemWrite), 
					 .MemtoReg(MemtoReg), 
					 .PCSrc(PCSrc));

datapath_v dp( .clk(clk), 
					.reset(reset),					
					.RegSrc(RegSrc),
					.RegWrite(RegWrite), 
					.ImmSrc(ImmSrc), 
					.ALUSrc(ALUSrc), 
					.ALUControl(ALUControl),
					.MemtoReg(MemtoReg), 
					.PCSrc(PCSrc), 
					.ALUFlags(ALUFlags), 
					.PC(PC), 
					.Instr(Instr),
					.ALUResult(DataAdr), 
					.WriteData(WriteData), 
					.ReadData(ReadData));

endmodule