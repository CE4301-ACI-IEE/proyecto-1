`timescale 1ns / 1ps

module mux4x1 #(parameter SIZE = 32)
(
    input logic [1:0] s,
    input logic [SIZE-1:0] d0,
    input logic [SIZE-1:0] d1,
    input logic [SIZE-1:0] d2,
    input logic [SIZE-1:0] d3,
    output logic [SIZE-1:0] y
);

logic [SIZE-1:0] r_temp;

always @(*)
begin
    case (s)
        2'b00: r_temp = d0;
        2'b01: r_temp = d1;
        2'b01: r_temp = d2;
        2'b11: r_temp = d3;
    endcase
end

assign y = r_temp;

endmodule