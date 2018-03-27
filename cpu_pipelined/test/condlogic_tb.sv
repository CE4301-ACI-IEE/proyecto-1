`timescale 1ns / 1ps

// Condition logic module testbench
module condlogic_tb;

	// Inputs
    logic clk;
    logic reset;
    logic [3:0] cond;
    logic [3:0] alu_flags;
    logic [1:0] flag_w;
    logic pcs;
    logic reg_w;
    logic mem_w;
	
	//Outputs
    logic pc_src;
    logic reg_write;
    logic mem_write;
	
	// Instantiate the Device Under Test (DUT)
	condlogic DUT(
        .CLK( clk ),
        .Reset( reset ),
        .Cond( cond ),
        .ALUFlags( alu_flags ),
        .FlagW( flag_w ),
        .PCS( pcs ),
        .RegW( reg_w ),
        .MemW( mem_w ),
        .PCSrc( pc_src ),
        .RegWrite( reg_write ),
        .MemWrite( mem_write ),
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
		
		// Add stimulus here

	end
	
endmodule

