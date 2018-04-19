# Date: 04/04/18
# Hexadecimal converter:
#   https://stackoverflow.com/questions/7822956/how-to-convert-negative-integer-value-to-hex-in-python

# WIDTH OF THE MEMORY
N_BITS = 8

# convert to signed dec to hex
def tohex( val, nbits ):
    a = hex((val+(1<<nbits))%(1<<nbits))
    return a[2::]

# read arguments
import sys
import cv2
import os

print( "Starting..." )

# Convert the picture given as mem_kernel.sv file
image = len(sys.argv)
if ( image > 1):
    try:
        image = cv2.imread(sys.argv[1])
        image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    except:
        sys.exit("Error loading image.")
else:
    sys.exit("Error loading image.")

# create mem_kernel.sv file
this_file_dir = os.path.dirname(os.path.realpath('__file__'))   # Direction of this file
output_file_dir = "../cpu_pipelined/hdl/mem_pic.sv"             # Direction of output file
path = os.path.join( this_file_dir, output_file_dir )           # Create a relative path
f = open( path, "w+" )

# initilize module
f.write( "`timescale 1ns / 1ps\n" )
f.write( "module mem_pic #( parameter SIZE = 16 )\n(\n\t" )
# inputs and outputs of module
f.write( "input logic CLK,\n\t" )
f.write( "input logic [31:0] ADDRESS,\n\t" )
f.write( "output logic [SIZE-1:0] READ\n" )
f.write( ");\n\n" )

# always block
f.write( "always_ff@( posedge CLK ) begin\n\t" )
f.write( "case( ADDRESS )\n\t\t" )

# set data outputs, like a multiplexor
d = image
aux_addr = 0
for i in range( d.shape[0] ):
    f.write( "\n\t\t")
    for j in range( d.shape[1] ):
        val = d[i][j]
        f.write( "32'H")
        f.write( tohex( i, 16 ).zfill(4) )
        f.write( tohex( j, 16 ).zfill(4) )
        f.write( ": READ <= 16'H%s;\n\t\t" % tohex( val, N_BITS ) )
        aux_addr += 1

f.write( "default: READ <= 16'b0;\n\t" )
f.write( "endcase\n\t" )
f.write( "end\n" )
f.write( "\nendmodule\n" ) # endmodule
f.close() # close file

print( "Finish. OK." )
print( "See 'cpu_pipelined/hdl/mem_pic.sv'." )
# fisnish the program