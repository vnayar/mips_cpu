####
# Declare symbolic names for data stored in RAM.
####
.data
# For now, we have no way to initialize RAM.
numbers: .space 40 # 10 Integers
numbers_len: .word 40

####
# Program code, typically stored in ROM.
####
.text

# Special symbol recognized by SPIM, execution starts here.
main:

# Load sample data into RAM.
init:
  # Set value of numbers_len = 40 (10 * 4)
  la $t1, numbers_len
  addi $t0, $0, 40
  sw $t0, ($t1)
  # Load address of 'numbers' into t1.
  la $t1, numbers
  # The 'load-imediate' instruction can be simulated with add 0.
  addi $t0, $0, 5
  sw $t0, 0($t1)  # numbers[0] = 5
  addi $t0, $0, 7
  sw $t0, 4($t1)  # numbers[1] = 7
  addi $t0, $0, 3
  sw $t0, 8($t1)  # numbers[2] = 3
  addi $t0, $0, 2
  sw $t0, 12($t1)  # numbers[3] = 2
  addi $t0, $0, 9
  sw $t0, 16($t1)  # numbers[4] = 9
  addi $t0, $0, 4
  sw $t0, 20($t1)  # numbers[5] = 4
  addi $t0, $0, 1
  sw $t0, 24($t1)  # numbers[6] = 1
  addi $t0, $0, 8
  sw $t0, 28($t1)  # numbers[7] = 8
  addi $t0, $0, 6
  sw $t0, 32($t1)  # numbers[8] = 6
  addi $t0, $0, 0
  sw $t0, 36($t1)  # numbers[9] = 0

# for (int i = 0; i < numbers.length; i++) {
init_for_i:
  la $t0, numbers
  lw $t9, numbers_len  # numbers.length
  add $t9, $t0, $t9
cond_for_i:
  blt $t0, $t9, body_for_i 
  b end_for_i
body_for_i:
#   int min = i;
  move $t1, $t0
#   int min_val = numbers[i];
  lw $t2, ($t0)
#   for (int j = i + 1; j < numbers.length; j++) {
init_for_j:
  add $t3, $t0, 4
cond_for_j:
  blt $t3, $t9, body_for_j
  b end_for_j
body_for_j:
#     int check_val = numbers[j];
  lw $t4, ($t3)
#     if (check_val < min_val) {
  blt $t4, $t2, body_if_check
  b end_if_check
body_if_check:
#       min = j;
  move $t1, $t3
#       min_val = check_val;
  move $t2, $t4
#     }
end_if_check:
#   }
  add $t3, $t3, 4  # j++
  b cond_for_j
end_for_j:
#   int temp_val = numbers[i];
  lw $t5, ($t0)
#   numbers[i] = min_val;
  sw $t2, ($t0)
#   numbers[min] = temp_val;
  sw $t5, ($t1)
# }
  addi $t0, $t0, 4  # i++
  b cond_for_i
end_for_i:
# exit()
li $v0, 10  # syscall 10 is exit
syscall

