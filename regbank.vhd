library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity XREGS is
  generic (WSIZE : natural := 32);
  port (
    clk, wren : in std_logic;
    rs1, rs2, rd : in std_logic_vector(4 downto 0);
    data : in std_logic_vector(WSIZE-1 downto 0);
    ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
  );
end XREGS;

architecture Behavioral of XREGS is
  type regbank is array (0 to 31) of std_logic_vector(WSIZE-1 downto 0);
  signal registers : regbank := (
    2 => x"00003FFC",  -- SP
    3 => x"00001800",  -- GP
    others => (others => '0')
);
begin

  process(clk)
  begin
    if rising_edge(clk) then
      if wren = '1' and rd /= "00000" then  -- Impede escrita no registrador zero
        registers(to_integer(unsigned(rd))) <= data;
      end if;
    end if;
  end process;

  ro1 <= registers(to_integer(unsigned(rs1)));
  ro2 <= registers(to_integer(unsigned(rs2)));

end Behavioral;
