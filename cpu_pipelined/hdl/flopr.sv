`timescale 1ns / 1ps

module flopr #(
    parameter SIZE = 32     
)(
    input logic CLK,
    input logic reset,
    input logic [SIZE-1:0] d,
    output logic [SIZE-1:0] q
);

always@( negedge CLK, posedge reset )begin
    if( reset ) q <= {32{1'b0}};
    else q <= d;
end
endmodule