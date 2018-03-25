`timescale 1ns / 1ps

module adder #(
    parameter SIZE = 32
)(
    input bit CLK,
    input logic [SIZE-1:0] a,
    input logic [SIZE-1:0] b,
    output logic [SIZE-1:0] c
);
    logic [SIZE-1:0] tmp;
    always@(*)
    begin
        tmp <= a+b;
    end
    assign c = tmp;
endmodule