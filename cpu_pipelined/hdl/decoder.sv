`timescale 1ns / 1ps

// Decoder module
module decoder (
input logic [2:0] Op,
input logic [5:0] Funct,
input logic [4:0] Rd,
output logic [1:0] FlagWriteD,
output logic PCSrcD,
output logic RegWriteD,
output logic MemWriteD,
output logic MemtoRegD,
output logic ALUSrcD,
output logic [1:0] ImmSrcD,
output logic [1:0] RegSrc,
output logic [3:0] ALUControlD,
output logic BranchD
);

logic [9:0] controls;
bit branch_temp;
bit ALUOp;
logic [3:0] ALUControl_temp;
logic [1:0] FlagW_temp;

always@(*) begin
	
	case( Op )
									
		3'b000: 	       //Data-processing inmediate //Data-processing register
			controls = (Funct[5]) ? 10'b0000101001 : 10'b0000001001;
			
											//LDR			//STR //Memory processing
		3'b001:  	controls = (Funct[0]) ? 10'b0001111000 : 10'b1001110100;
		
		3'b010:	controls = 10'b0110100010; //B

										//LDR-Concat //STR-Concat
		3'b011: controls = (Funct[0])? 10'b0000011001:10'b0000010101;
		default: controls = 10'bx; // DEfault
		
	endcase
	
end

assign {RegSrc, ImmSrcD, ALUSrcD, MemtoRegD,
	RegWriteD, MemWriteD, branch_temp, ALUOp} = controls;

always@(*) begin

	if( ALUOp ) begin  // ALU Operation
		case( Funct[4:1] )
			4'b0000: ALUControl_temp = 4'b0000; //Vectorial sum
			4'b0001: ALUControl_temp = 4'b0110; //MUL
			4'b0010: ALUControl_temp = 4'b0010; //SUB
			4'b0011: ALUControl_temp = 4'b0111; //concatenación
			4'b0100: ALUControl_temp = 4'b0011; //ADD
			4'b1100: ALUControl_temp = 4'b0101; //Escalado
			4'b1101: ALUControl_temp = 4'b0001; //Producto Punto
			4'b1111: ALUControl_temp = 4'b0100; //CMP
			default: ALUControl_temp = 4'bx; //Default
		endcase
		
		// if bit S is activated, update flags (C & V)
		FlagW_temp[1] = Funct[0];
		FlagW_temp[0] = Funct[0] &
				(ALUControl_temp==3'b011 | ALUControl_temp==3'b010);
	end 
	else begin
		ALUControl_temp = 3'b011; // add for branch and memory processing
		FlagW_temp = 2'b00; // don't update flags
	end
	
end

assign PCSrcD = ((Rd==5'b01111) & RegWriteD) | branch_temp;
assign ALUControlD = ALUControl_temp;
assign FlagWriteD = FlagW_temp;
assign BranchD = branch_temp;

endmodule
