`timescale 1ns / 1ps

// Resettable flip-flop with enable module 
module flopenr #(
    parameter WIDTH = 8
)
(
    input logic CLK,
    input logic Reset,
    input logic EN,
    input logic [WIDTH-1:0] D,
    output logic [WIDTH-1:0] Q
);

always@(negedge CLK, posedge Reset) begin
	if( Reset ) Q <= {WIDTH{1'b0}};
	else if( EN ) Q <= D;
end

endmodule
