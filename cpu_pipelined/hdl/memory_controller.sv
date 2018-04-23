// Design By: Ernesto & Isaac

`timescale 1ns / 1ps

// Memory controller module
// Module thats control the memories of kernel and picture
// This is a prototype

// input logic [1:0] Ctrl meaning:
    // if Ctrl[0] == 0 : is expected a singular value of the matrix
        // Ctrl[1] don't care
    // if Ctrl[0] == 1 : is expected a multiple value of the matrix, with another options:
        // if Ctrl[1] == 0 : is expected multiple horizontal values
        // if Ctrl[1] == 1 : is expected multiple vertical values

module memory_controller 
(
    input logic CLK,
    input logic RESET,
    input logic ENABLE,
    input logic [1:0] Ctrl,
    input logic [1:0] IndexCtrl,
    input logic [31:0] ADDRESS,
    input logic [15:0] ReadMem,
    output logic [31:0] AddressMem,
    output logic HANDSHAKE,
    output logic [47:0] READ
);

// States
parameter SS = 100, S0 = 00, S1 = 01, S2 = 02;
parameter S11 = 11, S12 = 12, S13 = 13, S14 = 14, S15 = 15, S16 = 16;

// Logic state machine
logic [15:0] _state;
logic [15:0] _next_state;

logic [31:0] _local_address;
logic [31:0] _address_mem;
logic [47:0] _read_tmp;
logic [15:0] _val_aux;

// convert the index in _address_mem to a memory address
conv_index_to_mem kernelIndexConverter(
    .CLK( CLK ),
    .RESET( RESET ),
    .SIZE_IMAGE_SRC( IndexCtrl ),
    .INDEX_ADDRESS( _address_mem ),
    .MEM_ADDRESS( AddressMem )
);

// change the actual state
always_ff@( posedge CLK ) begin
    if( ~ENABLE )
        _state <= SS;
    else
        _state <= _next_state;
end

// state changes
always_ff@( posedge CLK ) begin
    case( _state )
        
        SS: begin 
            if( ENABLE ) begin    
                            _next_state = S0; 
                            _local_address = ADDRESS; 
            end
            else         begin   
                            _next_state = SS; 
                            _local_address = 32'bx; 
            end
        end
        
        S0: begin 
            if( Ctrl[0] )   _next_state = S11;
            else            _next_state = S2;
        end

        S1: begin
            _next_state = S2;
        end

        S2: begin
            if( _val_aux<0 ) _next_state = S2;
            else            _next_state = SS; // Wait cycles
        end
        
        S11:                _next_state = S12;
        
        S12:                _next_state = S13;
        
        S13:                _next_state = S14;
        
        S14:                _next_state = S15;
        
        S15:                _next_state = S16;
        
        S16: begin
            if( _val_aux<1 )_next_state = S16;
            else            _next_state = SS; // Wait cycles
        end
    endcase
end

// set variables and excecute functions
// in this case there are two main fuctions
// 1 - extract 1 value of the memory by index
// 2 - extract 3 values of the memory by index( only needs a start value )
always_ff@( posedge CLK ) begin
    case( _state )

        SS: begin
            READ = 48'bx; // nothing to read
            HANDSHAKE = 1'b0; // handshake off
            _address_mem = _local_address; // set variable
        end

        S0: begin // set first address delay
            //_address_mem = _local_address;
            _val_aux = 1'b0; // initialize wait flag
        end

        /***********************************************************/
        // Only for 1 value
        // Get 1 value of the memory
        S2: begin
            READ = { {32{ReadMem[15]}}, ReadMem[15:0] }; // set read value in output 
            _val_aux = _val_aux + 1'b1; // increment wait flag
            HANDSHAKE = 1'b1; // handshake on
        end

        /************************************************************/
        // Only for 3 values
        S11: begin // set second address delay
            if( Ctrl[1] == 1'b0 ) begin
                //_address_mem = { _local_address[31:16], _local_address[15:0] };
                _val_aux = _local_address[15:0] + 1'b1;
                _address_mem = { _local_address[31:16], _val_aux[15:0] };
            end
            else if( Ctrl[1] == 1'b1 ) begin
                //_address_mem = { _local_address[31:16], _local_address[15:0] };
                _val_aux = _local_address[31:16] + 1'b1;
                _address_mem = { _val_aux[15:0], _local_address[15:0] };
            end
        end

        S12: begin // set third address delay and read first value
            if( Ctrl[1] == 1'b0 ) begin
                _address_mem = { _local_address[31:16], _val_aux[15:0] };
                _val_aux = _val_aux[15:0] + 1'b1;
            end
            else if( Ctrl[1] == 1'b1 ) begin
                _address_mem = { _val_aux[15:0], _local_address[15:0] };
                _val_aux = _val_aux[15:0] + 1'b1;
            end
            _read_tmp[15:0] = ReadMem[15:0];
        end

        S13: begin // reads second value
            if( Ctrl[1] == 1'b0 ) begin
                //_address_mem = { _local_address[31:16], _val_aux[15:0] };
            end
            else if( Ctrl[1] == 1'b1 ) begin
                //_address_mem = { _val_aux[15:0], _local_address[15:0] };
            end

            //_val_aux = 16'b0;
            //_read_tmp[15:0] = ReadMem[15:0];    
            _read_tmp[31:16] = ReadMem[15:0];
        end

        S14: begin // reads third value
            //_read_tmp[31:16] = ReadMem[15:0];
            //_address_mem = 32'bx;
            _read_tmp[47:32] = ReadMem[15:0];
        end

        S16: begin // delay
            //_read_tmp[47:32] = ReadMem[15:0];
        end

        S15: begin // set concatenated value in output READ
            READ = _read_tmp;
            HANDSHAKE = 1'b1;
            _val_aux = _val_aux + 1'b1;
        end

    endcase
end

endmodule
