`timescale 1ns / 1ps

module RegDE #(
    parameter SIZE = 32
)(
    input logic CLK, PCSrcD, RegWriteD, MemToRegD, MemWriteD, 
    input logic BranchD, ALUSrcD, FlagWriteD, CLR,
    input logic [2:0] ALUControlD,
    input logic [3:0] Flags, CondD, WA3D,
    input logic [SIZE-1:0] RD1, RD2, ExtImmD,

    output logic PCSrcE, RegWriteE, MemToRegE, MemWriteE, 
    output logic BranchE, ALUSrcE, FlagWriteE,
    output logic [2:0] ALUControlE,
    output logic [3:0] FlagsE, CondE, WA3E,
    output logic [SIZE-1:0] RE1, RE2, ExtImmE
);

logic CLK_tmp, PCSrcD_tmp, RegWriteD_tmp, MemToRegD_tmp, MemWriteD_tmp;
logic BranchD_tmp, ALUSrcD_tmp, FlagWriteD_tmp;
logic [2:0] ALUControlD_tmp;
logic [3:0] Flags_tmp, CondD_tmp, WA3D_tmp;
logic [SIZE-1:0] RD1_tmp, RD2_tmp, ExtImmD_tmp;

always@(CLR)
begin
    PCSrcD_tmp      = 1'b0;
    RegWriteD_tmp   = 1'b0;
    MemToRegD_tmp   = 1'b0;
    MemWriteD_tmp   = 1'b0;
    BranchD_tmp     = 1'b0;
    ALUSrcD_tmp     = 1'b0;;
    FlagWriteD_tmp  = 1'b0;
    ALUControlD_tmp = 3'b0;
    Flags_tmp       = 4'b0;
    CondD_tmp       = 4'b0;
    WA3D_tmp        = 4'b0;
    RD1_tmp         = {SIZE{1'b0}};
    RD2_tmp         = {SIZE{1'b0}};
    ExtImmD_tmp     = {SIZE{1'b0}};
end

always@(posedge CLK)//se debe cambiar por negedge
begin
    PCSrcD_tmp      = PCSrcD;
    RegWriteD_tmp   = RegWriteD;
    MemToRegD_tmp   = MemToRegD;
    MemWriteD_tmp   = MemWriteD;
    BranchD_tmp     = BranchD;
    ALUSrcD_tmp     = ALUSrcD;
    FlagWriteD_tmp  = FlagWriteD;
    ALUControlD_tmp = ALUControlD;
    Flags_tmp       = Flags;
    CondD_tmp       = CondD;
    WA3D_tmp        = WA3D;
    RD1_tmp         = RD1;
    RD2_tmp         = RD2;
    ExtImmD_tmp     = ExtImmD;
end

assign PCSrcE       = PCSrcD_tmp;
assign RegWriteE    = RegWriteD_tmp;
assign MemToRegE    = MemToRegD_tmp;
assign MemWriteE    = MemWriteD_tmp;
assign BranchE      = BranchD_tmp;
assign ALUSrcE      = ALUSrcD_tmp;
assign FlagWriteE   = FlagWriteD_tmp;
assign ALUControlE  = ALUControlD_tmp;
assign FlagsE       = Flags_tmp;
assign CondE        = CondD_tmp;
assign WA3E         = WA3D_tmp;
assign RE1          = RD1_tmp;
assign RE2          = RD2_tmp;
assign ExtImmE      = ExtImmD_tmp;
endmodule