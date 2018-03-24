`timescale 1ns / 1ps
module condlogic_v(
input 
	wire clk,
	wire reset,
	wire [3:0] Cond,
	wire [3:0] ALUFlags,
	wire [1:0] FlagW,
	wire PCS,
	wire RegW,
	wire MemW,
output
	wire PCSrc,
	wire RegWrite,
	wire MemWrite
);

wire [1:0] FlagWrite;
wire [3:0] Flags;
wire CondEx;

flopenr_v #(2) flagreg1(clk, reset, FlagWrite[1],
							  ALUFlags[3:2], Flags[3:2]);
flopenr_v #(2) flagreg0(clk, reset, FlagWrite[0],
							  ALUFlags[1:0], Flags[1:0]);

//Escribe condiciones
condcheck_v cc(Cond, Flags, CondEx);
assign FlagWrite = FlagW & {2{CondEx}};
assign RegWrite = RegW & CondEx;
assign MemWrite = MemW & CondEx;
assign PCSrc = PCS & CondEx;

endmodule
