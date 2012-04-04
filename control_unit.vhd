-------------------------------------------------------------------------------
-- control_unit.vhd
-- Decodes instructions into control signals for multiplexers and the ALU.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity ControlUnit is
  port (
    opcode : in std_logic_vector (5 downto 0);
    funct  : in std_logic_vector (5 downto 0);

    reg_wr_en : out std_logic;
    reg_dst   : out std_logic;
    alu_src   : out std_logic;

    alu_ctrl   : out std_logic_vector (2 downto 0);
    ram_wr_en  : out std_logic;
    ram_to_reg : out std_logic;
    branch     : out std_logic;
    bzf        : out std_logic;
    jump       : out std_logic;
    shift_imm  : out std_logic
    );
end ControlUnit;

architecture struct of ControlUnit is
  component MainDecoder
    port (
      -- The leading opcode bits of the instruction.
      opcode     : in  std_logic_vector (5 downto 0);
      ram_to_reg : out std_logic;
      ram_wr_en  : out std_logic;
      branch     : out std_logic;
      bzf        : out std_logic;
      alu_src    : out std_logic;
      reg_dst    : out std_logic;
      reg_wr_en  : out std_logic;
      -- Provide high level controls to ALU Decoder.
      alu_op     : out std_logic_vector (2 downto 0);
      jump       : out std_logic;
      shift_imm  : out std_logic
      );
  end component;

  component ALUDecoder
    port (
      -- The leading opcode bits of the instruction.
      funct    : in  std_logic_vector (5 downto 0);
      -- The general type of operation from the MainDecoder.
      alu_op   : in  std_logic_vector (2 downto 0);
      -- Specify the arithmetic operator for the ALU.
      alu_ctrl : out std_logic_vector (2 downto 0)
      );
  end component;

  signal alu_op : std_logic_vector (2 downto 0);

begin

  main_decoder : MainDecoder
    port map (
      opcode     => opcode,
      ram_to_reg => ram_to_reg,
      ram_wr_en  => ram_wr_en,
      branch     => branch,
      bzf        => bzf,
      alu_src    => alu_src,
      reg_dst    => reg_dst,
      reg_wr_en  => reg_wr_en,
      alu_op     => alu_op,
      jump       => jump,
      shift_imm  => shift_imm
      );

  alu_decoder : ALUDecoder
    port map (
      funct    => funct,
      alu_op   => alu_op,
      alu_ctrl => alu_ctrl
      );

end;
