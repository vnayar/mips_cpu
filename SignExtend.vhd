-------------------------------------------------------------------------------
-- SignExtend.vhd
-- Sign-extend a 16-bit immediate to 32-bits.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity SignExtend is
  port (
    instr_imm : in  std_logic_vector (15 downto 0);
    sign_imm  : out std_logic_vector (31 downto 0)
    );
end SignExtend;

architecture behaviour of SignExtend is
begin
  sign_imm (15 downto 0)  <= instr_imm (15 downto 0);
  sign_imm (31 downto 16) <= (others => instr_imm(15));
end behaviour;
