library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ulaRV is
	port (
		opcode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(31 downto 0);
		Z : out std_logic_vector(31 downto 0);
		cond : out std_logic);
end ulaRV;


architecture behavioural of ulaRV is

	constant ADD_OP   : std_logic_vector(3 downto 0) := "0000";
	constant SUB_OP   : std_logic_vector(3 downto 0) := "0001";
	constant AND_OP   : std_logic_vector(3 downto 0) := "0010";
	constant OR_OP    : std_logic_vector(3 downto 0) := "0011";
	constant XOR_OP   : std_logic_vector(3 downto 0) := "0100";
	constant SLL_OP   : std_logic_vector(3 downto 0) := "0101";
	constant SRL_OP   : std_logic_vector(3 downto 0) := "0110";
	constant SRA_OP   : std_logic_vector(3 downto 0) := "0111";
	constant SLT_OP   : std_logic_vector(3 downto 0) := "1000";
	constant SLTU_OP  : std_logic_vector(3 downto 0) := "1001";
	constant SGE_OP   : std_logic_vector(3 downto 0) := "1010";
	constant SGEU_OP  : std_logic_vector(3 downto 0) := "1011";
	constant SEQ_OP   : std_logic_vector(3 downto 0) := "1100";
	constant SNE_OP   : std_logic_vector(3 downto 0) := "1101";
	constant ZERO	  : std_logic_vector(31 downto 0) := x"00000000";
	constant UM		  : std_logic_vector(31 downto 0) := x"00000001";
	
	signal a32 : std_logic_vector(31 downto 0);
	
begin
	Z <= a32;
    proc_ula: process(A, B, opcode)
    begin
        case opcode is
            when ADD_OP  => 
                a32 <= std_logic_vector(signed(A) + signed(B));
                cond <= '0';
            when SUB_OP  => 
                a32 <= std_logic_vector(signed(A) - signed(B));
                cond <= '0';
            when AND_OP  => 
                a32 <= A and B;
                cond <= '0';
            when OR_OP   => 
                a32 <= A or B;
                cond <= '0';
            when XOR_OP  => 
                a32 <= A xor B;
                cond <= '0';
            when SLL_OP  => 
                a32 <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
                cond <= '0';
            when SRL_OP  => 
                a32 <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
                cond <= '0';
            when SRA_OP  => 
                a32 <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B(4 downto 0)))));
                cond <= '0';
            when SLT_OP  =>
                if signed(A) < signed(B) then
                    a32 <= UM;
                    cond <= '1';
                else
                    a32 <= ZERO;
                    cond <= '0';
                end if;
            when SLTU_OP =>
                if unsigned(A) < unsigned(B) then
                    a32 <= UM;
                    cond <= '1';
                else
                    a32 <= ZERO;
                    cond <= '0';
                end if;
            when SGE_OP  =>
                if signed(A) >= signed(B) then
                    a32 <= UM;
                    cond <= '1';
                else
                    a32 <= ZERO;
                    cond <= '0';
                end if;
            when SGEU_OP =>
                if unsigned(A) >= unsigned(B) then
                    a32 <= UM;
                    cond <= '1';
                else
                    a32 <= ZERO;
                    cond <= '0';
                end if;
            when SEQ_OP  =>
                if A = B then
                    a32 <= UM;
                    cond <= '1';
                else
                    a32 <= ZERO;
                    cond <= '0';
                end if;
            when SNE_OP  =>
                if A /= B then
                    a32 <= UM;
                    cond <= '1';
                else
                    a32 <= ZERO;
                    cond <= '0';
                end if;
            when others  =>
                a32 <= ZERO;
                cond <= '0';
        end case;
    end process proc_ula;
end behavioural;
