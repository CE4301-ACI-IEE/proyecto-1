`timescale 1ns / 1ps
/**
It releases the next PC value to be used in the register file to fetch the instruction
If an stall or reset is recieve, the pipe will froze or restart.
*/
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