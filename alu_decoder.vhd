LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ALUDecoder IS
  PORT (
    -- The leading opcode bits of the instruction.
    funct : in std_logic_vector (5 downto 0);
    -- The general type of operation from the MainDecoder.
    --   00  add
    --   01  subtract
    --   10  use funct field
    --   11  UNUSED
    alu_op : in std_logic_vector (1 downto 0);

    -- Specify the arithmetic operator for the ALU.
    alu_ctrl : out std_logic_vector (2 downto 0)
  );
END ALUDecoder;

-- Decode the ALU operation to an ALU Control.
--   alu_op   funct  alu_ctrl
--       00       X       010 (add)
--       X1       X       110 (subtract)
--       1X  100000       010 (add)
--       1X  100010       110 (subtract)
--       1X  100100       000 (and)
--       1X  100101       001 (or)
--       1X  101010       111 (set less than)
ARCHITECTURE synth OF ALUDecoder IS
BEGIN
  alu_ctrl <= "010" when (alu_op = "00") or ((alu_op(1) = '1') and (funct = "100000")) else
              "110" when (alu_op(0) = '1') or ((alu_op(1) = '1') and (funct = "100010")) else
              "000" when ((alu_op(1) = '1') and (funct = "100100")) else
              "001" when ((alu_op(1) = '1') and (funct = "100101")) else
              "111" when ((alu_op(1) = '1') and (funct = "101010"));
END;

