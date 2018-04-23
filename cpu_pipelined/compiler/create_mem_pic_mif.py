# Date: 04/18/18
# Hexadecimal converter:
#   https://stackoverflow.com/questions/7822956/how-to-convert-negative-integer-value-to-hex-in-python

# WIDTH OF THE MEMORY
WIDTH = 48
DEPTH = 307200

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
output_file_dir = "../cpu_pipelined/rtl/mem_pic.mif"             # Direction of output file
path = os.path.join( this_file_dir, output_file_dir )           # Create a relative path
f = open( path, "w+" )

f.write( "WIDTH=%d;\n" % WIDTH )
f.write( "DEPTH=%d;\n\n" % DEPTH )

f.write( "ADDRESS_RADIX=UNS;\n" )
f.write( "DATA_RADIX=HEX;\n\n" )

f.write( "CONTENT BEGIN\n" )

# set data outputs
d = image
aux_addr = 0
for i in range( d.shape[0] ):
    f.write( "\n")
    for j in range( d.shape[1] ):
        val = d[i][j]
        f.write( "\t%d\t:\t" % aux_addr )
        f.write( "%s;\n" % tohex( int(val), WIDTH//4 ) )
        aux_addr += 1
f.write( "END;" )
f.close() # close file

print( "Finish. OK." )
print( "See 'cpu_pipelined/hdl/mem_pic.sv'." )
# fisnish the program