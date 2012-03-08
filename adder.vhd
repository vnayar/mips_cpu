library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY adder IS
  GENERIC (
    S : positive -- the size of the adder
  );
  PORT (
    src_a : in std_logic_vector (S - 1 downto 0);
    src_b : in std_logic_vector (S - 1 downto 0); 
    sum : out std_logic_vector (S - 1 downto 0)
  );
END adder;

ARCHITECTURE behavioral OF adder IS
BEGIN
  sum <= src_a + src_b;
END behavioral;

