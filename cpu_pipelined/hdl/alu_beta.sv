`timescale 1ns / 1ps
module alu_beta (
	input logic clk,
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [2:0] CtrlFunc,
    output logic [31:0] Result,
    output logic [3:0] Flags
);

logic [31:0] Result_temp;
logic [3:0] Flags_temp;

always@(*) begin
	case(CtrlFunc)
		3'b000 : Result_temp <= A & B; //AND
		3'b101 : Result_temp <= A | B; //OR
		3'b011 : Result_temp <= A + B; //ADD
		3'b001 : Result_temp <= A ^ B; //XOR
		3'b010 : Result_temp <= A - B; //SUB
		//3'b110 : Result_temp <= A * B; //MUL
		3'b100 : Result_temp <= A - B; //CMP
		default: Result_temp <= {32{1'b1}};
	endcase
end

//always @(negsedge clk)     //para simular	(Result), para placa (negedge clk)			     //flags  [N,Z,C,V]
always @(Result_temp)
begin
	if(Result_temp == 32'd0)
		Flags_temp <= 4'b0100;

	else if(B > A)
		Flags_temp <= 4'b1000;
		
	else if(Result_temp > 32'd0)
		Flags_temp <= 4'b0000;
	else Flags_temp <= 4'b1111;
end

assign Flags = Flags_temp;
assign Result = Result_temp;

endmodule