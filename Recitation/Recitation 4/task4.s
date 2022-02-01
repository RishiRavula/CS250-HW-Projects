.text


main:
    li $v0, 4 # create the immediate to print a string 
    la $a0, name_prompt #store name i a0 THIS IS A POINTER TO ADDRESS
    syscall
    
    li $v0, 8 # instruction set to read in a string
    la $a0, name_buffer #store in a0 THIS IS A POINTER TO ADDRESS
    li $a1, 16
    syscall

    li $v0, 4 # same instructions for age this time
    la $a0, age_prompt
    syscall

    li $v0, 5
    syscall #AGE WILL BE STORED IN v0, MAKE SURE TO MOVE THIS TO REUSE v0

    move $t5, $v0 #move value of v0 to t5 = AGE

    la $t1, name_buffer
    li $t3, 10 # ASCII FOR \n
    find_newline:
        lb $t2,0($t1)
        beq $t3, $t2, newline_found #check if newline is found
        addi $t1, $t1, 1 #move the pointer
        j find_newline
    newline_found:
    sb $zero 0($t1) #store byte zero and replace \n
    
    li $v0, 4
    la $a0, name_buffer
    syscall

    li $v0, 4
    la $a0, template_string
    syscall
    
    li $t0,50
    sub $t0, $t0, $t5
    addi $t0, $t0, 2022

    li $v0, 1
    move $a0, $t0
    syscall


    jr $ra

.data
newline: .asciiz "\n"
name_prompt: .asciiz "Please Enter Your Name: "
age_prompt: .asciiz "Please Enter Your Age: "
template_string: .asciiz " will turn 50 in the year "
name_buffer: .space 16

