#!/usr/bin/python
import os
import sys
import cv2

#Dictionary corresponding to cond-op-funct of one instruction
nemo = {
            #cond op func
    'ADD'   :'1110000001000',
    'SUB'   :'1110000000100',
    'MUL'   :'1110000000010',
    'CMP'   :'1110000011111',
    'ADDI'  :'1110000101000', #Adds using immidiate
    'SUBI'  :'1110000100101', #Substracts using immidiate
    'MULI'  :'1110000100010', #Normal multiplication using immidiate
    'CMPI'  :'1110000111111', #Compares using immidiate
    'LDR'   :'1110001010001',
    'B'     :'1110010000000',
    'STR'   :'1110001010000',
    'BEQ'   :'0000010100000',
    'VES'   :'1110000000000', #Vectorial sum
    'CNC'   :'1110000000110', #Concatenacion
    'SCL'   :'1110000011000', #Scalated (vector*scalar)
    'DOT'   :'1110000011010', #Dot product
    'REK'   :'1110100000110', #Reads singular values from Kernel_mem
    'RKM'   :'1110100100110', #Reads a vector from kernel_mem
    'SAP'   :'1110101001000', #Saves pixel value into RAM
    'REP'   :'1110110000110'  #Reads vector value from ROM used in convolution    
}

#Dictionary corresponding to the binary code for each register
register = {
    'R0'    :'00000',
    'R1'    :'00001',
    'R2'    :'00010',
    'R3'    :'00011',
    'R4'    :'00100',
    'R5'    :'00101',
    'R6'    :'00110',
    'R7'    :'00111',
    'R8'    :'01000',
    'R9'    :'01001',
    'R10'   :'01010',
    'R11'   :'01011',
    'R12'   :'01100',
    'R13'   :'01101',
    'R14'   :'01110',
    'R15'   :'01111',
    'R16'   :'10000',
    'R17'   :'10001',
    'R18'   :'10010',
    'R19'   :'10011',
    'R20'   :'10100',
    'R21'   :'10101',
    'R22'   :'10110',
    'R23'   :'10111',
    'R24'   :'11000',
    'R25'   :'11001',
    'R26'   :'11010',
    'R27'   :'11011',
    'R28'   :'11100',
    'R29'   :'11101',
    'R30'   :'11110',
    'R31'   :'11111'
}

#Dictionary used to know where the tags are and so generate the branch 
tags = {}
#Converts number into 48-bit hexadecimal
def tohex(number, bits):
    a = hex((number+(1<<bits)))
    return a[3::]
            
#Creates .mif for image
def createmif(image):
    print(image)

