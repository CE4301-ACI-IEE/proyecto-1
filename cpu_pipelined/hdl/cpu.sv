`timescale 1ns / 1ps

// CPU module
module cpu (
	input logic CLK,
	input logic Reset,
	input logic [31:0] Instr,
	input logic [31:0] ReadData,
	output logic MemWrite,
	output logic [31:0] PC,
	output logic [31:0] AddrData,
	output logic [31:0] WriteData,
	output logic PCSrc,
	output logic [31:0] PCPlus4,
	output logic [3:0] RA1, RA2,
	output logic [31:0] RD1, RD2,
	output logic [3:0] ALUFlags
);

// Condlogic wires
logic [3:0] alu_flags;
logic cond_exE;
logic [1:0]	flags;

// Decoder wires
logic mem_to_regD, alu_src;
logic [1:0] reg_src, imm_src;
logic [2:0] alu_control;
logic branchD;
logic pc_srcD;
logic reg_writeD;
logic mem_writeD;
logic flag_writeD;

// Next PC logic wires
logic [31:0] pc;
logic [31:0] pc_next, pc_plus4, pc_plus8;
logic [31:0] ext_imm, src_a, src_b, result;
logic [3:0] ra_1, ra_2;

// Regfile wires
logic [31:0] write_data;
logic [31:0] alu_result;
logic [31:0] read_data;

//Hazard Wires
logic stallF, stallD, flushD, flushE;

//RegFD wires
logic [31:0]instD;

//RegDE wires
logic pc_srcE;
logic condE;
logic branchE;
logic flagsE;
logic reg_writeE;	
logic mem_writeE;
logic mem_to_regE;
logic flag_writeE;

//RegEM wires



//RegMW wires
logic reg_writeW;




assign ReadData = read_data;
assign MemWrite = mem_write;
assign PC = pc;
assign AddrData = alu_result;
assign WriteData = write_data;
assign PCSrc = pc_src;			// cambiar por la salida del WB
assign PCPlus4 = pc_plus4;
assign RA1 = ra_1;
assign RA2 = ra_2;
assign RD1 = src_a;
assign RD2 = src_b;
assign ALUFlags = alu_flags;

condlogic cl( .CLK( CLK ), 
				 .Reset( Reset ), 
				 .CondE(condE), 
				 .ALUFlags( alu_flags ),
				 .FlagWriteE( flag_writeE ), 
				 .FlagE(flagsE),  
				 .Flags(flags),
				 .CondExE(cond_exE) );
//Wires para ands en salida de condlogic
logic BranchTakenE;
logic pc_srcE2;
logic reg_writeE2;

//Compuertas AND en salida de condlogic
assign BranchTakenE = branchE & cond_exE;
assign pc_srcE2 =  pc_srcE & cond_exE;	
assign reg_writeE2 =  reg_writeE & cond_exE;			 


decoder dec( .Op( instD[27:26] ), 
				.Funct( instD[25:20] ), 
				.Rd( instD[15:12] ),
				.FlagWriteD( flag_writeD ), 
				.PCSrcD( pc_srcD ), 
				.RegWriteD( reg_writeD ), 
				.MemWriteD( mem_writeD ),
				.MemtoRegD( mem_to_regD ), 
				.ALUSrc( alu_src ), 
				.ImmSrc( imm_src ), 
				.RegSrc( reg_src ), 
				.ALUControl( alu_control ),
				.BranchD(branchD)	);

// Next PC logic

mux2x1 #(32) pcmux( pc_src, pc_plus4, result, pc_next );		//cambiar por pc_srcW
RegPC pcreg (.StallF(stallF), .CLK(), .PC(pc_next), .PCF() );//analizar el CLK
//flopr #(32) pcreg( CLK, Reset, pc_next, pc );
adder #(32) pcadd1( CLK, pc, 32'd4, pc_plus4 );
//Diagrama la salida del adder pc_puls4 va directo a R15
//adder #(32) pcadd2( CLK, pc_plus4, 32'd4, pc_plus8 );

// Register file logic
mux2x1 #(4) ra1mux( reg_src[0], instD[19:16], 4'b1111, ra_1 );
mux2x1 #(4) ra2mux( reg_src[1], instD[3:0], instD[15:12], ra_2 );
regfile rf( .CLK( CLK ),
			.WE3( reg_writeW ), //cambiar por reg_writeW
			.RA1( ra_1 ),
			.RA2( ra_2 ),
			.RA3( ),
			.WD3( result ),
			.R15( pc_next ),//se conecta directamente la salida del pcmux segun diagrama
			.RD1( src_a ),
			.RD2( write_data )
);
mux2x1 #(32) resmux( mem_to_reg, alu_result, read_data, result );
extend ext( Instr[23:0], imm_src, ext_imm );

// ALU logic
mux2x1 #(32) srcBmux( alu_src, write_data, ext_imm, src_b );
alu_beta alu( CLK, 
			src_a, 
			src_b, 
			alu_control, 
			alu_result, 
			alu_flags );
			
//RegFD Logic
RegFD	reg_fd(.CLK(), .StallD(stallD), .CLR(flushD), .InstrF(Instr), .InstrD(instD) );

//RegDE Logic
RegDE	reg_de(	.CLK(), .PCSrcD(pc_srcD), .RegWriteD(reg_writeD), .MemToRegD(mem_to_regD), .MemWriteD(mem_writeD),
					.BranchD(branchD), .ALUSrcD(), .FlagWriteD(flag_writeD), .CLR(flushE), .ALUControlD(),
					.Flags(flags), .CondD(instD[31:28]), .WA3D(instD[15:12]), .RD1(), .RD2(), .ExtImmD(),
					.PCSrcE(pc_srcE), .RegWriteE(reg_writeE), .MemToRegE(mem_to_regE), .MemWriteE(mem_writeE),
					.BranchE(branchE), .ALUSrcE(), .FlagWriteE(flag_writeE), .ALUControlE(), 
					.FlagsE(flagsE), .CondE(condE), .WA3E(), .RE1(), .RE2(), .ExtImmE()	);
					
//RegEM Logic
RegDE	reg_em(	.CLK(), .PCSrcD(pc_srcE2), .RegWriteD(reg_writeD), .MemToRegD(mem_to_regD), .MemWriteD(mem_writeD),
					.BranchD(branchD), .ALUSrcD(), .FlagWriteD(), .CLR(), .ALUControlD(),
					.Flags(flags), .CondD(instD[31:28]), .WA3D(), .RD1(), .RD2(), .ExtImmD(),
					.PCSrcE(pc_srcE), .RegWriteE(reg_writeE), .MemToRegE(mem_to_regE), .MemWriteE(mem_writeE),
					.BranchE(branchE), .ALUSrcE(), .FlagWriteE(), .ALUControlE(), 
					.FlagsE(flagsE), .CondE(condE), .WA3E(), .RE1(), .RE2(), .ExtImmE()	);



//Hazard Unit Logic
hazard hazard_unit( .RegWriteM(),
							.RegWriteW(), 
							.MemToRegE(mem_to_regE), 
							.BranchTakenE(BranchTakenE), 
							.PCSrcD(pc_srcD), 
							.PCSrcE(pc_srcE), 
							.PCSrcM(), 
							.PCSrcW(),
							.RA1D(), 
							.RA2D(), 
							.RA1E(), 
							.RA2E(), 
							.WA3M(), 
							.WA3W(), 
							.WA3E(),
							.StallF(stallF), 
							.StallD(stallD), 
							.FlushD(flushD), 
							.FlushE(flushE),
							.FowardAE(), 
							.FowardBE(),
							.match()	);
endmodule