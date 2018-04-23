`timescale 1ns / 1ps

// Extend module
module extend
(
	input logic [23:0] Instr,
 	input logic [1:0] ImmSrc, 
 	output logic [47:0] ExtImm
);

reg [47:0] temp_ExtImm;

always@(*) begin
	case( ImmSrc )
							//8-bit Sin signo Inmediato
		2'b00: temp_ExtImm = {40'b0,Instr[7:0]};
		
							//12-bit Inmediato
		2'b01: temp_ExtImm = {36'b0,Instr[11:0]};
		
							//24-bit 2-complemento shifted branch 
		2'b10: temp_ExtImm = {{22{Instr[23]}}, Instr[23:0], 2'b00};
		
		default: temp_ExtImm = 48'bx; //Sin definir
		
	endcase
end

assign ExtImm = temp_ExtImm;

endmodule