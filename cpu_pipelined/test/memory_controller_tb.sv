`timescale 1ns / 1ps

// Memory controller module testbench
module memory_controller_tb;

    // Parameters
    parameter SIZE_ADDR = 32;
    parameter SIZE_READ = 16;
    parameter SIZE = 48;

	// Inputs
	logic clk;
    logic clk_mem;
    logic enable;
    logic [1:0] ctrl;
    logic [31:0] alu_address; // Or 48 bits, whatever
    logic [SIZE_READ-1:0] read_mem;

	//Outputs
    logic [SIZE_ADDR-1:0] address_mem;
    logic handshake;
    logic [SIZE-1:0] read_data;
    logic [SIZE-1:0] _state_;
	
	// Instantiate the Device Under Test (DUT)
	memory_controller DUT (
        .CLK( clk ),
        .CLK_MEM( clk_mem ),
        .ENABLE( enable ),
        .Ctrl( ctrl ),
        .ADDRESS( alu_address ),
        .ReadMem( read_mem ),
        .AddressMem( address_mem ),
        .HANDSHAKE( handshake ),
        .READ( read_data ),
        ._state_( _state_ ) // For debugging
    );

	//Initialize clock
	initial begin
		clk = 1'b1;
			forever begin
			#5;
			clk = ~clk;
		end
	end
	
	//Stimulus 
    logic reset;
    clk_div clk_div_1(
        .RESET( reset ),
        .MASTER_CLK( clk ),
        .CLK_MEM( clk_mem ),
        .CLK_CPU(  )
    );
    mem_kernel mk(
        .CLK( clk ),
		.ADDRESS( address_mem ),
		.READ( read_mem )
    );
	initial begin
        $display("MEMORY CONTROLLER TESTBENCH");
		// Initialize Inputs
        enable = 1'b0;
        ctrl = 2'bxx;
        reset = 1'b1;

		// Wait 20 ns for global reset to finish
		#20;
		
		// Add stimulus here
        reset = 1'b0;
        enable = 1'b0;
        
        #20;
        enable = 1'b1;
        ctrl = 2'b10;
        alu_address = 32'H00010002;
        
        #60;
        $display("SINGULAR VALUE IN DIR: 32'H00010002");
        if( read_data == 48'Hffffffffffff )
            $display("SINGULAR VALUE: OK! (expected value:48'Hffffffffffff)");
        else
            $display("SINGULAR VALUE: FAILED...");
        #20;

        enable = 1'b0;
        alu_address = 32'H00020002;
        ctrl = 2'b00;

        #40;
        enable = 1'b1;
        alu_address = 32'H00020001;
        ctrl = 2'b11;

        #100;
        $display("MULTIPLE VALUES IN DIR: 32'H00020001, VERTICAL");
        if( read_data == 48'H00000000ffff )
            $display("MULTIPLE VALUES: OK! (expected value:48'H00000000ffff)");
        else
            $display("MULTIPLE VALUES: FAILED...");
       
        $stop;

	end
	
endmodule

