`timescale 1ns / 1ps
module instruction_rom #( parameter SIZE = 32)
(
  input logic CLK,
  input logic Reset,
  input logic [SIZE-1:0] Address,
  output logic [SIZE-1:0] Instr
);
always@(posedge CLK) begin
  if( Reset ) Instr <= 48'bx;
  else begin
    case (Address/48'd4)
      48'H000000000000: Instr <= 48'He8300a000000;
      48'H000000000001: Instr <= 48'He14002000001;
      48'H000000000002: Instr <= 48'He14004000002;
      48'H000000000003: Instr <= 48'He14006000003;
      48'H000000000004: Instr <= 48'He8300c000001;
      48'H000000000005: Instr <= 48'He8300e000002;
      48'H000000000006: Instr <= 48'He403c0fffff8;
      default: Instr <= 48'bx;
    endcase
  end
end
endmodule