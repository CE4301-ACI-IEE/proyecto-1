`timescale 1ns / 1ps

module div_v(
	input
		wire clk,
	output
		wire enable240,
		wire enable50M,
		wire enable25M
    );


reg [20:0] count;

always  @(posedge clk) count = count + 1'b1;
	
assign enable240 = (count[18:0] == {19{1'b1}});
	
assign enable50M = (count[0] == 1'b1);

assign enable25M = (count[1:0] == 2'b11);


endmodule
