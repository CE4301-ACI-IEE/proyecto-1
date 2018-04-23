`timescale 1ns / 1ps

module mux2x1 #(parameter SIZE = 32)
(
    input logic s,
    input logic [SIZE-1:0] d0,
    input logic [SIZE-1:0] d1,
    output logic [SIZE-1:0] y
);
always@(*) begin 
    case( s )
        1'b0: y = d0;
        1'b1: y = d1;
        default: y = 0;
    endcase
end

endmodule