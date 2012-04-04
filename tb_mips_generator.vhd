-------------------------------------------------------------------------------
-- tb_mips_generator.vhd
-- Test bench for the MIPS CPU with generated clock and reset.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_bit.all;


entity tb_mips_generator is
  port (
    clk    : out std_logic;
    resetb : out std_logic
    );           
end tb_mips_generator;

architecture testbench_gen of tb_mips_generator is
  
  signal clock   : std_logic := '0';    --clock signal
  signal reset_n : std_logic := '0';    --reset signal

begin
  clocking : block
  begin
    clock <= not clock after 5 ns;
  end block;

  Reset : process
  begin
    reset_n <= '0';
    wait for 35 ns;
    reset_n <= '1';
    wait until false;
  end process;

  -- output ports driven by signals
  clk    <= clock;
  resetb <= reset_n;

end testbench_gen;
