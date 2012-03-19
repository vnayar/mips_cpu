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

-- Perform arithmetic operations depending upon alu_ctrl.
--   alu_ctrl  operation
--        000  A & B
--        001  A | B
--        010  A + B
--        100  A & ~B
--        110  A - B
--        111  set less than
ARCHITECTURE behavioral OF ALU IS

  signal alu_result_temp : std_logic_vector (31 downto 0);
  signal alu_less_than : std_logic;

BEGIN

  alu_less_than <= '1' when src_a < src_b else '0';
  zero_flag <= '1' when alu_result_temp = X"00000000" else '0';
  alu_result <= alu_result_temp;

  WITH alu_ctrl SELECT alu_result_temp <=
    src_a and src_b  WHEN "000",
    src_a or src_b   WHEN "001",
    src_a + src_b    WHEN "010",
    src_a - src_b    WHEN "110",
    (0 => alu_less_than, others => '0') WHEN "111",
    (others => '0')  WHEN others;

END behavioral;
