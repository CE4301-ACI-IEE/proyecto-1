`timescale 1ns / 1ps

module dmem #( parameter SIZE = 32 )
(
    input bit CLK, WE,
	input logic [SIZE-1:0] A, WD,
	output logic [SIZE-1:0] RD
);

	logic [SIZE-1:0] RAM[63:0];

	always @ (posedge CLK) begin
		if (WE) RAM[ A[ SIZE-1:2 ] ] <= WD; //word aligned
	end

	assign RD = RAM[ A[ SIZE-1:2 ] ]; //word aligned

endmodule