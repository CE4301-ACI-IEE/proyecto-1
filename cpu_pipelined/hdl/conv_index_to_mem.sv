module conv_index_to_mem
(
    input CLK,
    input RESET,
    input [1:0] SIZE_IMAGE_SRC,
    input [31:0] INDEX_ADDRESS,
    output [31:0] MEM_ADDRESS
);

logic [31:0] _width;
logic [31:0] _height;
logic [31:0] _const_byte;
logic [31:0] tmp1;
logic [31:0] tmp2;
logic [31:0] tmp3;
logic [31:0] out;

always_ff@( posedge CLK or posedge RESET ) begin
    if( RESET ) begin
        if( ~SIZE_IMAGE_SRC[0] ) begin
            _width = 32'd640;
            _height = 32'd480;
            _const_byte = 32'd1;
        end
        else begin
            _width = 32'd1024;
            _height = 32'd768;
            _const_byte = 32'd1;
        end
        if( SIZE_IMAGE_SRC[1] ) begin
            _width = 32'd3;
            _height = 32'd3;
            _const_byte = 32'b1;
        end
    end
    else begin
        tmp1 = 32'b0;
        tmp2 = 32'b0;
        tmp1[15:0] = INDEX_ADDRESS[31:16];
        tmp2[15:0] = INDEX_ADDRESS[15:0];
        if( tmp1 >= _height || tmp2 >= _width ) begin
            out = 32'Hffffffff;
        end
        else begin
            tmp1 = (_const_byte*INDEX_ADDRESS[15:0]);
            tmp2 = (_const_byte*_width);
            tmp3 = (tmp2*INDEX_ADDRESS[31:16]);
            out = (tmp1+tmp3); 
        end
    end
end

assign MEM_ADDRESS = out;

endmodule
