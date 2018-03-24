`timescale 1ns / 1ps
module instruction_rom #( parameter SIZE = 32 )  
( 
	input bit CLK,
	input bit RESET,
	input logic [SIZE-1:0] address, 
	output logic [SIZE-1:0] instr
 );

logic [SIZE-1:0] instruction;

always@( posedge CLK ) begin
	if( RESET ) instruction <= {32{1'b1}};
	else begin
		case( address / 32'd4 )
			32'd0: instruction  <= 32'HE04F000F;
			32'd1: instruction  <= 32'HE2802005;
			32'd2: instruction  <= 32'HE280300C;
			32'd3: instruction <= 32'HE2437009;
			32'd4: instruction <= 32'HE1874002;
			32'd5: instruction <= 32'HE0035004;
			32'd6: instruction <= 32'HE0855004;
			32'd7: instruction <= 32'HE0558007;
			32'd8: instruction <= 32'H0A00000C;
			32'd9: instruction <= 32'HE0538004;
			32'd10: instruction <= 32'HAA000000;
			32'd11: instruction <= 32'HE2805000;
			32'd12: instruction <= 32'HE0578002;
			32'd13: instruction <= 32'HB2857001;
			32'd14: instruction <= 32'HE0477002;
			32'd15: instruction <= 32'HE5837054;
			32'd16: instruction <= 32'HE5902060;
			32'd17: instruction <= 32'HE08FF000;
			32'd18: instruction <= 32'HE280200E;
			32'd19: instruction <= 32'HEA000001;
			32'd20: instruction <= 32'HE280200D;
			32'd21: instruction <= 32'HE280200A;
			32'd22: instruction <= 32'HE5802064;
			default: instruction <= 32'Hx;
		endcase
	end
end

assign instr = instruction;

endmodule