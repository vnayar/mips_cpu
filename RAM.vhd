LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY RAM is
  GENERIC (
    N      : positive := 30; -- number of addrress bits
    M      : positive := 32;  -- number of data bits
    W      : positive := 3   -- # of words in the memory
  );
  PORT (
    ram_wr_en    : in  std_logic; -- write enable
    clk          : in  std_logic; -- clock
    ram_addr     : in  std_logic_vector (N - 1 downto 0);
    ram_din      : in  std_logic_vector (M - 1 downto 0);
    ram_dout     : out std_logic_vector (M - 1 downto 0)
  );
END RAM;

ARCHITECTURE behavior of RAM IS
  TYPE vector_array is ARRAY (0 to W - 1) of STD_LOGIC_VECTOR (M - 1 DOWNTO 0);
  -- Initialization values are for testing ONLY.
  signal memory: vector_array := (
    X"00000001",
    X"00000002",
    X"00000003"
  );

BEGIN
  -- Read is combinatorial.
  ram_dout <= memory(conv_integer(ram_addr)) when (conv_integer(ram_addr) < M) else
    X"00000000";

  -- Write is sequential.
  PROCESS (clk)
     BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         IF (ram_wr_en = '1') THEN
           memory(conv_integer(ram_addr)) <= ram_din;
         END IF;
    END IF;
  END PROCESS;
END behavior;
