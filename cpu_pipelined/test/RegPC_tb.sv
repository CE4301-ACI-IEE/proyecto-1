`timescale 1ns / 1ps

module RegPC_tb;

logic reset, clk, stallf;
logic [31:0] PC;

logic [31:0] PCF;

RegPC DUT(.CLK(clk),
          .StallF(stallf),
          .RESET(reset),
          .PC(PC),
          .PCF(PCF));

initial begin
    clk = 1'b0;
    forever begin
        #5
        clk = ~clk;
    end
end

initial begin
    
end

initial begin
    PC = 32'b0;
    reset = 1'b1;
    stallf = 1'b1;
    #20
    reset = 1'b0;
    stallf = 1'b0;
    forever begin
        #10
        PC = PC+32'd4;        
    end
end

endmodule
