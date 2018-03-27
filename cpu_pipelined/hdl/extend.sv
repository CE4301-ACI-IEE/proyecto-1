`timescale 1ns / 1ps

// Extend module
module extend
(
	input logic [23:0] Instr,
 	input logic [1:0] ImmSrc, 
 	output logic [31:0] ExtImm
);

reg [31:0] temp_ExtImm;

always@(*) begin
	case( ImmSrc )
							//8-bit Sin signo Inmediato
		2'b00: temp_ExtImm = {24'b0,Instr[7:0]};
		
							//12-bit Inmediato
		2'b01: temp_ExtImm = {20'b0,Instr[11:0]};
		
							//24-bit 2-complemento shifted branch 
		2'b10: temp_ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00};
		
		default: temp_ExtImm = 32'bx; //Sin definir
		
	endcase
end

assign ExtImm = temp_ExtImm;

endmodule