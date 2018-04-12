`timescale 1ns / 1ps

// CPU module
module cpu (
	input logic CLK,
	input logic Reset,
	input logic [31:0] Instr, //Instruccion desde el instruction rom
	input logic [31:0] ReadDataM, //Dato desde las memorias
	output logic MemWriteM, //Enable de la memoria datos
	output logic [31:0] ALUOutM, //Adrres para memory controller
	output logic [31:0] WriteDataM,
	output logic [2:0] MemoryControl, //Controlar el memory controller 
	output logic [31:0]PCF,
	output logic [31:0]iD 
	//output logic [31:0] PCPlus4,	//for debug
	//output logic [3:0] RA1, RA2, //for debug
	//output logic [31:0] RD1, RD2, //for debug
	//output logic [3:0] ALUFlags //for debug
);

// Condlogic wires
logic cond_exE;
logic [1:0]	flags;

// Decoder wires
logic mem_to_regD, alu_srcD;
logic [1:0] reg_src, imm_srcD;
logic [2:0] alu_controlD;
logic branchD;
logic pc_srcD;
logic reg_writeD;
logic mem_writeD;
logic [1:0] flag_writeD;

//ALU Wires
logic [3:0] alu_flags;
logic [31:0] alu_resultE;

//Next PC logic wires
logic [31:0] pc_temp;
logic [31:0] pcF;
logic [31:0] pc_next, pc_plus4;

//Extend Unit Wires
logic [31:0] ext_immD;

//Regfile wires
logic [31:0] rd1_D;
logic [31:0] rd2_D;
logic [31:0] write_data;
logic [31:0] alu_result;
logic [31:0] read_data;
logic [3:0] ra1_D, ra2_D;

//Hazard Wires
logic stallF, stallD, flushD, flushE;
logic [1:0] forwardAE, forwardBE;

//RegFD wires
logic [31:0]instD;

//RegDE wires
logic pc_srcE;
logic [3:0] condE;
logic branchE;
logic [1:0] flagsE;
logic reg_writeE;	
logic mem_writeE;
logic mem_to_regE;
logic flag_writeE;
logic alu_srcE;
logic [2:0] alu_controlE;
logic [3:0] wa3E;
logic [31:0] rd1_E;
logic [31:0] rd2_E;
logic [31:0] ext_immE;
logic [3:0]	ra1E, ra2E;

//RegEM wires
logic pc_srcM;
logic reg_writeM;	
logic mem_writeM;
logic mem_to_regM;
logic [31:0] alu_outM;
logic [3:0] wa3M;
logic [31:0] writedata_M;

//RegMW wires
logic pc_srcW;
logic reg_writeW;
logic mem_to_regW;
logic [31:0] alu_outW;
logic [3:0] wa3W;
logic [31:0] read_data_W;
logic [31:0] resultW;

//Wires Mux3x1 y Mux2x1 entradas ALU
logic [31:0] srcA_E;
logic [31:0] srcB_E;
logic [31:0] writedata_E;

//CondLogic Logic
condlogic cl( .CLK( CLK ), 
				 .Reset( Reset ), 
				 .CondE(condE), 
				 .ALUFlags( alu_flags ),
				 .FlagWriteE( flag_writeE ), 
				 .FlagsE(flagsE),  
				 .Flags(flags),
				 .CondExE(cond_exE) );				
				 
//Wires para compuertas AND en salida de condlogic
logic BranchTakenE;
logic pc_srcE2;
logic reg_writeE2;
logic mem_writeE2;

//Compuertas AND en salida de condlogic
assign BranchTakenE = branchE & cond_exE;
assign pc_srcE2 =  pc_srcE & cond_exE;	
assign reg_writeE2 =  reg_writeE & cond_exE;
assign mem_writeE2 =  mem_writeE & cond_exE;				 

//Decoder Logic
decoder dec( .Op( instD[27:26] ), 
				.Funct( instD[25:20] ), 
				.Rd( instD[15:12] ),
				.FlagWriteD( flag_writeD ), 
				.PCSrcD( pc_srcD ), 
				.RegWriteD( reg_writeD ), 
				.MemWriteD( mem_writeD ),
				.MemtoRegD( mem_to_regD ), 
				.ALUSrcD( alu_srcD ), 
				.ImmSrcD( imm_srcD ), 
				.RegSrc( reg_src ), 
				.ALUControlD( alu_controlD ),
				.BranchD(branchD)	);

// Next PC logic

mux2x1 #(32) pc_mux1( pc_srcW, pc_plus4, resultW, pc_temp );
mux2x1 #(32) pc_mux2( .s(BranchTakenE), .d0(pc_temp), .d1(alu_resultE), .y(pc_next) );	
RegPC pcreg (.RESET(Reset), .StallF(stallF), .CLK(CLK), .PC(pc_next), .PCF(pcF) );//analizar el CLK
//flopr #(32) pcreg( CLK, Reset, pc_next, pc );
adder #(32) pcadd1( pcF, 32'd4, pc_plus4 );
//Diagrama la salida del adder pc_puls4 va directo a R15
//adder #(32) pcadd2( CLK, pc_plus4, 32'd4, pc_plus8 );

//Register file logic
mux2x1 #(4) ra1mux( reg_src[0], instD[19:16], 4'b1111, ra1_D );
mux2x1 #(4) ra2mux( reg_src[1], instD[3:0], instD[15:12], ra2_D );
regfile rf( .CLK( CLK ),
			.WE3( reg_writeW ), 
			.RA1( ra1_D ),
			.RA2( ra2_D ),
			.RA3( wa3W ),
			.WD3( resultW ),
			.R15( pc_next ),//se conecta directamente la salida del pcmux segun diagrama
			.RD1( rd1_D ),
			.RD2( rd2_D )
);
//MUx2x1 Salida de estapa de WriteBack
mux2x1 #(32) resmux( mem_to_regW, alu_outW, read_data_W, resultW );
//Extend Logic
extend ext( instD[23:0], imm_srcD, ext_immD );

// ALU logic

//Mux 3x1, multiplexar entradas al ALU
mux3x1	mux_scrA( .s(forwardAE), .ALUOutM(alu_outM), .ResultW(resultW), .RegFile(rd1_E), .Src(srcA_E) );
mux3x1	mux_scrB( .s(forwardBE), .ALUOutM(alu_outM), .ResultW(resultW), .RegFile(rd2_E), .Src(writedata_E) );
//Mux 2x1
mux2x1 #(32) srcBmux( alu_srcE, writedata_E, ext_immE, srcB_E );
alu_beta alu( CLK, 
			srcA_E, 
			srcB_E, 
			alu_controlE, 
			alu_resultE, 
			alu_flags
);
			
//RegFD Logic
RegFD	reg_fd(.CLK(CLK), .StallD(stallD), .CLR(flushD), .InstrF(Instr), .InstrD(instD) );

//RegDE Logic
RegDE	reg_de(	.CLK(CLK), .PCSrcD(pc_srcD), .RegWriteD(reg_writeD), .MemToRegD(mem_to_regD), .MemWriteD(mem_writeD),
					.BranchD(branchD), .ALUSrcD(alu_srcD), .FlagWriteD(flag_writeD), .CLR(flushE), .ALUControlD(alu_controlD),
					.Flags(flags), .CondD(instD[31:28]), .WA3D(instD[15:12]), .RD1(rd1_D), .RD2(rd2_D), .ExtImmD(ext_immD),
					.RA1D(ra1_D), .RA2D(ra2_D), .PCSrcE(pc_srcE), .RegWriteE(reg_writeE), .MemToRegE(mem_to_regE),
					.MemWriteE(mem_writeE), .BranchE(branchE), .ALUSrcE(alu_srcE), .FlagWriteE(flag_writeE),
					.ALUControlE(alu_controlE), .FlagsE(flagsE), .CondE(condE), .WA3E(wa3E), .RE1(rd1_E), 
					.RE2(rd2_E), .ExtImmE(ext_immE), .RA1E(ra1E), .RA2E(ra2E)	);
					
//RegEM Logic
RegEM	reg_em(	.CLK(CLK), .PCSrcE2(pc_srcE2), .RegWriteE2(reg_writeE2), .MemToRegE(mem_to_regE), .MemWriteE2(mem_writeE2),
					.WA3E(wa3E), .ALUResultE(alu_resultE), .WriteDataE(writedata_E),	
					.PCSrcM(pc_srcM), .RegWriteM(reg_writeM), .MemToRegM(mem_to_regM), .MemWriteM(mem_writeM),
					.WA3M(wa3M), .ALUOutM(alu_outM), .WriteDataM(writedata_M) );

//RegMW Logic
RegMW	reg_mw(	.CLK(CLK), .PCSrcM(pc_srcM), .RegWriteM(reg_writeM), .MemToRegM(mem_to_regM),
					.WA3M(wa3M), .ALUOutM(alu_outM), .ReadDataM(ReadDataM),	
					.PCSrcW(pc_srcW), .RegWriteW(reg_writeW), .MemToRegW(mem_to_regW),
					.WA3W(wa3W), .ALUOutW(alu_outW), .ReadDataW(read_data_W) );

//Hazard Unit Logic
hazard hazard_unit( .RegWriteM(reg_writeM),
							.RegWriteW(reg_writeW), 
							.MemToRegE(mem_to_regE), 
							.BranchTakenE(BranchTakenE), 
							.PCSrcD(pc_srcD), 
							.PCSrcE(pc_srcE), 
							.PCSrcM(pc_srcM), 
							.PCSrcW(pc_srcW),
							.RA1D(ra1_D), 
							.RA2D(ra2_D), 
							.RA1E(ra1E), 
							.RA2E(ra2E), 
							.WA3M(wa3M), 
							.WA3W(wa3W), 
							.WA3E(wa3E),
							.StallF(stallF), 
							.StallD(stallD), 
							.FlushD(flushD), 
							.FlushE(flushE),
							.FowardAE(forwardAE), 
							.FowardBE(forwardBE),
							.match()	);							
							
//Salidas CPU
							
//assign ReadData = read_data;
assign MemWriteM = mem_writeM;
//assign PC = pc;
assign ALUOutM = alu_outM;
assign WriteDataM = writedata_M;
assign PCF = pcF; 
assign iD = instD;
//assign PCPlus4 = pc_plus4;
//assign RA1 = ra1_D;
//assign RA2 = ra2_D;
//assign RD1 = srcA_E;
//assign RD2 = srcB_E;
//assign ALUFlags = alu_flags;

endmodule