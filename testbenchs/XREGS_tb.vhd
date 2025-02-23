library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity XREGS_TB is
end XREGS_TB;

architecture Behavioral of XREGS_TB is

    component XREGS
        generic (WSIZE : natural := 32);
        port (
            clk, wren : in std_logic;
            rs1, rs2, rd : in std_logic_vector(4 downto 0);
            data : in std_logic_vector(WSIZE-1 downto 0);
            ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
        );
    end component;

    signal clk   : std_logic := '0';
    signal wren  : std_logic := '0';
    signal rs1   : std_logic_vector(4 downto 0) := (others => '0');
    signal rs2   : std_logic_vector(4 downto 0) := (others => '0');
    signal rd    : std_logic_vector(4 downto 0) := (others => '0');
    signal data  : std_logic_vector(31 downto 0) := (others => '0');
    signal ro1   : std_logic_vector(31 downto 0);
    signal ro2   : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: XREGS
        generic map (WSIZE => 32)
        port map (
            clk  => clk,
            wren => wren,
            rs1  => rs1,
            rs2  => rs2,
            rd   => rd,
            data => data,
            ro1  => ro1,
            ro2  => ro2
        );


		  clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;


    stim_proc: process
    begin

	 wait for 100 ns;


	 for i in 1 to 31 loop
            wren <= '1'; 
            rd   <= std_logic_vector(to_unsigned(i, 5));
            data <= std_logic_vector(to_unsigned(i, 32));
            wait for clk_period;
        end loop;

        -- Desativa escrita
        wren <= '0';
        wait for clk_period;

        for i in 1 to 31 loop
            rs1 <= std_logic_vector(to_unsigned(i, 5));  -- Seleciona o registrador i para leitura
            wait for clk_period;
            assert ro1 = std_logic_vector(to_unsigned(i, 32))
                report "Erro na leitura do registrador " & integer'image(i)
                severity error;
        end loop;

        rs1 <= "00000";
        wait for clk_period;
        assert ro1 = x"00000000"
            report "Erro: O registrador zero não é zero"
            severity error;

        report "Testes Concluidos";
        wait;
    end process;

end Behavioral;