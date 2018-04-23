// By: Ernesto & Isaac

// Clock gating module
// This is a prototype
module gate_clk (
    input logic MASTER_CLK,
    input logic WAIT_SIGNAL,
    input logic HANDSHAKE,
    output logic CLK_CPU
);

logic tmp;
always_ff@( posedge HANDSHAKE or posedge WAIT_SIGNAL or posedge MASTER_CLK ) begin
    tmp = 1'b1;
    if( WAIT_SIGNAL) begin
        if( ~HANDSHAKE ) begin
            tmp = 1'b0;
        end
    end
end
// if wait signal is off CLK_CPU = MASTER_CLK
// if wait signal is on CLK_CPU = 0, until receive handshake
assign CLK_CPU = tmp && MASTER_CLK;

endmodule