`timescale 1ns / 1ps
module flopr_v(clk, reset, d, q);
parameter WIDTH = 8;

input wire clk;
input wire reset;
input wire [WIDTH-1:0] d;
output wire [WIDTH-1:0] q;

reg [WIDTH-1:0] temp;

always@(negedge clk, posedge reset) begin
	if(reset) temp <= 0;
	else temp <= d;
end

assign q = temp;


endmodule
