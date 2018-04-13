`timescale 1ns / 1ps

// Memory controller module

// input logic [1:0] Ctrl meaning:
    // if Ctrl[0] == 0 : is expected a singular value of the matrix
        // Ctrl[1] don't care
    // if Ctrl[0] == 1 : is expected a multiple value of the matrix, with another options:
        // if Ctrl[1] == 0 : is expected multiple horizontal values
        // if Ctrl[1] == 1 : is expected multiple vertical values

module memory_controller 
(
    input logic CLK,
    input logic CLK_MEM,
    input logic ENABLE,
    input logic [1:0] Ctrl,
    input logic [31:0] ADDRESS,
    input logic [15:0] ReadMem,
    output logic [15:0] AddressMem,
    output logic HANDSHAKE,
    output logic [47:0] READ,
    output logic [47:0] _state_ // For debug only
);

parameter SS = 100, S0 = 00, S1 = 01, S2 = 02, S3 = 03, S4 = 04;
parameter S11 = 11, S12 = 12, S13 = 13, S14 = 14, S15 = 15, S16 = 16;

logic [15:0] _state;
logic [15:0] _next_state;

logic [47:0] read_tmp;
logic [15:0] val_tmp;

always_ff@( posedge CLK ) begin
    if( ~ENABLE )
        _state <= SS;
    else if( CLK_MEM )
        _state <= _next_state;
end

always_comb begin
    _next_state = 16'bx;
    case( _state )
        
        SS: begin 
            if( ENABLE )    _next_state = S0;
            else            _next_state = SS;
        end
        
        S0: begin 
            if( Ctrl[0] )   _next_state = S11;
            else            _next_state = S1;
        end
        
        S1:                 _next_state = S2;
        
        S2:                 _next_state = S3;
        
        S3: begin
            if( val_tmp<3 ) _next_state = S3;
            else            _next_state = SS; // FIX. Wait cycles (?)
        end
        
        S11:                _next_state = S12;
        
        S12:                _next_state = S13;
        
        S13:                _next_state = S14;
        
        S14:                _next_state = S15;
        
        S15:                _next_state = S16;
        
        S16:                _next_state = S16;

    endcase
end

always_ff@( posedge CLK ) begin
    if( CLK_MEM ) begin
        case( _state )

            SS: begin
                _state_ <= SS;
                READ <= 48'bx;
                AddressMem <= 16'bx;
            end

            S0: begin
                _state_ <= S0;
            end

            S1: begin
                _state_ <= S1;
                AddressMem <= ADDRESS;
            end

            S2: begin
                _state_ <= S2;
                val_tmp <= 1'b0; // Possible wait flag
            end

            S3: begin
                _state_ <= S3;
                READ <= { {32{ReadMem[15]}}, ReadMem[15:0] };
                val_tmp <= val_tmp + 1'b1; // Possible wait flag
            end

            S11: begin
                _state_ <= S11;
                if( Ctrl[1] == 1'b0 ) begin
                    AddressMem <= { ADDRESS[31:16], ADDRESS[15:0] };
                    val_tmp <= ADDRESS[15:0] + 1'b1;
                end
                else if( Ctrl[1] == 1'b1 ) begin
                    AddressMem <= { ADDRESS[31:16], ADDRESS[15:0] };
                    val_tmp <= ADDRESS[31:16] + 1'b1;
                end
            end

            S12: begin
                _state_ <= S12;
                if( Ctrl[1] == 1'b0 ) begin
                    AddressMem <= { ADDRESS[31:16], val_tmp[15:0] };
                    val_tmp <= val_tmp[15:0] + 1'b1;
                end
                else if( Ctrl[1] == 1'b1 ) begin
                    AddressMem <= { val_tmp[15:0], ADDRESS[15:0] };
                    val_tmp <= val_tmp[15:0] + 1'b1;
                end
            end

            S13: begin
                _state_ <= S13;
                if( Ctrl[1] == 1'b0 ) begin
                    AddressMem <= { ADDRESS[31:16], val_tmp[15:0] };
                end
                else if( Ctrl[1] == 1'b1 ) begin
                    AddressMem <= { val_tmp[15:0], ADDRESS[15:0] };
                end
                
                read_tmp[15:0] <= ReadMem[15:0];
            end

            S14: begin
                _state_ <= S14;
                read_tmp[31:16] <= ReadMem[15:0];
                AddressMem <= 32'bx;
            end

            S15: begin
                _state_ <= S15;
                read_tmp[47:32] <= ReadMem[15:0];
            end

            S16: begin
                _state_ <= S16;
                READ <= read_tmp;
            end

        endcase
    end
end

endmodule
