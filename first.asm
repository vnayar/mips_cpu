
addiu $2, $0, 12
addiu $3, $0, 15
addiu $4, $0, 32
addiu $5, $0, 33
addiu $6, $0, 40
addiu $7, $0, 48
addiu $8, $0, 16
add $9, $2, $3
sw $8, 0x04($0)
sw $2, 0x08($0)
lw $11, 0x04($0)