#Opens file and do file processing
print("Start files generation...")
args = len(sys.argv) #First argument is instruction file, next one is the image
if (args > 1):
    try:
        file = open(sys.argv[1], "r")
        i = 0 #index corresponding to actual PC
        for line in file:
            split_line = line.split(' ')
            if (len(split_line)>2 and not split_line[1]=="DCD"):
                tags[split_line[0]] = i
                i+=4
        
        #File operations for kernel rom
        script_dir  = os.path.dirname(os.path.realpath('__file__'))
        kernel_file = "../cpu_pipelined/hdl/mem_kernel.mif"
        kernel_path = os.path.join(script_dir,kernel_file)
        file_kernel = open(kernel_path, "w+")
        file_kernel.write("WIDTH=16;\n")
        file_kernel.write("DEPTH=9;\n")
        file_kernel.write("ADDRESS_RADIX=UNS;\n")
        file_kernel.write("DATA_RADIX=HEX;\n\n")
        file_kernel.write("CONTENT BEGIN\n")
        
        #File operations for instruction rom
        instr_file = "../cpu_pipelined/hdl/instruction_rom.sv"
        instr_path = os.path.join(script_dir,instr_file)
        file = open(instr_path, "w+")
        file.write("`timescale 1ns / 1ps\n")
        file.write("module instruction_rom #( parameter SIZE = 32)\n")
        file.write("(\n")
        file.write("\tinput logic CLK,\n")
        file.write("\tinput logic Reset,\n")
        file.write("\tinput logic [SIZE-1:0] Address,\n")
        file.write("\toutput logic [SIZE-1:0] Instr\n")
        file.write(");\n")
        file.write("always@(posedge CLK) begin\n")
        file.write("\tif( Reset ) Instr <= 48'bx;\n")
        file.write("\telse begin\n")
        file.write("\t\tcase (Address/48'd4)\n")
        files = open(sys.argv[1], "r")
        pc = 0
        print(tags)
        for lines in files:
            line = ""
            if("\n" in lines):
                line = lines[:lines.rfind("\n")]
            elif ("" in lines):
                line = lines[:lines.rfind("")]
            split_line = line.split(' ')
            len_split = len(split_line)

            instr_tmp   = ""
            reg_tmp     = ""

            if(len_split==3 and split_line[1]=="DCD"):
                pos = split_line[2].split(',')
                p = 0
                for pos_data in pos:
                    addr = "\t"
                    addr = addr + str(p)+" : " +  tohex(int(pos_data),17)+";\n"
                    file_kernel.write(addr)
                    p += 1
                while p <= 8:
                    addr = "\t"
                    addr = addr + str(p)+" : " +  tohex(0,17)+";\n"
                    file_kernel.write(addr)
                    p += 1
                pc = 0
                file_kernel.write("END;")
                file_kernel.close()
            elif (len_split == 2):
                instr_tmp   = split_line[0]
                reg_tmp     = split_line[1]
            elif (len_split == 3):
                instr_tmp   = split_line[1]
                reg_tmp     = split_line[2]
            else:
                sys.exit("There has been an error on PC=%s" %i)
            
            try:
                if(instr_tmp in nemo):
                    print(instr_tmp)
                    registers = reg_tmp.split(',')
                    addr = "\t\t\t48'H"
                    addr += tohex((pc/4),48)+": Instr <= "
                    instr = nemo[instr_tmp]
                    len_reg = len(registers)
                    if  (
                        instr_tmp == "ADD" or 
                        instr_tmp == "SUB" or 
                        instr_tmp == "MUL" or
                        instr_tmp == "VES" or
                        instr_tmp == "CNC" or
                        instr_tmp == "SCL" or
                        instr_tmp == "DOT" or
                        instr_tmp == "REK" or
                        instr_tmp == "RKM" or
                        instr_tmp == "REP"):                        
                        if (len_reg == 3 and registers[2] in register):
                            a = bin(0+1<<20)
                            instr += register[registers[1]] + register[registers[0]] + str(a[3::]) + register[registers[2]]
                        else:
                            sys.exit("It is the wrong instruction: %s" %instr_tmp)

                    elif(instr_tmp == "CMP"):
                        if (len_reg == 2 and registers[1] in register):
                            a = bin(0+1<<25)
                            instr += register[registers[0]] +  a[3::] + register[registers[1]]
                        else:
                            sys.exit("It is the wrong instruction: %s" %instr_tmp)

                    elif(instr_tmp == "ADDI" or instr_tmp == "SUBI" or instr_tmp == "MULI"):
                        if (len_reg == 3 and not registers[2] in register):
                            a = bin(0+(1<<13))
                            b = bin(int(registers[2])+(1<<12))
                            instr += register[registers[1]] + register[registers[0]] + a[3::] + b[3::]
                        else:
                            sys.exit("It is the wrong instruction: %s" %instr_tmp)

                    elif(instr_tmp == "CMPI"):
                        if (len_reg == 2 and not registers[1] in register):
                            a = bin(0+(1<<18))
                            b = bin(int(registers[1])+(1<<12))
                            instr += register[registers[0]] + a[3::] + b[3::]
                        else:
                            sys.exit("It is the wrong instruction: %s" %instr_tmp)

                    elif(instr_tmp == "BEQ" or instr_tmp == "B"):
                        if (len_reg == 1 and registers[0] in tags):
                            a = bin(0+(1<<6))
                            pc_next = int(tags[registers[0]])
                            imm = (pc_next - (pc+8))/4
                            print(imm)
                            b = bin(imm+(1<<25))
                            print(b)
                            instr += "01111"+a[3::] + b[3::]
                        else:
                            sys.exit("It is the wrong instruction: %s" %instr_tmp)

                    elif (instr_tmp == "SAP"):
                        if (len_reg == 3 and registers[2] in register):
                            a = bin(0+1<<25)
                            instr += register[registers[1]] + register[registers[0]] + str(a[3::])
                        else:
                            sys.exit("It is the wrong instruction: %s" %instr_tmp)
                    result = tohex(int(instr,2),48)
                    addr += "48'H"+result+";\n"
                    file.write(addr)
                    pc += 4
            except Exception as e:
                exc_type, exc_obj, exc_tb = sys.exc_info()
                fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
                print(exc_tb.tb_lineno)
                print(exc_obj)
                print(e.message)
        
        file.write("\t\t\tdefault: Instr <= 48'bx;\n")
        file.write("\t\tendcase\n")
        file.write("\tend\n")
        file.write("end\n")
        file.write("endmodule")
        file.close()

    except Exception as e:
        print(e.message)
        sys.exit("There has been an error opening the instruction file.")
else:
    sys.exit("You must provide the image and instruction file")
print("Process done, no error found.")
