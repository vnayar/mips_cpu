LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ALUDecoder IS
  PORT (
    -- The leading opcode bits of the instruction.
    funct : in std_logic_vector (5 downto 0);
    -- The general type of operation from the MainDecoder.
    --   00  add
    --   01  subtract
    --   10  or
    --   11  use funct field
    alu_op : in std_logic_vector (2 downto 0);

    -- Specify the arithmetic operator for the ALU.
    alu_ctrl : out std_logic_vector (2 downto 0)
  );
END ALUDecoder;

-- Decode the ALU operation to an ALU Control.
--   alu_op   funct  alu_ctrl
--      000       X       010 (add)
--      001       X       110 (subtract)
--      010       X       001 (or)
--      011  100000       010 (add)
--      011  100010       110 (subtract)
--      011  100100       000 (and)
--      011  100101       001 (or)
--      011  101010       111 (set less than)
--      111       X       111 (set less than)
ARCHITECTURE synth OF ALUDecoder IS
BEGIN
  alu_ctrl <= "010" when (alu_op = "000") or ((alu_op = "011") and (funct = "100000")) else
              "110" when (alu_op = "001") or ((alu_op = "011") and (funct = "100010")) else
              "000" when ((alu_op = "011") and (funct = "100100")) else
              "001" when (alu_op = "010") or ((alu_op = "011") and (funct = "100101")) else
              "111" when (alu_op = "111") or ((alu_op = "011") and (funct = "101010"));
END;

