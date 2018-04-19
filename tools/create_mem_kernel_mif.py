# Date: 04/17/18

print( "Starting..." )

import os

OUTPUT_BITS = 16
DEPTH = 9

# convert to signed dec to hex
def tohex( val, nbits ):
    a = hex((val+(1<<nbits))%(1<<nbits))
    return a[2::]

# Convert the matrix given as mem_kernel.mif file 

# kernel blur (box blur)
#kernel_matrix = [ [1,1,1], [1,1,1], [1,1,1] ]

# kernel sharpen
kernel_matrix = [ [0,-1,0], [-1,5,-1], [0,-1,0] ]

# kernel edge detection
#kernel_matrix = [ [-1,-1,-1], [-1,-8,-1], [-1,-1,-1] ]

# create mem_kernel.mif file
this_file_dir = os.path.dirname(os.path.realpath('__file__'))   # Direction of this file
output_file_dir = "../cpu_pipelined/hdl/mem_kernel.mif"           # Direction of output file
path = os.path.join( this_file_dir, output_file_dir )           # Create a relative path
f = open( path, "w+" )

f.write( "WIDTH=%d;\n" % OUTPUT_BITS )
f.write( "DEPTH=%d;\n\n" % DEPTH )

f.write( "ADDRESS_RADIX=HEX;\n" )
f.write( "DATA_RADIX=HEX;\n\n" )

f.write( "CONTENT BEGIN\n" )
d = kernel_matrix
aux_address = 0
for i in range( len(d) ):
    for j in range( len(d[i]) ):
        val = d[i][j];
        f.write( "\t%d\t:\t" % aux_address )
        f.write( "%s;\n" % tohex( val, OUTPUT_BITS ).zfill(4) )
        aux_address += 1

f.write( "END;" )
f.close() # close file

print( "Finish.OK" )
print( "See 'cpu_pipelined/hdl/mem_kernel.mif'." )

# fisnish the program