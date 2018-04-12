`timescale 1ns / 1ps

module RegPC #(
    parameter SIZE = 32
)(
    input logic StallF, CLK, RESET,
    input logic [SIZE-1:0] PC,
    output logic [SIZE-1:0] PCF
);

logic [SIZE-1:0] PCF_tmp;

always@(RESET)
begin
    PCF_tmp <= {SIZE{1'bx}};
end

always@(~RESET)
begin
    PCF_tmp <= {SIZE{1'b0}};
end

always@(negedge CLK & ~RESET)
begin
     if (StallF == 1'b0)
        PCF_tmp <= PC;
    else if ((StallF == 1'b1))
        PCF_tmp <= PCF_tmp;
    else
        PCF_tmp <= PC;
end

assign PCF = PCF_tmp;

endmodule