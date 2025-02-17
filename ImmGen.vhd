library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity genImm32 is
    port (
        instr : in std_logic_vector(31 downto 0);
        imm32 : out signed(31 downto 0)
    );
end genImm32;

architecture behavior of genImm32 is
 
    type FORMAT_RV is (R_type, I_type, S_type, SB_type, UJ_type, U_type);

 
    constant OPCODE_R_TYPE : std_logic_vector(6 downto 0) := "0110011";
    constant OPCODE_I_TYPE : std_logic_vector(6 downto 0) := "0010011";
	constant OPCODE_I2_TYPE : std_logic_vector(6 downto 0) := "0000011";
	constant OPCODE_JALR_TYPE : std_logic_vector(6 downto 0) := "1100111";
    constant OPCODE_S_TYPE : std_logic_vector(6 downto 0) := "0100011";
    constant OPCODE_SB_TYPE : std_logic_vector(6 downto 0) := "1100011";
    constant OPCODE_U_TYPE : std_logic_vector(6 downto 0) := "0110111";
    constant OPCODE_UJ_TYPE : std_logic_vector(6 downto 0) := "1101111";

    signal format : FORMAT_RV; -- Formato identificado
    signal opcode : std_logic_vector(6 downto 0);

begin
    opcode <= instr(6 downto 0);


    process(opcode)
    begin
        case opcode is
            when OPCODE_R_TYPE =>
                format <= R_type;

            when OPCODE_I_TYPE =>
                format <= I_type;
				
			when OPCODE_I2_TYPE =>
				format <= I_type;
				
			WHEN OPCODE_JALR_TYPE =>
				format <= I_type;

            when OPCODE_S_TYPE =>
                format <= S_type;

            when OPCODE_SB_TYPE =>
                format <= SB_type;

            when OPCODE_U_TYPE =>
                format <= U_type;

            when OPCODE_UJ_TYPE =>
                format <= UJ_type;

            when others =>
                format <= R_type; 
        end case;
    end process;

    process(instr,format)
        variable imm : signed(31 downto 0);
    begin
        imm := (others => '0'); 

        case format is
            when R_type =>
  
                imm := (others => '0');

            when I_type =>
            -- func3
				if instr(14 downto 12) = "101" or instr(14 downto 12) = "001" then
       
					imm := resize(signed(('0' & instr(24 downto 20))), 32); -- Explicit casting and sign extension
				else
     
					imm := resize(signed(instr(31 downto 20)), 32); -- Explicit casting
				end if;
	
            when S_type =>
     
                imm := resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32);

            when SB_type =>
           
                imm := resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & "0"), 32);

            when U_type =>
    
                imm := resize(signed(instr(31 downto 12) & (x"000")), 32);

            when UJ_type =>
          
                imm := resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & "0"), 32);
			
			when others =>
				imm := resize("0",32);
        end case;

        imm32 <= imm; 
    end process;

end behavior;
