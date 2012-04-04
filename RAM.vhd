-------------------------------------------------------------------------------
-- RAM.vhd
-- A 2-port RAM with one combinational read-port and one sequential write-port.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RAM is
  generic (
    N : positive := 8;                  -- number of addrress bits
    W : positive := 32                  -- word size
    );
  port (
    ram_wr_en : in  std_logic;          -- write enable
    clk       : in  std_logic;          -- clock
    ram_addr  : in  std_logic_vector (N - 1 downto 0);
    ram_din   : in  std_logic_vector (W - 1 downto 0);
    ram_dout  : out std_logic_vector (W - 1 downto 0)
    );
end RAM;

architecture behavior of RAM is
  type   vector_array is array (0 to 2**N) of std_logic_vector (W - 1 downto 0);
  -- Initialization values are for testing ONLY.
  signal memory : vector_array;

begin
  -- Read is combinatorial.
  ram_dout <= memory(conv_integer(ram_addr));

  -- Write is sequential.
  process (clk)
  begin
    if (clk'event and clk = '1') then
      if (ram_wr_en = '1') then
        memory(conv_integer(ram_addr)) <= ram_din;
      end if;
    end if;
  end process;
end behavior;
