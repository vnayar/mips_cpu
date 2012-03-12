LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ControlUnit IS
  PORT (
    opcode : in std_logic_vector (5 downto 0);
    funct : in std_logic_vector (5 downto 0);
    
    reg_wr_en : out std_logic;
    reg_dst : out std_logic;
    alu_src : out std_logic;

    alu_ctrl : out std_logic_vector (2 downto 0);
    ram_wr_en : out std_logic;
    ram_to_reg : out std_logic;
    branch : out std_logic
  );
END ControlUnit;

ARCHITECTURE struct of ControlUnit IS
  COMPONENT MainDecoder
    PORT (
      -- The leading opcode bits of the instruction.
      opcode : in std_logic_vector (5 downto 0);
      ram_to_reg : out std_logic;
      ram_wr_en : out std_logic;
      branch : out std_logic;
      alu_src : out std_logic;
      reg_dst : out std_logic;
      reg_wr_en : out std_logic;
      -- Provide high level controls to ALU Decoder.
      alu_op : out std_logic_vector (1 downto 0)
    );
  END COMPONENT;
  
  COMPONENT ALUDecoder 
    PORT (
      -- The leading opcode bits of the instruction.
      funct : in std_logic_vector (5 downto 0);
      -- The general type of operation from the MainDecoder.
      alu_op : in std_logic_vector (1 downto 0);
      -- Specify the arithmetic operator for the ALU.
      alu_ctrl : out std_logic_vector (2 downto 0)
    );
  END COMPONENT;

  signal alu_op : std_logic_vector (1 downto 0);

BEGIN

  main_decoder : MainDecoder
  port map (
    opcode => opcode,
    ram_to_reg => ram_to_reg,
    ram_wr_en => ram_wr_en,
    branch => branch,
    alu_src => alu_src,
    reg_dst => reg_dst,
    reg_wr_en => reg_wr_en,
    alu_op => alu_op
  );

  alu_decoder : ALUDecoder
  port map (
    funct => funct,
    alu_op => alu_op,
    alu_ctrl => alu_ctrl
  );

END;
