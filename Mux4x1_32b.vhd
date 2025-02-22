library IEEE;
use IEEE.std_logic_1164.all;

entity mux4x1 is
    port(
        d0,d1,d2,d3 : in std_logic_vector (31 downto 0);
        s: in std_logic_vector(1 downto 0);
        outputv : out std_logic_vector (31 downto 0)
    );
end mux4x1;

architecture rtl of mux4x1 is

begin

    outputv <= d0 when (s="00") else
               d1 when (s="01") else
               d2 when (s="10") else
               d3; 

end rtl;