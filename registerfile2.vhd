-- There are two read data buses, a_dout and b_dout, two read address buses, 
-- a_addr and b_addr. one write data bus, wr_dbus and one write address bus, 
-- wr_addr. Each of these address buses is used to specify one of the 32 registers
-- for either reading or writing. 
-- The write operation takes place on the rising edge of the clk signal
-- when the wr_en signal is logic 1. The read operation, however, 
-- is not clocked - it is combinational. Thus, the value on the a_dout should 
-- always be the contents of the register specified by the a_addr bus. 
-- Similarly, the value on the b_dout should always be the contents of 
-- the register specified by the b_addr bus. So, with this register file, 
-- you can write to a register and read two registers simultaneously. 
-- It is also possible to read a single register on both of the read buses simultaneously. 
-- It essence it is a 3-port memory element that allows two reads and one write simultaneously.


LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY registerfile is
  GENERIC (M      : integer := 32);  -- number of data bits 

  PORT ( resetb     : in std_logic;
         clk        : in  std_logic; -- clock
         instr      : in  std_logic_vector (M - 1 downto 0);
         opcode_alu : out std_logic_vector (5 downto 0 );
         addr_imm   : out std_logic_vector (31 downto 0);
         rd         : out std_logic_vector (4 downto 0); -- destination register address
         wr_en      : in  std_logic; -- write enable for Reg File
         wr_dbus    : in  std_logic_vector (31 downto 0);
         wr_addr    : in  std_logic_vector (4 downto 0);
         a_dout     : out std_logic_vector (31 downto 0);
         b_dout     : out std_logic_vector (31 downto 0));

END registerfile;

ARCHITECTURE behavior of registerfile IS

  TYPE vector_array is ARRAY (0 to 31) of STD_LOGIC_VECTOR (M-1 DOWNTO 0);
   signal registers: vector_array;

--signal at, v0,  v1, a0, a1, a2, a3    : std_logic_vector (M-1 downto 0);
--signal t0, t1, t2, t3, t4, t5, t6, t7 : std_logic_vector (M-1 downto 0);
--signal s0, s1, s2, s3, s4, s5, s6, s7 : std_logic_vector (M-1 downto 0);
--signal t8, t9                         : std_logic_vector (M-1 downto 0);
--signal k0, k1                         : std_logic_vector (M-1 downto 0);
--signal gp, sp, fp, ra                 : std_logic_vector (M-1 downto 0);

signal a_addr_decode                  : integer;
signal b_addr_decode                  : integer;
signal wr_addr_decode                 : integer;

signal opcode : integer;
signal rs : std_logic_vector (4 downto 0);
signal rt : std_logic_vector (4 downto 0);
signal funct : std_logic_vector (5 downto 0);
signal shamt : std_logic_vector (4 downto 0);

begin

  -- R-Type Instruction (000000 opcodes):
  --   opcode[6] rs[5] rt[5] rd[5] sa[5] function[6]
  -- I-Type Instruction (all opcodes but 000000, 00001x, 0100xx):
  --   opcode[6] rs[5] rt[5] immediate[16]
  -- J-Type Instruction (00001x opcodes):
  --   opcode[6] target[26]
  -- Coprocessor Instruction (0100xx opcodes):
  --   n/a

  opcode <= conv_integer (instr (31 downto 26));
  rs <= instr (25 downto 21);
  rt <= instr (20 downto 16);
  shamt <= instr (10 downto 6);
  funct <= instr (5 downto 0);
  wr_addr_decode <= conv_integer (wr_addr);
  
ALUinstrPass: Process (resetb, clk)
begin
    if (resetb = '0') then
      opcode_alu <= (others => '0');
    elsif (clk'EVENT AND clk = '1') then
      case opcode is
        when 0 => -- R-type instructions
          opcode_alu <= instr (5 downto 0);
        when 1|4 to 16|32|33|35|36|37|40|43|41|49|56 => -- I-type instructions
          opcode_alu <= instr (31 downto 26);
          addr_imm <= X"0000" & instr (15 downto 0);
        when 2 to 3 => -- J-type instructions
          addr_imm <= "000000" & instr (25 downto 0);
        when others =>
          null;
      end case;
    end if;
end process;  

InstrDecode : process (opcode, instr, rs, rt)
begin
  case opcode is
    when 0 => -- R - type instructions
      a_addr_decode <= conv_integer(rs);
      b_addr_decode <= conv_integer (rt);
      rd <= instr (15 downto 11);
    when 1 to 16|32|33|35|36|37|40|43|41|49|56 => -- I - type instructions
      a_addr_decode <= conv_integer(rs);
      b_addr_decode <= conv_integer (rt);
      rd <= instr (20 downto 16); --In the I-type instruction RT is the destination reg.
    when others =>
      null;
    end case;
end process;

write_regs: PROCESS (clk)
begin
    if resetb = '0' then
         registers <= (others => (others => '0'));
    elsif (clk'EVENT AND clk = '1') then
      if (wr_en = '1') then
       case wr_addr_decode is
         when 1 to 31 => 
           registers(wr_addr_decode) <= wr_bus;
         when others => 
           null;
         end case;
       END IF;
  END IF;
END PROCESS;
  
read_regs: PROCESS (a_addr_decode, b_addr_decode)
     BEGIN
       case a_addr_decode is
         when 0 to 31 =>
           a_dout <= registers(a_addr_decode);
         when others =>
           null;
       end case; 

       case b_addr_decode is
         when 0 to 31 => 
           b_dout <= registers(b_addr_decode);
         when others =>
           null;
       end case; 
END PROCESS;

END behavior;
