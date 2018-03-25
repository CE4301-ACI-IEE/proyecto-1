`timescale 1ns / 1ps

// Decoder module
module decoder (
input logic [1:0] Op,
input logic [5:0] Funct,
input logic [3:0] Rd,
output logic [1:0] FlagW,
output bit PCS,
output bit RegW,
output bit MemW,
output bit MemtoReg,
output bit ALUSrc,
output logic [1:0] ImmSrc,
output logic [1:0] RegSrc,
output logic [2:0] ALUControl
);

logic [9:0] controls;
bit Branch;
bit ALUOp;
logic [2:0] ALUControl_temp;
logic [1:0] FlagW_temp;

always@(*) begin
	
	case( Op )
									
		2'b00: 	       //Data-processing inmediate //Data-processing register
			controls = (Funct[5]) ? 10'b0000101001 : 10'b0000001001;
			
													//LDR				  //STR
		2'b01:  	controls = (Funct[0]) ? 10'b0001111000 : 10'b1001110100;
		
		2'b10:	controls = 10'b0110100010; //B
		
		default: controls = 10'bx; //Sin implementar
		
	endcase
	
end

assign {RegSrc, ImmSrc, ALUSrc, MemtoReg,
	RegW, MemW, Branch, ALUOp} = controls;

always@(*) begin

	if( ALUOp ) begin  // ALU Operation
		case( Funct[4:1] )
			4'b0100: ALUControl_temp = 3'b011; //ADD
			4'b0010: ALUControl_temp = 3'b010; //SUB
			4'b0000: ALUControl_temp = 3'b000; //AND
			4'b1100: ALUControl_temp = 3'b101; //ORR
			4'b1101: ALUControl_temp = 3'b001; //XOR
			4'b0001: ALUControl_temp = 3'b110; //MUL
			4'b1111: ALUControl_temp = 3'b100; //CMP
			default: ALUControl_temp = 3'bx; //Default
		endcase
		
		// if bit S is activated, update flags (C & V)
		FlagW_temp[1] = Funct[0];
		FlagW_temp[0] = Funct[0] &
				(ALUControl_temp==3'b011 | ALUControl_temp==3'b010);
	end 
	else begin
		ALUControl_temp = 3'b011; // add for branch
		FlagW_temp = 2'b00; // don't update flags
	end
	
end

assign PCS = ((Rd==4'b1111) & RegW) | Branch;
assign ALUControl = ALUControl_temp;
assign FlagW = FlagW_temp;

endmodule