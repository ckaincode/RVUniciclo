library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;

entity tb_main is end;

architecture tbmain of tb_main is

    component main is
        port(
            rst: in std_logic;
            clock: in std_logic
        );
    end component;

    signal clk : std_logic := '0';
    signal rst: std_logic := '1';

    begin

        uut: main port map(rst,clk);
        jaj: process
            begin
                wait for 6 ns;
                rst <= '0';
                wait;
            end process jaj;
        clk <= not clk after 5 ns;
end tbmain;
    