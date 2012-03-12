LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Mux2 IS
  GENERIC (
    size : positive
  );
  PORT (
    d0, d1 : in std_logic_vector (size - 1 downto 0);
    s : in std_logic;
    y : out std_logic_vector (size - 1 downto 0)
  );
END Mux2;

ARCHITECTURE synth OF Mux2 IS
BEGIN
  y <= d0 when s = '0' else d1;
END synth;
