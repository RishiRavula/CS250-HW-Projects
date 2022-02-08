
main:

    li $v0, 4 # create the immediate to print a string 
    la $a0, int_prompt #store int i a0 THIS IS A POINTER TO ADDRESS
    syscall
    li $v0, 5
    syscall #MERSENNE NUMBER WILL BE STORED IN v0, MAKE SURE TO MOVE THIS TO REUSE v0

    move $t1, $v0 #move value of v0 to t5 = INT INPUT
    li $t2, 1 #Start a counter
    li $t3 , 2 #Initialize value to do exponent multiplication with
    li $t4 , 2 # Base 2 to multiply with

    start_loop:
        addi $t2, $t2, 1 #increase counter by 1
        bgt $t2, $t1, sub_one	# if $t2 == $t1 then go to subtract 1
        mul $t3,$t3,$t4 # Multiply t3 with 2 and store result in t3
        j start_loop
    sub_one:
        addiu	$t3, $t3, -1	
        
    li $v0, 1 #Syscall to print int
    move 	$a0, $t3 # $a0 = $t1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    jr $ra
       
.data

int_prompt: .asciiz "Please Enter An Integer:"
newline: .asciiz "\n"
