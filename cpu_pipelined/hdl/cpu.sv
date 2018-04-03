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
logic [1:0] flag_w;
logic pcs, reg_w, mem_w;
logic reg_write, mem_write;
logic pc_src;

// Decoder wires
logic mem_to_reg, alu_src;
logic [1:0] reg_src, imm_src;
logic [2:0] alu_control;

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


assign ReadData = read_data;
assign MemWrite = mem_write;
assign PC = pc;
assign AddrData = alu_result;
assign WriteData = write_data;
assign PCSrc = pc_src;
assign PCPlus4 = pc_plus4;
assign RA1 = ra_1;
assign RA2 = ra_2;
assign RD1 = src_a;
assign RD2 = src_b;
assign ALUFlags = alu_flags;

condlogic cl( .CLK( CLK ), 
				 .Reset( Reset ), 
				 .Cond( Instr[31:28] ), 
				 .ALUFlags( alu_flags ),
				 .FlagW( flag_w ), 
				 .PCS( pcs ), 
				 .RegW( reg_w ), 
				 .MemW( mem_w ), 
				 .PCSrc( pc_src ), 
				 .RegWrite( reg_write ), 
				 .MemWrite( mem_write ) );

decoder dec( .Op( Instr[27:26] ), 
				.Funct( Instr[25:20] ), 
				.Rd( Instr[15:12] ),
				.FlagW( flag_w ), 
				.PCS( pcs ), 
				.RegW( reg_w ), 
				.MemW( mem_w ),
				.MemtoReg( mem_to_reg ), 
				.ALUSrc( alu_src ), 
				.ImmSrc( imm_src ), 
				.RegSrc( reg_src ), 
				.ALUControl( alu_control ) );

// Next PC logic

mux2x1 #(32) pcmux( pc_src, pc_plus4, result, pc_next );
RegPC pcreg (.StallF(stallF), .CLK(), .PC(pc_next), .PCF();//analizar el CLK
//flopr #(32) pcreg( CLK, Reset, pc_next, pc );
adder #(32) pcadd1( CLK, pc, 32'd4, pc_plus4 );
//Diagrama la salida del adder pc_puls4 va directo a R15
//adder #(32) pcadd2( CLK, pc_plus4, 32'd4, pc_plus8 );

// Register file logic
mux2x1 #(4) ra1mux( reg_src[0], Instr[19:16], 4'b1111, ra_1 );
mux2x1 #(4) ra2mux( reg_src[1], Instr[3:0], Instr[15:12], ra_2 );
regfile rf( .CLK( CLK ),
			.WE3( reg_write ),
			.RA1( ra_1 ),
			.RA2( ra_2 ),
			.RA3( Instr[15:12] ),
			.WD3( result ),
			.R15( pc_plus8 ),
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
//Hazard Unit Logic
hazard hazard_unit( .RegWriteM(),
							.RegWriteW(), 
							.MemToRegE(), 
							.BranchTakenE(), 
							.PCSrcD(), 
							.PCSrcE(), 
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
							.StallD(), 
							.FlushD(), 
							.FlushE(),
							.FowardAE(), 
							.FowardBE(),
							.match()	);
endmodule