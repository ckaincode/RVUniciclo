library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALUCtrl is
    port(
        ALUOp: in std_logic_vector(1 downto 0);
        funct3: in std_logic_vector(2 downto 0);
        bit_30: in std_logic;
        ALUCode: out std_logic_vector(3 downto 0)
    );
end ALUCtrl;

architecture Behavioural of ALUCtrl is

begin

ALUProc: process(ALUOp,funct3,bit_30)
    begin
        case ALUOp is

            when "00" => ALUCode <= "0000";

            when "01" =>
                        if (funct3 = "000") then
                            ALUCode <= "1100";
                        else
                            ALUCode <= "1101";
                        end if;
            
            when "10" =>
                        case funct3 is                      
                            when "111" => ALUCode <= "0010";
                            when "010" => ALUCode <= "1000";
                            when "110" => ALUCode <= "0011";
                            when "100" => ALUCode <= "0100";    
                            when "000" =>
                                        if (bit_30 = '0') then
                                            ALUCode <= "0000";
                                        else
                                            ALUCode <= "0001";
                                        end if;
                            when "001" => ALUCode <= "0101";
                            when "101" =>
                                        if (bit_30 = '0') then
                                            ALUCode <= "0110";
                                        else
                                            ALUCode <= "0111";
                                        end if;
                            when others => ALUCode <= "0000";
                        end case;

            when "11" =>
                        case funct3 is
                            when "000" => ALUCode <= "0000";
                            when "111" => ALUCode <= "0010";
                            when "110" => ALUCode <= "0011";
                            when "100" => ALUCode <= "0100";
                            when others => ALUCode <= "0000";
                        end case;
            when others => ALUCode <= "0000";                      
        end case;
    end process ALUProc;
end Behavioural;