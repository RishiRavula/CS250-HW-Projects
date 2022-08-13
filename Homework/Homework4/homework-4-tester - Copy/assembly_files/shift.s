.text
# test shl, shra instructions

#Delay instruction
add $r0, $r0, $r0

#shl
addi $r1, $r0, 1
shl $r2, $r1, 7

#shra
shr $r3, $r2, 6

halt

.data
