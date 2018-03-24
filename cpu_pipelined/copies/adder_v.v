`timescale 1ns / 1ps
module adder_v(clk, a, b, y );
parameter WIDTH = 8;

input [WIDTH-1:0] a, b;
input wire clk;
output [WIDTH-1:0] y;

reg [31:0] temp; 

always@(*) temp <= a + b;

assign y = temp;

endmodule
