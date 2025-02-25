library IEEE;
use IEEE.std_logic_1164.all;

entity mux2x1 is
    port(
        d0,d1 : in std_logic_vector (31 downto 0);
        s: in std_logic;
        outputv : out std_logic_vector (31 downto 0)
    );
end mux2x1;

architecture rtl of mux2x1 is

begin

    outputv <= d0 when (s='0') else d1;

end rtl;