# Descripción de convolution2D.txt#

Este documento se refiere al proceso seguido en `convolution2D.txt`, el cual corresponde al código ASM para la arquitectura Sullivan48.

Dicha arquitectura cuenta con 32 registros de uso general, con 1 registro reservado al sistema. Para esta aplicación solo se ocuparon 12 registros.

En el caso de `R0`, es el registro general con el valor del cero.

Primero se procede a cargar todos los valores del kernel necesarios, en este caso, al usar convolución separable, el kernel se puede separar en vector fila y vector columna, donde ambos son iguales, por lo que en `R2,R3 y R4` se cargan los valores del vector columna respectivamente mientras que en `R5` se carga el vector fila. Esto con la intención de facilitar operaciones.

Se va a mantener cuatro registros para índices, estos son: `R6,R7,R8 y R12`, los tres primeros corresponden a `i, j, i_actual` y el último a la posición en memoria del nuevo pixel a guardar. La idea de dichos índices es siempre tener conciencia de dónde se está en memoria (ya sea de lectura o escritura) y el `i_actual` corresponde a la matrix 3x3 para poder realizar la convolución, cabe destacar que `i_actual = i + offset`, donde `offset` es un valor temporal de `0..2` y luego se reestablece a cero para indicar que se está en la primera fila de la matrix 3x3.

Luego de cargar todas las posiciones y valores del kernel al banco de registros, se verifica que no se esté en la última columna de la matriz de la imagen (en este caso 640), si es así, se aumenta el `i` y se reestablece el `j = 0` para empezar la convolución con la siguiente fila. Luego se verifica que no se esté en la última fila de la matriz (en este caso 480), si es así, significa que ya se salió de la imagen y no queda más pixeles por convolucionar, por lo que el programa finaliza.

Al no cumplirse esas dos restricciones, el valor de `i` se copiará a `R8` que corresponde con `i_actual`, de aquí solicita los tres vectores de pixeles de la memoria de imagen y los guarda en `R9, R10  y R11`; al finalizar, escala `R9, R10  y R11` por `R2, R3 y R4` respectivamente, luego suma `R9 con R10` y lo guarda en `R9` y ese vector resultante lo suma con `R11` para guardarlo en `R9`; asímismo, `R9` hace producto punto con `R5` y lo guarda en `R9` para luego guardar ese escalar en `R12`, siendo R12 la posición en memoria del nuevo pixel. Finalmente aumenta `R12` por cuatro y reestablece el valor de `R8` a cero para que no interfiera con las primeras operaciones del loop. Además aumenta la posición en `j`. 