`timescale 1ns / 1ps
module instruction_rom #( parameter SIZE = 32)
(
	input logic CLK,
	input logic Reset,
	input logic [SIZE-1:0] Address,
	output logic [SIZE-1:0] Instr
);
always@(posedge CLK) begin
	if( Reset ) Instr <= 48'bx;
	else begin
		case (Address/48'd4)
			48'H000000000000: Instr <= 48'He04082000003;
			48'H000000000001: Instr <= 48'He0f840000001;
			48'H000000000002: Instr <= 48'H0503c0fffffc;
			default: Instr <= 48'bx;
		endcase
	end
end
endmodule