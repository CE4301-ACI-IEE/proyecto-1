`timescale 1ns / 1ps

// Condition logic module testbench
module condlogic_tb;

	// Inputs
    bit clk;
    bit reset;
    logic [3:0] cond;
    logic [3:0] alu_flags;
    logic [1:0] flag_w;
    bit pcs;
    bit reg_w;
    bit mem_w;
	
	//Outputs
    bit pc_src;
    bit reg_write;
    bit mem_write;
	
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
		
		// Wait 20 ns for global reset to finish
		#20;
		
		// Add stimulus here

	end
	
endmodule

