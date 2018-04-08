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
f = open( "outputs/mem_pic.sv", "w+" )

# initilize module
f.write( "`timescale 1ns / 1ps\n" )
f.write( "module mem_pic #( parameter SIZE = 8 )\n" )
f.write( "(\n" )
# inputs and outputs of module
#f.write( "  input logic CLK,\n" )
f.write( "  input logic [SIZE-1:0] ADDRESS,\n" )
f.write( "  output logic [SIZE-1:0] READ\n" )
f.write( ");\n" )

# always block
#f.write( "always_ff@( posedge CLK ) begin\n" )
f.write( "always_comb begin\n" )
f.write( "  case( ADDRESS << 2 )\n" )

# set data outputs, like a multiplexor
d = image
aux_addr = 0
for i in range( d.shape[0] ):
    for j in range( d.shape[1] ):
        val = d[i][j]
        f.write( "      32'H%d: READ " % aux_addr )
        f.write( "<= 8'H%s;\n" % tohex( val, N_BITS ) )
        aux_addr += 1

f.write( "      default: READ <= 8'bx;\n" )
f.write( "  endcase\n" )
f.write( "end\n" )
f.write( "\nendmodule\n" ) # endmodule
f.close() # close file

print( "Finish. OK." )
# fisnish the program