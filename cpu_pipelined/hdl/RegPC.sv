`timescale 1ns / 1ps

module RegPC #(
    parameter SIZE = 32
)(
    input logic StallF, CLK,
    input logic [SIZE-1:0] PC,
    output logic [SIZE-1:0] PCF
);

logic [SIZE-1:0] PCF_tmp, PCF_store;

always@(negedge CLK)
begin
    if (StallF)
    begin
        PCF_tmp = {SIZE{1'bx}};
    end else begin
        PCF_tmp = PCF_store;
    end
end

always@(posedge CLK)
begin
    PCF_store = PC;
end


assign PCF = PCF_tmp;
endmodule