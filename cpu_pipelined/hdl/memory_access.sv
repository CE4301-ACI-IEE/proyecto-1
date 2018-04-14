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

assign READ = ( ~CTRL[0] ) ? m_k_READ : m_p_READ ;
assign HANDSHAKE = ( ~CTRL[0] ) ? m_k_handshake : m_p_handshake ;

parameter   STATE_MAX = 12;
parameter   S_IDLE = 0,
            S_START = 1,
            S_ENABLE_K = 2,
            S_ENABLE_P = 3,
            S_READ_K = 4,
            S_READ_P = 5,
            S_START_K = 6,
            S_START_P = 7,
            S_DLY_1 = 8,
            S_DONE = 9,
            S_NOT_ENABLE_K = 10,
            S_NOT_ENABLE_P = 11;
;

logic [STATE_MAX:0] _state, _next_state;
logic [47:0] read_tmp;

always_ff@( posedge CLK or RESET ) begin
    if( RESET ) begin
        _state <= {STATE_MAX{1'b0}};
        _state[ S_IDLE ] <= 1'b1;
    end
    else _state <= _next_state;
end

always_ff@( _state or ENABLE or CTRL[0] or m_k_handshake or m_p_handshake) begin
    _next_state <= {STATE_MAX{1'b0}};
    case( 1'b1 )

        _state[S_IDLE] : begin
            if( ENABLE )        _next_state[ S_START ]      <= 1'b1;
            else                _next_state[ S_IDLE ]       <= 1'b1;
        end

        _state[S_START] : begin
            if( ~CTRL[0] ) begin // States      
                                _next_state[ S_START_K ]    <= 1'b1;
                                // Tasks
                                _next_state[ S_ENABLE_K ]   <= 1'b1;
            end                 
            else begin          // States
                                _next_state[ S_START_P ]    <= 1'b1;
                                // Tasks
                                _next_state[ S_ENABLE_P ]   <= 1'b1;
            end
        end
        
        _state[S_START_K] : begin
                                 // States      
            if( m_k_handshake ) _next_state[ S_DLY_1 ]      <= 1'b1;
            else                _next_state[ S_START_K ]    <= 1'b1;
                                
                                // Tasks
                                _next_state[ S_ENABLE_K ]   <= 1'b1;
        end

        _state[S_START_P] : begin
                                 // States      
            if( m_p_handshake ) _next_state[ S_DLY_1 ]      <= 1'b1;
            else                _next_state[ S_START_P ]    <= 1'b1;
                                // Tasks
                                _next_state[ S_ENABLE_P ]   <= 1'b1;
        end

        _state[S_DLY_1] : begin
                                _next_state[ S_DONE ]       <= 1'b1;
        end

        _next_state[S_DONE] : begin
                                _next_state[ S_IDLE ]       <= 1'b1;
                            _next_state[ S_NOT_ENABLE_K ]   <= 1'b1;
                            _next_state[ S_NOT_ENABLE_P ]   <= 1'b1;                            
        end

    endcase
end

always_ff@( posedge CLK or RESET ) begin
    if( RESET ) begin
        read_tmp <= 48'bx;
        m_k_enable <= 1'b0;
        m_p_enable <= 1'b0;
    end
    else begin
        case( 1'b1 )
            
            _next_state[ S_ENABLE_K ] : m_k_enable <= 1'b1;
            _next_state[ S_NOT_ENABLE_K ] : m_k_enable <= 1'b0;

            _next_state[ S_ENABLE_P ] : m_p_enable <= 1'b1;
            _next_state[ S_NOT_ENABLE_P ] : m_k_enable <= 1'b0;

        endcase
    end
end

endmodule
