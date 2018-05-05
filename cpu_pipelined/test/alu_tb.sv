`timescale 1ns / 1ps

module alu_tb;

    //Inputs
    logic clk;
    logic [47:0] OPERA;
    logic [47:0] OPERB;
    logic [3:0] ALUControlE;

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
        ALUControlE = 4'b0;

        #20

        ALUControlE = 4'b0;
        #10
        
        ALUControlE = 4'b0001;
        #10

        ALUControlE = 4'b0010;
        #10

        ALUControlE = 4'b0011;
        #10

        ALUControlE = 4'b0100;
        #10

        ALUControlE = 4'b0101;
        #10

        ALUControlE = 4'b0110;
        #10

        $stop;
    end
endmodule
