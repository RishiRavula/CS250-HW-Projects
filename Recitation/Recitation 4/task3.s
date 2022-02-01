.text

main:
    li $t0, 0 #Create a value and store in register t0
    li $t1, 10 # Terminating case, ensure it doesnt go past 10

    start_loop:
        li $v0, 1 #syscall register value 1 = print integer
        move $a0, $t0 #move the value of t0 into a0
        syscall

        addi $t0, $t0, 1 #Add intermediate, add whatever alr exists in t0 and add 1
        
        ble $t0,$t1, start_loop # jump to the start of the loop UNTIL $t0 > $t1
    jr $ra


.data
