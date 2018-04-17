module gate_clk (
    input logic MASTER_CLK,
    input logic WAIT_SIGNAL,
    input logic HANDSHAKE,
    output logic CLK_CPU
);

logic tmp;

always_ff@( HANDSHAKE or WAIT_SIGNAL or MASTER_CLK ) begin
    tmp = 1'b1;
    if( WAIT_SIGNAL ) begin
        if( ~HANDSHAKE ) begin
            tmp = 1'b0;
        end
    end
end
assign CLK_CPU = tmp && MASTER_CLK;

endmodule