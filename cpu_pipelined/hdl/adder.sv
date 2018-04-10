`timescale 1ns / 1ps

module adder #(
    parameter SIZE = 32
)(
    input logic [SIZE-1:0] a,
    input logic [SIZE-1:0] b,
    output logic [SIZE-1:0] c
);
    logic [SIZE-1:0] tmp;
    always_comb
    begin
        tmp <= a+b;
    end
    assign c = tmp;
endmodule