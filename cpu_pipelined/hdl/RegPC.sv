`timescale 1ns / 1ps

module RegPC #(
    parameter SIZE = 32
)(
    input logic StallF, CLK, RESET,
    input logic [SIZE-1:0] PC,
    output logic [SIZE-1:0] PCF
);

logic [SIZE-1:0] PCF_tmp;

always@(negedge CLK)
begin
    if (RESET)
        PCF_tmp = {SIZE{1'b0}};
    else if (StallF == 1'b0)
        PCF_tmp = PC;
    else if (StallF == 1'b1)
        PCF_tmp = PCF_tmp;
end

assign PCF = PCF_tmp;

endmodule