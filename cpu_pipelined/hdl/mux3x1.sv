`timescale 1ns / 1ps
//mux use in fowarding
module mux3x1 #(
    parameter SIZE = 32
)(
    input logic [1:0] s,
    input logic [SIZE-1:0] ALUOutM, ResultW, RegFile,
    output logic [SIZE-1:0] Src
);
    logic [SIZE-1:0] reg_tmp;

    always@(*)
    begin
        case (s)
            2'b00: reg_tmp = RegFile;
            2'b01: reg_tmp = ResultW;
            2'b10: reg_tmp = ALUOutM;
        endcase
    end

    assign Src = reg_tmp;
endmodule