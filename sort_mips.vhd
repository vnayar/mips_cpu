----
-- Sort MIPS
-- The top-level entity for a sorting with a MIPS CPU.
----

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all ;

ENTITY sort_mips IS
  --port (
  --);
END;

ARCHITECTURE structure of sort_mips IS
signal  clk    : STD_LOGIC;
signal  resetb  : STD_LOGIC;

signal instr : std_logic_vector (31 downto 0);
signal pc : std_logic_vector (31 downto 0);

COMPONENT ROM is
   generic( N    : integer := 32;  -- number of address bits
            M    : integer := 32;  -- number of bits in a word (instruction)
            W    : integer := 27;  -- number of words (instructions)
            F    : string := "./test_suite.dat");
   port( pc      : in std_logic_vector (N-1 downto 0);  -- program counter
         instr   : out std_logic_vector(M-1 downto 0)); -- instructions
END COMPONENT;

COMPONENT mips_top
  PORT (
    resetb: in STD_LOGIC;
    clk: in STD_LOGIC;
    -- Plug in our ROM chip.
    instr : in std_logic_vector (31 downto 0);
    pc : out std_logic_vector (31 downto 0)
  );
END COMPONENT;

COMPONENT tb_mips_generator
  PORT (
    clk      :out   std_logic;
    resetb   :out   std_logic
  );  
END COMPONENT;

BEGIN
  ROM1: ROM
  GENERIC MAP (N => 32, M => 32, W => 66, F => "./sort.dat")
  PORT MAP (
    pc => pc,
    instr => instr
  );

  UUT: mips_top
  PORT Map (
    clk     => clk,
    resetb  => resetb,
    instr => instr,
    pc => pc
  );
  
  Gen: tb_mips_generator
  PORT Map (
    clk    => clk,
    resetb  => resetb
  );
END ;
