`timescale 1ns / 1ps

module hazard_tb;

//input
logic RegWriteM, RegWriteW, MemToRegE, BranchTakenE, PCSrcD, PCSrcE, PCSrcM, PCSrcW,clk;
logic [5:0] RA1D, RA2D, RA1E, RA2E, WA3M, WA3W, WA3E;

//output 
logic StallF, StallD, FlushD, FlushE;
logic [1:0] FowardAE, FowardBE;
logic [3:0] match;

//instantiate the DUT
hazard DUT(
    .CLK(clk),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .MemToRegE(MemToRegE),
    .BranchTakenE(BranchTakenE),
    .PCSrcD(PCSrcD),
    .PCSrcE(PCSrcE),
    .PCSrcM(PCSrcM),
    .PCSrcW(PCSrcW),
    .RA1D(RA1D),
    .RA2D(RA2D),
    .RA1E(RA1E),
    .RA2E(RA2E),
    .WA3E(WA3E),
    .WA3M(WA3M),
    .WA3W(WA3W),
    .StallD(StallD),
    .StallF(StallF),
    .FlushD(FlushD),
    .FlushE(FlushE),
    .FowardAE(FowardAE),
    .FowardBE(FowardBE),
    .match(match)
);

initial begin
		clk = 1'b0;
			forever begin
			#5;
			clk = ~clk;
		end
	end

initial begin
    RegWriteM = 0;
    RegWriteW = 0;
    RA1E = 6'b0;
    RA2E = 6'b0;
    WA3M = 6'b0;
    WA3W = 6'b0;

    #20

    RegWriteM = 1;
    RegWriteW = 1;
    RA1E = 6'b000001;
    RA2E = 6'b000010;
    WA3M = 6'b0;
    WA3W = 6'b000010;
    #10;
    
    #10;
    
    RegWriteM = 1;
    RegWriteW = 1;
    RA1E = 6'b000001;
    RA2E = 6'b000010;
    WA3M = 6'b0;
    WA3W = 6'b000010;
    #10;

    RegWriteM = 1;
    RegWriteW = 1;
    RA1E = 6'b000011;
    RA2E = 6'b000010;
    WA3M = 6'd3;
    WA3W = 6'b000010;
    #10;

    RegWriteM = 1;
    RegWriteW = 1;
    RA1E = 6'b000010;
    RA2E = 6'b000001;
    WA3M = 6'b0;
    WA3W = 6'b000010;
    #10;

    RegWriteM = 1;
    RegWriteW = 1;
    RA1E = 6'b000001;
    RA2E = 6'b000010;
    WA3M = 6'b1;
    WA3W = 6'b000010;
    #10;

    RegWriteM = 1;
    RegWriteW = 0;
    RA1E = 6'b000001;
    RA2E = 6'b000010;
    WA3M = 6'b0;
    WA3W = 6'b000010;
    #10;
    
    
end
endmodule
