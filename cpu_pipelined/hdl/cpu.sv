`timescale 1ns / 1ps

// CPU module
module cpu (
	//input logic CLK,
	input logic MASTER_CLK,
	input logic Reset,
	input logic [47:0] Instr, //Instruccion desde el instruction rom
	input logic [47:0] ReadDataM, //Dato desde las memorias
	output logic MemWriteM, //Enable de la memoria datos
	output logic [47:0] ALUOutM, //Adrres para memory controller
	output logic [47:0] WriteDataM,
	output logic [47:0]PCF,
	output logic [47:0]iD,
	output logic [6:0] Ctrl_D,Ctrl_E,Ctrl_M
	//output logic [47:0] PCPlus4,	//for debug
	//output logic [3:0] RA1, RA2, //for debug
	//output logic [47:0] RD1, RD2, //for debug
	//output logic [3:0] ALUFlags //for debug
);

logic CLK;
logic handshake;

// Condlogic wires
logic cond_exE;
logic [1:0]	flags;

// Decoder wires
logic mem_to_regD, alu_srcD;
logic [1:0] reg_src, imm_srcD;
logic [3:0] alu_controlD;
logic branchD;
logic pc_srcD;
logic reg_writeD;
logic mem_writeD;
logic [1:0] flag_writeD;

//ALU Wires
logic [3:0] alu_flags;
logic [47:0] alu_resultE;

//Next PC logic wires
logic [47:0] pc_temp;
logic [47:0] pcF;
logic [47:0] pc_next, pc_plus4;

//Extend Unit Wires
logic [47:0] ext_immD;

//Regfile wires
logic [47:0] rd1_D;
logic [47:0] rd2_D;
logic [47:0] write_data;
logic [47:0] alu_result;
logic [47:0] read_data;
logic [4:0] ra1_D, ra2_D;

//Hazard Wires
logic stallF, stallD, flushD, flushE;
logic [1:0] forwardAE, forwardBE;

//RegFD wires
logic [47:0]instD;
logic [6:0] CtrlD;

//RegDE wires
logic pc_srcE;
logic [3:0] condE;
logic branchE;
logic [1:0] flagsE;
logic reg_writeE;	
logic mem_writeE;
logic mem_to_regE;
logic [1:0] flag_writeE;
logic alu_srcE;
logic [3:0] alu_controlE;
logic [4:0] wa3E;
logic [47:0] rd1_E;
logic [47:0] rd2_E;
logic [47:0] ext_immE;
logic [4:0]	ra1E, ra2E;
logic [6:0] CtrlE;

//RegEM wires
logic pc_srcM;
logic reg_writeM;	
logic mem_writeM;
logic mem_to_regM;
logic [47:0] alu_outM;
logic [4:0] wa3M;
logic [47:0] writedata_M;
logic [6:0] CtrlM;

//MemoryAccess wires
logic [47:0] _read_ma;
logic [47:0] _read_dmem;
logic [47:0] _read_data_m;

//RegMW wires
logic pc_srcW;
logic reg_writeW;
logic mem_to_regW;
logic [47:0] alu_outW;
logic [4:0] wa3W;
logic [47:0] read_data_W;
logic [47:0] resultW;

//Wires Mux3x1 y Mux2x1 entradas ALU
logic [47:0] srcA_E;
logic [47:0] srcB_E;
logic [47:0] writedata_E;

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

//Decoder Logic //checked for 48 bits
decoder dec( .Op( instD[43:41] ), 
				.Funct( instD[40:35] ), 
				.Rd( instD[29:25] ),
				.FlagWriteD( flag_writeD ), 
				.PCSrcD( pc_srcD ), 
				.RegWriteD( reg_writeD ), 
				.MemWriteD( mem_writeD ),
				.MemtoRegD( mem_to_regD ), 
				.ALUSrcD( alu_srcD ), 
				.ImmSrcD( imm_srcD ), 
				.RegSrc( reg_src ), 
				.ALUControlD( alu_controlD ),
				.BranchD(branchD),
				.Ctrl(CtrlD));

// Next PC logic

mux2x1 #(48) pc_mux1( pc_srcW, pc_plus4, resultW, pc_temp ); //Checked for 48 bits
mux2x1 #(48) pc_mux2( .s(BranchTakenE), .d0(pc_temp), .d1(alu_resultE), .y(pc_next) ); //Checked for 48 bits	
RegPC  #(48)  pcreg(.RESET(Reset), .StallF(stallF), .CLK(CLK), .PC(pc_next), .PCF(pcF) );//checked for 48 bits
//flopr #(32) pcreg( CLK, Reset, pc_next, pc );
adder #(48) pcadd1( pcF, 48'd4, pc_plus4 ); //checked for 48 bits
//Diagrama la salida del adder pc_puls4 va directo a R15
//adder #(32) pcadd2( CLK, pc_plus4, 32'd4, pc_plus8 );

//Register file logic
mux2x1 #(5) ra1mux( reg_src[0], instD[34:30], 5'b01111, ra1_D ); //checked for 48 bits
mux2x1 #(5) ra2mux( reg_src[1], instD[4:0], instD[29:25], ra2_D );
regfile #(48,5) rf( .CLK( CLK ),
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
mux2x1 #(48) resmux( mem_to_regW, alu_outW, read_data_W, resultW );
//Extend Logic
extend ext( instD[23:0], imm_srcD, ext_immD );

// ALU logic

//Mux 3x1, multiplexar entradas al ALU //checked for 48 bits
mux3x1 #(48) mux_scrA( .s(forwardAE), .ALUOutM(alu_outM), .ResultW(resultW), .RegFile(rd1_E), .Src(srcA_E) );
mux3x1 #(48) mux_scrB( .s(forwardBE), .ALUOutM(alu_outM), .ResultW(resultW), .RegFile(rd2_E), .Src(writedata_E) );
//Mux 2x1 //checked for 48 bits
mux2x1 #(48) srcBmux( alu_srcE, writedata_E, ext_immE, srcB_E );
ALU alu( CLK, 
			srcA_E, 
			srcB_E, 
			alu_controlE, 
			alu_resultE, 
			alu_flags
);
			
//RegFD Logic //checked for 48 bits
RegFD #(48)	reg_fd(.CLK(CLK), .StallD(stallD), .CLR(flushD), .InstrF(Instr), .InstrD(instD) );

//RegDE Logic //checked for 48 bits
RegDE #(48) reg_de(	.CLK(CLK), .PCSrcD(pc_srcD), .RegWriteD(reg_writeD), .MemToRegD(mem_to_regD), .MemWriteD(mem_writeD),
					.BranchD(branchD), .ALUSrcD(alu_srcD), .FlagWriteD(flag_writeD), .CLR(flushE), .ALUControlD(alu_controlD),
					.Flags(flags), .CondD(instD[47:44]), .WA3D(instD[29:25]), .RD1(rd1_D), .RD2(rd2_D), .ExtImmD(ext_immD),
					.RA1D(ra1_D), .RA2D(ra2_D), .PCSrcE(pc_srcE), .RegWriteE(reg_writeE), .MemToRegE(mem_to_regE),
					.MemWriteE(mem_writeE), .BranchE(branchE), .ALUSrcE(alu_srcE), .FlagWriteE(flag_writeE),
					.ALUControlE(alu_controlE), .FlagsE(flagsE), .CondE(condE), .WA3E(wa3E), .RE1(rd1_E), 
					.RE2(rd2_E), .ExtImmE(ext_immE), .RA1E(ra1E), .RA2E(ra2E), .CtrlD(CtrlD), .CtrlE(CtrlE));
					
//RegEM Logic //checked for 48 bits
RegEM #(48)	reg_em(	.CLK(CLK), .PCSrcE2(pc_srcE2), .RegWriteE2(reg_writeE2), .MemToRegE(mem_to_regE), .MemWriteE2(mem_writeE2),
					.WA3E(wa3E), .ALUResultE(alu_resultE), .WriteDataE(writedata_E),	
					.PCSrcM(pc_srcM), .RegWriteM(reg_writeM), .MemToRegM(mem_to_regM), .MemWriteM(mem_writeM),
					.WA3M(wa3M), .ALUOutM(alu_outM), .WriteDataM(writedata_M), .CtrlE(CtrlE), .CtrlM(CtrlM));

//Gate clock
gate_clk gc(
	.MASTER_CLK( MASTER_CLK ),
	.WAIT_SIGNAL( CtrlM[6] ),
	.HANDSHAKE( handshake ),
	.CLK_CPU( CLK )
);

//Memory access modules
memory_access ma_KP(
        .CLK( MASTER_CLK ),
        .RESET( Reset ),
        .ENABLE( CtrlM[1] ),
        .CTRL( CtrlM[4:2] ),
        .ADDRESS( alu_outM ),
        .READ( _read_ma ),
        .HANDSHAKE( handshake )
    );

dmem #(48) ma_ram(
        .CLK( CLK ),
        .WE( mem_writeM ),
        .A( alu_outM ),
        .WD( writedata_M ),
        .RD( _read_dmem )
    );

mux2x1 #(48) mux_memory( CtrlM[5], _read_ma, _read_dmem, _read_data_m );
//RegMW Logic //checked for 48 bits
RegMW #(48)	reg_mw(	.CLK(CLK), .PCSrcM(pc_srcM), .RegWriteM(reg_writeM), .MemToRegM(mem_to_regM),
					.WA3M(wa3M), .ALUOutM(alu_outM), .ReadDataM(_read_data_m),	
					.PCSrcW(pc_srcW), .RegWriteW(reg_writeW), .MemToRegW(mem_to_regW),
					.WA3W(wa3W), .ALUOutW(alu_outW), .ReadDataW(read_data_W) );

//Hazard Unit Logic //checked for 48 bits
hazard hazard_unit( 
							.Reset( Reset ),
							.RegWriteM(reg_writeM),
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
							.CLK(CLK)	);							
							
//Salidas CPU
							
//assign ReadData = read_data;
assign MemWriteM = mem_writeM;
//assign PC = pc;
assign ALUOutM = alu_outM;
assign WriteDataM = writedata_M;
assign PCF = pcF; 
assign iD = instD;
assign Ctrl_D = CtrlD;
assign Ctrl_E = CtrlE;
assign Ctrl_M = CtrlM;
//assign PCPlus4 = pc_plus4;
//assign RA1 = ra1_D;
//assign RA2 = ra2_D;
//assign RD1 = srcA_E;
//assign RD2 = srcB_E;
//assign ALUFlags = alu_flags;

endmodule