`timescale 1ns / 1ps
module top_v(
input
	wire CLK,
	wire RESET,
	wire KDATA,
	wire KCLK,
output 
	wire [31:0]  DataAdr, WriteData,
	wire MemWrite,
	wire [3:0] AN4,
	wire [6:0] SEG7
);
	
	wire [31:0] Instr, PC, AddresKey, DataKey,  AddresArm, DataArm, MemReadArm, MemReadKey;
	wire MemWriteKey, MemWriteArm;
	wire [7:0] data_decod; //wire para 7 segmentos
	wire [7:0] data_ram; // Datos del teleclado para la ram
	wire enable240; //divisor 240 Hz
	wire enable50M; //divisor 50 MHz
	wire enable25M; //divisor 25 Mhz
	
	//Instancia Controlador ARM
	arm_v ARM( .clk(CLK), .reset(RESET),
				  .Instr(Instr), .ReadData(MemReadArm),
				  .MemWrite(MemWriteArm), .PC(PC),
				  .DataAdr(AddresArm), .WriteData(DataArm));
	
	//Instancia de memoria de instrucciones
	ROM_v instrucciones(CLK, RESET, PC, Instr);
	
	//Instancia RAM
	RAM_v RAM(.ArmData(DataArm), .KeyData(DataKey), .ArmAddr(AddresArm), .KeyAddr(AddresKey), .ArmWe(MemWriteArm), .KeyWe(MemWriteKey), 
					.clk(CLK), .ArmRead(MemReadArm), .KeyRead(MemReadKey));
	
	//Instacia Controlador de teclado 
	KeyboardController_v key( CLK, RESET, KDATA, KCLK, 1'b1, data_decod, DataKey, AddresKey, MemWriteKey );

	//Instancia decodificador 7 segmentos
	deco_7seg_v deco(.clk(CLK), .enable240(enable240), .data1(data_decod), .data2(MemReadKey), .data3(), .data4(), .seg7(SEG7), .an(AN4));

	//Instancia divisor de frecuencia 
	div_v div240(.clk(CLK), .enable240(enable240), .enable50M(enable50M), .enable25M(enable25M));
	
	assign DataAdr = DataArm;
	assign WriteData = AddresArm;
	
endmodule
