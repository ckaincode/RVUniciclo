library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ulaRV_TB is
end ulaRV_TB;

architecture Behavioral of ulaRV_TB is

    component ulaRV
        port (
            opcode : in std_logic_vector(3 downto 0);
            A, B   : in std_logic_vector(31 downto 0);
            Z      : out std_logic_vector(31 downto 0);
            cond   : out std_logic
        );
    end component;

    signal opcode : std_logic_vector(3 downto 0) := (others => '0');
    signal A      : std_logic_vector(31 downto 0) := (others => '0');
    signal B      : std_logic_vector(31 downto 0) := (others => '0');
    signal Z      : std_logic_vector(31 downto 0);
    signal cond   : std_logic;

    constant clk_period : time := 10 ns;

begin
    uut: ulaRV
        port map (
            opcode => opcode,
            A      => A,
            B      => B,
            Z      => Z,
            cond   => cond
        );

    stim_proc: process
    begin

	 opcode <= "0000";  -- ADD
        A      <= x"00000005"; 
        B      <= x"00000003";
        wait for clk_period;
        assert Z = x"00000008" and cond = '0'
            report "Erro na operação ADD"
            severity error;

        opcode <= "0001";  -- SUB
        A      <= x"00000005";
        B      <= x"00000003";
        wait for clk_period;
        assert Z = x"00000002" and cond = '0'
            report "Erro na operação SUB"
            severity error;

        opcode <= "0010";  -- AND
        A      <= x"0000000F"; 
        B      <= x"0000000A";
        wait for clk_period;
        assert Z = x"0000000A" and cond = '0'
            report "Erro na operação AND"
            severity error;

        opcode <= "0011";  -- OR
        A      <= x"0000000F";
        B      <= x"0000000A";
        wait for clk_period;
        assert Z = x"0000000F" and cond = '0'
            report "Erro na operação OR"
            severity error;

        opcode <= "0100";  -- XOR
        A      <= x"0000000F";
        B      <= x"0000000A";
        wait for clk_period;
        assert Z = x"00000005" and cond = '0'
            report "Erro na operação XOR"
            severity error;

        opcode <= "0101";  -- SLL
        A      <= x"0000000F";
        B      <= x"00000002";
        wait for clk_period;
        assert Z = x"0000003C" and cond = '0'
            report "Erro na operação SLL"
            severity error;

        opcode <= "0110";  -- SRL
        A      <= x"0000000F";
        B      <= x"00000002";
        wait for clk_period;
        assert Z = x"00000003" and cond = '0'
            report "Erro na operação SRL"
            severity error;

        opcode <= "0111";  -- SRA
        A      <= x"F000000F";
        B      <= x"00000004"; 
        wait for clk_period;
        assert Z = x"FF000000" and cond = '0'
            report "Erro na operação SRA"
            severity error;

        opcode <= "1000";  -- SLT
        A      <= x"00000005";
        B      <= x"0000000A";
        wait for clk_period;
        assert Z = x"00000001" and cond = '1'
            report "Erro na operação SLT"
            severity error;

        opcode <= "1001";  -- SLTU
        A      <= x"00000005"; 
        B      <= x"0000000A";
        wait for clk_period;
        assert Z = x"00000001" and cond = '1'
            report "Erro na operação SLTU"
            severity error;

        opcode <= "1010";  -- SGE
        A      <= x"0000000A";
        B      <= x"00000005";
        wait for clk_period;
        assert Z = x"00000001" and cond = '1'
            report "Erro na operação SGE"
            severity error;

        opcode <= "1011";  -- SGEU
        A      <= x"0000000A";
        B      <= x"00000005";
        wait for clk_period;
        assert Z = x"00000001" and cond = '1'
            report "Erro na operação SGEU"
            severity error;

        opcode <= "1100";  -- SEQ
        A      <= x"0000000A";
        B      <= x"0000000A";
        wait for clk_period;
        assert Z = x"00000001" and cond = '1'
            report "Erro na operação SEQ"
            severity error;

        opcode <= "1101";
        A      <= x"0000000A";
        B      <= x"00000005";
        wait for clk_period;
        assert Z = x"00000001" and cond = '1'
            report "Erro na operação SNE"
            severity error;

        report "Testes Concluidos";
        wait;
    end process;

end Behavioral;