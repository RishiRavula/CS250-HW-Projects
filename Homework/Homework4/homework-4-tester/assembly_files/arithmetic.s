.text
# test addi, add, sub instructions

#Delay instruction
add $r0, $r0, $r0

#addi, add
addi $r1, $r0, 16
addi $r2, $r0, 31
add $r3, $r2, $r1

#sub
subi $r1, $r0, 16
subi $r2, $r0, 31
sub $r3, $r2, $r1

halt

.data
