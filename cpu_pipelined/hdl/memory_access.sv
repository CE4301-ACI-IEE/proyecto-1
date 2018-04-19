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
    output logic [47:0] READ,
    output logic HANDSHAKE
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

logic [31:0] _read_address;
logic [31:0] _local_address;
logic [2:0] _local_ctrl;
logic [47:0] _local_read_output;

mem_kernel rom_kernel (
        .address( m_k_address ),
        .clock( CLK ),
        .data(  ),
        .wren( 1'b0 ),
        .q( m_k_read )
);

mem_pic rom_pic (
        .address( m_p_address ),
        .clock( CLK ),
        .data(  ),
        .wren( 1'b0 ),
        .q( m_p_read )
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

conv_index_to_mem index_converter(
    .CLK( CLK ),
    .RESET( RESET ),
    .SIZE_IMAGE( 1'b0 ),
    .INDEX_ADDRESS( _read_address ),
    .MEM_ADDRESS( _local_address )
);

assign m_k_ctrl[0] = _local_ctrl[1];
assign m_k_ctrl[1] = _local_ctrl[2];

assign m_p_ctrl[0] = _local_ctrl[1];
assign m_p_ctrl[1] = _local_ctrl[2];

assign m_k_ADDRESS = _local_address;
assign m_p_ADDRESS = _local_address;

logic [15:0] _state;
logic [15:0] _next_state;
parameter   SS = 00,
            S0 = 01,
            S10 = 10,
            S20 = 20,
            S_DONE = 30;

always_ff@( posedge CLK ) begin
    if( ~ENABLE ) begin
        _state <= SS;
    end
    else begin
        _state <= _next_state;
    end
end

always@(*) begin
    case( _state )

        SS: begin
            if( ENABLE ) begin
                                _next_state = S0;
                                _read_address = ADDRESS[31:0];
                                _local_ctrl = CTRL;
            end
            else begin                
                                _next_state = SS;
                                _local_address = 32'bx;
                                _local_ctrl = 3'bx;
            end
                                m_k_enable = 1'b0;
                                m_p_enable = 1'b0; 
        end

        S0: begin
            if(~_local_ctrl[0]) begin
                                _next_state = S10;
                                m_k_enable = 1'b1;
            end
            else begin                
                                _next_state = S20;
                                m_p_enable = 1'b1;
            end
        end

        S10: begin
            if( m_k_handshake ) begin
                                _next_state = S_DONE;
            end
            else                _next_state = S10;
        end

        S20: begin
            if( m_p_handshake ) begin
                                _next_state = S_DONE;
            end
            else                _next_state = S20;
        end

    endcase
end

always_ff@( posedge CLK ) begin
    if( CLK_MEM ) begin
        case( _state )

            SS: begin
                READ <= 48'bx;
                HANDSHAKE <= 1'b0;
            end

            S0: begin
            end

            S10: begin
                READ <= m_k_READ;
                HANDSHAKE <= m_k_handshake;
            end

            S20: begin
                READ <= m_p_READ;
                HANDSHAKE <= m_p_handshake;
            end

            S_DONE: begin
                //HANDSHAKE <= 1'b1;
            end

        endcase
    end
end

endmodule
