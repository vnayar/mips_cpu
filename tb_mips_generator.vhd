library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_bit.ALL;
entity tb_mips_generator is 
 port (
       clk      :out   std_logic;
       resetb   :out   std_logic;
       -- FIXME: Remove when Control Unit is done.
       reg_wr_en : out std_logic;
       ram_wr_en : out std_logic;
       alu_ctrl : out std_logic_vector
       );           
end tb_mips_generator;
        
architecture testbench_gen of tb_mips_generator is           
            
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

-- FIXME: Remove when Control Unit is implemented.
Control : PROCESS
BEGIN
   -- Tests for LW instruction.
   reg_wr_en <= '1'; -- Always write for LW.
   alu_ctrl <= "010"; -- Lock ALU to 'add' for LW test.
   ram_wr_en <= '0';
     wait for 66 ns;
   -- Tests for SW instruction.
   reg_wr_en <= '0'; -- Always write for LW.
   alu_ctrl <= "010"; -- Lock ALU to 'add' for LW test.
   ram_wr_en <= '1';
     wait until false;
END Process;

end testbench_gen;
