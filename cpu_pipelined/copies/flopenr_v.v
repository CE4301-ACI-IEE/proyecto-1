`timescale 1ns / 1ps
module flopenr_v(clk, reset, en, d, q);
parameter WIDTH = 8;

input wire clk;
input wire reset;
input wire en;
input wire [WIDTH-1:0] d;
output wire [WIDTH-1:0] q;

reg [WIDTH-1:0] q_temp;
always@(negedge clk, posedge reset) begin
	if(reset) q_temp <= {WIDTH{1'b1}};
	else if(en) q_temp <= d;
end
assign q = q_temp;
endmodule
