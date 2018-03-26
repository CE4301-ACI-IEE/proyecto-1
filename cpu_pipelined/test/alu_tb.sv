`timescale 1ns / 1ps

module alu_tb;

    //Inputs
    logic clk;
    logic [47:0] OPERA;
    logic [47:0] OPERB;
    logic [2:0] ALUControlE;

    //Outputs
    logic [47:0] ALUResultE;
    logic [3:0] ALUFlags;

    //Instante the DUT
    ALU DUT(
        .clk(clk),
        .OPERA(OPERA),
        .OPERB(OPERB),
        .ALUControlE(ALUControlE),
        .ALUResultE(ALUResultE),
        .ALUFlags(ALUFlags)
    );

    initial begin
        clk = 1'b0;
        forever begin
            #5
            clk = ~clk;
        end
    end

    initial begin
        OPERA = 48'b001001110001000000000011111010000000000100101100;
        OPERB = 48'b001010101111100000000001111101000000000010010110;
        ALUControlE = 3'bx;

        #20

        ALUControlE = 3'b0;
        #10
        
        ALUControlE = 3'b001;
        #10

        ALUControlE = 3'b010;
        #10

        ALUControlE = 3'b011;
        #10

        ALUControlE = 3'b100;
        #10

        ALUControlE = 3'b101;
        #10

        ALUControlE = 3'b110;
        #10

        $stop;
    end
endmodule