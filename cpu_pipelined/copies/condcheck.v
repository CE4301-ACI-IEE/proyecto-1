`timescale 1ns / 1ps
module condcheck;
	reg clk;
	// Inputs
	reg [3:0] Cond;
	reg [3:0] Flags;
	//Output
	wire CondEx;
	reg x;
	// Instantiate the Unit Under Test (UUT)
	condcheck_v uut (
		.Cond(Cond), .Flags(Flags), .CondEx(CondEx)
	);

	initial begin
	clk = 0;
		// Initialize Inputs
		Cond = 4'bxxxx;
		Flags = 4'b0000;
		$display(CondEx);
		// Add stimulus here
	end
	always@(*)begin 
		#10;
		clk <= ~clk;
		x <= x&0;
	end
   
	/*always@(posedge clk) begin 
		Cond = Cond + 4'b0001;
		$display(CondEx);
	end*/
endmodule
