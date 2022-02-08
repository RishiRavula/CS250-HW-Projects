.data

newline: .asciiz "\n"


.text 

main:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $a0, 1
    li $a1, 2

    jal	foo				# jump to foo and save position to $ra
    
    move $t1, $v0 #move v0 into t1

    li $v0, 1
    move $a0, $t1
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

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


