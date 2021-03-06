#include <sys/regdef.h>
#include <sys/syscall.h>

.data
msg_error: .asciiz "error in mymalloc\n"

.text
.align 2
.globl merge_sort
.ent merge_sort
#Comienzo de la funcion mergesort, recibe el arreglo y su longitud
merge_sort:
  	.frame	fp, 48, ra
	.set	noreorder
	.cpload t9
	.set	reorder

  	# creo stack frame
 	subu sp, sp, 48 # 4 (SRA) + 4 (LTA) + 4 (ABA)
 	.cprestore 32   # sw gp, 32(sp)
 	sw fp, 36(sp)
 	sw ra, 40(sp)
 	move fp, sp

 	sw 	a0, 48(fp) # puntero a array
  	sw 	a1, 52(fp) # size del array
	li 	t0, 1      # cargo 1 en t0

	ble	a1, t0, _return	# if a0 <= t0 then return

	srl   t0, a1, 1  # cargo en t0 = len / 2
  	sw   t0, 24(sp) #Guardo t0 en LTA (local temporary area)

#Comienzo del pedido de memoria, recibe por 24(sp) el tam del arreglo izquierdo y en 52(fp)
#el tam del arreglo entero para calcular el tamaño del arreglo derecho como (tamaño total - 
#tamaño izquierdo), devuelve en 28(sp) el tamaño calculado del arreglo derecho, 
#en 16(sp) el inicio del puntero izquierdo que tenga la memoria reservada que fue 
#pedida antes, y por 20(sp) el puntero al arreglo derecho.
#en caso de error salta a error_mymalloc
mallocs:
	#t1 size en bytes de memoria
	sll   t1, t0, 2  		 # Multiplico por 4 (tamanio int)
	move  a0, t1     		 # argumento 0 size bytes
	jal   mymalloc   		 # mymalloc(sizeof(int) * middle)
	beqz  v0, error_mymalloc # if(mymalloc(sizeof(int) * middle) == NULL) branch to error_mymalloc
  	lw    t0, 24(sp) 		 # Se esta guardando el middle(numero) del array left
	sw    v0, 16(sp) 		 # 16(sp) = left

	#t1 size en bytes de memoria
	lw    t2, 52(fp)   		 # Cargo en t2 size del array
	sub   t2, t2, t0   		 # t2 = len - middle
  	sw    t2, 28(sp)   		 # Guardo len - middle en LTA
	sll   t1, t2, 2  		 # Multiplico por 4 (tamanio int)
	move  a0, t1     		 # argumento 0 size bytes
	jal   mymalloc     		 # mymalloc(sizeof(int) * len - middle)
	beqz  v0, error_mymalloc # if(mymalloc(sizeof(int) * middle) == NULL) branch to error_mymalloc
  	lw    t2, 28(sp)   		 # reload the len on t2 to be used in future steps
  	lw    t0, 24(sp) 		 # Se levanta devuelta el valor de t0 para estar seguros que conserva el valor
	sw    v0, 20(sp)		 # 20(sp) = right


  	li t4, 0      # Iterador left
  	lw t5, 48(fp) # Cargo array en t5
  	lw t6, 16(sp) # Cargo left en t6
#Inicio del loop izquierdo, recibe por t5 el array entero y por t6 el array izquierdo 
#y carga los elementos que correspondan al array izquierdo.
loop_left:
    # 16(sp) left, 48(fp) array
    bge t4, t0, exit_left
    lw t7, 0(t5) # Cargo primer elemento de array en t7
    sw t7, 0(t6) # Cargo t7 en left
    addi t5, t5, 4 # Sumo int al array
    addi t6, t6, 4 # Sumo int al left
    addi t4, t4, 1 # Sumo iterador
    j loop_left

exit_left:
    li t4, 0 # Iterador right
    lw t5, 48(fp) # Cargo array en t5
    lw t6, 20(sp) # Cargo right en t6
    sll   t3, t0, 2 # Multiplico t0 por 4 y guardo en t3
    add t5, t5, t3 # array <- array + middle

#Inicio del loop derecho, recibe por t5 la posicion del array entero desplazada a la mitad, 
#por t4 un iterador, por t2 el largo del arreglo total, y por t6 el array derecho, y
#guarda los elementos que correspondan en el array derecho.
loop_right:
     bge  t4, t2, exit_right
     lw   t7, 0(t5) # Cargo primer elemento de array en t7
     sw   t7, 0(t6) # Cargo t7 en right
     addi t5, t5, 4 # Siguiente posicion en int
     addi t6, t6, 4 # Siguiente posicion
     addi t4, t4, 1 # Avanza iterador
     j loop_right

