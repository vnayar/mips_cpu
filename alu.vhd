library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALU IS
  PORT (
    resetb     : in  std_logic;
    clk        : in  std_logic;
    src_a      : in std_logic_vector (31 downto 0);
    src_b      : in std_logic_vector (31 downto 0);      
    alu_ctrl   : in std_logic_vector (2 downto 0);
    alu_result : out std_logic_vector (31 downto 0);
    zero_flag  : out std_logic
  );
END ALU;

ARCHITECTURE behavioral OF ALU IS

BEGIN

  zero_flag <= '0';

  WITH alu_ctrl SELECT alu_result <=
    src_a + src_b    WHEN "010",
    (others => '0')  WHEN others;

END behavioral;
