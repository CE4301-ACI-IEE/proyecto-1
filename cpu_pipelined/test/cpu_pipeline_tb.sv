`timescale 1ns / 1ps

// CPU module testbench
module cpu_pipeline_tb;

    parameter SIZE = 48;

	// Inputs
	logic clk;
    logic reset;
    logic [SIZE-1:0] instr;
    logic [SIZE-1:0] read_data;

	// Outputs
    logic mem_write;
    logic [SIZE-1:0] pc;
    logic [SIZE-1:0] addr_data;
    logic [SIZE-1:0] write_data;

    // Debug outputs
    logic pc_src;
    logic [31:0] pc_plus4;
    logic [3:0] ra_1, ra_2;
    logic [31:0] rd_1, rd_2;
    logic [3:0] alu_flags;
	
	// Instantiate the Device Under Test (DUT)
	cpu DUT(
        .CLK( clk ),
        .Reset( reset ),
        .Instr( instr ),
        .ReadDataM( read_data ),
        .MemWriteM( mem_write ),
        .PCF( pc ),
        .ALUOutM( addr_data ),
        .WriteDataM( write_data ),
        .MemoryControl()
        // Test wires
        //.PCSrc( pc_src ),
        //.PCPlus4( pc_plus4 ),
        //.RA1( ra_1 ),
        //.RA2( ra_2 ),
        //.RD1( rd_1 ),
        //.RD2( rd_2 ),
        //.ALUFlags( alu_flags )
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
    instruction_rom ir(
        .CLK( clk ),
        .Reset( reset ),
        .Address( pc ),
        .Instr( instr )
    );

    dmem dm(
        .CLK( clk ),
        .WE( mem_write ),
        .A( addr_data ),
        .WD( write_data ),
        .RD( read_data )
    ); 
	initial begin
		// Initialize Inputs
        reset = 1'b1;
		
		// Wait 20 ns for global reset to finish
		#20;
		
		// Add stimulus here
        reset = 1'b0;
        #60;

        $stop;

	end
	
endmodule

