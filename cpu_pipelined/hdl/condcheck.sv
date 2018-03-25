`timescale 1ns / 1ps

// Condition check module
module condcheck (
input logic [3:0] Cond,
input logic [3:0] Flags,
output bit CondEx
);

bit neg, zero, carry, overflow, ge;
bit CondEx_temp;

assign {neg, zero, carry, overflow} = Flags;
assign ge = (neg == overflow);

always@(*) begin
	case( Cond )
		4'b0000: CondEx_temp = zero; 				// EQ
		4'b0001: CondEx_temp = ~zero; 				// NE
		4'b0010: CondEx_temp = carry; 				// CS
		4'b0011: CondEx_temp = ~carry; 				// CC
		4'b0100: CondEx_temp = neg; 				// MI
		4'b0101: CondEx_temp = ~neg; 				// PL
		4'b0110: CondEx_temp = overflow; 			// VS
		4'b0111: CondEx_temp = ~overflow; 			// VC
		4'b1000: CondEx_temp = carry & ~zero; 		// HI
		4'b1001: CondEx_temp = ~(carry & ~zero); 	// LS
		4'b1010: CondEx_temp = ge; 					// GE
		4'b1011: CondEx_temp = ~ge; 				// LT
		4'b1100: CondEx_temp = ~zero & ge; 			// GT
		4'b1101: CondEx_temp = ~(~zero & ge); 		// LE
		4'b1110: CondEx_temp = 1'b1; 				// Always
		default: CondEx_temp = 1'bx; 				// Default
	endcase
end

assign CondEx = CondEx_temp;

endmodule
