library IEEE;
use IEEE.std_logic_1164.all;

entity control is
    port(
        op: in std_logic_vector(6 downto 0);
        Branch,MemtoReg,MemWR,RegWR: out std_logic;
        ALUSrc1: out std_logic; --XREGS1 ou PC/ XREGS2 ou Imm
        ALUSrc2 : out std_logic_vector(1 downto 0); -- XREGS2 ou Imm ou Imm << 1
        JALs,JALRs : out std_logic;
        ALUOp: out std_logic_vector(1 downto 0);
        RegSrc: out std_logic_vector (1 downto 0) -- WB ou Imm ou PC+4
    );
end control;

architecture rtl of control is

    constant LUI : std_logic_vector (6 downto 0) := "0110111";
    constant AUIPC : std_logic_vector (6 downto 0) := "0010111";
    constant JAL : std_logic_vector (6 downto 0) := "1101111";
    constant JALR : std_logic_vector (6 downto 0) := "1100111";
    constant C_JUMP : std_logic_vector (6 downto 0) := "1100011"; --BEQ/BNE
    constant LOAD : std_logic_vector (6 downto 0) := "0000011"; --LW,LB,LBU
    constant STORE : std_logic_vector (6 downto 0) := "0100011"; --SW,SB
    constant REGISTER_LASC: std_logic_vector (6 downto 0) := "0110011"; --AND,SLT,OR,XOR,ADD,SUB,SLL,SRL,SRA
    constant IMMEDIATE : std_logic_vector (6 downto 0) := "0010011" --ADDI,ANDI,ORI,XORI

begin

-- REVIEW AFTER ALUControl IMPLEMENTATION, Patterson 254
comb_proc: process(op)
    begin
        case op is
            when LUI => Branch <= '0' ; MEMWR <= '0';
        RegWR <= '1'; JALs <= '0' ; JALRs <= '0'; RegSrc <= "01" ;

            when AUIPC => Branch <= '0'; MemtoReg <= '0' ; MEMWR <= '0';
        RegWR <= '1' ; ALUSrc1 <= '1' ; ALUSrc2 <= "01" ; JALs <= '0' ; JALRs <= '0'; ALUOp <= "10" ; RegSrc <= "00" ;

            when JAL => Branch <= '0'; MEMWR <= '0' ;
        RegWR <= '1'; JALs <= '1' ; JALRs <= '0'; RegSrc <="10" ;

            when JALR => Branch <= '0'; MemtoReg <= '0' ; MEMWR <='0' ;
        RegWR <= '1' ; ALUSrc1 <='0' ; ALUSrc2 <="10" ; JALs <= '0' ; JALRs <= '1' ; ALUOp <= "10" ; RegSrc <= "10";

            when C_JUMP => Branch <= '1' ; MemtoReg <= '0' ; MEMWR <= '0' ;
        RegWR <= '0' ; ALUSrc1 <= '0' ; ALUSrc2 <= "00" ; JALs <= '0' ; JALRs <= '0' ; ALUOp <= "01" ;

            when LOAD => Branch <= '0' ; MemtoReg <= '1' ; MEMWR <= '0';
        RegWR <= '1' ; ALUSrc1 <= '0' ; ALUSrc2 <= "10" ; JALs <= '0' ; JALRs <= '0' ; ALUOp <= "00" ; RegSrc <= "00" ;

            when STORE => Branch <= '0'; MemtoReg <= '0' ; MEMWR <= '1' ;
        RegWR <= '0' ; ALUSrc1 <= '0' ; ALUSrc2 <= "10" ; JALs <= '0' ; JALRs <= '0' ; ALUOp <="00" ; RegSrc <= "00";

            when REGISTER_LASC => Branch <= '0' ; MemtoReg <= '0' ; MEMWR <= '0';
        RegWR <= '1' ; ALUSrc1 <= '0' ; ALUSrc2 <= "00" ; JALs <= '0' ; JALRs <= '0' ; ALUOp <= "10" ; RegSrc <="00" ;

            when IMMEDIATE => Branch <= '0'; MemtoReg <= '0'; MEMWR <= '0'; 
        RegWR <= '1'; ALUSrc1 <= '0''; ALUSrc2 <= "01"; JAL <= '0'; JALRs <= '0'; ALUOp <= "10"; RegSrc <= "00";

            when others => Branch <= '0' ; MemtoReg <= '0' ; MEMWR <= '0';
        RegWR <= '0' ; ALUSrc1 <= '0' ; ALUSrc2 <= "00" ; JALs <= '0' ; JALRs <= '0' ; ALUOp <= "00" ; RegSrc <="00" ;


        end case;    
    end process comb_proc;
end rtl;