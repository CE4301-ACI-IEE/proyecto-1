`timescale 1ns / 1ps

module RegFD #(
    parameter SIZE = 32
)(
    input logic CLK, StallD, CLR,
    input logic [SIZE-1:0] InstrF,
    output logic [SIZE-1:0] InstrD
);

logic [SIZE-1:0] InstrD_temp;

always_ff@(negedge CLK or posedge CLR)
begin
	//if(CLR) InstrD_temp <= {SIZE{1'b0}};
	/*else*/ if (StallD) InstrD_temp <= InstrD_temp;
	else InstrD_temp <= InstrF;
end

assign InstrD = InstrD_temp;

endmodule