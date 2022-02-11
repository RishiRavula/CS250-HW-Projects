
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
    
    	xor $a1, $a1, $a1
    	xor $a0, $a0, $a0

        la $a0, infectee_buffer
        jal strclr
        la $a0, infector_buffer
        jal strclr
        move $a0, $t4
        jal strclr
        move $t4, $a0
        move $a0, $t3 
        jal strclr
        move $t3, $a0
        

    
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
        addi $sp, $sp, -8
		sw $a0, 0($sp)
		sw $a1, 4($sp)
        jal strcmp
        lw $a0, 0($sp)
		lw $a1, 4($sp)
    	addi $sp, $sp, 8
        beqz $v0, clean
        
        
        
        addi $sp, $sp, -16
        sw $t4, 0($sp)
        sw $t5, 4($sp)
        sw $t6, 8($sp)
        
        la $t4, infectee_buffer
   
   		jal find_newline
   		
   		
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
		move $a2, $t4
		
		addi $sp, $sp, -16
        sw $ra, 12($sp)
        sw $t4, 0($sp)
        sw $t5, 4($sp)
        sw $t6, 8($sp)
        
		jal find_newline
        #la $t4, infector_buffer
        #--------------INFECTOR IS STORED IN $t4--------------#

        #-----IF INFECTOR ALREADY EXISTS, DONT MAKE A NEW NODE!! ADD TO EXISTING NODE----#
        #addi $sp, $sp, -8
        #sw $s0, 0($sp)

        move $t7, $s0 #TEMP POINTER TO THE INFECTORS IN THE ENTIRE LINKED LIST

        # Add a node for the patient if it doesn't exist already
        patient_check_loop:
        	move $a0, $t7 # *main list
            move $a1, $t3 # *infectee
        	addi $sp, $sp, -8
			sw $a0, 0($sp)
			sw $a1, 4($sp)
            jal strcmp
            lw $a0, 0($sp)
			lw $a1, 4($sp)
    		addi $sp, $sp, 8
            beqz $v0, sub_loop
            
            lw $t7, 96($t7)
            bnez $t7, patient_check_loop
            
        move $t7, $s0 #TEMP POINTER TO THE INFECTORS IN THE ENTIRE LINKED LIST
             
        # at this point, patient is not in the list, so we need to insert him
        	# $a1 - name
			# $a2 - current head
		move $a1, $t3
		move $a2, $s0
		jal linked_list_insert

        sub_loop:
            move $a0, $t7
            move $a1, $t4    
            addi $sp, $sp, -8
			sw $a0, 0($sp)
			sw $a1, 4($sp)            
            jal strcmp
            lw $a0, 0($sp)
			lw $a1, 4($sp)
    		addi $sp, $sp, 8
            bnez $v0, AddToExistingNodeJAL
            j AddToExistingNode
            AddToExistingNodeJAL:
            lw $t7, 96($t7)
            beqz $t7, sub_loop_exit
            j sub_loop

        ##ELSE{
        sub_loop_exit:

        move $a1, $t4
        move $a2, $s0        
        jal linked_list_insert
        
        # First, make sure the main list has a node for the infector.
        # Then, add the new patient to the sublist of the infector's node.
        # -- here --
        # Then, make sure the main list has a node for the patient (if it didn't already)
        
        
		move $a0, $t3 #INFECTEE
		move $a1, $s0 #MAIN LINKED LIST
		check_if_patient_is_a_node:
			addi $sp, $sp, -8
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			jal strcmp
			lw $a0, 0($sp)
			lw $a1, 4($sp)
    		addi $sp, $sp, 8
			beqz $a1, add_patient_to_main_list 
			beqz $v0, found
			addi $a1, $a1, 96 #traverse through linked list nodes
			j check_if_patient_is_a_node
		found:
			j loop
		add_patient_to_main_list:
			move $a1, $t3
			move $a2, $s0
			jal linked_list_insert
			## --- WHAT IS THE LOGIC NECESARY TO ADD THE PATIENT TO THE MAIN LIST? --- ##
			j loop
        # for node in main_list ($s0):
        	# if node.name == patient_name
        		# goto found
        # found:
        # goto done
        
        # add patient to main_list
        # done:
        
        
        
        
        #move $t7, $s0 
        #move $s6, $v0
        
                	
        
        	j loop
       
        	#sw $v0, 96($s7) #Store NEWLY CREATED NODE into the PREVIOUS NODE next
        
        	#lw $s7, 96($s7) # ALLOW THE WHOLE WHOLE POINTER TO NEXT TO MOVE FOR NEXT LOOP ITERATION

        	###}
 

        #-------------- LOOP BACK AROUND HERE--------------#



    
    AddToExistingNode:
    	addi $sp, $sp, -12
    	sw $s4, 8($sp)
    	sw $s5, 0($sp)
    	sw $ra, 4($sp)
    	
    	
    	
    	#$t7 = Head of the node that exists
    	#CASE 1: Check if the entire thing is empty 
    	
    	lw $s5, 32($t7)
    	bnez $s5, SlotsNotEmpty
    	lw $s5 64($t7)
    	bnez $s5, SlotsNotEmpty
    	
    	move $a1, $t3
    	move $a0, $t7
    	addi $a0, $a0, 32
    	
    	sw $a0, 0($sp)
		sw $a1, 4($sp)
    	jal strcpy
    	lw $a0, 0($sp)
		lw $a1, 4($sp)
    	addi $sp, $sp, 8
    	
    	j loop
    		
    	SlotsNotEmpty:
    	#t3 input, $t7 current existing
    	move $a0, $t3
    	move $a1, $t7
    	addi $a1, $a1, 32
    	addi $sp, $sp, -8
		sw $a0, 0($sp)
		sw $a1, 4($sp)
    	jal strcmp
    	lw $a0, 0($sp)
		lw $a1, 4($sp)
    	addi $sp, $sp, 8
    	
    	#IF $v0 is -, $a0 comes before $a1
    	
    	bgtz  $v0, Case2
    	
    	Case1:
    	addi $a1,$t7, 32 
    	addi $a0, $t7, 64
    	
    	addi $sp, $sp, -8
    	sw $a0, 0($sp)
		sw $a1, 4($sp)
    	jal strcpy
    	lw $a0, 0($sp)
		lw $a1, 4($sp)
    	addi $sp, $sp, 8
    	
    	
    	addi $a0, $t7, 32
    	jal strclr
    	
    	move $a1, $t3
    	addi $a0, $t7, 32
    	
    	addi $sp, $sp, -8
    	sw $a0, 0($sp)
		sw $a1, 4($sp)
    	jal strcpy
    	lw $a0, 0($sp)
		lw $a1, 4($sp)
    	addi $sp, $sp, 8
    	   	
		j loop
    	
    	Case2:
    	
    	move $a1, $t3
    	addi $a0, $t7, 64
    	
    	
    	addi $sp, $sp, -8
    	sw $a0, 0($sp)
		sw $a1, 4($sp)
    	jal strcpy
    	lw $a0, 0($sp)
		lw $a1, 4($sp)
    	addi $sp, $sp, 8

       	lw $s4, 8($sp)
        lw $ra, 4($sp)
        lw $s5, 0($sp)
        addi $sp, $sp, 12
        j loop
        
        
        #jr $ra
    	
    
    ##LOGIC TO ADD TO EXISTING NODE

    lw $s0, 0($sp)
    addi $sp, $sp, 8
    j loop

    
    CreatePatientNode:
    	addi $sp, $sp, -8 #OPEN FRAME AND SAVE
    	sw $ra, 0($sp)
    	sw $s2, 4($sp)
    	
    	        #---ALLOC SPACE IN HEAP---#
        li $v0, 9 # Alloc space in the heap
        li $a0, 100 #Byte Logic: 32 for Person, 64 bytes for the infected, 4 for the pointer to next in the LinkedList
        syscall

        move $s2, $v0

        
        move $a1, $t3 #MOVE INFECTEE INTO ARG0
        move $a0, $s2 #DESTINATION FOR INFECTOR

       	addi $sp, $sp, -8
    	sw $a0, 0($sp)
		sw $a1, 4($sp)
    	jal strcpy
    	lw $a0, 0($sp)
		lw $a1, 4($sp)
    	addi $sp, $sp, 8

    
    	lw $s2, 4($sp)
    	lw $ra, 0($sp)
    	addi $sp, $sp, 8 #CLOSE FRAME AND RETURN
    	jr $ra
    	
    	
    CreateNewNode: ## NOT REALLY WORKING, INFO IS NOT GETTING STORED IN CREATENEWNODE
    			# t4 = infector
    			# t3 = infectee
    			# return v0
    			
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

        addi $sp, $sp, -8
    	sw $a0, 0($sp)
		sw $a1, 4($sp)
    	jal strcpy
    	lw $a0, 0($sp)
		lw $a1, 4($sp)
    	addi $sp, $sp, 8

        move $a1, $t3 #MOVE INFECTED INTO ARG0
        addi $s2, $s2, 32 #DESTINATION FOR INFECTED 
        move $a0, $s2 #DESTINATION FOR PERSON
        
        addi $sp, $sp, -8
    	sw $a0, 0($sp)
		sw $a1, 4($sp)
    	jal strcpy
    	lw $a0, 0($sp)
		lw $a1, 4($sp)
    	addi $sp, $sp, 8

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
        #argument a2
    find_newline:
        li $t5, 10 # ASCII FOR \n
            lb $t6,0($t4)
            beq $t5, $t6, newline_found #check if newline is found
            addi $t4, $t4, 1 #move the pointer
            j find_newline
            newline_found:
                sb $zero, 0($t4) #store byte zero and replace \n
        lw $t4, 0($sp)
        lw $t5, 4($sp)
        lw $t6, 8($sp)
        addi $sp, $sp, 16
        jr $ra


    

    print:
        beq $s0, $zero done_print
        
        
        li $v0, 4 #PRINT STRING
        move $a0, $s0
        syscall
        
        la $a0, spacebar
        syscall

        la $a0, 32($s0)
        syscall
        
        la $a0, spacebar
        syscall

        la $a0, 64($s0)
        syscall
        
        la $a0, newline
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


