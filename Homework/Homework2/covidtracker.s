.text 


      

main:


    addi $sp, $sp,-8 #OPEN STACK
    sw $ra, 0($sp) #SAVE RA
    sw $s0, 4($sp) #STORE HEAD, MAIN LINKED LIST!!!!!!!

    

    
    la $a0, infectee_buffer
    jal strclr
    la $a0, infector_buffer
    jal strclr
    la $t1, BlueDevil
    move $t0, $zero

    addi $sp, $sp,-8 #OPEN STACK
    sw $t1, 0($sp) #SAVE RA
    sw $t0, 4($sp) #SAVE RA


    jal CreateNewNode

    lw $t1, 0($sp) #restore
    lw $t0, 4($sp) #restore
    addi $sp, $sp,8 #close STACK
    
    move $s0 , $v0 #STORE THE HEAD OF THE ENTIRE LINKED LIST CHAIN

    la $s7, 0($s0) #Pointer to Head

    
    
    loop:

        li $v0, 4 #PRINT STRING
        la $a0, infectee_prompt #Load infectee prompt in a0
        syscall

        li $v0, 8 #READ STRING
        la $a0, infectee_buffer
        jal strclr
        li $a1, 32
        syscall
        move $t3, $v0 #move the infectee into $t3 to clear up $v0

        #TERMINATE LOOP ONCE DONE IS CALLED

        addi $sp, $sp,-8 #OPEN STACK
        sw $a0, 0($sp) #SAVE RA
        sw $a1, 4($sp) #STORE HEAD

         
        la $a0, infectee_buffer
        la $a1, DONE
        jal strcmp
        beqz $v0, clean

        lw $a0, 0($sp) #Restore a0
        lw $a1, 4($sp) #Restore a1
        addi $sp, $sp,8 #close stack
        




        



        #--------------INFECTEE IS STORED IN $t3--------------#


        #-----------BEGIN TO READ IN THE INFECTOR-----------#
        li $v0, 4 #PRINT STRING
        la $a0, infector_prompt #Load infector prompt in a0
        syscall

        li $v0, 8 #READ STRING
        la $a0, infector_buffer
        jal strclr
        li $a1, 32
        syscall
        #INFECTOR IS STORED IN $v0
        move $t4, $v0 #move the infectee into $t4 to clear up $v0


        #--------------INFECTOR IS STORED IN $t4--------------#


        jal CreateNewNode

        

        sw $v0, 96($s7) #Store NEWLY CREATED NODE into the PREVIOUS NODE next
        
        lw $s7, 96($s7) # ALLOW THE WHOLE WHOLE POINTER TO NEXT TO MOVE FOR NEXT LOOP ITERATION

        


            
        j loop


        #--------------POSSIBLE LOOP BACK AROUND HERE--------------#




    clean:

        addi $sp, $sp -4
        sw $ra, 0($sp)


        #jal print

        la $a0, infector_buffer
        jal strclr
        la $a0, infectee_buffer
        jal strclr

    
        li $v0, 10
        syscall #FORCE CLOSE PROG
            
        li $v0, 4 #PRINT STRING
        la $a0, infector_buffer #Load infector name in a0
        syscall
        li $v0, 4 #PRINT STRING
        la $a0, spacebar #add a space in a0
        syscall
        li $v0, 4 #PRINT STRING
        la $a0, infectee_buffer #Load infectee name in a0
        syscall
        li $v0, 4 #PRINT STRING
        la $a0, newline #make a new line to move in a0
        syscall

        lw $s0, 4($sp) #RECOVER s0
        lw $ra, 0($sp) #RECOVER RA
        addi $sp, $sp, 4 #CLOSE STACK   


        jr $ra #end program


    CreateNewNode: ## NOT REALLY WORKING, INFO IS NOT GETTING STORED IN CREATENEWNODE
        addi $sp, $sp, -8 #OPEN FRAME AND SAVE
        sw $ra, 0($sp)
        sw $s2, 4($sp)


        #---ALLOC SPACE IN HEAP---#
        li $v0, 9 # Alloc space in the heap
        li $a0, 100 #Byte Logic: 32 for Person, 64 bytes for the infected, 4 for the pointer to next in the LinkedList
        syscall

        move $s2, $v0


        la $a1, infector_buffer #MOVE PERSON INTO ARG0
        move $a0, $s2 #DESTINATION FOR PERSON

        jal strcpy

        la $a1, infectee_buffer #MOVE INFECTED INTO ARG0
        addi $s2, $s2, 32 #DESTINATION FOR INFECTED 
        move $a0, $s2 #DESTINATION FOR PERSON

        jal strcpy

        addi $s2, $s2, -32 #GO BACK TO START OF NODE

        move $v0, $s2

        lw $s2, 4($sp)
        lw $ra, 0($sp)
  
        addi $sp, $sp, 8 #CLOSE FRAME AND RETURN
        jr $ra


    # $a0 = dest, $a1 = src
    strcpy:
        lb $t0, 0($a1)
        beq $t0, $zero, done_copying
        sb $t0, 0($a0)
        addi $a0, $a0, 1
        addi $a1, $a1, 1
        j strcpy

        done_copying:
        jr $ra
    # $a0, $a1 = strings to compare
    # $v0 = result of strcmp($a0, $a1)
    strcmp:
        lb $t0, 0($a0) #SOME ERROR BEING THROWN HERE!!! (help pls)
        lb $t1, 0($a1)

        bne $t0, $t1, done_with_strcmp_loop
        addi $a0, $a0, 1
        addi $a1, $a1, 1
        bnez $t0, strcmp
        li $v0, 0
        jr $ra

        done_with_strcmp_loop:
	        sub $v0, $t0, $t1
	        jr $ra

    # $a0 = string buffer to be zeroed out
    strclr:
        lb $t0, 0($a0)
        beq $t0, $zero, done_clearing
        sb $zero, 0($a0)
        addi $a0, $a0, 1
        j strclr

        done_clearing:
        jr $ra

    remove_newline:

    print:

        beq $s0, $zero, done_print
        
        
        li $v0, 4 #PRINT STRING
        move $a0, $s0
        syscall

        li $v0, 4 #PRINT STRING
        lw $a0, 32($s0)
        syscall

        li $v0, 4 #PRINT STRING
        lw $a0, 64($s0)
        syscall

        lw $s0, 96($s0)



        j print


        done_print:
            lw $ra, 0($sp)
            addi $sp, $sp 4
            jr $ra



    







        


   



.data
newline: .asciiz "\n"
infectee_prompt: .asciiz "Please enter patient:"
infector_prompt: .asciiz "Please enter infector:"
spacebar: .asciiz " "
infectee_buffer: .space 32
infector_buffer: .space 32
DONE: .asciiz "DONE\n"
nullchar: .asciiz ""

BlueDevil: .asciiz "BlueDevil\n"
