LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all ;

ENTITY tb_mips IS
  --port (
  --);
END;

ARCHITECTURE structure of tb_mips IS
signal  clk    : STD_LOGIC;
Signal  resetb  : STD_LOGIC;
-- FIXME: Test signals until Control Unit is implemented.
signal reg_wr_en : std_logic;
signal ram_wr_en : std_logic;
signal alu_ctrl : std_logic_vector (2 downto 0);

--COMPONENT mipstop
COMPONENT test_pc_top
  PORT (
    resetb: in STD_LOGIC;
    clk: in STD_LOGIC;
    -- FIXME: Test ports until Control Unit is implemented.
    reg_wr_en : in std_logic;
    ram_wr_en : in std_logic;
    alu_ctrl : in std_logic_vector (2 downto 0)
  );
END COMPONENT;

COMPONENT tb_mips_generator
  PORT (
    clk      :out   std_logic;
    resetb   :out   std_logic;
    -- FIXME: Remove when Control Unit is done.
    reg_wr_en : out std_logic;
    ram_wr_en : out std_logic;
    alu_ctrl : out std_logic_vector
  );  
END COMPONENT;

BEGIN
  --UUT: mipstop
  UUT: test_pc_top
  PORT Map (
    clk     => clk,
    resetb  => resetb,
    -- FIXME: Remove when Control Unit is implemented.
    reg_wr_en => reg_wr_en,
    ram_wr_en => ram_wr_en,
    alu_ctrl => alu_ctrl
  );
  
  Gen: tb_mips_generator
  PORT Map (
    clk    => clk,
    resetb  => resetb,
    -- FIXME Remove when Control Unit is implemented.
    reg_wr_en => reg_wr_en,
    ram_wr_en => ram_wr_en,
    alu_ctrl => alu_ctrl
  );
END ;
