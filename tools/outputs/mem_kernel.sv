`timescale 1ns / 1ps
module mem_kernel #( parameter SIZE = 16 )
(
  input logic [5:0] ADDRESS,
  output logic [SIZE-1:0] READ
);
always_comb begin
  case( ADDRESS[5:2] )
      4'd0: READ <= 16'H0;
      4'd1: READ <= 16'Hffff;
      4'd2: READ <= 16'H0;
      4'd3: READ <= 16'Hffff;
      4'd4: READ <= 16'H5;
      4'd5: READ <= 16'Hffff;
      4'd6: READ <= 16'H0;
      4'd7: READ <= 16'Hffff;
      4'd8: READ <= 16'H0;
      default: READ <= 16'bx;
  endcase
end

endmodule
