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
  COMPONENT ControlUnit IS
    PORT (
      opcode : in std_logic_vector (5 downto 0);
      funct : in std_logic_vector (5 downto 0);
      
      reg_wr_en : out std_logic;
      reg_dst : out std_logic;
      alu_src : out std_logic;

      alu_ctrl : out std_logic_vector (2 downto 0);
      ram_wr_en : out std_logic;
      ram_to_reg : out std_logic;
      branch : out std_logic;
      bzf : out std_logic;
      jump : out std_logic;
      shift_imm : out std_logic
    );
  END COMPONENT;

  COMPONENT PCounter
    PORT (
      clk : in std_logic;
      resetb : in std_logic; 
      pc_in : in std_logic_vector (31 downto 0);
      pc_out : out std_logic_vector (31 downto 0)
    );
  END COMPONENT;
  
  COMPONENT Mux2 
    GENERIC (
      size : positive
    );
    PORT (
      d0, d1 : in std_logic_vector (size - 1 downto 0);
      s : in std_logic;
      y : out std_logic_vector (size - 1 downto 0)
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
      pc : in std_logic_vector (31 downto 0);
      instr : out std_logic_vector (31 downto 0)
    );
  END COMPONENT;

  COMPONENT SignExtend
    PORT (
      instr_imm : in std_logic_vector (15 downto 0);
      sign_imm : out std_logic_vector (31 downto 0)
    );
  END COMPONENT;

  COMPONENT lshift IS
    GENERIC (
      S : positive := 32; -- the size of the value
      SH : positive := 8  -- the amount to left shift by
    );
    PORT (
      sh_in : in std_logic_vector (S - 1 downto 0);
      sh_out : out std_logic_vector (S - 1 downto 0)
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
  

  -- Program Counter related signals
  signal pc : std_logic_vector (31 downto 0);
  signal pc_plus : std_logic_vector (31 downto 0);
  signal pc_inc : std_logic_vector (31 downto 0);
  signal pc_branch_addr : std_logic_vector (31 downto 0);
  signal pc_next : std_logic_vector (31 downto 0);
  signal pc_jump : std_logic_vector (31 downto 0);
  -- ROM Output
  signal instr : std_logic_vector (31 downto 0);
  -- The immediate part of the instruction expanded.
  signal sign_imm : std_logic_vector (31 downto 0);
  signal shift8_imm : std_logic_vector (31 downto 0);
  signal imm : std_logic_vector (31 downto 0);
  signal sign_imm_shift2 : std_logic_vector (31 downto 0);
  -- The read-data from the register-file.
  signal rd1 : std_logic_vector (31 downto 0);
  signal rd2 : std_logic_vector (31 downto 0);
  signal write_reg : std_logic_vector (4 downto 0);
  -- ALU Output
  signal src_b : std_logic_vector (31 downto 0);
  signal alu_result : std_logic_vector (31 downto 0);
  signal zero_flag : std_logic;
  -- RAM
  signal ram_dout : std_logic_vector(31 downto 0);
  signal result : std_logic_vector (31 downto 0);
  -- Control Unit
  signal reg_wr_en : std_logic;
  signal reg_dst : std_logic;
  signal alu_src : std_logic;
  signal alu_ctrl : std_logic_vector (2 downto 0);
  signal ram_wr_en : std_logic;
  signal ram_to_reg : std_logic;
  signal branch : std_logic;
  signal bzf : std_logic;
  signal pc_src : std_logic;
  signal pc_branch_plus : std_logic_vector (31 downto 0);
  signal jump : std_logic;
  signal shift_imm : std_logic;

BEGIN
  -- R-Type Instruction (000000 opcodes):
  --   opcode[6] rs[5] rt[5] rd[5] sa[5] function[6]
  -- I-Type Instruction (all opcodes but 000000, 00001x, 0100xx):
  --   opcode[6] rs[5] rt[5] immediate[16]
  -- J-Type Instruction (00001x opcodes):
  --   opcode[6] target[26]
  -- Coprocessor Instruction (0100xx opcodes):
  --   n/a
  control_unit : ControlUnit
  port map (
    opcode => instr (31 downto 26),
    funct => instr (5 downto 0),
    reg_wr_en => reg_wr_en,
    reg_dst => reg_dst,
    alu_src => alu_src,
    alu_ctrl => alu_ctrl,
    ram_wr_en => ram_wr_en,
    ram_to_reg => ram_to_reg,
    branch => branch,
    bzf => bzf,
    jump => jump,
    shift_imm => shift_imm
  );

  pc_inc <= X"00000004";

  pc_src <= '1' when (branch = '1') and ((zero_flag xor bzf) = '0') else '0';

  pc_branch_plus_mux : Mux2
  generic map (
    size => 32
  )
  port map (
    d0 => pc_plus,
    d1 => pc_branch_addr,
    s => pc_src,
    y => pc_branch_plus
  );

  -- Read the jump immediate from the instruction and pc.
  --   PC = (PC & 0xF0000000) | (jump_imm << 2)
  pc_jump <= pc (31 downto 28) & instr (25 downto 0) & "00";

  pc_jump_mux : Mux2
  generic map (
    size => 32
  )
  port map (
    d0 => pc_branch_plus,
    d1 => pc_jump,
    s => jump,
    y => pc_next
  );

  PCounter1 : PCounter
  port map (
    clk => clk,
    resetb => resetb,
    pc_in => pc_next,
    pc_out => pc
  );

  PCPlus : adder
  generic map (
    S => 32
  )
  port map (
    src_a => pc,
    src_b => pc_inc,
    sum => pc_plus
  );

  ROM1 : ROM
  port map (
    pc => pc,
    instr => instr
  );

  reg1 : registerfile
  port map (
    resetb     => resetb,
    clk        => clk,
    -- The 'rs' part of the instruction
    ra1        => instr (25 downto 21),
    -- The 'rt' part of the instruction
    ra2        => instr (20 downto 16),
    rd1        => rd1,
    rd2        => rd2,
    wa3        => write_reg,
    wd3        => result,
    we3        => reg_wr_en
  );

  signex1 : SignExtend
  port map (
    -- Only the final 16 bits in I-Type instructions are the immediate.
    instr_imm => instr (15 downto 0),
    sign_imm => sign_imm
  );

  -- Shifts the instruction immediate left by 8-bits
  shift8_imm_shifter : lshift
  generic map (
    S => 32,
    SH => 16
  )
  port map (
    sh_in => sign_imm,
    sh_out => shift8_imm
  );

  -- Convert immediate to instruction number by left-shifting by 2.
  sign_imm_shift2 <= sign_imm (29 downto 0) & "00";

  pc_branch_adder : adder
  generic map (
    S => 32
  )
  port map (
    src_a => sign_imm_shift2,
    src_b => pc,
    sum => pc_branch_addr
  );


  -- Controls if 'rt' or 'rd' will be used as the register write address
  reg_dst_mux : Mux2
  generic map (
    size => 5
  )
  port map (
    -- The 'rt' part of the instruction
    d0 => instr (20 downto 16),
    -- The 'rd' part of the instruction
    d1 => instr (15 downto 11),
    s => reg_dst,
    y => write_reg
  );

  -- Controls if the instruction immediate will be shifted up (for lui)
  sign_shift8_imm_mux : Mux2
  generic map (
    size => 32
  )
  port map (
    d0 => sign_imm,
    d1 => shift8_imm,
    s => shift_imm,
    y => imm
  );

  -- Controls if 'rt' or the instruction immediate will go to the ALU
  alu_src_mux : Mux2
  generic map (
    size => 32
  )
  port map (
    d0 => rd2,
    d1 => imm,
    s => alu_src,
    y => src_b
  );

  ALU1 : ALU
  port map (
    resetb => resetb,
    clk => clk,
    src_a => rd1,
    src_b => src_b,
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
    ram_din => rd2,
    ram_dout => ram_dout
  );

  -- Controls whether the ALU or the RAM output will be write a to the register.
  ram_to_reg_mux : Mux2
  generic map (
    size => 32
  )
  port map (
    d0 => alu_result,
    d1 => ram_dout,
    s => ram_to_reg,
    y => result
  );


END pc_test_arch;
