#!/usr/bin/python
import os
import sys
import cv2

#Dictionary corresponding to cond-op-funct of one instruction
inst = {
            #cond op func
    'ADD'   :'1110000001000',
    'SUB'   :'1110000000101',
    'MUL'   :'1110000000010',
    'CMP'   :'1110000011111',
    'ADDI'  :'1110000101000', #Adds using immidiate
    'SUBI'  :'1110000100101', #Substracts using immidiate
    'MULI'  :'1110000100010', #Normal multiplication using immidiate
    'CMPI'  :'1110000111111', #Compares using immidiate
    'LDR'   :'1110001010001',
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

#Creates file corresponding to kernel_rom

#Creates file corresponding to instruction_room

#Creates .mif for image
def createmif(image):
    print(image)
#Opens file and do file processing
print("Start files generation...")
args = len(sys.argv) #First argument is instruction file, next one is the image
print(args)
if (args > 2):
    try:
        image = cv2.imread(sys.argv[2])
        image = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
        createmif(image)
    except:
        sys.exit("There has been an error loading the image")
    
    try:
        file = open(sys.argv[1], "r")
        i = 0 #index corresponding to actual PC
        for line in file:
            split_line = line.split(' ')
            if (len(split_line)>2):
                tags[split_line[0]] = i
                print(tags)
            i+=1
        i = 0
        
        this_file_dir = os.path.dirname(os.path.realpath('__file__'))
        output_file = "../cpu_pipelined/hdl/instruction_rom.sv"
        path = os.path.join(this_file_dir,output_file)
        #f = open(path, "w+")
        #a = hex((15+(1<<48))%(1<<48))
        #print(a[2::])
    except:
        sys.exit("There has been an error opening the instruction file.")
else:
    sys.exit("You must provide the image and instruction file")
print("Process done, no error found.")
print(inst["ADD"])