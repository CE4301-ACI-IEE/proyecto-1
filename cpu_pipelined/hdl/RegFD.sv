`timescale 1ns / 1ps

module RegFD #(
    parameter SIZE = 32
)(
    input logic CLK, StallD, CLR,
    input logic [SIZE-1:0] InstrF,
    output logic [SIZE-1:0] InstrD
);

logic [SIZE-1:0] InstrD_temp;

always_ff@(negedge CLK)
begin
	if(StallD == 1'b0)
		InstrD_temp = InstrF;
	else if(StallD)
		InstrD_temp = InstrD_temp;
	else if(CLR)
		InstrD_temp = {SIZE{1'b0}};
end

assign InstrD = InstrD_temp;

endmodule