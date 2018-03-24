`timescale 1ns / 1ps
module mux4x1_v(s, d0, d1, d2, d3, y);
parameter WIDTH = 8;

input wire [1:0] s;
input wire [WIDTH-1:0] d0, d1, d2, d3;
output wire [WIDTH-1:0] y;

reg [WIDTH-1:0] s_temp;

always@(*) begin
	case(s)
		2'b00: s_temp = d0;
		2'b01: s_temp = d1;
		2'b10: s_temp = d2;
		2'b11: s_temp = d03;
	endcase
end

assign y = s_temp;

endmodule
