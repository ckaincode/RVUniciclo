library IEEE;
use IEEE.std_logic_1164.all;


entity tb_PC is end;

architecture tbPC of tb_PC is

    component PC is
        port(
            clk : in std_logic;
            next_pc : in std_logic_vector(31 downto 0);
            current : out std_logic_vector(31 downto 0)
        );
    end component;

    signal clki : std_logic := '0';
    signal nexti : std_logic_vector(31 downto 0);

begin

    uut: PC port map (clki,nexti,current => open);

    clki <= not clki after 5 ns;

    stim: process
    begin
        nexti <= x"00000000";
        wait for 5 ns;
        nexti <= x"00000004";
        wait for 5 ns;
        nexti <= x"00000008";
        wait for 5 ns;
        nexti <= x"00000001";
        wait for 5 ns;
    end process stim;

end tbPC;
