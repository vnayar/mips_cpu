-------------------------------------------------------------------------------
-- PCounter.vhd
-- Register that holds the current instruction address
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity PCounter is
  port (
    clk    : in  std_logic;
    resetb : in  std_logic;
    pc_in  : in  std_logic_vector (31 downto 0);
    pc_out : out std_logic_vector (31 downto 0)
    );
end PCounter;

architecture behavioral of PCounter is

  signal program_counter : std_logic_vector (31 downto 0);
  
begin

  pc_out <= program_counter;

  process (clk, resetb)
  begin
    if (resetb = '0') then
      program_counter <= X"00000000";
    elsif rising_edge(clk) then
      program_counter <= pc_in;
    end if;
  end process;

end behavioral;
