`timescale 1ns / 1ps

// Memory controller module testbench
module memory_controller_tb;

	// Inputs
    logic clk;
    logic reset;
    logic enable;
    logic [1:0] ctrl;
    logic [1:0] index_ctrl;
    logic [47:0] address_controller;
    logic [15:0] read_mem;

	//Outputs
    logic [31:0] addr_mem;
    logic handshake;
    logic [47:0] read_controller; 

	// Instantiate the Device Under Test (DUT)
	memory_controller DUT (
        .CLK( clk ),
        .RESET( reset ),
        .ENABLE( enable ),
        .Ctrl( ctrl ),
        .IndexCtrl( index_ctrl ),
        .ADDRESS( address_controller ),
        .ReadMem( read_mem ),
        .AddressMem( addr_mem ),
        .HANDSHAKE( handshake ),
        .READ( read_controller )
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
    mem_kernel mk(
        .address( addr_mem[3:0] ),
        .clock( clk ),
        .data(  ),
        .wren( 1'b0 ),
        .q( read_mem )
    );
	initial begin
        $display("MEMORY CONTROLLER TESTBENCH");
		// Initialize Inputs
        index_ctrl = 2'b10;
        enable = 1'b0;
        ctrl = 2'bxx;
        address_controller = 32'bx;
        reset = 1'b1;

		// Wait 20 ns for global reset to finish
		#20;
		
		// Add stimulus here
        reset = 1'b0;
        enable = 1'b0;
        #20; // wait 20 ns

        enable = 1'b1;
        ctrl = 2'b10;
        address_controller = 32'H00000002;
        #20; // wait 2 cycles // It is expected that this cycles do not generate error
        address_controller = 32'Hx; // Error data. // Without error
        #30; // wait 3 cycles
        $display("SINGULAR VALUE IN DIR: 32'H00000002");
        if( read_controller == 48'H000000000001 ) begin
            $display("SINGULAR VALUE: OK! (expected value:48'H000000000001)");
            enable = 0;
        end
        else
            $display("SINGULAR VALUE: FAILED...");
        #50; // wait 5 cycles
        
        enable = 1'b0;
        address_controller = 32'H00020002;
        ctrl = 2'b00;

        #40; // wait 4 cycles
        enable = 1'b1; 
        address_controller = 32'H00000000;
        ctrl = 2'b01;

        #60;
        //address_controller = 32'Hx;
        //ctrl = 2'bx;
        #30;
        $display("MULTIPLE VALUES IN DIR: 32'H00020001, VERTICAL");
        if( read_mem == 48'H00000000ffff ) begin
            $display("MULTIPLE VALUES: OK! (expected value:48'H00000000ffff)");
            enable = 0;
        end
        else
            $display("MULTIPLE VALUES: FAILED...");

        #100;
        $stop;
        /*address_controller = 32'H0;
        ctrl = 2'b0;
        #40; // wait 4 cycles               
        $stop;*/
        
	end
	
endmodule

