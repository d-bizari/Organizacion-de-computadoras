#include <sys/regdef.h>

.text
.align 2
.globl merge_sort
.ent   merge_sort

merge_sort:
  	.frame	fp, 40, ra
	.set	noreorder
	.cpload t9
	.set	reorder

  # creo stack frame
 	subu sp, sp, 40 # 4 (SRA) + 2 (LTA) + 4 (ABA)
 	.cprestore 24  # sw gp, 24(sp)
 	sw fp, 28(sp)
 	sw ra, 32(sp)
 	move fp, sp

 	sw a0, 40(fp) # Guardo puntero a array
  	sw a1, 44(fp) # Guardo largo de array

  	lw t0, 44(fp) # t0 = size
	lw t1, 40(fp) # Guardamos la direccion de memoria del INICIO del arreglo en t1
	#  t2 valor de elemento de array
	#  t3 registro temporal para shift

sum_recursive:
	beqz  t0, caso_base
	addi  t0, t0, -1    # n--
	sll   t3, t0, 2     # Multiplico por 4 (tamanio int)
	addu  t3, t3, t1    # sumo puntero de inicio del array con desplazamiento
	lw    t2, 0(t3)     # guardo en t2 elemento
	sw    t2, 16(sp)    # Guardo elem en LTA

	addu  a0, t1, zero  # Pongo puntero a array en arg0
	addu  a1, t0, zero  # Pongo n-1 en arg1
	jal	  merge_sort    # merge_sort(int * arr, n-1)
	
	lw	  t2, 16(sp)	# recupero elem actual
	add   v0, v0, t2    # sumo con el valor que me devolvieron
	j     _return       

caso_base:
	move v0, zero
	j    _return	

_return:
	lw	gp, 24(sp)
	lw	fp, 28(sp)
	lw	ra, 32(sp)
	addu	sp, sp, 40
	jr	ra

	.end	merge_sort
	# .size	merge_sort,.-merge_sort
	# .ent    merge_sort
