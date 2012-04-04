-------------------------------------------------------------------------------
-- adder.vhd
-- Simple adder for updating the Program Counter.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity adder is
  generic (
    S : positive                        -- the size of the adder
    );
  port (
    src_a : in  std_logic_vector (S - 1 downto 0);
    src_b : in  std_logic_vector (S - 1 downto 0);
    sum   : out std_logic_vector (S - 1 downto 0)
    );
end adder;

architecture behavioral of adder is
begin
  sum <= src_a + src_b;
end behavioral;

