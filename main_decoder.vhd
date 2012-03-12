LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MainDecoder IS
  PORT (
    -- The leading opcode bits of the instruction.
    opcode : in std_logic_vector (5 downto 0);

    -- Controls which output is sent to register write-data.
    --   0 ALU
    --   1 RAM
    ram_to_reg : out std_logic;
    -- Controls when RAM may be written to.
    --   0 disabled
    --   1 enabled
    ram_wr_en : out std_logic;
    -- Controls when the PC uses an immediate to branch
    --   0 normal increment
    --   1 branch, add immediate to PC
    branch : out std_logic;
    -- Controls whether srcB of ALU is immediate or register
    --   0 register
    --   1 immediate
    alu_src : out std_logic;
    -- Controls when 'rd' part of instruction is destination
    --   0 use 'rt' as destination
    --   1 use 'rd' as destination
    reg_dst : out std_logic;
    -- Controlls the write-enable of the register file.
    --   0 disable
    --   1 enable
    reg_wr_en : out std_logic;
    -- Provide high level controls to ALU Decoder.
    --   See alu_decoder for details.
    alu_op : out std_logic_vector (1 downto 0)
  );
END MainDecoder;

-- Control the various mux and alu components for different instructions.
--   Instruction  Opcode  reg_wr_en  reg_dst  alu_src  branch  ram_wr_en  ram_to_reg  alu_op
--   R-Type       000000          1        1        0       0          0           0      10
--   addi         001000          1        0        1       0          0           0      00
--   lw           100011          1        0        1       0          0           1      00
--   sw           101011          0        X        1       0          1           X      00
--   beq          000100          0        X        0       1          0           X      01
ARCHITECTURE synth OF MainDecoder IS
BEGIN
  reg_wr_en <= '1' when (opcode = "000000") or (opcode = "100011") or (opcode = "001000") else '0';
  reg_dst <= '1' when (opcode = "000000") else '0';
  alu_src <= '1' when (opcode = "001000") or (opcode = "100011") or (opcode = "101011") else '0';
  branch <= '1' when (opcode = "000100") else '0';
  ram_wr_en <= '1' when (opcode = "101011") else '0';
  ram_to_reg <= '1' when (opcode = "100011") else '0';
  alu_op(1) <= '1' when (opcode = "000000") else '0';
  alu_op(0) <= '1' when (opcode = "000100") else '0';
END;
