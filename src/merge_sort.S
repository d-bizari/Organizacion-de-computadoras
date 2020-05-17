#include <sys/regdef.h>
.text
.align 2
.globl merge_sort
.ent merge_sort

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

 	# salvo 1er arg (siempre)
 	sw a0, 40(fp) # n: a0, sp+40
  #Guardo el segundo valor, que seria el largo del arreglo guardado en 40
  sw a1, 44(fp)
  #Pedir memoria
  move a0, a1
  jal mymalloc
  sw v0, 20(sp)

  lw t0, 44(fp) #t0 = size
  lw t1, 40(fp) #Guardamos la direccion de memoria del INICIO del arreglo en t1
  lw t3, 20(sp) #Guardamos la direccion del nuevo arreglo
copyValues_loop:
	beqz t0, _return
  lw t2, 0(t1)
  sw t2, 0(t3)
  addiu t3, t3, 4
  addiu t1, t1, 4
  addi t0, t0, - 1
	j copyValues_loop
_return:
  lw v0, 20(sp)
	lw	gp, 24(sp)
	lw	fp, 28(sp)
	lw	ra, 32(sp)
	addu	sp, sp, 40
	jr	ra

	.end	merge_sort
	.size	merge_sort,.-merge_sort
	.ent    merge_sort
