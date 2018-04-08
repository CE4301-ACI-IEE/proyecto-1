`timescale 1ns / 1ps

module clk_div (
    input logic RESET, 
    input logic MASTER_CLK,
    output logic CLK_MEM,
    output logic CLK_CPU
);

logic [4:0] _count;

always_ff@( posedge MASTER_CLK ) begin
    if( RESET ) begin
        _count = 5'b00000;
    end
    else begin
        _count <= _count + 5'b0001;
    end
end

assign CLK_CPU = ( _count[1:0] == 2'b11 );
assign CLK_MEM = ( _count[0] == 1'b1 );

endmodule