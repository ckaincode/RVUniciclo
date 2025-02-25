library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is
    port(
        arg1,arg2: in std_logic_vector(31 downto 0);
        sout : out std_logic_vector(31 downto 0)
    );
end adder;

architecture rtl of adder is
    begin
        sout <= std_logic_vector(signed(arg1) + signed(arg2));    
end rtl;