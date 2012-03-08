LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY SignExtend IS
  PORT (
    instr_imm : in std_logic_vector (15 downto 0);
    sign_imm : out std_logic_vector (31 downto 0)
  );
END SignExtend;

ARCHITECTURE behaviour OF SignExtend IS
BEGIN
  sign_imm (15 downto 0) <= instr_imm (15 downto 0);
  sign_imm (31 downto 16) <= (others => instr_imm(15));
END behaviour;
