main:

# BEQ test

addi $t0, $0, 4
addi $t1, $0, 5

inc:
add $t0, $t0, 1
beq $t0, $t1, inc


# BNE test

add $t0, $0, 2
add $t1, $0, 4

inc2:
add $t0, $t0, 1
bne $t0, $t1, inc2
