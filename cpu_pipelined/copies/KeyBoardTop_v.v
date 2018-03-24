`timescale 1ns / 1ps
module KeyBoardTop_v(
input
	wire CLK,
	wire RESET,
	wire KDATA,
	wire KCLK,
output 
	wire [3:0] AN4,
	wire [6:0] SEG7,
	wire LED1
);


wire [7:0] data1; //wire para 7 segmentos
wire enable240; //divisor 240 Hz
wire enable50M; //divisor 50 MHz
wire enable25M;

KeyboardController_v key( CLK, RESET, KDATA, KCLK, 1'b1, LED1, data1 );

deco_7seg_v deco(.clk(CLK), .enable240(enable240), .data1(data1), .data2(8'H45), .seg7(SEG7), .an(AN4));

div_v div240(.clk(CLK), .enable240(enable240), .enable50M(enable50M), .enable25M(enable25M));


endmodule
