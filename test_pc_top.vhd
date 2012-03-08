LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all ;

-- Set up the main component to test the Program Counter.
ENTITY test_pc_top IS
  PORT (
    resetb : in std_logic;
    clk : in std_logic
  );
END;

ARCHITECTURE pc_test_arch of test_pc_top IS
  COMPONENT PCounter
    PORT (
      clk : in std_logic;
      resetb : in std_logic; 
      pc_in : in std_logic_vector (15 downto 0);
      pc_out : out std_logic_vector (15 downto 0)
    );
  END COMPONENT;

  COMPONENT adder
    GENERIC (
      S : positive -- the size of the adder
    );
    PORT (
      src_a : in std_logic_vector (S - 1 downto 0);
      src_b : in std_logic_vector (S - 1 downto 0); 
      sum : out std_logic_vector (S - 1 downto 0)
    );
  END COMPONENT;

  COMPONENT ROM
    PORT (
      pc : in std_logic_vector (15 downto 0);
      resetb : in std_logic;
      clk : in std_logic;
      instr : out std_logic_vector (31 downto 0)
    );
  END COMPONENT;

  COMPONENT SignExtend
    PORT (
      instr_imm : in std_logic_vector (15 downto 0);
      sign_imm : out std_logic_vector (31 downto 0)
    );
  END COMPONENT;

  COMPONENT registerfile is
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

  END COMPONENT;

  COMPONENT ALU
    PORT (
      resetb     : in std_logic;
      clk        : in std_logic;
      src_a      : in std_logic_vector (31 downto 0);
      src_b      : in std_logic_vector (31 downto 0);      
      alu_ctrl   : in std_logic_vector (2 downto 0);
      alu_result : out std_logic_vector (31 downto 0);
      zero_flag  : out std_logic
    );
  END COMPONENT;

  COMPONENT RAM
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
  END COMPONENT;



  signal pc : std_logic_vector (15 downto 0);
  signal pc_next : std_logic_vector (15 downto 0);
  signal pc_inc : std_logic_vector (15 downto 0);
  signal instr : std_logic_vector (31 downto 0);
  -- The immediate part of the instruction expanded.
  signal sign_imm : std_logic_vector (31 downto 0);
  -- The read-data from the register-file.
  signal rd1 : std_logic_vector (31 downto 0);
  signal rd2 : std_logic_vector (31 downto 0);
  -- ALU Output
  signal alu_result : std_logic_vector (31 downto 0);
  signal zero_flag : std_logic;
  -- RAM
  signal ram_wr_en : std_logic;
  signal ram_din : std_logic_vector(31 downto 0);
  signal ram_dout : std_logic_vector(31 downto 0);

  -- FIXME: Temporary signals.
  signal alu_ctrl : std_logic_vector (2 downto 0);
  signal ra2 : std_logic_vector (4 downto 0);
  signal wa3 : std_logic_vector (4 downto 0);
  signal we3 : std_logic;


BEGIN
  -- R-Type Instruction (000000 opcodes):
  --   opcode[6] rs[5] rt[5] rd[5] sa[5] function[6]
  -- I-Type Instruction (all opcodes but 000000, 00001x, 0100xx):
  --   opcode[6] rs[5] rt[5] immediate[16]
  -- J-Type Instruction (00001x opcodes):
  --   opcode[6] target[26]
  -- Coprocessor Instruction (0100xx opcodes):
  --   n/a

  pc_inc <= X"0001";
  -- FIXME:  Temporary signals.
  alu_ctrl <= "010"; -- Lock ALU to 'add' for LW test.
  ra2 <= "00000"; -- We aren't using read 2 yet.
  we3 <= '1'; -- Always write for LW.
  ram_wr_en <= '0';
  ram_din <= (others => '0');

  PCounter1 : PCounter
  port map (
    clk => clk,
    resetb => resetb,
    pc_in => pc_next,
    pc_out => pc
  );

  PCPlus : adder
  generic map (
    S => 16
  )
  port map (
    src_a => pc,
    src_b => pc_inc,
    sum => pc_next
  );

  ROM1 : ROM
  port map (
    pc => pc,
    resetb => resetb,
    clk => clk,
    instr => instr
  );

  reg1 : registerfile
  port map (
    resetb     => resetb,
    clk        => clk,
    -- The 'rs' part of the instruction
    ra1        => instr (25 downto 21),
    ra2        => ra2,
    rd1        => rd1,
    rd2        => rd2,
    -- The 'rt' part of the instruction is the dest for LW.
    wa3        => instr (20 downto 16),
    wd3        => ram_dout, -- Our data comes from the RAM.
    we3        => we3
  );

  signex1 : SignExtend
  port map (
    -- Only the final 16 bits in I-Type instructions are the immediate.
    instr_imm => instr (15 downto 0),
    sign_imm => sign_imm
  );

  ALU1 : ALU
  port map (
    resetb => resetb,
    clk => clk,
    src_a => rd1,
    src_b => sign_imm,
    alu_ctrl => alu_ctrl,
    alu_result => alu_result,
    zero_flag => zero_flag
  );

  RAM1 : RAM
  port map (
    ram_wr_en => ram_wr_en,
    clk => clk,
    -- The ALU computes the address, data is read word (4 bytes) at a time.
    ram_addr => alu_result (31 downto 2),
    ram_din => ram_din,
    ram_dout => ram_dout
  );

END pc_test_arch;
