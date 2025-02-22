library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALUCtrl_tb is
end ALUCtrl_tb;

architecture Behavioural of ALUCtrl_tb is

    signal ALUOp_tb: std_logic_vector(1 downto 0);
    signal funct3_tb: std_logic_vector(2 downto 0);
    signal bit_30_tb: std_logic;
    signal ALUCode_tb: std_logic_vector(3 downto 0);

begin

    uut: entity work.ALUCtrl
        port map (
            ALUOp => ALUOp_tb,
            funct3 => funct3_tb,
            bit_30 => bit_30_tb,
            ALUCode => ALUCode_tb
        );


    process
    begin

        ALUOp_tb <= "00";
        funct3_tb <= "000";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "0000" report "ALUCode deveria ser 0000" severity error;

        ALUOp_tb <= "01";
        funct3_tb <= "000";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "1100" report "ALUCode deveria ser 1100" severity error;

        ALUOp_tb <= "01";
        funct3_tb <= "001";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "1101" report "ALUCode deveria ser 1101" severity error;

        ALUOp_tb <= "10";
        funct3_tb <= "111";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "0010" report "ALUCode deveria ser 0010" severity error;

        ALUOp_tb <= "10";
        funct3_tb <= "010";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "1000" report "ALUCode deveria ser 1000" severity error;

        ALUOp_tb <= "10";
        funct3_tb <= "110";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "0011" report "ALUCode deveria ser 0011" severity error;

        ALUOp_tb <= "10";
        funct3_tb <= "100";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "0100" report "ALUCode deveria ser 0100" severity error;

        ALUOp_tb <= "10";
        funct3_tb <= "000";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "0000" report "ALUCode deveria ser 0000" severity error;

        ALUOp_tb <= "10";
        funct3_tb <= "000";
        bit_30_tb <= '1';
        wait for 10 ns;
        assert ALUCode_tb = "0001" report "ALUCode deveria ser 0001" severity error;

        ALUOp_tb <= "10";
        funct3_tb <= "101";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "0110" report "ALUCode deveria ser 0110" severity error;

        ALUOp_tb <= "10";
        funct3_tb <= "101";
        bit_30_tb <= '1';
        wait for 10 ns;
        assert ALUCode_tb = "0111" report "ALUCode deveria ser 0111" severity error;

        ALUOp_tb <= "11";
        funct3_tb <= "000";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "0000" report "ALUCode deveria ser 0000" severity error;

        ALUOp_tb <= "11";
        funct3_tb <= "111";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "0010" report "ALUCode deveria ser 0010" severity error;

        ALUOp_tb <= "11";
        funct3_tb <= "110";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "0011" report "ALUCode deveria ser 0011" severity error;

        ALUOp_tb <= "11";
        funct3_tb <= "100";
        bit_30_tb <= '0';
        wait for 10 ns;
        assert ALUCode_tb = "0100" report "ALUCode deveria ser 0100" severity error;

        report "Testes concluidos!";
        wait;
    end process;
end Behavioural;