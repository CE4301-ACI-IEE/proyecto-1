// Date: 04/11/18
// By: Ernesto & Isaac

`timescale 1ns / 1ps

// Memory access controller module
// Select the type of memory to read
// and calls the respective memory controller
module memory_access
(
    input logic CLK,
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
logic [47:0] m_p_read;

// Logics memory_controller kernel
logic m_p_enable;
logic [1:0] m_p_ctrl;
logic [31:0] m_p_ADDRESS;
logic [47:0] m_p_READ;
logic m_p_handshake;

// logic state machine
logic [1:0] _size_img_src_kernel;
logic [1:0] _size_img_src_pic;
logic [31:0] _read_address;
logic [2:0] _local_ctrl;
logic [47:0] _local_read_output;

// ROM of kernel
mem_kernel rom_kernel (
        .address( m_k_address[3:0] ),
        .clock( CLK ),
        .data(  ),
        .wren( 1'b0 ),
        .q( m_k_read )
);


// ROM of picture
mem_pic rom_pic (
        .address( m_p_address[18:0] ),
        .clock( CLK ),
        .data(  ),
        .wren( 1'b0 ),
        .q( m_p_read )
);


// Memory controller of kernel ROM
memory_controller mc_k (
        .CLK( CLK ),
        .RESET( RESET ),
        .ENABLE( m_k_enable ),
        .Ctrl( m_k_ctrl ),
        .IndexCtrl( _size_img_src_kernel ),
        .ADDRESS( _read_address ),
        .ReadMem( m_k_read ),
        .AddressMem( m_k_address ),
        .HANDSHAKE( m_k_handshake ),
        .READ( m_k_READ )
    );


// Memory controller of picture ROM
memory_controller mc_p(
        .CLK( CLK ),
        .ENABLE( m_p_enable ),
        .Ctrl( m_p_ctrl ),
        .ADDRESS( m_p_ADDRESS ),
        .IndexCtrl( _size_img_src_pic ),
        .ReadMem( m_p_read[15:0] ),
        .AddressMem(  m_p_address),
        .HANDSHAKE( m_p_handshake ),
        .READ( m_p_READ )
    );


// Constant values
assign m_k_ctrl[0] = _local_ctrl[1];
assign m_k_ctrl[1] = _local_ctrl[2];

assign m_p_ctrl[0] = _local_ctrl[1];
assign m_p_ctrl[1] = _local_ctrl[2];

logic [15:0] _state;
logic [15:0] _next_state;
parameter   SS = 00,
            S0 = 01,
            S10 = 10,
            S20 = 20,
            S_DONE = 30;

// change the actual state
always_ff@( posedge CLK ) begin
    if( RESET ) begin
        _state <= SS;
        _size_img_src_kernel <= 2'b10;
        _size_img_src_pic <= 2'b00;
    end
    else begin
       if( ~ENABLE ) begin
            _state <= SS;
        end
        else begin
            _state <= _next_state;
        end 
    end
end

// logic next state and set constants
always_ff@( posedge CLK ) begin
    case( _state )

        SS: begin
            if( ENABLE ) begin
                                _next_state = S0;
                                _read_address = ADDRESS[31:0];
                                _local_ctrl = CTRL;
            end
            else begin                
                                _next_state = SS;
                                _read_address = 32'bx;
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

// set variables and excecute functions
always_ff@( negedge CLK ) begin
    case( _state )

        SS: begin // waits enable signal
            READ = 48'bx;
            HANDSHAKE = 1'b0;
        end

        S0: begin // delay
        end

        S10: begin // delay in kernel memory controller until the value(s) is(are) readed
            READ = m_k_READ;
            HANDSHAKE = m_k_handshake;
        end

        S20: begin // delay in picture memory controller until the value(s) is(are) readed
            READ = m_p_READ;
            HANDSHAKE = m_p_handshake;
        end

        S_DONE: begin // dealy, finish
            HANDSHAKE = 1'b0;
        end

    endcase
end

endmodule
