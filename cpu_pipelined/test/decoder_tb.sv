`timescale 1ns / 1ps

// Decoder module testbench
module testbech_pattern_tb;

	// Inputs
    // logic [31:12] instr; // real
	logic [31:0] instr; // test

	//Outputs
    logic [1:0] flag_w;
    bit pcs;
    bit reg_w;
    bit mem_w;
	bit mem_to_reg;
    bit alu_src;
    logic [1:0] imm_src;
    logic [1:0] reg_src;
    logic [2:0] alu_control;

	// Instantiate the Device Under Test (DUT)
	decoder DUT( 
        .Op( instr[27:26] ), // input
        .Funct( instr[25:20] ), // input
        .Rd( instr[15:12] ), // input
        .FlagW( flag_w ), // output
        .PCS( pcs ), // output
        .RegW( reg_w ), // output
        .MemW( mem_w ), // output
        .MemtoReg( mem_to_reg ), // output
        .ALUSrc( alu_src ), // output
        .ImmSrc( imm_src ), // output
        .RegSrc( reg_src ), // output
        .ALUControl( alu_control ) // output
         );
	
	//Stimulus 
	initial begin
		// Initialize Inputs
		instr = 32'bx;

		// Wait 20 ns for global reset to finish
		#20;
		
		// Add stimulus here
    
        // TODO

        $stop;

	end
	
endmodule

