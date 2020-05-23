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
  	sw v0, 20(sp)	 # 16(sp) = left

copyValues_loop:
	beqz t0, _return
  	lw t2, 0(t1)
  	sw t2, 0(t3)
  	addiu t3, t3, 4
  	addiu t1, t1, 4
  	addi t0, t0, - 1
	j copyValues_loop

_return:
	lw		gp, 32(sp)
	lw		fp, 36(sp)
	lw		ra, 40(sp)
	addu	sp, sp, 48
	jr		ra

	.end	merge_sort