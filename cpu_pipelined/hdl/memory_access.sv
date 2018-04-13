// Date: 04/11/18

`timescale 1ns / 1ps

// Memory access controller module
module memory_access
(
    input logic CLK,
    input logic CLK_MEM,
    input logic RESET,
    input logic ENABLE,
    input logic [2:0] CTRL,
    input logic [47:0] ADDRESS,
    output logic [47:0] READ
);

// Logics mem_kernel
logic [31:0] m_k_address;
logic [15:0] m_k_read;

// Logics memory_controller kernel
logic m_k_enable;
logic [1:0] m_k_ctrl;
logic [31:0] m_k_ADDRESS;
logic [47:0] m_k_READ;
logic m_k_handshake;

// Logics mem_pic
logic [31:0] m_p_address;
logic [15:0] m_p_read;

// Logics memory_controller kernel
logic m_p_enable;
logic [1:0] m_p_ctrl;
logic [31:0] m_p_ADDRESS;
logic [47:0] m_p_READ;
logic m_p_handshake;


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
        .ADDRESS( m_k_ADDRESS ),
        .ReadMem( m_k_read ),
        .AddressMem( m_k_address ),
        .HANDSHAKE( m_k_handshake ),
        .READ( m_k_READ ),
        ._state_(  ) // For debugging
    );

memory_controller mc_p(
        .CLK( CLK ),
        .CLK_MEM( CLK_MEM ),
        .ENABLE( m_p_enable ),
        .Ctrl( m_p_ctrl ),
        .ADDRESS( m_p_ADDRESS ),
        .ReadMem( m_p_read ),
        .AddressMem(  m_p_address),
        .HANDSHAKE( m_p_handshake ),
        .READ( m_p_READ ),
        ._state_(  ) // For debugging
    );

assign m_k_ctrl[0] = CTRL[1];
assign m_k_ctrl[1] = CTRL[2];

assign m_p_ctrl[0] = CTRL[1];
assign m_p_ctrl[1] = CTRL[2];

assign m_k_ADDRESS = ADDRESS[31:0];
assign m_p_ADDRESS = ADDRESS[31:0];

logic [47:0] read_tmp;

logic [15:0] _state;
logic [15:0] _next_state;

always_ff@( posedge CLK ) begin
	if( RESET ) _state = S_IDLE;
    else _state = _next_state;
end

always_ff@( _state ) begin
    case( _state )

    S_IDLE: if( ~ENABLE )           _next_state = S_START;

    S_START: 

    endcase
end

always_ff@( posedge CLK ) begin
    case( _state ) 

        S_IDLE: begin
            m_k_enable <= 1'b0;
            m_p_enable <= 1'b0;
        end

        S_START: begin
            if( CTRL[0] )            
        end

    endcase
end

assign READ = read_tmp;

endmodule
