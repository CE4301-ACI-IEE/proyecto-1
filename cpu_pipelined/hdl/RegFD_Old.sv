`timescale 1ns / 1ps

module RegFD_Old #(
    parameter SIZE = 48
)(
    input logic CLK, StallD, CLR,
    input logic [SIZE-1:0] InstrF,
    output logic [SIZE-1:0] InstrD
);
logic [SIZE-1:0] InstrD_tmp,InstrD_tmp2;
always@(*)
begin
    if (StallD)
    begin
        InstrD_tmp = {SIZE{1'bx}};
    end 
	 else if (CLR)
    begin
        InstrD_tmp = {SIZE{1'b0}};
    end 
end

always_ff@(posedge CLK)
begin
    InstrD_tmp2 = InstrD_tmp;
end

always_ff@(negedge CLK)
begin
    InstrD_tmp = InstrF;
end

assign InstrD = InstrD_tmp2;
    
endmodule