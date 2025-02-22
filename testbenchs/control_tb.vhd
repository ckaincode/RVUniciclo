library IEEE;
use IEEE.std_logic_1164.all;

entity control_tb is
end control_tb;

architecture Behavioural of control_tb is

    signal op_tb: std_logic_vector(6 downto 0);
    signal Branch_tb, MemtoReg_tb, MemWR_tb, RegWR_tb: std_logic;
    signal ALUSrc1_tb: std_logic;
    signal ALUSrc2_tb: std_logic_vector(1 downto 0);
    signal JALs_tb, JALRs_tb: std_logic;
    signal ALUOp_tb: std_logic_vector(1 downto 0);
    signal RegSrc_tb: std_logic_vector(1 downto 0);

begin

    uut: entity work.control
        port map (
            op => op_tb,
            Branch => Branch_tb,
            MemtoReg => MemtoReg_tb,
            MemWR => MemWR_tb,
            RegWR => RegWR_tb,
            ALUSrc1 => ALUSrc1_tb,
            ALUSrc2 => ALUSrc2_tb,
            JALs => JALs_tb,
            JALRs => JALRs_tb,
            ALUOp => ALUOp_tb,
            RegSrc => RegSrc_tb
        );

    process
    begin

        op_tb <= "0110111";
        wait for 10 ns;
        assert Branch_tb = '0' and MemtoReg_tb = '0' and MemWR_tb = '0' and RegWR_tb = '1' and
               JALs_tb = '0' and JALRs_tb = '0' and RegSrc_tb = "01"
            report "(LUI) falhou" severity error;


        op_tb <= "0010111";
        wait for 10 ns;
        assert Branch_tb = '0' and MemtoReg_tb = '0' and MemWR_tb = '0' and RegWR_tb = '1' and
               ALUSrc1_tb = '1' and ALUSrc2_tb = "01" and JALs_tb = '0' and JALRs_tb = '0' and
               ALUOp_tb = "00" and RegSrc_tb = "00"
            report "Teste 2 (AUIPC) falhou" severity error;

        op_tb <= "1101111";
        wait for 10 ns;
        assert Branch_tb = '0' and MemWR_tb = '0' and RegWR_tb = '1' and
               JALs_tb = '1' and JALRs_tb = '0' and RegSrc_tb = "10"
            report "Teste 3 (JAL) falhou" severity error;

        op_tb <= "1100111";
        wait for 10 ns;
        assert Branch_tb = '0' and MemtoReg_tb = '0' and MemWR_tb = '0' and RegWR_tb = '1' and
               ALUSrc1_tb = '0' and ALUSrc2_tb = "10" and JALs_tb = '0' and JALRs_tb = '1' and
               ALUOp_tb = "00" and RegSrc_tb = "10"
            report "Teste 4 (JALR) falhou" severity error;
				
        op_tb <= "1100011";
        wait for 10 ns;
        assert Branch_tb = '1' and MemtoReg_tb = '0' and MemWR_tb = '0' and RegWR_tb = '0' and
               ALUSrc1_tb = '0' and ALUSrc2_tb = "00" and JALs_tb = '0' and JALRs_tb = '0' and
               ALUOp_tb = "01"
            report "Teste 5 (C_JUMP) falhou" severity error;

        op_tb <= "0000011";
        wait for 10 ns;
        assert Branch_tb = '0' and MemtoReg_tb = '1' and MemWR_tb = '0' and RegWR_tb = '1' and
               ALUSrc1_tb = '0' and ALUSrc2_tb = "10" and JALs_tb = '0' and JALRs_tb = '0' and
               ALUOp_tb = "00" and RegSrc_tb = "00"
            report "Teste 6 (LOAD) falhou" severity error;

        op_tb <= "0100011"; 
        wait for 10 ns;
        assert Branch_tb = '0' and MemtoReg_tb = '0' and MemWR_tb = '1' and RegWR_tb = '0' and
               ALUSrc1_tb = '0' and ALUSrc2_tb = "10" and JALs_tb = '0' and JALRs_tb = '0' and
               ALUOp_tb = "00" and RegSrc_tb = "00"
            report "Teste 7 (STORE) falhou" severity error;

        op_tb <= "0110011";
        wait for 10 ns;
        assert Branch_tb = '0' and MemtoReg_tb = '0' and MemWR_tb = '0' and RegWR_tb = '1' and
               ALUSrc1_tb = '0' and ALUSrc2_tb = "00" and JALs_tb = '0' and JALRs_tb = '0' and
               ALUOp_tb = "10" and RegSrc_tb = "00"
            report "(REGISTER_LASC) falhou" severity error;

        op_tb <= "0010011";
        wait for 10 ns;
        assert Branch_tb = '0' and MemtoReg_tb = '0' and MemWR_tb = '0' and RegWR_tb = '1' and
               ALUSrc1_tb = '0' and ALUSrc2_tb = "01" and JALs_tb = '0' and JALRs_tb = '0' and
               ALUOp_tb = "11" and RegSrc_tb = "00"
            report "(IMMEDIATE) falhou" severity error;
				
        op_tb <= "1111111";
        wait for 10 ns;
        assert Branch_tb = '0' and MemtoReg_tb = '0' and MemWR_tb = '0' and RegWR_tb = '0' and
               ALUSrc1_tb = '0' and ALUSrc2_tb = "00" and JALs_tb = '0' and JALRs_tb = '0' and
               ALUOp_tb = "00" and RegSrc_tb = "00"
            report "Teste 10 (Inválido) falhou" severity error;

        report "Testes concluidos!";
        wait;
    end process;
end Behavioural;