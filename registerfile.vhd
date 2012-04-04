-------------------------------------------------------------------------------
-- registerfile.vhd
-- A three-port memory with two combinational reads and one sequential write.
-- The 32 registers of the MIPS architecture are stored here.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity registerfile is
  port (
    resetb : in  std_logic;
    clk    : in  std_logic;  -- clock
    ra1    : in  std_logic_vector (4 downto 0);  -- read-address 1
    ra2    : in  std_logic_vector (4 downto 0);  -- read-address 2
    rd1    : out std_logic_vector (31 downto 0);  -- read-data 1
    rd2    : out std_logic_vector (31 downto 0);  -- read-data 2
    wa3    : in  std_logic_vector (4 downto 0);  -- write-address
    wd3    : in  std_logic_vector (31 downto 0);  -- write-data
    we3    : in  std_logic              -- write-enable for register file
    );

end registerfile;

architecture synth of registerfile is

  type   vector_array is array (0 to 31) of std_logic_vector (31 downto 0);
  signal registers : vector_array;

begin

  -- Data is read combinatorially (independent of clock).
  rd1 <= registers(conv_integer(ra1));
  rd2 <= registers(conv_integer(ra2));

  -- Data is written sequentially with the clock.
  write_regs : process (clk)
  begin
    -- Reset always blanks the registers.
    if resetb = '0' then
      registers <= (others => (others => '0'));
    elsif rising_edge(clk) then
      -- Only write on a clock-edge if write-enable is on.
      if (we3 = '1') then
        case conv_integer(wa3) is
          -- Remember that $0 is special in MIPS and non-writable.
          when 1 to 31 =>
            registers(conv_integer(wa3)) <= wd3;
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

end synth;
