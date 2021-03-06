`timescale 1ns / 1ps
/**
It releases the instruction to be decoded,
if a stall is recieve the pipe won't go on.
*/
module RegFD #(
    parameter SIZE = 32
)(
    input logic CLK, StallD, CLR,
    input logic [SIZE-1:0] InstrF,
    output logic [SIZE-1:0] InstrD
);

logic [SIZE-1:0] InstrD_temp;

always@(negedge CLK or posedge CLR)
begin
	//if(CLR) InstrD_temp <= {SIZE{1'b0}};
	/*else*/ if (StallD) InstrD_temp <= InstrD_temp;
	else if (~StallD) InstrD_temp <= InstrF;
    else InstrD_temp <= {SIZE{1'b0}};
end

assign InstrD = InstrD_temp;

endmodule
