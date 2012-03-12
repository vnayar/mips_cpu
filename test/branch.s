main:

addi $t0, $0, 4
addi $t1, $0, 5

inc:
add $t0, $t0, 1
beq $t0, $t1, inc
