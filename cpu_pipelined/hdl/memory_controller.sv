`timescale 1ns / 1ps

// Falta considerar el tamano de la imagen, debe ser alguna constante.
// Definir las entradas i y j o address.

module memory_controller #( parameter SIZE = 48 )
(
    input logic CLK,
    input logic CLK_MEM,
    input logic [SIZE-1:0] ADDRESS,
    input logic ENABLE,
    input logic [1:0] CTRL,
    output logic [SIZE-1:0] READ,
    output logic [1:0] state
);

parameter P_FET = 0;
parameter P_KER = 1, P_PIC = 2;
parameter P_KER_S = 3, P_KER_M = 4;
parameter P_PIC_S = 5, P_PIC_M = 6;

logic [1:0] _state;
logic [1:0] _next_state;

logic [5:0] addr_kernel;
logic [31:0] addr_pic;
logic [15:0] read_kernel;
logic [7:0] read_pic;

mem_kernel #(16) mk(
    .ADDRESS( addr_kernel ),
    .READ( read_kernel ),
);

mem_pic #(8) mp(
    .ADDRESS( addr_pic ),
    .READ( read_pic )
);

always_ff@( posedge CLK ) begin
    if( CLK_MEM & ENABLE == 1'b0 ) begin
        _state = P_FET;
    end
    else if( CLK_MEM )begin
        _state = _next_state;
    end
end

always_ff@( _state ) begin
    case( _state )
        
        P_FET: begin
            state = P_FET;
            if( CTRL[1] == 1'b0; )
                _next_state = P_KER;
            if( CTRL[1] == 1'b1; )
                _next_state = P_PIC;
        end

        P_KER: begin
            state = P_KER;
            if( CTRL[0] == 1'b0 )
                _next_state = P_KER_S;
            if( CTRL[0] == 1'b1 )
                _next_state = P_KER_M;
        end

        P_KER_S: begin
            state = P_KER_S;

        end

    endcase
end

endmodule
