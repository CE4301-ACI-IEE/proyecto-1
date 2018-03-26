`timescale 1ns / 1ps

// Resettable flip-flop with enable module 
module flopenr #(
    parameter WIDTH = 8
)
(
    input bit CLK,
    input bit Reset,
    input bit EN,
    input logic [WIDTH-1:0] D,
    output logic [WIDTH-1:0] Q
);

always@(negedge CLK, posedge Reset) begin
	if( Reset ) Q <= {WIDTH{1'b0}};
	else if( EN ) Q <= D;
end

endmodule
