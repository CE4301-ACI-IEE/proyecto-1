`timescale 1ns / 1ps

// Condition logic module
module condlogic (
input logic CLK,
input logic Reset,
input logic [3:0] Cond,
input logic [3:0] ALUFlags,
input logic [1:0] FlagW,
input logic PCS,
input logic RegW,
input logic MemW,
output logic PCSrc,
output logic RegWrite,
output logic MemWrite
);

logic [1:0] FlagWrite;
logic [3:0] Flags;
logic CondEx;

flopenr #(2) flagreg1(CLK, Reset, FlagWrite[1],
							  ALUFlags[3:2], Flags[3:2]);
flopenr #(2) flagreg0(CLK, Reset, FlagWrite[0],
							  ALUFlags[1:0], Flags[1:0]);

// Write conditions
condcheck cc( Cond, Flags, CondEx );
assign FlagWrite = FlagW & {2{CondEx}};
assign RegWrite = RegW & CondEx;
assign MemWrite = MemW & CondEx;
assign PCSrc = PCS & CondEx;

endmodule
