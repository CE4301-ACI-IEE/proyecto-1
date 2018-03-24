`timescale 1ns / 1ps
module regfile_v(
input
	wire clk,
	wire we3,
	wire [3:0] ra1,
	wire [3:0] ra2,
	wire [3:0] wa3,
	wire [31:0] wd3,
	wire [31:0] r15,
output
	wire [31:0] rd1,
	wire [31:0] rd2
);

reg [31:0] rf[14:0];

always@(posedge clk) begin
	if( we3 ) rf[wa3] <= wd3;
end

assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];

endmodule
