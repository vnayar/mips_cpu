library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY lshift IS
  GENERIC (
    S : positive := 32; -- the size of the shift
    SH : positive := 8  -- the amount to left shift by
  );
  PORT (
    sh_in : in std_logic_vector (S - 1 downto 0);
    sh_out : out std_logic_vector (S - 1 downto 0)
  );
END lshift;

ARCHITECTURE synth OF lshift IS
BEGIN
    sh_out (S - 1 downto SH) <= sh_in (S - 1 - SH downto 0);
    sh_out (SH - 1 downto 0) <= (others => '0');
END synth;

