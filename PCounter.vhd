library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY PCounter IS
  PORT (
    clk : in std_logic;
    resetb : in std_logic; 
    pc_in : in std_logic_vector (15 downto 0);
    pc_out : out std_logic_vector (15 downto 0)
  );
END PCounter;

ARCHITECTURE behavioral OF PCounter IS

  signal program_counter : std_logic_vector (15 downto 0);
 
BEGIN

  pc_out <= program_counter;

  PROCESS (clk, resetb)
  BEGIN
    IF (resetb = '0') THEN
      program_counter <= X"0000";
    ELSIF rising_edge(clk) THEN
      IF (program_counter = X"0003") THEN
        program_counter <= X"0003";
      ELSE
        program_counter <= pc_in;
      END IF;
    END IF;
  END PROCESS;

END behavioral;
