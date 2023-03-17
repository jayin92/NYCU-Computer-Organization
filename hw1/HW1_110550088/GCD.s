.data
input1: .asciiz "Enter the first number: "
input2: .asciiz "Enter the second number: "
output: .asciiz "\nThe GCD is: "

.text
.globl main

main:
    li $v0, 4
    la $a0, input1
    syscall

    li $v0, 5
    syscall
    move $a1, $v0

    li $v0, 4
    la $a0, input2
    syscall

    li $v0, 5
    syscall
    move $a2, $v0    

    jal gcd

    move $t0, $v0

    li $v0, 4
    la $a0, output
    syscall

    move $a0, $t0
    li $v0, 1
    syscall

    li $v0, 10
    syscall

.text
gcd:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	move $t1, $a1
	move $t2, $a2
	
	rem $t3, $t1, $t2
	sw $t3, 0($sp)
	bne $t3, $zero, L1
	
	move $v0, $a2
	addi $sp, $sp, 8
	jr $ra
	
L1: 
	move $a1, $a2
	lw $t1, 0($sp)
	move $a2, $t1
	jal gcd
	
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra