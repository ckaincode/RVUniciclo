library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity genImm32_tb is
end genImm32_tb;

architecture Behavioural of genImm32_tb is
    -- Declaração dos sinais
    signal instr_tb: std_logic_vector(31 downto 0);
    signal imm32_tb: signed(31 downto 0);

begin
    -- Instanciação do módulo genImm32
    uut: entity work.genImm32
        port map (
            instr => instr_tb,
            imm32 => imm32_tb
        );

    -- Processo de teste
    process
    begin
        -- Teste 1: Formato R-type (sem imediato)
        instr_tb <= "00000000000000000000000000110011"; -- R-type (ADD)
        wait for 10 ns;
        assert imm32_tb = x"00000000" report "Teste 1 (R-type) falhou" severity error;

        -- Teste 2: Formato I-type (ADDI)
        instr_tb <= "00000000010100000000000010010011"; -- I-type (ADDI)
        wait for 10 ns;
        assert imm32_tb = x"00000005" report "Teste 2 (I-type ADDI) falhou" severity error;

        -- Teste 3: Formato I-type (LW)
        instr_tb <= "00000000010100000010000010000011"; -- I-type (LW)
        wait for 10 ns;
        assert imm32_tb = x"00000005" report "Teste 3 (I-type LW) falhou" severity error;

        -- Teste 4: Formato I-type (JALR)
        instr_tb <= "00000000010100000000000011100111"; -- I-type (JALR)
        wait for 10 ns;
        assert imm32_tb = x"00000005" report "Teste 4 (I-type JALR) falhou" severity error;

        -- Teste 5: Formato S-type (SW)
        instr_tb <= "00000000101000010010010100100011"; -- S-type (SW)
        wait for 10 ns;
        assert imm32_tb = x"0000000A" report "Teste 5 (S-type SW) falhou" severity error;

        -- Teste 6: Formato SB-type (BEQ)
        instr_tb <= "00000000101000010000010101100011"; -- SB-type (BEQ)
        wait for 10 ns;
        assert imm32_tb = x"0000000A" report "Teste 6 (SB-type BEQ) falhou" severity error;

        -- Teste 7: Formato U-type (LUI)
        instr_tb <= "00000000000000001010000000110111"; -- U-type (LUI)
        wait for 10 ns;
        assert imm32_tb = x"0000A000" report "Teste 7 (U-type LUI) falhou" severity error;

	     -- Teste 8: Formato UJ-type (JAL)
		  instr_tb <= "000000000000000001010000001101111"; -- UJ-type (JAL)
		  wait for 10 ns;
		  assert imm32_tb = x"0000000A" 
		  report "Teste 8 (UJ-type JAL) falhou"
		  severity error;

        -- Teste 9: Formato I-type (SLLI)
        instr_tb <= "00000000010100000001000010010011"; -- I-type (SLLI)
        wait for 10 ns;
        assert imm32_tb = x"00000005" report "Teste 9 (I-type SLLI) falhou" severity error;

        -- Teste 10: Formato I-type (SRLI)
        instr_tb <= "00000000010100000101000010010011"; -- I-type (SRLI)
        wait for 10 ns;
        assert imm32_tb = x"00000005" report "Teste 10 (I-type SRLI) falhou" severity error;

        -- Finaliza a simulação
        report "Testes concluídos!";
        wait;
    end process;
end Behavioural;