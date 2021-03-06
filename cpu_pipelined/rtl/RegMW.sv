`timescale 1ns / 1ps
/**
It is an stage register, it stores the previous value
to be release in the next edge to all the stages are syncronized.
It is located between memory and writeback. It stores the previous value
of control signals.
*/
module RegMW #(
    parameter SIZE = 32
)(
    input logic CLK, PCSrcM, RegWriteM, MemToRegM,
    input logic [4:0] WA3M,
	 input logic [SIZE-1:0] ALUOutM, ReadDataM,	
    output logic PCSrcW, RegWriteW, MemToRegW, 
    output logic [4:0] WA3W,
	 output logic [SIZE-1:0] ALUOutW, ReadDataW

);

logic PCSrcM_tmp, RegWriteM_tmp, MemToRegM_tmp;
logic [4:0] WA3M_tmp;
logic [SIZE-1:0] ALUOutM_temp, ReadDataM_temp;


always@(negedge CLK)//se debe cambiar por negedge
begin
    PCSrcM_tmp       <= PCSrcM;
    RegWriteM_tmp    <= RegWriteM;
    MemToRegM_tmp    <= MemToRegM;
    WA3M_tmp         <= WA3M;
	ALUOutM_temp	 <= ALUOutM;
    ReadDataM_temp	 <= ReadDataM;
end

assign PCSrcW       = PCSrcM_tmp;
assign RegWriteW    = RegWriteM_tmp;
assign MemToRegW    = MemToRegM_tmp;
assign WA3W         = WA3M_tmp;
assign ALUOutW      = ALUOutM_temp;
assign ReadDataW    = ReadDataM_temp;

endmodule