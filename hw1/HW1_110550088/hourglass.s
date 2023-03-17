.data
input: .asciiz "enter a number: "
spchar: .asciiz " "
stchar: .asciiz "*"
endl: .asciiz "\n"

.text
.globl main

main:

	li $v0, 4
    la $a0, input
    syscall

    li $v0, 5
    syscall
    move $a1, $v0
    
    move $a2, $a1
    move $a1, $zero
    move $a3, $a2
    
    jal print1
    

    li $v0, 10
    syscall

.text
print1:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal L1

L1: 
	sgt $t0, $a2, $zero
	beq $t0, $zero, print2
	addi $sp, $sp, -8
	sw $a1, 0($sp)
	sw $a2, 4($sp)
	jal printline
	lw $a1, 0($sp)
	lw $a2, 4($sp)
	addi $sp, $sp, 8
	addi $a1, $a1, 1
	addi $a2, $a2, -2
	jal L1

print2:
	addi $a1, $a1, -1
	addi $a2, $a2, 2
	addi $sp, $sp, -8	
	sw $a1, 0($sp)
	sw $a2, 4($sp)
	addi $t4, $zero, 1
	beq $a2, $t4, print2

	jal printline
	lw $a1, 0($sp)
	lw $a2, 4($sp)
	addi $sp, $sp, 8
	sgt $t0, $a1, $zero
	beq $t0, $zero, exit	
	jal print2


exit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


# a1: space, a2: star
printline:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t1, $a1
	move $t2, $a2
	
	move $a1, $t1	
	jal space
	
	move $a1, $t2
	jal star
	
	li $v0, 4
    la $a0, endl
    syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

space:
	addi $a1, $a1, -1
	slt $t1, $a1, $zero
	bne $t1, $zero, return
	
	li $v0, 4
    la $a0, spchar
    syscall
    
    j space
	

star:
	addi $a1, $a1, -1
	slt $t1, $a1, $zero
	bne $t1, $zero, return
	
	li $v0, 4
    la $a0, stchar
    syscall
	
	j star

return:
	jr $ra