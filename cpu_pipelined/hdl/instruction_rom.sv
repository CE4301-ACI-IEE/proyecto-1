`timescale 1ns / 1ps
module instruction_rom #( parameter SIZE = 32 )  
( 
	input bit CLK,
	input bit Reset,
	input logic [SIZE-1:0] Address, 
	output logic [SIZE-1:0] Instr
 );

always@( posedge CLK ) begin
	if( Reset ) Instr <= 32'HE04F000F;
	else begin
		case( Address / 32'd4 )
			32'd0: Instr  <= 32'HE04F000F;
			32'd1: Instr  <= 32'HE2802005;
			32'd2: Instr  <= 32'HE5802064;
			default: Instr <= 32'bx;
		endcase
	end
end

endmodule