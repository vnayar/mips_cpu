-------------------------------------------------------------------------------
-- lshift.vhd
-- Fixed amount left shifter, useful for non-word aligned operations.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity lshift is
  generic (
    S  : positive := 32;                -- the size of the shift
    SH : positive := 8                  -- the amount to left shift by
    );
  port (
    sh_in  : in  std_logic_vector (S - 1 downto 0);
    sh_out : out std_logic_vector (S - 1 downto 0)
    );
end lshift;

architecture synth of lshift is
begin
  sh_out (S - 1 downto SH) <= sh_in (S - 1 - SH downto 0);
  sh_out (SH - 1 downto 0) <= (others => '0');
end synth;

