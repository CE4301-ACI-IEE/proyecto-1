`timescale 1ns / 1ps

module mux2x1 #(parameter SIZE = 32)
(
    input logic s,
    input logic [SIZE-1:0] d0,
    input logic [SIZE-1:0] d1,
    output logic [SIZE-1:0] y
);
always@(*)
begin 
	if(s) y = d1;
	else y = d0;
end

endmodule