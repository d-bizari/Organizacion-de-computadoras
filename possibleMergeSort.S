.data
Array1 :    .word 0:20

Array2 :        .word 0:20

.text
.globl main

main :


#initial activation record ... send the three arguments to sort......0
li $v0, 5           # system call for read_int
syscall
move $t4, $v0           # number read is put in $t0

li $v0, 5           # system call for read_int
syscall
move $t5, $v0           # number read is put in $t1

li $v0, 5           # system call for read_int
syscall
move $t6, $v0           # number read is put in $t2

li $v0, 5           # system call for read_int
syscall
move $t7, $v0           # number read is put in $t3

#do the syscall for array 1 and array 2(empty)(no syscall) and size save them in t0 , t1 , t2 respectively which are then send to stack

la $t0 , Array1
sw $t4 , 0($t0)
sw $t5 , 4($t0)
sw $t6 , 8($t0)
sw $t7 , 12($t0)

la $t1 , Array2
li $t2 , 4
sw $t0, -12($sp)
sw $t1, -8($sp)
sw $t2, -4($sp)
addi $sp, $sp, -184
jal sort


#.........display the result stored in B and then clear the stack (exit the program) ...........#

li $v0, 10          # system call for exit
syscall
#....................................................................0



#creating the initial activation record .............1
sort:
# a0 mein A (initial one) and a1 mein B (initial one) a2 mein initial n which will be taken as system call
sw $ra, 168($sp)

#//already done addi $sp , $sp , -184


#for n1 and n2
lw  $t2 , 180($sp)              #($t2 = n)
srl $t0 , $t2 , 1           #($t0 = n1 = n/2)
sra $t0 , $t2 , 1
sub $t1 , $t2 , $t0         #($t1 = n2 = n - n1)
sw $t1 , 164($sp)       #(stored n2)
sw $t0 , 160($sp)           #(stored n1)
#la $t0 , Array1
#la $t1 , Array2
#sw $t1 , 80($sp)       #stored ARRAY2
#sw $t0 , 0($sp)        #stored ARRAY1
#....................................................1

#SORT FUNC FIRST PART................................2

#ASSUMPTIONS:
#a0 = A
#a1 = B
#a2 = n




#BASE CASE
li $t0 , 1                          #t0 = 1
bne $t0 , $t2 , firstL              #((t2 = n) != 1) then go to firstL
lw $t1 , 172($sp)                   #t1 = &A
lw $t1 , 0($t1)                     #t1 = A[0]
lw $t2 , 176($sp)                   #t2 = &B
sw $t1 , 0($t2)                     #B[0] = A[0]
addi $sp , $sp , 184                #THE CORRECTION
jr $ra

#First Loop

firstL :
#........................................................2

#CALLING SORT ...........................................3
lw $t8, 172($sp)            #loading &A
sw $t8, -12($sp)            #storing &A at the desired location
add $t8, $sp, $zero         #loading &A1
sw $t8, -8($sp)             #storing &A1 at the desired location
lw $t8, 160($sp)            #loading n1
sw $t8, -4($sp)             #storing n1 at the desired location
addi $sp, $sp, -184
jal sort


#.........................................................3

#CALLING SORT AGAIN ......................................4
lw $t8, 172($sp)            #loading &A
lw $t7, 160($sp)            #loading n1
sll $t7 , $t7 , 2           #n1*= 4 for mips address
add $t8 , $t8 , $t7             #adding &A + n1
sw $t8, -12($sp)            #storing &A + n1
addi $t8, $sp, 80           #loading &A2
sw $t8, -8($sp)             #storing A2
lw $t8, 164($sp)            #loading n2
sw $t8, -4($sp)
addi $sp, $sp, -184
jal sort

#calling merge...........................................5

add $a0, $sp, $zero     #a0 = &A1
addi $a1, $sp, 80   #a1 = &A2
lw $a2, 176($sp)    #a2 = &B
lw $t8, 160($sp)
sw $t8, -8($sp)     #stored p
lw $t8, 164($sp)
sw $t8, -4($sp)     #stored q
addi $sp, $sp, -12
jal merge
#........................................................5

#return from sort........................................8
lw $ra, 168($sp)
lw $t0 , 176($sp)
lw $t1 , 0($t0)
lw $t2 , 4($t0)
lw $t3 , 8($t0)
lw $t4 , 12($t0)
li $v0, 1           # system call for print_int
move $a0, $t1       # number in $t3 is to be printed
syscall

li $v0, 1           # system call for print_int
move $a0, $t2       # number in $t3 is to be printed
syscall
li $v0, 1           # system call for print_int
move $a0, $t3       # number in $t3 is to be printed
syscall
li $v0, 1           # system call for print_int
move $a0, $t4       # number in $t3 is to be printed
syscall
addi $sp , $sp , 184

jr $ra
#........................................................8


#Merge ..................................................6

merge:

sw $ra, 0($sp)      #stored ra              .........
#ASSUMPTION :
#a0 = P         #available from stack though.....
#a1 = Q
#a2 = R
#s1 = p
#s2 = q

lw $s1 , 4($sp)
lw $s2 , 8($sp)

move $t0 , $zero    # t0 = i , t1 = j, t2 = k (= 0)
move $t1 , $zero
move $t2 , $zero
While1:
sll $t3 , $t0 , 2
add $t3 , $t3 , $a0      #t3 = &P[i]
sll $t4 , $t1 , 2
add $t4 , $t4 , $a1      #t4 = &Q[j]
lw $t5 , 0($t3)      #t5 = P[i]
lw $t6 , 0($t4)      #t6 = Q[j]
sll $t7 , $t2 , 2
add $t7 , $t7 , $a2  #t7 = &R[k]
bge $t0 , $s1 , While2
bge $t1 , $s2 , While2   # exit loop 1 if j>=q or i>=p
bge $t5 , $t6 , While12
sw $t5 , 0($t7)          #R[k] = P[i]
addi $t0 , $t0 , 1   #incremented i and k
addi $t2 , $t2 , 1
j While1
While12:
sw $t6 , 0($t7)          #R[K] = Q[j]
addi $t1 , $t1 , 1   #incremented j and k
addi $t2 , $t2 , 1
j While1

While2:
bge $t0 , $s1 , While3   #exit loop if i >= p
sw $t5 , 0($t7)          #R[k] = P[i]
addi $t0 , $t0 , 1   #incremented i and k
addi $t2 , $t2 , 1
j While1

While3:
bge $t1 , $s2 , Exit    #exit loop if j>= q
sw $t6 , 0($t7)         #R[k] = Q[j]
addi $t1 , $t1 , 1  #incremented j and k
addi $t2 , $t2 , 1
j While1

Exit :
#.........................................................6
