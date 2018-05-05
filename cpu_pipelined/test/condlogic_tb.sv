`timescale 1ns / 1ps

// Condition logic module testbench
module condlogic_tb;

	// Inputs
    logic clk;
    logic reset;
    logic [3:0] cond;
    logic [3:0] alu_flags;
    logic [1:0] flag_w,flagsE;
	
	//Outputs
    logic [1:0] flags;
    logic condexe;
	
	// Instantiate the Device Under Test (DUT)
	condlogic DUT(
        .CLK( clk ),
        .Reset( reset ),
        .CondE( cond ),
        .ALUFlags( alu_flags ),
        .FlagWriteE( flag_w ),
        .FlagsE( flagsE ),
        .Flags( flags ),
        .CondExE( condexe )
    );

	//Initialize clock
	initial begin
		clk = 1'b0;
			forever begin
			#5;
			clk = ~clk;
		end
	end
	
	//Stimulus 
	initial begin
		// Initialize Inputs
        reset = 1'b1;
		cond = 4'b1110;     // AL or none (Always/unconditional)
        alu_flags = 4'b0000;
        flag_w = 2'b00;

		// Wait 20 ns for global reset to finish
		#20;
        
        alu_flags = 4'd0;
        flag_w = 2'd0;
        flagsE = 2'd0;
        #10;
        
        alu_flags = 4'd1;
        flag_w = 2'd1;
        flagsE = 2'd1;
        #10;

        alu_flags = 4'd2;
        flag_w = 2'd0;
        flagsE = 2'd1;
        #10;

        alu_flags = 4'd3;
        flag_w = 2'd0;
        flagsE = 2'd0;
        #10;

        alu_flags = 4'd4;
        flag_w = 2'd2;
        flagsE = 2'd1;
        #10;

	end
	
endmodule

