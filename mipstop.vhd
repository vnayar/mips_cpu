LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all ;

ENTITY mipstop IS
port ( resetb : in std_logic;
       clk    : in std_logic
);
END;

ARCHITECTURE structure of mipstop IS

constant RAM_ADDR_BITS : positive := 16;
constant RAM_DATA_BITS : positive := 8;
constant RAM_DATA_LEN  : positive := 8;

signal pc         : std_logic_vector (15 downto 0);
signal instr      : std_logic_vector (31 downto 0);
-- Control of ALU.
signal alu_instr  : std_logic_vector (5 downto 0);
signal a_dout     : std_logic_vector (31 downto 0);
signal b_dout     : std_logic_vector (31 downto 0);
signal opcode_alu : std_logic_vector (5 downto 0);
signal addr_imm   : std_logic_vector (31 downto 0);
signal rd         : std_logic_vector (4 downto 0);
-- Register writing signals.
signal wr_en      : std_logic;
signal wr_addr    : std_logic_vector (4 downto 0);
signal wr_dbus    : std_logic_vector (31 downto 0);
-- Ram writing signals.
signal ram_wr_en : std_logic;
signal ram_addr  : std_logic_vector (15 downto 0);
signal ram_din   : std_logic_vector (7 downto 0);
signal ram_dout  : std_logic_vector (7 downto 0);

COMPONENT PCounter 
  PORT (
         clk    :in  std_logic;
         resetb :in  std_logic;
         pc     :out std_logic_vector(15 downto 0)
       );
END COMPONENT;

COMPONENT Rom
  PORT (
         pc     : in  std_logic_vector (15 downto 0);
         resetb : in std_logic;
         clk    : in  std_logic;
         instr  : out std_logic_vector (31 downto 0)
       );
END COMPONENT;
      
COMPONENT registerfile
  PORT ( resetb     : in  std_logic;
         clk         : in  std_logic; -- clock
         instr      : in  std_logic_vector (31 downto 0);
         opcode_alu : out std_logic_vector (5 downto 0 );
         addr_imm   : out std_logic_vector (31 downto 0);
         rd         : out std_logic_vector (4 downto 0);
         wr_en      : in  std_logic; -- write enable for Reg File
         wr_dbus    : in  std_logic_vector (31 downto 0);
         wr_addr    : in  std_logic_vector (4 downto 0);
         a_dout     : out std_logic_vector (31 downto 0);
         b_dout     : out std_logic_vector (31 downto 0)
       );
END COMPONENT;

COMPONENT ALU
  PORT (
         resetb     : in  std_logic;
         clk        : in  std_logic;
         a_dout     : in  std_logic_vector (31 downto 0);
         b_dout     : in  std_logic_vector (31 downto 0);      
         opcode_alu : in  std_logic_vector (5 downto 0 );
         addr_imm   : in  std_logic_vector (31 downto 0);
         rd         : in  std_logic_vector (4 downto 0); -- destination register address
         wr_en      : out std_logic; -- write enable for Reg File
         wr_dbus    : out std_logic_vector (31 downto 0);
         wr_addr    : out std_logic_vector (4 downto 0)
       );    
END COMPONENT;

COMPONENT RAM
  GENERIC (
         N          : positive,
         M          : positive,
         W          : positive);
  PORT (
         ram_wr_en      : in  std_logic;
         clk        : in  std_logic;
         ram_addr   : in  std_logic_vector (N - 1 downto 0);
         ram_din    : in  std_logic_vector (M - 1 downto 0);
         ram_dout   : out std_logic_vector (M - 1 downto 0);
       );
END COMPONENT;


BEGIN

U1: PCounter
port map (
           clk    => clk,
           resetb => resetb,
           pc     => pc
         );
         
U2: Rom
port map (
           pc     => pc,
           resetb => resetb,
           clk    => clk,
           instr  => instr
         );
         
U3: registerfile
port map ( resetb     => resetb,
           clk         => clk,
           instr      => instr,
           opcode_alu => opcode_alu,
           addr_imm   => addr_imm,
           rd         => rd,
           wr_en      => wr_en, -- write enable for Reg File
           wr_dbus    => wr_dbus,
           wr_addr    => wr_addr,
           a_dout     => a_dout,
           b_dout      => b_dout
           );

U4: ALU
port map (
           resetb     => resetb,
           clk        => clk,
           a_dout     => a_dout,
           b_dout      => b_dout,     
           opcode_alu => opcode_alu,
           addr_imm   => addr_imm,
           rd         => rd,          -- destination register address
           wr_en      => wr_en,       -- write enable for Reg File
           wr_dbus    => wr_dbus,
           wr_addr    => wr_addr
         );

U5: Ram
generic map (
              RAM_ADDR_BITS,
              RAM_DATA_BITS,
              RAM_DATA_LEN
            )
port map (
           ram_wr_en     => ram_wr_en,
           clk        => clk,
           ram_addr   => ram_addr,
           ram_din    => ram_din,
           ram_dout   => ram_dout
         );

END structure;
