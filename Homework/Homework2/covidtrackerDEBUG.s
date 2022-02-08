.text 


      

main:


    addi $sp, $sp,-8 #OPEN STACK
    sw $ra, 0($sp) #SAVE RA
    sw $s0, 4($sp) #STORE HEAD, MAIN LINKED LIST!!!!!!!

    

    
    la $a0, infectee_buffer
    jal strclr
    la $a0, infector_buffer
    jal strclr
    la $t4, BlueDevil
    la $t3, nullchar

    


    jal CreateNewNode

    
    move $s0 , $v0 #STORE THE HEAD OF THE ENTIRE LINKED LIST CHAIN

    la $s7, 0($s0) #Pointer to Head

    move $a0, $t3
    jal strclr
    move $a0, $t4
    jal strclr
    la $t4, nullchar
    la $t3, nullchar



    
    
    loop:

        la $a0, infectee_buffer
        jal strclr
        la $a0, infector_buffer
        jal strclr

    
        li $v0, 4 #PRINT STRING
        la $a0, infectee_prompt #Load infectee prompt in a0
        syscall

        li $v0, 8 #READ STRING
        la $a0, infectee_buffer
        li $a1, 32
        syscall
        la $t3, infectee_buffer #move the infectee into $t3 to clear up $v0
        

        

        #---- IF THE INFECTEE IS "DONE",  BREAK LOOP ----#
        la $a0, infectee_buffer
        la $a1, DONE 
        jal strcmp
        beqz $v0, clean






        



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
        la $t4, infector_buffer #move the infectee into $t4 to clear up $v0
        ##REMOVE THE NEW LINE, INFECTOR SHOULD NEVER HAVE A NEW LINE CHARACTER

        addi $sp, $sp, -12
        sw $t4, 0($sp)
        sw $t5, 4($sp)
        sw $t6, 8($sp)
        li $t5, 10 # ASCII FOR \n
        find_newline:
            lb $t6,0($t4)
            beq $t5, $t6, newline_found #check if newline is found
            addi $t4, $t4, 1 #move the pointer
            j find_newline
            newline_found:
                sb $zero 0($t4) #store byte zero and replace \n
        
        lw $t4, 0($sp)
        lw $t5, 4($sp)
        lw $t6, 8($sp)
        addi $sp, $sp, 12

        la $t4, infector_buffer
        #--------------INFECTOR IS STORED IN $t4--------------#

        #-----IF INFECTOR ALREADY EXISTS, DONT MAKE A NEW NODE!! ADD TO EXISTING NODE----#
        addi $sp, $sp, -8
        sw $s0, 0($sp)

        lw $t7, 0($s0) #POINTER TO THE INFECTORS IN THE ENTIRE LINKED LIST

        

        sub_loop:
            move $a0, $t7
            move $a1, $t4                
            jal strcmp

            beqz $v0, AddToExistingNode
            lw $t7, 96($t7)
            j sub_loop

        ##ELSE{

        jal CreateNewNode

        sw $v0, 96($s7) #Store NEWLY CREATED NODE into the PREVIOUS NODE next
        
        lw $s7, 96($s7) # ALLOW THE WHOLE WHOLE POINTER TO NEXT TO MOVE FOR NEXT LOOP ITERATION

        ###}
        
        


        

        


            
        j loop


        #--------------POSSIBLE LOOP BACK AROUND HERE--------------#




    AddToExistingNode:
    
    ##LOGIC TO ADD TO EXISTING NODE

    lw $s0, 0($sp)
    addi $sp, $sp, 8
    j loop

    
    CreateNewNode: ## NOT REALLY WORKING, INFO IS NOT GETTING STORED IN CREATENEWNODE
        addi $sp, $sp, -8 #OPEN FRAME AND SAVE
        sw $ra, 0($sp)
        sw $s2, 4($sp)


        #---ALLOC SPACE IN HEAP---#
        li $v0, 9 # Alloc space in the heap
        li $a0, 100 #Byte Logic: 32 for Person, 64 bytes for the infected, 4 for the pointer to next in the LinkedList
        syscall

        move $s2, $v0

        
        move $a1, $t4 #MOVE PERSON INTO ARG0
        move $a0, $s2 #DESTINATION FOR PERSON

        jal strcpy

        move $a1, $t3 #MOVE INFECTED INTO ARG0
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

    

    print:
        beq $s0, $zero done_print
        
        
        li $v0, 4 #PRINT STRING
        move $a0, $s0
        syscall

        li $v0, 4 #PRINT STRING
        la $a0, 32($s0)
        syscall

        li $v0, 4 #PRINT STRING
        la $a0, 64($s0)
        syscall

        lw $s0, 96($s0)



        j print


        done_print:
            lw $ra, 0($sp)
            addi $sp, $sp 4
            li $v0, 10
            syscall ##TERMINATE PROGRAM##
            #jr $ra
    clean:

        addi $sp, $sp -4
        sw $ra, 0($sp)


        jal print

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
