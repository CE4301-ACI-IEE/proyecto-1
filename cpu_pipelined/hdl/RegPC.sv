`timescale 1ns / 1ps
module RegPC #(
    parameter SIZE = 32
)(
    input logic StallF, CLK, RESET,
    input logic [SIZE-1:0] PC,
    output logic [SIZE-1:0] PCF
);

logic [SIZE-1:0] PCF_tmp;

always@(negedge CLK) begin
    if( RESET ) begin
        PCF_tmp <= 48'HFFFFFFFFFFFC;
    end
    else if( StallF ) begin
		PCF_tmp <= PCF_tmp;
	 end
    else begin
		PCF_tmp <= PC;
    end
end

assign PCF = PCF_tmp;

endmodule