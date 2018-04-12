# Date: 04/03/18

print( "Starting..." )

import os

N_BITS = 16

# convert to signed dec to hex
def tohex( val, nbits ):
    a = hex((val+(1<<nbits))%(1<<nbits))
    return a[2::]

# Convert the matrix given as mem_kernel.sv file 

# kernel blur (box blur)
#kernel_matrix = [ [1,1,1], [1,1,1], [1,1,1] ]

# kernel sharpen
kernel_matrix = [ [0,-1,0], [-1,5,-1], [0,-1,0] ]

# kernel edge detection
#kernel_matrix = [ [-1,-1,-1], [-1,-8,-1], [-1,-1,-1] ]

# create mem_kernel.sv file
this_file_dir = os.path.dirname(os.path.realpath('__file__'))   # Direction of this file
output_file_dir = "../cpu_pipelined/hdl/mem_kernel.sv"           # Direction of output file
path = os.path.join( this_file_dir, output_file_dir )           # Create a relative path
f = open( path, "w+" )

# initilize module
f.write( "`timescale 1ns / 1ps\n" )
f.write( "module mem_kernel #( parameter SIZE = 16 )\n(\n\t" )
# inputs and outputs of module
f.write( "input logic CLK,\n\t" )
f.write( "input logic [31:0] ADDRESS,\n\t" )
f.write( "output logic [SIZE-1:0] READ\n" )
f.write( ");\n" )

# always block
f.write( "always_ff@( posedge CLK ) begin\n\t" )
f.write( "case( ADDRESS )\n\t\t" )

# set data outputs, multiplexor
d = kernel_matrix
aux_addr = 0
for i in range( len(d) ):
    for j in range( len(d[i]) ):
        val = d[i][j]
        f.write( "32'H" )
        f.write( tohex( i, N_BITS ).zfill( 4 ) )
        f.write( tohex( j, N_BITS ).zfill( 4 ) )
        f.write( ": READ <= 16'H%s;\n\t\t" % tohex(val,N_BITS) )
        aux_addr += 1

f.write( "default: READ <= 16'b0;\n\t" )
f.write( "endcase\n" )
f.write( "end\n" )
f.write( "\nendmodule\n" ) # endmodule
f.close() # close file

print( "Finish.OK" )
print( "See 'cpu_pipelined/hdl/mem_kernel.sv'." )

# fisnish the program