`timescale 1ns / 1ps

// Memory access controller module

// 
module memory_access
(
    input logic CLK,
    input logic CLK_MEM,
    input logic RESET,
    input logic [2:0] CTRL,
    input logic [31:0] ADDRESS,
    output logic [47:0] READ,
);

logic [15:0] _state;
logic [15:0] _next_state;

logic [SIZE-1:0] read_tmp;
logic [15:0] val_tmp;

// Logics mem_kernel
logic [31:0] m_k_address;
logic [15:0] m_k_read;

// Logics memory_controller kernel
logic m_k_enable;
logic [1:0] m_k_ctrl;
logic [31:0] m_k_ADDRESS_tmp;
logic [47:0] m_k_READ;

// Logics mem_pic
logic [31:0] m_p_address;
logic [15:0] m_p_read;

// Logics memory_controller kernel
logic m_p_enable;
logic [1:0] m_p_ctrl;
logic [31:0] m_p_ADDRESS_tmp;
logic [47:0] m_p_READ;

mem_kernel m_k (
        .CLK( CLK ),
		.ADDRESS( m_k_address ),
		.READ( m_k_read )
);

mem_pic m_p (
        .CLK( CLK ),
		.ADDRESS( m_p_address ),
		.READ( m_p_read )
    );

memory_controller mc_k (
        .CLK( CLK ),
        .CLK_MEM( CLK_MEM ),
        .ENABLE( m_k_enable ),
        .Ctrl( m_k_ctrl ),
        .ADDRESS(  ),
        .ReadMem( m_k_read ),
        .AddressMem( m_k_address ),
        .HANDSHAKE(  ),
        .READ( m_k_READ ),
        ._state_(  ) // For debugging
    );

memory_controller mc_p(
        .CLK( CLK ),
        .CLK_MEM( CLK_MEM ),
        .ENABLE( m_p_enable ),
        .Ctrl( m_p_ctrl ),
        .ADDRESS(  ),
        .ReadMem( m_p_read ),
        .AddressMem(  m_p_address),
        .HANDSHAKE(  ),
        .READ( m_p_READ ),
        ._state_(  ) // For debugging
    );

always_ff@( posedge CLK ) begin
    if( RESET )
        _state <= SS;
    else if( CLK_MEM )
        _state <= _next_state;
end

always_comb begin
    _next_state = 16'bx;
    case( _state )

    endcase
end

always_ff@( posedge CLK ) begin
    if( CLK_MEM ) begin
        case( _state )

        endcase
    end
end

endmodule
