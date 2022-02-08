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

    li $s0, 5
    li $s1, 6
    

    jal	foo				# jump to foo and save position to $ra

    
    move $t3, $v0 #move v0 into t1

    add $t3, $t3, $s0
    add $t3, $t3, $s1




    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra

foo: #SHOULD TAKE CARE OF ANY S REGISTERS
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)


    add $v0, $a1,$a0 # $v0 = a0 + a1 = 1 + 2
    li $s0, 0
    li $s1, 0 #THIS SHOULDNT MATTER IF STACK WAS SAVED PROPERLY
    
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra


