`timescale 1ns / 1ps

//Copy this content to create a testbech file
module condcheck_tb;

	// Inputs
	logic [3:0] cond;
    logic [3:0] flags;

	//Outputs
    bit cond_ex;
	
	// Instantiate the Device Under Test (DUT)
	condcheck DUT(
        .Cond( cond ),
        .Flags( flags ),
        .CondEx( cond_ex )
    );
	
	//Stimulus 
	initial begin
		// Initialize Inputs
		cond = 4'bx;
        flags = 4'bx;

		// Wait 20 ns for global reset to finish
		#20;
		
		// Add stimulus here
        cond = 4'b0000;     // EQ (Equal)
        flags = 4'b0100;
        #10;

        cond = 4'b0001;     // NE (Not equal)
        flags = 4'b0000;
        #10;

        cond = 4'b0010;     // CS/HS (Carry set, unsigned higher or same)
        flags = 4'b0010;
        #10;

        cond = 4'b0011;     // CC/LO (Carry clear, unsigned lower)
        flags = 4'b0000;
        #10;

        cond = 4'b0100;     // MI (Negative)
        flags = 4'b1000;
        #10;

        cond = 4'b0101;     // PL (Positive)
        flags = 4'b0000;
        #10;

        cond = 4'b0110;     // VS (Overflow)
        flags = 4'b0001;
        #10;

        cond = 4'b0111;     // VC (No overflow)
        flags = 4'b0000;
        #10;

        cond = 4'b1000;     // HI (Unsigned higher)
        flags = 4'b0010;
        #10;

        cond = 4'b1001;     // LS (Unsigned lower or same)
        flags = 4'b0000;
        #10;
        
        cond = 4'b1010;     // GE (Signed greather than or equal)
        flags = 4'b0110;
        #10;

        cond = 4'b1011;     // LT (Signed less than)
        flags = 4'b0001;
        #10;

        cond = 4'b1100;     // GT (Signed greather than)
        flags = 4'b0000;
        #10;

        cond = 4'b1101;     // LE (Signed less than or equal)
        flags = 4'b0100;
        #10;

        cond = 4'b1110;     // AL or none (Always/unconditional)
        flags = 4'b0000;
        #10;

        $stop;

	end
	
endmodule

