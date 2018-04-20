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
			48'H000000000000: Instr <= 48'He83006000002;
			48'H000000000001: Instr <= 48'He14084000001;
			48'H000000000002: Instr <= 48'He83008000002;
			48'H000000000003: Instr <= 48'He14084000001;
			48'H000000000004: Instr <= 48'He8300a000002;
			48'H000000000005: Instr <= 48'He02084000002;
			48'H000000000006: Instr <= 48'He9300c000002;
			48'H000000000007: Instr <= 48'He403c0fffff7;
			default: Instr <= 48'bx;
		endcase
	end
end
endmodule