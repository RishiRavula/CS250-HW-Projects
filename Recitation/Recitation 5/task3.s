.data

newline: .asciiz "\n"


.text 

main:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $t0, 1
    li $t1, 2

    move $a0, $t0
    move $a1, $t1 #CALLER SAVED REGISTER: Main is responsible for saving value in t register

    addi $sp, $sp, -8
    sw $t0, 4($sp)
    sw $t1, 0($sp)

    jal	foo				# jump to foo and save position to $ra

    lw $t1, 0($sp)
    lw $t0, 4($sp)
    addi $sp, $sp, 8
    
    move $t3, $v0 #move v0 into t1

    add $t3, $t3, $t0
    add $t3, $t3, $t1




    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra

foo:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    add $v0, $a1,$a0 # $v0 = a0 + a1 = 1 + 2

    li $t0, 0
    li $t1, 0

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


