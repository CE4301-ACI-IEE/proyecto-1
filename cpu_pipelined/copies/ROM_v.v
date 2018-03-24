`timescale 1ns / 1ps
module ROM_v(
	input wire clk,
	input wire reset,
   input wire [31:0] Dir,
   output wire [31:0] Instruccion
    );

reg [31:0] Instruccion_temp;

always@(posedge clk) begin
	if( reset ) Instruccion_temp <= {32{1'b1}};
	else begin
		case( Dir / 32'd4 )
			32'd0: Instruccion_temp  <= 32'HE04F000F;
			32'd1: Instruccion_temp  <= 32'HE2802005;
			32'd2: Instruccion_temp  <= 32'HE280300C;
			32'd3: Instruccion_temp <= 32'HE2437009;
			32'd4: Instruccion_temp <= 32'HE1874002;
			32'd5: Instruccion_temp <= 32'HE0035004;
			32'd6: Instruccion_temp <= 32'HE0855004;
			32'd7: Instruccion_temp <= 32'HE0558007;
			32'd8: Instruccion_temp <= 32'H0A00000C;
			32'd9: Instruccion_temp <= 32'HE0538004;
			32'd10: Instruccion_temp <= 32'HAA000000;
			32'd11: Instruccion_temp <= 32'HE2805000;
			32'd12: Instruccion_temp <= 32'HE0578002;
			32'd13: Instruccion_temp <= 32'HB2857001;
			32'd14: Instruccion_temp <= 32'HE0477002;
			32'd15: Instruccion_temp <= 32'HE5837054;
			32'd16: Instruccion_temp <= 32'HE5902060;
			32'd17: Instruccion_temp <= 32'HE08FF000;
			32'd18: Instruccion_temp <= 32'HE280200E;
			32'd19: Instruccion_temp <= 32'HEA000001;
			32'd20: Instruccion_temp <= 32'HE280200D;
			32'd21: Instruccion_temp <= 32'HE280200A;
			32'd22: Instruccion_temp <= 32'HE5802064;
			default: Instruccion_temp <= 32'Hx;
		endcase
	end
end

assign Instruccion = Instruccion_temp;

endmodule