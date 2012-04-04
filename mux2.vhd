-------------------------------------------------------------------------------
-- mux2.vhd
-- Two-port multiplexer with fixed-size inputs.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Mux2 is
  generic (
    size : positive
    );
  port (
    d0, d1 : in  std_logic_vector (size - 1 downto 0);
    s      : in  std_logic;
    y      : out std_logic_vector (size - 1 downto 0)
    );
end Mux2;

architecture synth of Mux2 is
begin
  y <= d0 when s = '0' else d1;
end synth;
