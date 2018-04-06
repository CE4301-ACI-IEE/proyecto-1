# Date: 04/03/18

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
f = open( "outputs/mem_kernel.sv", "w+" )

# initilize module
f.write( "`timescale 1ns / 1ps\n" )
f.write( "module mem_kernel #( parameter SIZE = 16 )\n" )
f.write( "(\n" )
# inputs and outputs of module
f.write( "  input logic CLK,\n" )
f.write( "  input logic [SIZE-1:0] ADDRESS,\n" )
f.write( "  output logic [SIZE-1:0] READ\n" )
f.write( ");\n" )

# always block
f.write( "always_ff@( posedge CLK ) begin\n" )
f.write( "  case( ADDRESS[SIZE-1:2] )\n" )

# set data outputs, multiplexor
d = kernel_matrix
aux_addr = 0
for i in range( len(d) ):
    for j in range( len(d[i]) ):
        val = d[i][j]
        f.write( "      16'd%d: READ " % aux_addr )
        f.write( "<= 16'H%s;\n" % tohex(val,N_BITS) )
        aux_addr += 1

f.write( "      default: READ <= 16'bx;\n" )
f.write( "  endcase\n" )
f.write( "end\n" )
f.write( "\nendmodule\n" ) # endmodule
f.close() # close file

# fisnish the program