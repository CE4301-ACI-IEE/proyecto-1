`timescale 1ns / 1ps

module RegEM #(
    parameter SIZE = 32
)(
    input logic CLK, PCSrcE2, RegWriteE2, MemToRegE, MemWriteE2, 
    input logic [3:0] WA3E,
	 input logic [SIZE-1:0] ALUResultE, WriteDataE,	
    output logic PCSrcM, RegWriteM, MemToRegM, MemWriteM, 
    output logic [3:0] WA3M,
	 output logic [SIZE-1:0] ALUOutM, WriteDataM

);

logic PCSrcE2_tmp, RegWriteE2_tmp, MemToRegE_tmp, MemWriteE2_tmp;
logic [3:0] WA3E_tmp;
logic [SIZE-1:0] ALUResultE_temp, WriteDataE_temp;


always@(posedge CLK)//se debe cambiar por negedge
begin
    PCSrcE2_tmp      = PCSrcE2;
    RegWriteE2_tmp   = RegWriteE2;
    MemToRegE_tmp    = MemToRegE;
    MemWriteE2_tmp   = MemWriteE2;
    WA3E_tmp         = WA3E;
	 ALUResultE_temp	= ALUResultE;
	 WriteDataE_temp	= WriteDataE;
end

assign PCSrcM       = PCSrcE2_tmp;
assign RegWriteM    = RegWriteE2_tmp;
assign MemToRegM    = MemToRegE_tmp;
assign MemWriteM    = MemWriteE2_tmp;
assign WA3M         = WA3E_tmp;
assign ALUOutM      = ALUResultE_temp;
assign WriteDataM   = WriteDataE_temp;

endmodule