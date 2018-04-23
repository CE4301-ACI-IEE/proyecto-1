# Instrucciones de uso del compilador

## Compiler.py

Este archivo es el que se usará para generar dos tipos diferentes de archivos, por un lado generará `kernel_mem.mif` y `instruction_rom.sv`, esto con la finalidad de ser utilizados por el procesador, cabe destacar que no es necesario indicarle el path a dónde se encuentra el código pues ya viene por defecto. Lo único que utiliza es el path al código ensamblador. Dicho archivo puede estar en la misma carpeta que el compilador o utilizar un path relativo al mismo.

### Requerimientos

Debe tener instalado `python` y `opencv` para python. Si no lo tiene instalado, lo puede instalar desde la terminal de su ordenador mediante:

> $ apt install python-dev python-opencv

Si no se puede ejecutar, debe instalar `numpy` mediante:

> $ apt install python-numpy

### Ejecución

> $ python compiler.py /<path to asm code>

## create_mem_pic_mif.py

Este archivo, crea el archivo `.mif` de la imagen, este archivo corresponde a la ROM de la imagen. Cabe destacar que la imagen que se acepta por el momento no debe exceder la dimensión de 1024x768

### Ejecución

> $ python create_mem_pic_mif.py \<path to image>