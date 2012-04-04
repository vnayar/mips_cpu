-------------------------------------------------------------------------------
-- ROM.vhd
-- ROM that can load contents from a file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- For file I/O
library std;
use std.textio.all;


entity ROM is
  generic(N : integer := 32;  -- number of address bits
          M : integer := 32;  -- number of bits in a word (instruction)
          W : integer := 27;  -- number of words (instructions)
          F : string  := "./test_suite.dat");
  port(pc    : in  std_logic_vector (N-1 downto 0);  -- program counter
       instr : out std_logic_vector(M-1 downto 0));  -- instructions
end ROM;

architecture synth of ROM is
begin
  process is
    -- File reading variables
    file mem_file          : text;
    variable L             : line;
    variable ch            : character;
    variable index, result : integer;
    -- The actual RAM data
    type     Vector_array is array (0 to W-1) of std_logic_vector(M-1 downto 0);
    variable Memory        : Vector_array;

    variable print_line : line;

  begin
    -- initialize memory from file
    for i in 0 to W - 1 loop
      Memory(conv_integer(i)) := conv_std_logic_vector(0, M);
    end loop;

    index := 0;

    FILE_OPEN(mem_file, F, read_mode);
    parse_line : while not endfile(mem_file) loop
      readline(mem_file, L);
      result := 0;
      -- Only look at the first 8 characters per line (32 bits).
      for i in 1 to 8 loop
        read(L, ch);

        -- Treat lines starting with '--' as comments.
        if (i = 1 and ch = '-') then
          next parse_line;
        end if;

        -- Assure we only have valid hex characters.
        if '0' <= ch and ch <= '9' then
          result := result*16 + character'pos(ch) - character'pos('0');
        elsif 'a' <= ch and ch <= 'f' then
          result := result*16 + character'pos(ch) - character'pos('a') + 10;
        else
          report "Format error on line " & integer'image(index) severity error;
        end if;
      end loop;

      write(print_line, string'("Writing line ") & integer'image(index) &
            string'(": ") & integer'image(result));
      writeline(output, print_line);
      Memory(index) := conv_std_logic_vector(result, 32);
      index         := index + 1;

    end loop;

    -- In VHDL, processes are simultaneous, so we must add the normal
    -- logic after the initialization logic in the same process.
    loop
      -- Ignore the 2 least significant bits.
      instr <= Memory(conv_integer(pc (31 downto 2)));
      wait on pc;
    end loop;
  end process;
end architecture;


