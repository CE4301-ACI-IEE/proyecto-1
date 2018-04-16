`timescale 1ns / 1ps
module instruction_rom #( parameter SIZE = 32 )  
( 
	input bit CLK,
	input bit Reset,
	input logic [SIZE-1:0] Address, 
	output logic [SIZE-1:0] Instr
 );

always@( posedge CLK ) begin
	if( Reset ) Instr <= 48'bx;
	else begin
		case( Address / 32'd4 )
			48'd0: Instr  <= 48'HE023C000000F;
			48'd1: Instr  <= 48'HE14004000005;
			48'd2: Instr  <= 48'HE2C004000064;
			48'd3: Instr  <= 48'HEA4084000000;
			//48'd3: Instr  <= 48'HEC3086000000;
			default: Instr <= 48'bx;
		endcase
	end
end

endmodule