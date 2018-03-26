`timescale 1ns / 1ps

module flopr #(
    parameter SIZE = 32     
)(
    input logic CLK,
    input logic reset,
    input logic [SIZE-1:0] d,
    output logic [SIZE-1:0] q
);

logic [SIZE-1:0] tmp;

always@(negedge CLK,posedge reset)
begin
    if(reset) tmp <= 0;
    else tmp <= d;
end
assign q = tmp;
endmodule