#include <sys/regdef.h>
.text
.align 2
.globl mystrlen
.ent mystrlen

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


	sw fp, 4(sp)
	move fp, sp
	li v0, 0

mystrlen_loop:
	lb t0, 0(a0)
	beqz t0, _return
	addiu a0, a0, 1
	addiu v0, v0, 1
	j mystrlen_loop
_return:
	# return;
	lw	gp, 24(sp)
	lw	fp, 28(sp)
	lw	ra, 32(sp)
	addu	sp, sp, 40
	jr	ra

	.end	merge_sort
	.size	merge_sort,.-merge_sort