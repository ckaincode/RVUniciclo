library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;

entity RAM_RV is
    port (
        clck      : in std_logic;               
        we        : in std_logic;               
        byte_en   : in std_logic;               
        sgn_en    : in std_logic;               
        address   : in std_logic_vector(13 downto 0); 
        datain    : in std_logic_vector(31 downto 0); 
        dataout   : out std_logic_vector(31 downto 0) 
    );
end RAM_RV;

architecture rtl of ram_rv is

    type mem_type is array (0 to 16384) of std_logic_vector(7 downto 0); 
    signal mem : mem_type := (others => (others => '0')); 

    --Função auxiliar para acessar e processar a leitura de bytes com ou sem sinal
    impure function read_byte(address : integer) return std_logic_vector is
        variable byte_data : std_logic_vector(7 downto 0);
    begin
        byte_data := mem(address);
        if sgn_en = '1' then
            if byte_data(7) = '1' then
                return (x"FFFFFF"&byte_data);  -- Expande para 32 bits com sinal
            else
                return (x"000000"&byte_data);  -- Expande para 32 bits sem sinal
            end if;
        else
            -- lbu
            return x"000000"& byte_data;  
        end if;
    end function;

begin

    process(clck)
    begin
        if rising_edge(clck) then
            --Write
            if we = '1' then
                if byte_en = '1' then
                    -- Escrevendo um byte na memória
                    mem(to_integer(unsigned(address))) <= datain(7 downto 0);
                else
                    -- Escrevendo uma palavra 
                    mem(to_integer(unsigned(address))) <= datain(7 downto 0);
                    mem(to_integer(unsigned(address)) + 1) <= datain(15 downto 8);
                    mem(to_integer(unsigned(address)) + 2) <= datain(23 downto 16);
                    mem(to_integer(unsigned(address)) + 3) <= datain(31 downto 24);
                end if;
            end if;
        end if;

            -- Read
        if byte_en = '1' then
                -- Lendo um byte da memória
            dataout <= read_byte(to_integer(unsigned(address)));
        else
                -- Lendo uma palavra  da memória
            dataout <= mem(to_integer(unsigned(address))) & mem(to_integer(unsigned(address)) + 1) &
                        mem(to_integer(unsigned(address)) + 2) & mem(to_integer(unsigned(address)) + 3);
        end if;
    end process;

end rtl;