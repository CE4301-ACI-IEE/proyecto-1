// Date: 04/12/18

`timescale 1ns / 1ps

// Memory access testbench module
module memory_access_tb;

	// Inputs
	logic clk;
    logic clk_mem;
    logic reset;
    logic enable;
    logic [2:0] ctrl;
    logic [31:0] address_input;

	//Outputs
    logic [47:0] read_output;
    logic handshake;
	
	// Instantiate the Device Under Test (DUT)
	memory_access DUT(
        .CLK( clk ),
        .CLK_MEM(  clk_mem),
        .RESET( reset ),
        .ENABLE( enable ),
        .CTRL( ctrl ),
        .ADDRESS( address_input ),
        .READ( read_output ),
        .HANDSHAKE( handshake )
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
	clk_div ck(
        .RESET( reset ),
        .MASTER_CLK( clk ),
        .CLK_MEM( clk_mem ),
        .CLK_CPU(  )
    );
	initial begin
        $display("MEMORY ACCESS MODULE TESTBENCH");
		// Initialize Inputs
        enable = 1'b0;
        ctrl = 3'b000;
        address_input = 32'H0;
        reset = 1'b1;
		
		// Wait 40 ns for global reset to finish
		#40;
		
		// Add stimulus here
        reset = 1'b0;
        ctrl = 3'b100;
        address_input = 32'H00010002;
        #20;

        enable = 1'b1; // Last operation is completed in 7 cycles.
        #20; // Wait 2 cycles
        ctrl = 3'bx;
        address_input = 32'Hx;
        #50;

        $display("TEST 1: =");
        if( enable & handshake ) begin
            if( read_output == 48'Hffffffffffff ) begin
                $display("SINGULAR VALUE FROM KERNEL MEMORY: OK! (expected value:48'Hffffffffffff)");
            end
            else begin
                $display("SINGULAR VALUE FROM KERNEL MEMORY: FAILED... (expected value:48'Hffffffffffff)");
            end
            enable = 1'b0;
        end
        #40;

        enable = 1'b0;
        address_input = 32'H00020001;
        ctrl = 3'b110;
        #20;

        enable = 1'b1;
        #20;
        address_input = 32'Hx;
        ctrl = 3'bx;
        #90;
        $display("TEST 2: =");
        if( enable & handshake ) begin
            if( read_output == 48'H00000000ffff ) begin
                $display("MULTIPLE VALUES FROM KERNEL MEMORY: OK! (expected value:48'Hffffffffffff)");
            end
            else begin
                $display("MULTIPLE VALUES FROM KERNEL MEMORY: FAILED... (expected value:48'Hffffffffffff)");
            end
            enable = 1'b0;
        end
        
        /*************************************************************************************************************/
        #40;
        ctrl = 3'b101;
        address_input = 32'H00010002;
        
        #20;
        enable = 1'b1; // Last operation is completed in 7 cycles.
        #70; // Wait 7 cycles
        $display("TEST 3: =");
        if( enable & handshake ) begin
            if( read_output == 48'H0000000000b7 ) begin
                $display("SINGULAR VALUE FROM PICTURE MEMORY: OK! (expected value:48'H0000000000b7)");
            end
            else begin
                $display("SINGULAR VALUE FROM PICTURE MEMORY: FAILED... (expected value:48'H0000000000b7)");
            end
            enable = 1'b0;
        end
        
        address_input = 32'H00020001;
        ctrl = 3'b111;
        #20;

        enable = 1'b1;
        #20;
        address_input = 32'Hx;
        ctrl = 3'bx;
        #90;
        $display("TEST 4: =");
        if( enable & handshake ) begin
            if( read_output == 48'H00b100b300b3 ) begin
                $display("MULTIPLE VALUE IN PICTURE MEMORY: OK! (expected value:48'H00b100b300b3)");
            end
            else begin
                $display("MULTIPLE VALUE IN PICTURE MEMORY: FAILED... (expected value:48'H00b100b300b3)");
            end
            enable = 1'b0;
        end

	end
	
endmodule

