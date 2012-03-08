library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity ROM is
   generic( N    : integer := 16; -- number of bits in addressing the program memory
            M    : integer := 32;  -- number of bits in an instruction
            W    : integer := 4); -- number of instructions
   port( pc      : in std_logic_vector (N-1 downto 0);  -- program counter
         resetb  : in std_logic;
         clk     : in std_logic;
         instr   : out std_logic_vector(M-1 downto 0)); -- instructions
end ROM;

architecture behavior of ROM is

  type Vector_array is array (0 to W-1) of std_logic_vector(M-1 downto 0);
  constant Memory : Vector_array := (
    X"8c0a0004", --  lw $10, 0x04($0)
    X"8c0b0008", --  lw $11, 0x08($0)
    X"ac0b0004", -- sw $11, 0x04($0)
    X"ac0a0008"  -- sw $10, 0x08($0)
  );
                                    
begin
  
process (clk)
begin
  if (resetb = '0') then
    instr <= (others => '0');
  elsif rising_edge (clk) then
   instr <= Memory(conv_integer(pc));
  end if;
end process;
 
end behavior;


