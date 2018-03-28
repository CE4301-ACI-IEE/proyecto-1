`timescale 1ns / 1ps

module hazard 
(
    input   logic       RegWriteM, RegWriteW, MemToRegE, BranchTakenE, PCSrcD, PCSrcE, PCSrcM, PCSrcW,
    input   logic [5:0] RA1D, RA2D, RA1E, RA2E, WA3M, WA3W, WA3E,
    output  logic       StallF, StallD, FlushD, FlushE,
    output  logic [1:0] FowardAE, FowardBE
);
//creates temporal registers.
logic [3:0] Match;
logic       StallF_tmp, StallD_tmp, FlushD_tmp, FlushE_tmp, PCWrPendingF, LDRStall;
logic [1:0] FowardAE_tmp, FowardBE_tmp;

//assings temporal results to outputs
assign FowardAE = FowardAE_tmp;
assign FowardBE = FowardBE_tmp;
assign StallD = StallD_tmp;
assign StallF = StallF_tmp;
assign FlushD = FlushD_tmp;
assign FlushE = FlushE_tmp;
initial begin
    Match = 4'b0;
    PCWrPendingF = 1'b0;
end
    always@(*)
    begin
        Match[3] = (RA1E == WA3M);
        Match[2] = (RA1E == WA3W);
        Match[1] = (RA2E == WA3M);
        Match[0] = (RA2E == WA3M);
    end

    //fowarding block
    always@(*)
    begin
        if(Match[3]&RegWriteM)
        begin
            FowardAE_tmp = 2'b10;
        end else if (Match[2]&RegWriteW) begin
            FowardAE_tmp = 2'b01;
        end else begin
            FowardAE_tmp = 2'b0;
        end

        if(Match[1]&RegWriteM)
        begin
            FowardBE_tmp = 2'b10;
        end else if (Match[0]&RegWriteW) begin
            FowardBE_tmp = 2'b01;
        end else begin
            FowardBE_tmp = 2'b0;
        end
    end

    always@(*)
    begin
        PCWrPendingF    =   PCSrcD | PCSrcE | PCSrcM;
        LDRStall        =   ((RA1D == WA3E)|(RA2D==WA3E))&MemToRegE;
        StallD_tmp      =   LDRStall; 
        StallF_tmp      =   LDRStall | PCWrPendingF;
        FlushE_tmp      =   LDRStall | BranchTakenE;
        FlushD_tmp      =   PCWrPendingF | PCSrcW | BranchTakenE;
    end
    
endmodule