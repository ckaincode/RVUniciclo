library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM_RV_TB is
end RAM_RV_TB;

architecture behavior of RAM_RV_TB is

    component RAM_RV
        port (
            clck      : in std_logic;
            we        : in std_logic;
            byte_en   : in std_logic;
            sgn_en    : in std_logic;
            address   : in std_logic_vector(13 downto 0);
            datain    : in std_logic_vector(31 downto 0);
            dataout   : out std_logic_vector(31 downto 0)
        );
    end component;

    signal clck      : std_logic := '0';
    signal we        : std_logic := '0';
    signal byte_en   : std_logic := '0';
    signal sgn_en    : std_logic := '0';
    signal address   : std_logic_vector(13 downto 0) := (others => '0');
    signal datain    : std_logic_vector(31 downto 0) := (others => '0');
    signal dataout   : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin
    uut: RAM_RV
        port map (
            clck      => clck,
            we        => we,
            byte_en   => byte_en,
            sgn_en    => sgn_en,
            address   => address,
            datain    => datain,
            dataout   => dataout
        );

    clk_process: process
    begin
        clck <= '0';
        wait for clk_period / 2;
        clck <= '1';
        wait for clk_period / 2;
    end process;

    stim_proc: process
    begin
	 
        wait for 100 ns;

        we <= '1';
        byte_en <= '0';
        address <= "00000000000000";
        datain <= x"12345678";
        wait for clk_period;

        we <= '0';
        wait for clk_period;

        address <= "00000000000000";
        wait for clk_period;
        assert dataout = x"12345678"
            report "Erro na leitura da palavra escrita"
            severity error;

        we <= '1';
        byte_en <= '1';
        address <= "00000000000001";
        datain <= x"000000AB";
        wait for clk_period;

        we <= '0';
        wait for clk_period;

        address <= "00000000000001";
        wait for clk_period;
        assert dataout = x"000000AB"
            report "Erro na leitura do byte escrito"
            severity error;

        sgn_en <= '1';
        address <= "00000000000001";
        wait for clk_period;
        assert dataout = x"FFFFFFAB"
            report "Erro na leitura de byte com sinal"
            severity error;
				
        sgn_en <= '0';
        address <= "00000000000001";  
        wait for clk_period;
        assert dataout = x"000000AB"
            report "Erro na leitura de byte sem sinal"
            severity error;
		report "Testes concluidos";
		wait;
    end process;

end behavior;