linked_list_insert:
	# $a1 - name
	# $a2 - current head
	
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $t7, 4($sp)
	sw $s3, 8($sp)
	sw $s4, 12($sp)
	
	# If the new is smaller than the head, insert it at the head
	
	move $a0, $a2
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $a1, 4($sp)
    jal strcmp
    lw $a0, 0($sp)
	lw $a1, 4($sp)
    addi $sp, $sp, 8
	blez $v0, linked_list_insert_find_spot
	
	# Make the new node
    li $v0, 9 # Alloc space in the heap
    li $a0, 100 #Byte Logic: 32 for Person, 64 bytes for the infected, 4 for the pointer to next in the LinkedList
    syscall
        
    # Insert it and then set it's (return of sbrk aka $v0) .next to the old guy's ($a2) .next
    move $a0, $v0
    # name already in a1
	addi $sp, $sp, -8
    sw $a0, 0($sp)
	sw $a1, 4($sp)
    jal strcpy
    lw $a0, 0($sp)
	lw $a1, 4($sp)
    addi $sp, $sp, 8
    
    sw $s0, 96($v0)	# new.next = old head
    move $s0, $v0		# s0 = new head
	
	j linked_list_insert_end
	
	#linked_list_insert_find_spot_and_advance:
	#lw $a2, 96($a2)
	
	linked_list_insert_find_spot: # Return (in $t7) the location of the last node with name before the specified name

        #NODE STORED IN v0
       		
       		#lw $a0, 96($a2)  
       		move $a0, $a2     		
       		addi $sp, $sp, -8
			sw $a0, 0($sp)
			sw $a1, 4($sp)
    		jal strcmp
    		lw $a0, 0($sp)
			lw $a1, 4($sp)
    		addi $sp, $sp, 8

       		
       		# strcmp < 0 means $a0 < $a1, aka existing < name
       		# strcmp > 0 means $a0 > $a1, aka name comes before existing
       		
       		bgtz $v0, linked_list_insert_spot_found
       		
       	# At this point, the new name is > the current $s2
       	# Make sure that, even if #s2 is less than the new, @s2.next isn't ALSO less than the new
       	
       		lw $s4, 96($a2)
       		
       		# if the .next is null, then the check passes
       		beqz $s4, linked_list_insert_spot_found
       		
       		move $a0, $s4
       		addi $sp, $sp, -8
			sw $a0, 0($sp)
			sw $a1, 4($sp)
    		jal strcmp
    		lw $a0, 0($sp)
			lw $a1, 4($sp)
    		addi $sp, $sp, 8 #strcmp(s2, new)-- >0 means s2 > new
       		
       		bgez $v0, linked_list_insert_spot_found
       		
       		move $a2, $s4
       		
       		j linked_list_insert_find_spot
       	

