module conv_index_to_mem (
    input CLK,
    input RESET,
    input SIZE_IMAGE,
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
        if( ~SIZE_IMAGE ) begin
            _width = 32'd640;
            _height = 32'd480;
            _const_byte = 32'd4;
        end
        else begin
            _width = 32'd1024;
            _height = 32'd768;
            _const_byte = 32'd4;
        end
    end
    else begin
       tmp1 = (_const_byte*INDEX_ADDRESS[15:0]);
       tmp2 = (_const_byte*_width);
       tmp3 = (tmp2*INDEX_ADDRESS[31:16]);
       out = (tmp1+tmp3);
    end
end

assign MEM_ADDRESS = out;

endmodule
