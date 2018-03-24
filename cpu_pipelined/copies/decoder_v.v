`timescale 1ns / 1ps
module decoder_v(
input
	wire [1:0] Op,
	wire [5:0] Funct,
	wire [3:0] Rd,
output
	wire [1:0] FlagW,
	wire PCS,
	wire RegW,
	wire MemW,
	wire MemtoReg,
	wire ALUSrc,
	wire [1:0] ImmSrc,
	wire [1:0] RegSrc,
	wire [2:0] ALUControl
);

reg [9:0] controls;
wire Branch;
wire ALUOp;
reg [2:0] ALUControl_temp;
reg [1:0] FlagW_temp;

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

	if( ALUOp ) begin  // Instruccion?
		case( Funct[4:1] )
			4'b0100: ALUControl_temp = 3'b011; //ADD
			4'b0010: ALUControl_temp = 3'b010; //SUB
			4'b0000: ALUControl_temp = 3'b000; //AND
			4'b1100: ALUControl_temp = 3'b101; //ORR
			4'b1101: ALUControl_temp = 3'b001; //XOR
			4'b0001: ALUControl_temp = 3'b110; //MUL
			4'b1111: ALUControl_temp = 3'b100; //CMP
			default: ALUControl_temp = 3'b111; //Default
		endcase
		
		//Actualiza flags si bit S es activado (C & V)
		FlagW_temp[1] = Funct[0];
		FlagW_temp[0] = Funct[0] &
				(ALUControl_temp==3'b011 | ALUControl_temp==3'b010);
	end 
	else begin
		ALUControl_temp = 3'b011; //Suma para branch
		FlagW_temp = 2'b00; //Sin actualizar flags
	end
	
end

assign PCS = ((Rd==4'b1111) & RegW) | Branch;
assign ALUControl = ALUControl_temp;
assign FlagW = FlagW_temp;

endmodule
