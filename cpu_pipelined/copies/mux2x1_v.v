`timescale 1ns / 1ps
module mux2x1_v(s, d0, d1, y);
parameter WIDTH = 8;

input wire s;
input wire [WIDTH-1:0] d0, d1;
output wire [WIDTH-1:0] y;

assign y = s ? d1 : d0;
	
endmodule
