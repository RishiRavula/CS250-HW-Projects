.text 

main:
    addi $sp, $sp, -4 #open frame (1 words)
    sw $ra, 0($sp) #Save return address
    li $v0, 4 # create the immediate to print a string 
    la $a0, int_prompt #store int i a0 THIS IS A POINTER TO ADDRESS
    syscall

    li $v0, 5 # create immediate to store int for recursion
    syscall
    move $a0, $v0 #STORE N into $a0

    jal recurse

    move $a0, $v0 #move returned value from $v0 to $a0
    li $v0, 1 #prints answer
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    # li $v0, 10 #TEMRINATE PROGRAM
    # syscall




    
    recurse: 
        addi $sp, $sp, -8 #open frame (2 words)
        sw $ra, 4($sp) #Save return address
        sw $s0, 0($sp) #save $s0

        li $v0, -2 #BASE CASE To set f(0) = -2
        beq	$a0, 0, clean #if the base case of f(0) is hit, go to clean to finish

        move $s0, $a0 # $s0 = $a0 store in $s0
        addiu $a0, $a0, -1 #"N-1"
        jal recurse
        mul $s0, $s0, 3 # 3N
        mul $v0, $v0, 2 #[2f(N-1)]
        addiu $v0, $v0 -2 # [2f(N-1)]-2
        add $v0, $s0, $v0 # 3N + [2f(N-1)] - 2
    

    clean:
        lw $s0, 0($sp)
        lw $ra, 4($sp)
        addi $sp, $sp,8
        jr $ra

        
    


.data
int_prompt: .asciiz "Please Enter An Integer:"
newline: .asciiz "\n"
