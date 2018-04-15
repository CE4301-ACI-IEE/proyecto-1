`timescale 1ns / 1ps

module RegPC #(
    parameter SIZE = 32
)(
    input logic StallF, CLK, RESET,
    input logic [SIZE-1:0] PC,
    output logic [SIZE-1:0] PCF
);

logic [SIZE-1:0] PCF_tmp;

logic [2:0] flags;
logic condition;

always@(negedge CLK or negedge RESET)
begin
    flags = {StallF,RESET,condition};
    case (flags)
        3'b11_: begin PCF_tmp <= {SIZE{1'bx}}; condition = 1'bx; end
        3'b00x: begin PCF_tmp <= {SIZE{1'b0}}; condition = 1'b1; end
        3'b101: PCF_tmp <= PCF_tmp;
        3'b001: PCF_tmp <= PC;
    endcase
end

assign PCF = PCF_tmp;

endmodule