# no need check:
       		
       		# If the .next is null, this must be the insert spot
       		#lw $s4, 96($a2)
       		#beqz $s4, linked_list_insert_spot_found
       	       		
       		#lw $a2, 96($a2)	# a2 = a2.next
       		#j linked_list_insert_find_spot
        	
        linked_list_insert_spot_found:
        	# Make the new node
        	li $v0, 9 # Alloc space in the heap
        	li $a0, 100 #Byte Logic: 32 for Person, 64 bytes for the infected, 4 for the pointer to next in the LinkedList
        	syscall
        
        	# Insert it and then set it's (return of sbrk aka $v0) .next to the old guy's ($a2) .next
        	move $a0, $v0
        	# name already in a1
        	addi $sp, $sp, -8
    		sw $a0, 0($sp)
			sw $a1, 4($sp)
    		jal strcpy
    		lw $a0, 0($sp)
			lw $a1, 4($sp)
    		addi $sp, $sp, 8
        
        	# $v0.next = $a2.next
        	lw $s3, 96($a2)
        	sw $s3, 96($v0)
        	
        	# $a2.next = $v0
        	sw $v0, 96($a2)       
        	
        	j linked_list_insert_end
        
    linked_list_insert_end:
    	#stack restore
		lw $ra, 0($sp)
		lw $t7, 4($sp)
		lw $s3, 8($sp)
		lw $s4, 12($sp)
		addi $sp, $sp, 16
    	
    	jr $ra
	

.data
.align 3
newline: .asciiz "\n"
infectee_prompt: .asciiz "Please enter patient:"
infector_prompt: .asciiz "Please enter infector:"
spacebar: .asciiz " "
infectee_buffer: .space 32
infector_buffer: .space 32
DONE: .asciiz "DONE\n"
nullchar: .asciiz ""

debug1: .asciiz "Need to insert into mainlist!\n"

BlueDevil: .asciiz "BlueDevil"