exit_right:
    lw    t0, 24(sp) # Se esta guardando el middle(numero) del array left
    lw    t1, 16(sp) # Cargamos el arreglo left en t1
    move  a0, t1     # Lo pongo en el argumento 0
    move  a1, t0     # Lo agrego en el argumento 1
    jal   merge_sort # merge_sort(left, middle);

    lw    t0, 28(sp) # Se esta guardando el len - middle(numero) del array r
    lw    t1, 20(sp) # Cargamos el arreglo right en t1
    move  a0, t1     # Lo pongo en el argumento 0
    move  a1, t0     # Lo agrego en el argumento 1
    jal   merge_sort # #merge_sort(right, len - middle);

#Se encarga de la parte de merge, recibe por 24(sp) y 28(sp) los largos de los arreglos izquierdos y derechos
#respectivamente, y por 16(sp), 20(sp) y 48(sp) los arreglos izquierdos, derechos y total respectivamente,
#luego prosigue al mergeLoop
merge:
	li      t0, 0      # t0 es para left, t1 es para right
	li      t1, 0      # Cargo los registros t1 y t0 con cero
	lw      t2, 24(sp) # Largo del arreglo left
	lw      t3, 28(sp) # Largo del right
	lw      t4, 16(sp) # Cargamos el arreglo left en t4
	lw      t5, 20(sp) # Cargamos el arreglo right en t5
	lw      t8, 48(sp) # Cargamos el arreglo total en t8
	sll     t2, t2, 2  # Multiplico t2 por 4 asi se puede comparar correctamente con t0
	sll     t3, t3, 2  # Rt arriba
#Se encarga de mergear lo que reciba desde merge de manera ordenada.
mergeLoop:
	bge     t0, t2, exitLoop_l
	bge     t1, t3, exitLoop_r # Condicion de quiebre (si i o j son mayores que el len)
	lw      t6, 0(t4)          # Cargo elemento de array left en t6
	lw      t7, 0(t5)  		   # Cargo elemento de array right en t7
	bge     t6, t7,else		   # Brancheo a else si lo que esta en t6 >= t7
	sw      t6, 0(t8)  		   # Vec[i + j] = left[i];
	addi    t0, t0, 4  		   # i++
	add     t4, t4, 4  		   # Actualizamos la posicion de arrLeft
	add     t8, t8, 4  		   # Actualizo la posicion del arreglo en t8
	j       mergeLoop
else:
	sw      t7, 0(t8)  		   # Vec[i + j] = right[j];
	addi    t1, t1, 4          # j++
	add     t5, t5, 4          # Actualizamos la posicion de arrRight
	add     t8, t8, 4          # Actualizo la posicion del arreglo en t8
	j       mergeLoop

# t2 = len_l * 4
# t3 = len_r * 4
# t0 = i * 4
# t1 = j * 4
exitLoop_l: # i = len_l, entonces llenamos right
	bge     t1, t3, frees    # j >= len_r then branch to fress
	lw      t7, 0(t5)        # t7 = *(right)
	sw      t7, 0(t8)  		 # Vec[i + j] = right[j];
	addi    t1, t1, 4        # j++
	add     t5, t5, 4        # Actualizamos la posicion de arrRight
	add     t8, t8, 4        # Actualizo la posicion del arreglo en t8
	j       exitLoop_l

exitLoop_r: # j = len_r, entonces llenamos left
	bge     t0, t2, frees    # i >= len_l then branch to fress
	lw      t6, 0(t4)        # t6 = *(left)
	sw      t6, 0(t8)  		 # Vec[i + j] = left[i];
	addi    t0, t0, 4  		 # i++
	add     t4, t4, 4  		 # Actualizamos la posicion de arrLeft
	add     t8, t8, 4  		 # Actualizo la posicion del arreglo en t8
	j       exitLoop_r

#Libera la memoria pedida desde mymalloc, recibe por 16(sp) y 20(sp) los arreglos pedidos
frees:
    lw    t1, 16(sp) # Cargo el puntero del arreglo en t1
    move  a0, t1     # Lo pongo en el argumento 0
    jal   myfree

    lw    t1, 20(sp) # Cargamos el arreglo right en t1
    move  a0, t1     # Lo pongo en el argumento 0
    jal   myfree     # Libero el arreglo

_return:
	lw		gp, 32(sp)
	lw		fp, 36(sp)
	lw		ra, 40(sp)
	addu	sp, sp, 48
	jr		ra

# Termina el programa en caso de error
error_mymalloc:
	li  a2, 18        # Cantidad de bytes a escribir, en este caso char = 1byte, 18 char = 18bytes
	la  a1, msg_error # Pasamos puntero donde se encuentra primer char
	li 	a0, 2         # Elegimos el stream stderr
	li 	v0, SYS_write # Indicamos operacion a realizar a la syscall
	syscall           # Llamado a syscall para imprimir por stderr
exit:
	li 	v0, SYS_exit # Indicamos operacion a realizar a la syscall
    li 	a0, 1        # Ponemos valor con el que queremos salir del programa
    syscall          # Llamado a syscall para finalizar la ejecucion

	.end	merge_sort
