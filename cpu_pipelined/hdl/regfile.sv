`timescale 1ns / 1ps
module regfile #( 
    parameter SIZE = 32,
    parameter AMOUNT_REG = 4 )
(
input bit CLK,
input bit WE3,
input logic [AMOUNT_REG-1:0] RA1,
input logic [AMOUNT_REG-1:0] RA2,
input logic [AMOUNT_REG-1:0] RA3,
input logic [SIZE-1:0] WD3,
input logic [SIZE-1:0] R15,
output logic [SIZE-1:0] RD1,
output logic [SIZE-1:0] RD2
);

logic [SIZE-1:0] rf[14:0];

always@(posedge CLK) begin
	if( WE3 ) rf[RA3] <= WD3;
end

assign RD1 = (RA1 == 4'b1111) ? R15 : rf[RA1];
assign RD2 = (RA2 == 4'b1111) ? R15 : rf[RA2];

endmodule