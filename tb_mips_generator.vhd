LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_bit.ALL;


ENTITY tb_mips_generator IS 
  PORT (
    clk      :out   std_logic;
    resetb   :out   std_logic
  );           
END tb_mips_generator;
        
ARCHITECTURE testbench_gen OF tb_mips_generator IS           
            
signal clock:           std_logic:= '0';         --clock signal
signal reset_n:         std_logic:='0';        --reset signal

BEGIN
  clocking: block
  BEGIN
  	clock <= not clock after 5 ns;
  END block;

  Reset: PROCESS
  BEGIN
	  reset_n <= '0';
	  wait for 35 ns;
	  reset_n <= '1';
	  wait until false;
  END Process;

-- output ports driven by signals
   clk <= clock;
   resetb <= reset_n;

END testbench_gen;
