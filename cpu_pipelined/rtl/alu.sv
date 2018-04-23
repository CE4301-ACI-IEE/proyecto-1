`timescale 1ns / 1ps
/**
This is an vectorial arithmetic unit
It can perform the normal operation without considering logic ones, 
but it can also treat register as vectors and do operations over them
it can sum vector position, it can escalate a vector and generate a escalar
using dot product. As well can create a vector concatenating two numbers into one
register, this operation is useful in memory addressing.
*/
module ALU
(	
	input logic 		clk,
	input logic[47:0] 	OPERA,
	input logic[47:0] 	OPERB,
	input logic[3:0]	ALUControlE,
	output logic[47:0] 	ALUResultE,
	output logic[3:0] 	ALUFlags
);


	logic[47:0] Result;
	logic[3:0] Flags_tmp;
	logic[15:0] PosA, PosB, PosC;

	initial begin
		Result = 0;
		PosA = 0;
		PosB = 0;
		PosC = 0;
	end
	
	always @(posedge clk) 
	begin
		PosA = OPERA[47:32];
		PosB = OPERA[31:16];
		PosC = OPERA[15:0];
		
		if(ALUControlE == 4'b0000) //Vectorial sum
		begin
			Result[47:32] 	= OPERB[47:32]+PosA;
			Result[31:16] 	= OPERB[31:16]+PosB;
			Result[15:0]	= OPERB[15:0]+PosC;	
		end else if(ALUControlE == 4'b0001) //Producto Punto
		begin
			Result = (OPERB[47:32]*PosA) + (OPERB[31:16]*PosB) + (OPERB[15:0]*PosC);
		end else if(ALUControlE == 4'b0010) //Normal Subtraction
		begin
			Result = OPERA - OPERB;
		end else if (ALUControlE==4'b0011) begin //Normal sum
			Result = OPERA + OPERB;
		end else if (ALUControlE == 4'b0100) begin //CMP
			Result = OPERA - OPERB;
		end else if(ALUControlE == 4'b0101) //Scale
		begin
			Result[47:32] 	= PosA*OPERB[15:0];
			Result[31:16] 	= PosB*OPERB[15:0];
			Result[15:0]	= PosC*OPERB[15:0];
		end else if (ALUControlE == 4'b0110) begin //Normal multiplication
			Result = OPERA * OPERB;
		end else if (ALUControlE == 4'b0111) begin //Concat
			Result[47:32] 	= 16'b0;
			Result[31:16] 	= PosC;
			Result[15:0]	= OPERB[15:0];
		end else begin
			Result = {48{1'b1}};
		end
		
		if(Result == 48'b0)
		begin
			Flags_tmp = 4'b0100;
		end else if (OPERB > OPERA) begin
			Flags_tmp = 4'b1000;
		end else if (Result > 48'b0) begin
			Flags_tmp = 4'b0;
		end else begin
			Flags_tmp = 4'b1;
		end
	end

	
	assign ALUResultE = Result;
	assign ALUFlags = Flags_tmp;



endmodule