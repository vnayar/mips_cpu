-------------------------------------------------------------------------------
-- tb_mips.vhd
-- The top-level entity for testing the MIPS CPU.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity tb_mips is
  --port (
  --);
end;

architecture structure of tb_mips is
  signal clk    : std_logic;
  signal resetb : std_logic;

  signal instr : std_logic_vector (31 downto 0);
  signal pc    : std_logic_vector (31 downto 0);

  component ROM is
    generic(N : integer := 32;  -- number of address bits
            M : integer := 32;  -- number of bits in a word (instruction)
            W : integer := 27;  -- number of words (instructions)
            F : string  := "./test_suite.dat");
    port(pc    : in  std_logic_vector (N-1 downto 0);  -- program counter
         instr : out std_logic_vector(M-1 downto 0));  -- instructions
  end component;

  component mips_top
    port (
      resetb : in  std_logic;
      clk    : in  std_logic;
      -- Plug in our ROM chip.
      instr  : in  std_logic_vector (31 downto 0);
      pc     : out std_logic_vector (31 downto 0)
      );
  end component;

  component tb_mips_generator
    port (
      clk    : out std_logic;
      resetb : out std_logic
      );  
  end component;

begin
  ROM1 : ROM
    port map (
      pc    => pc,
      instr => instr
      );

  UUT : mips_top
    port map (
      clk    => clk,
      resetb => resetb,
      instr  => instr,
      pc     => pc
      );

  Gen : tb_mips_generator
    port map (
      clk    => clk,
      resetb => resetb
      );
end;
