-------------------------------------------------------------------------------
-- alu.vhd
-- Arithmetic Logic Unit for performing basic calculations.
-- Much of the system revolves around providing the right inputs to the ALU
-- and directing its output to the right place.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity ALU is
  port (
    resetb     : in  std_logic;
    clk        : in  std_logic;
    src_a      : in  std_logic_vector (31 downto 0);
    src_b      : in  std_logic_vector (31 downto 0);
    alu_ctrl   : in  std_logic_vector (2 downto 0);
    alu_result : out std_logic_vector (31 downto 0);
    zero_flag  : out std_logic
    );
end ALU;

-- Perform arithmetic operations depending upon alu_ctrl.
--   alu_ctrl  operation
--        000  A & B
--        001  A | B
--        010  A + B
--        100  A & ~B
--        110  A - B
--        111  set less than
architecture behavioral of ALU is

  signal alu_result_temp : std_logic_vector (31 downto 0);
  signal alu_less_than   : std_logic;

begin

  alu_less_than <= '1' when src_a < src_b                 else '0';
  zero_flag     <= '1' when alu_result_temp = X"00000000" else '0';
  alu_result    <= alu_result_temp;

  with alu_ctrl select alu_result_temp <=
    src_a and src_b                          when "000",
    src_a or src_b                           when "001",
    src_a + src_b                            when "010",
    src_a - src_b                            when "110",
    (0      => alu_less_than, others => '0') when "111",
    (others => '0')                          when others;

end behavioral;
