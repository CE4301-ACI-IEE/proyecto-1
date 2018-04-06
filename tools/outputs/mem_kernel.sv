`timescale 1ns / 1ps
module mem_kernel #( parameter SIZE = 16 )
(
  input logic CLK,
  input logic [SIZE-1:0] ADDRESS,
  output logic [SIZE-1:0] READ
);
always_ff@( posedge CLK ) begin
  case( ADDRESS[SIZE-1:2] )
      16'd0: READ <= 16'H0;
      16'd1: READ <= 16'Hffff;
      16'd2: READ <= 16'H0;
      16'd3: READ <= 16'Hffff;
      16'd4: READ <= 16'H5;
      16'd5: READ <= 16'Hffff;
      16'd6: READ <= 16'H0;
      16'd7: READ <= 16'Hffff;
      16'd8: READ <= 16'H0;
      default: READ <= 16'bx;
  endcase
end

endmodule
