-- There are two read data buses, a_dout and b_dout, two read address buses, 
-- a_addr and b_addr. one write data bus, wr_dbus and one write address bus, 
-- wr_addr. Each of these address buses is used to specify one of the 32 registers
-- for either reading or writing. 
-- The write operation takes place on the rising edge of the clk signal
-- when the wr_en signal is logic 1. The read operation, however, 
-- is not clocked - it is combinational. Thus, the value on the a_dout should 
-- always be the contents of the register specified by the a_addr bus. 
-- Similarly, the value on the b_dout should always be the contents of 
-- the register specified by the b_addr bus. So, with this register file, 
-- you can write to a register and read two registers simultaneously. 
-- It is also possible to read a single register on both of the read buses simultaneously. 
-- It essence it is a 3-port memory element that allows two reads and one write simultaneously.


LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY registerfile is
  PORT (
    resetb : in std_logic;
    clk : in  std_logic; -- clock
    ra1 : in std_logic_vector (4 downto 0); -- read-address 1
    ra2 : in std_logic_vector (4 downto 0); -- read-address 2
    rd1 : out std_logic_vector (31 downto 0); -- read-data 1
    rd2 : out std_logic_vector (31 downto 0); -- read-data 2
    wa3 : in std_logic_vector (4 downto 0); -- write-address for register file
    wd3 : in std_logic_vector (31 downto 0); -- write-data for register file
    we3 : in std_logic -- write-enable for register file
  );

END registerfile;

ARCHITECTURE behavior of registerfile IS

  TYPE vector_array is ARRAY (0 to 31) of STD_LOGIC_VECTOR (31 DOWNTO 0);
  signal registers: vector_array;

BEGIN
  
  -- Data is read combinatorially (independent of clock).
  rd1 <= registers(conv_integer(ra1));
  rd2 <= registers(conv_integer(ra2));

  -- Data is written sequentially with the clock.
  write_regs: PROCESS (clk)
  BEGIN
    -- Reset always blanks the registers.
    IF resetb = '0' THEN
      registers <= (others => (others => '0'));
    ELSIF rising_edge(clk) then
      -- Only write on a clock-edge if write-enable is on.
      IF (we3 = '1') THEN
        CASE conv_integer(wa3) IS
          -- Remember that $0 is special in MIPS and non-writable.
          WHEN 1 to 31 => 
            registers(conv_integer(wa3)) <= wd3;
          WHEN others => 
            null;
        END CASE;
      END IF;
    END IF;
  END PROCESS;

END behavior;
