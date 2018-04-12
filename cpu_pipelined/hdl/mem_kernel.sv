`timescale 1ns / 1ps
module mem_kernel #( parameter SIZE = 16 )
(
	input logic CLK,
	input logic [31:0] ADDRESS,
	output logic [SIZE-1:0] READ
);
always_ff@( posedge CLK ) begin
	case( ADDRESS )
		32'H00000000: READ <= 16'H0;
		32'H00000001: READ <= 16'Hffff;
		32'H00000002: READ <= 16'H0;
		32'H00010000: READ <= 16'Hffff;
		32'H00010001: READ <= 16'H5;
		32'H00010002: READ <= 16'Hffff;
		32'H00020000: READ <= 16'H0;
		32'H00020001: READ <= 16'Hffff;
		32'H00020002: READ <= 16'H0;
		default: READ <= 16'b0;
	endcase
end

endmodule
