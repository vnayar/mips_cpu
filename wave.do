onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips/clk
add wave -noupdate /tb_mips/resetb
add wave -noupdate -radix hexadecimal /tb_mips/UUT/PCounter1/pc_in
add wave -noupdate -radix hexadecimal /tb_mips/UUT/PCounter1/pc_out
add wave -noupdate -radix hexadecimal /tb_mips/UUT/PCPlus/sum
add wave -noupdate -radix hexadecimal /tb_mips/UUT/ROM1/instr
add wave -noupdate -radix hexadecimal /tb_mips/UUT/signex1/instr_imm
add wave -noupdate -radix hexadecimal /tb_mips/UUT/signex1/sign_imm
add wave -noupdate -radix hexadecimal /tb_mips/UUT/reg1/wa3
add wave -noupdate -radix hexadecimal /tb_mips/UUT/reg1/wd3
add wave -noupdate -radix hexadecimal /tb_mips/UUT/reg1/we3
add wave -noupdate -radix hexadecimal /tb_mips/UUT/ALU1/src_a
add wave -noupdate -radix hexadecimal /tb_mips/UUT/ALU1/src_b
add wave -noupdate -radix hexadecimal /tb_mips/UUT/ALU1/alu_ctrl
add wave -noupdate -radix hexadecimal /tb_mips/UUT/ALU1/alu_result
add wave -noupdate -radix hexadecimal /tb_mips/UUT/RAM1/ram_dout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {61448 ps} 0}
configure wave -namecolwidth 197
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {121241 ps}
