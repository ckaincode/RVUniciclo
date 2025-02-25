library IEEE;
use IEEE.std_logic_1164.all;

entity PC is
    port(
        rst: in std_logic;
        clk : in std_logic;
        next_pc : in std_logic_vector (31 downto 0);
        current : out std_logic_vector (31 downto 0)
    );
end PC;

architecture rtl of PC is

begin

PC_proc: process(clk)

begin
  -- Preocupado com a temporização, testar na integração
    if rising_edge(clk) then
        if rst = '1' then
            current <= x"00000000";
        else
            current <= next_pc;
    end if;
end if;

end process;

end rtl;