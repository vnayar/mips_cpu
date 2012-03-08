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

--COMPONENT mipstop
COMPONENT test_pc_top
  PORT (
    resetb: in STD_LOGIC;
    clk: in STD_LOGIC
  );
END COMPONENT;

COMPONENT tb_mips_generator
  PORT (
    clk      :out   std_logic;
    resetb   :out   std_logic 
  );  
END COMPONENT;

BEGIN
  --UUT: mipstop
  UUT: test_pc_top
  PORT Map (
    clk     => clk,
    resetb  => resetb
  );
  
  Gen: tb_mips_generator
  PORT Map (
    clk    => clk,
    resetb  => resetb
  );
END ;
