.text 

main:

    addi $sp, $sp,-4 #OPEN STACK
    sw $ra, 0($sp) #SAVE RA

    li $v0, 4 #PRINT STRING
    la $a0, infectee_prompt #Load infectee prompt in a0
    syscall

    li $v0, 8 #READ STRING
    syscall
    #INFECTEE IS STORED IN $v0

    addi $sp, $sp,-4 #OPEN STACK
    sw $t0, 0($sp) #SAVE $t0 which holds the infectee information

    move $t0, $v0 #move the infectee into $t0 to clear up $v0

    jal sort_head

    sort_head:
        addi $sp, $sp,-4 #OPEN STACK
        sw $ra, 0($sp) #SAVE RA
        #....
        lw $ra, 0($sp) #Recover link to main
        addi $sp, $sp,4 #close stack
        jr $ra

       
    lw $t0, 0($sp) #RECOVER $t0 which HELD the infectee information, restore to default (0) to use again later
    addi $sp, $sp,4 #Close stack
    
        





    li $v0, 4 #PRINT STRING
    la $a0, infector_prompt #Load infector prompt in a0
    syscall

    li $v0, 8 #READ STRING
    syscall
    #INFECTOR IS STORED IN $v0


    lw $ra, 0($sp) #RECOVER RA
    addi $sp, $sp, 4 #CLOSE STACK

.data
newline: .asciiz "\n"
infectee_prompt: .asciiz "Please enter patient:"
infector_prompt: .asciiz "Please enter infector:"
space: .asciiz " "