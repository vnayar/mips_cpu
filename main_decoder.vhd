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

    -- Branch Zero-Flag
    --   0 branch when the 'zero' flag is not set
    --   1 branch when the 'zero' flag is set
    bzf : out std_logic;

    -- Controls whether srcB of ALU is immediate or register
    --   0 register
    --   1 immediate
    alu_src : out std_logic;

    -- Controls when 'rd' part of instruction is destination
    --   0 use 'rt' as destination
    --   1 use 'rd' as destination
    reg_dst : out std_logic;

    -- Controls the write-enable of the register file.
    --   0 disable
    --   1 enable
    reg_wr_en : out std_logic;

    -- Provide high level controls to ALU Decoder.
    --   See alu_decoder for details.
    alu_op : out std_logic_vector (2 downto 0);

    -- Controls where the input to the PC comes from
    --   0 see 'branch'
    --   1 use the immediate from a 'jump' instruction
    jump : out std_logic;

    -- Shift Immediate
    --   0 leave the immediate alone
    --   1 left shift the immediate 8 bits
    shift_imm : out std_logic
  );
END MainDecoder;

-- Control the various mux and alu components for different instructions.
--   Instruction  Opcode  reg_wr_en  reg_dst  alu_src  branch  bzf ram_wr_en  ram_to_reg  alu_op  jump  shift_imm
--   R-Type       000000          1        1        0       0    X         0           0     011     0          0
--   addi         001000          1        0        1       0    X         0           0     000     0          0
--   slti         001010          1        0        1       0    X         0           0     111     0          0
--   ori          001101          1        0        1       0    X         0           0     010     0          0
--   lw           100011          1        0        1       0    X         0           1     000     0          0
--   sw           101011          0        X        1       0    X         1           X     000     0          X
--   beq          000100          0        X        0       1    1         0           X     001     0          X
--   bne          000101          0        X        0       1    0         0           X     001     0          X
--   j            000010          0        X        X       X    X         0           X     XXX     1          X
--   lui          001111          1        0        1       0    X         0           0     010     0          1
ARCHITECTURE synth OF MainDecoder IS
BEGIN
  reg_wr_en <= '1' when (opcode = "000000") or (opcode = "100011") or (opcode = "001000") or
                        (opcode = "001101") or (opcode = "001111") or (opcode = "001010") else '0';
  reg_dst <= '1' when (opcode = "000000") else '0';
  alu_src <= '1' when (opcode = "001000") or (opcode = "100011") or (opcode = "101011") or
                      (opcode = "001111") or (opcode = "001010") else '0';
  branch <= '1' when (opcode (5 downto 1) = "00010") else '0';
  bzf <= '1' when (opcode (0) = '0') else '0';
  ram_wr_en <= '1' when (opcode = "101011") else '0';
  ram_to_reg <= '1' when (opcode = "100011") else '0';
  alu_op <= "001" when (opcode (5 downto 1) = "00010") else -- sub (for beq)
            "010" when (opcode = "001101") or (opcode = "001111") else -- ori
            "011" when (opcode = "000000") else -- R-Type
            "111" when (opcode = "001010") else -- slti
            "000" when (opcode = "001000") else -- addi
            "000";
  jump <= '1' when (opcode = "000010") else '0';
  shift_imm <= '1' when (opcode = "001111") else '0';
END;
