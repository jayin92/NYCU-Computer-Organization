.data
input: .asciiz "Enter the number n = "
out_isprime: .asciiz " is a prime"
out_isnotprime: .asciiz " is not a prime, the nearest prime is "
space: .asciiz " "

endl: .asciiz "\n"

.text
.globl main

main:

	li $v0, 4
    la $a0, input
    syscall

    li $v0, 5
    syscall
    move $a0, $v0
    
    jal prime
    bne $v0, $zero, print_y
    j print_n   


.text
prime:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	beq $a0, 1, n_return
	
	addi $a1, $zero, 2
	
	jal loop
	
print_y:
	li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, out_isprime
    syscall	
	
	j exit

print_n:
	move $a3, $a0
	li $v0, 1
    syscall
    
  	li $v0, 4
    la $a0, out_isnotprime
    syscall
    

   	move $a2, $zero
   	
   	addi $a1, $zero, 1
   	jal loop2
   	
    
    j exit
    

# $a0: n, $a1: i
loop:
	jal check	
	addi $a1, $a1, 1
	mul $t0, $a1, $a1
	sgt $t1, $t0, $a0
	beq $t1, $zero, loop
	
	jal y_return

loop2:
	addi $a2, $a2, 1
	sub $a0, $a3, $a2
	jal prime
	bne $v0, $zero, print
	
	jal lower
	j loop2
	
print:
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	jal lower
	j exit

lower:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	add $a0, $a3, $a2
	jal prime
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	beq $v0, $zero, back
	li $v0, 1
	syscall
	
	j exit

back:
	jr $ra

check:
	rem $t0, $a0, $a1
	beq $t0, $zero, n_return
	jr $ra

y_return:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	addi $t0, $zero, 1
	move $v0, $t0
	jr $ra

n_return:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $v0, $zero
	jr $ra
	
return:
	jr $ra
	
    
exit:
    li $v0, 10
    syscall
