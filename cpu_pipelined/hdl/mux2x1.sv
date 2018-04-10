`timescale 1ns / 1ps

module mux2x1 #(parameter SIZE = 32)
(
    input logic s,
    input logic [SIZE-1:0] d0,
    input logic [SIZE-1:0] d1,
    output logic [SIZE-1:0] y
);
always_comb
begin 
	case(s)
		0: y <= d0;
		1: y <= d1;
		default: y<=d0;
	endcase
end

endmodule