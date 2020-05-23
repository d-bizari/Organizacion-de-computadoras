#include <sys/regdef.h>
.text
.align 2
.globl merge_sort
.ent merge_sort

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

	ble	a0, t0, _return	# if a0 <= t0 then return
	
	li 	t0, 2      # cargo 2 en t0
	div a1, t0     # len / 2
	move t0, lo    # cargo en t0 = len / 2 

mallocs:
	#t1 size en bytes de memoria
	sll   t1, t0, 2  # Multiplico por 4 (tamanio int)
	move  a0, t1     # argumento 0 size bytes
  	jal mymalloc     # mymalloc(sizeof(int) * middle)
  	sw v0, 16(sp)	 # 16(sp) = left

	#t1 size en bytes de memoria
	lw  t2, 52(fp)   # cargo en t2 size del array
	sub t2, t2, t0   # t2 = len - middle 
	sll   t1, t2, 2  # Multiplico por 4 (tamanio int)
	move  a0, t1     # argumento 0 size bytes
  	jal mymalloc     # mymalloc(sizeof(int) * len - middle)
  	sw v0, 20(sp)	 # 20(sp) = right


    li t4, 0 # Iterador left
    lw t5, 48(fp) # Cargo array en t5
    lw t6, 16(sp) # Cargo left en t6

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

loop_right:
     bge t4, t2, exit_right
     lw t7, 0(t5) # Cargo primer elemento de array en t7
     sw t7, 0(t6) # Cargo t7 en right
     addi t5, t5, 4 # Siguiente posicion en int
     addi t6, t6, 4 # Siguiente posicion
     addi t4, t4, 1 # Avanza iterador
     j loop_right

exit_right:


copyValues_loop:
	beqz t0, _return
  	lw t2, 0(t1) # t2 = *(t1)
  	sw t2, 0(t3) # *(t3) = t2
  	addiu t3, t3, 4 # Aumento puntero en int
  	addiu t1, t1, 4 # Aumento puntero en int
  	addi t0, t0, - 1
	j copyValues_loop

_return:
	lw		gp, 32(sp)
	lw		fp, 36(sp)
	lw		ra, 40(sp)
	addu	sp, sp, 48
	jr		ra

	.end	merge_sort