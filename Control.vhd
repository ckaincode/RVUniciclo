library IEEE;
use IEEE.std_logic_1164.all;

entity control is
    port(
        op: in std_logic_vector(6 downto 0);
        Branch,MemRD,MemtoReg,MemWR,RegWR: out std_logic;
        ALUSrc1,ALUSrc2 : out std_logic; --XREGS1 ou PC/ XREGS2 ou Imm
        JALs,JALRs : out std_logic;
        ALUOp: out std_logic_vector(1 downto 0);
        RegSrc: out std_logic_vector (1 downto 0) -- WB ou Imm ou PC+4
    );
end control;

architecture rtl of control is
    --TODO
end rtl;