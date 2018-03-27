`timescale 1ns / 1ps

module mux2x1 #(parameter SIZE = 32)
(
    input logic s,
    input logic [SIZE-1:0] d0,
    input logic [SIZE-1:0] d1,
    output logic [SIZE-1:0] y
);

assign y = s ? d1:d0;

endmodule