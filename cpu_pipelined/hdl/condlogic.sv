`timescale 1ns / 1ps

// Condition logic module
module condlogic (
input logic CLK,
input logic Reset,
input logic [3:0] CondE,
input logic [3:0] ALUFlags,
input logic [1:0] FlagWriteE,
input logic [1:0]	FlagsE,
output logic [1:0] Flags,
output logic CondExE
);


logic [3:0] flags_temp;
logic condexE_temp;

flopenr #(2) flagreg1(CLK, Reset, FlagsE[1],
							  ALUFlags[3:2], flags_temp[3:2]);
flopenr #(2) flagreg0(CLK, Reset, FlagsE[0],
							  ALUFlags[1:0], flags_temp[1:0]);

// Write conditions
condcheck cc( Cond, flags_temp, condexE_temp );
assign CondExE = condexE_temp; 
assign Flags = FlagWriteE & {2{condexE_temp}};

endmodule
