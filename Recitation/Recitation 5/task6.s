


.text 

main:
    addi $sp, $sp,-4
    sw $ra, 0($sp)

    li $a0, 1
    li $a1, 2

    jal foo

    move $t1, $v0

    li $v0, 1
    move $a0, $t1
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4

foo:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    add $t2, $a0, $a1

    li $s0, 10
    
    move $v0, $t2


    bgt $t2, $s0, func_exit

    #OTHERWISE
    addi $a0,$a0, 1
    addi $a1,$a1, 1

    addi $sp, $sp, -4
    sw $t2, 0($sp)
    jal foo
    lw $t2, 0($sp)
    addi $sp, $sp, 4
    

    
    
func_exit:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8

    jr $ra

    

.data

newline: .asciiz "\n"