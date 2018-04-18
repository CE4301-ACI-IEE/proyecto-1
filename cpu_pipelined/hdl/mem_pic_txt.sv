`timescale 1ns / 1ps

module mem_pic_txt #( parameter SIZE = 48 )
(
    input logic CLK, WE,
	input logic [SIZE-1:0] A, WD,
	output logic [SIZE-1:0] RD
);

	(* ram_init_file = "mem_pic_txt.hex" *) logic [SIZE-1:0] RAM[8:0];

	always @ (posedge CLK) begin
		if (WE) RAM[ A[ SIZE-1:2 ] ] <= WD; //word aligned
	end

	assign RD = RAM[ A[ SIZE-1:2 ] ]; //word aligned

endmodule