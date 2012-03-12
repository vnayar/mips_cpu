library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity ROM is
   generic( N    : integer := 32;  -- number of address bits
            M    : integer := 32;  -- number of bits in an instruction
            W    : integer := 12); -- number of instructions
   port( pc      : in std_logic_vector (N-1 downto 0);  -- program counter
         resetb  : in std_logic;
         clk     : in std_logic;
         instr   : out std_logic_vector(M-1 downto 0)); -- instructions
end ROM;

architecture behavior of ROM is

  type Vector_array is array (0 to W-1) of std_logic_vector(M-1 downto 0);
  constant Memory : Vector_array := (
    -- LW Test
    X"8c0a0004", --  lw $10, 0x04($0)
    X"8c0b0008", --  lw $11, 0x08($0)
    -- SW Test
    X"ac0b0004", -- sw $11, 0x04($0)
    X"ac0a0008", -- sw $10, 0x08($0)
    -- Addition Test
    X"20080003", -- addi $8, $0, 3           ; 3: addi $t0, $0, 3 
    X"20090005", -- addi $9, $0, 5           ; 4: addi $t1, $0, 5 
    X"01095020", -- add $10, $8, $9          ; 5: add $t2, $t0, $t1 
    -- Branch Test
    X"20080004", -- addi $8, $0, 4           ; 3: addi $t0, $0, 4 
    X"20090005", -- addi $9, $0, 5           ; 4: addi $t1, $0, 5 
    X"21080001", -- addi $8, $8, 1           ; 7: add $t0, $t0, 1 
    X"1109ffff", -- beq $8, $9, -4 [inc-0x00400030]; 8: beq $t0, $t1, inc 
    X"20080004"  -- addi $8, $0, 4           ; 3: addi $t0, $0, 4 
  );
                                    
begin
  
process (clk)
begin
  if (resetb = '0') then
    instr <= (others => '0');
  elsif rising_edge (clk) then
   -- Ignore the 2 least significant bits.
   instr <= Memory(conv_integer(pc (31 downto 2)));
  end if;
end process;
 
end behavior;


