library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity ROM_RV is
port(
    address: in std_logic_vector(9 downto 0);
    dataout: out std_logic_vector(31 downto 0)
    );
end ROM_RV;

architecture tb_ROM of ROM_RV is

    type ram_type is array (0 to (2**address'length)-1) of std_logic_vector(dataout'range);

    impure function init_ram_hex return ram_type is
        file text_file : text open read_mode is "hex_RV.txt";
        variable text_line : line;
        variable ram_content : ram_type;
    begin
        for i in 0 to 1023 loop
            if not endfile(text_file) then
                readline(text_file, text_line);
                hread(text_line, ram_content(i)); -- Read hex value into RAM
            else
                ram_content(i) := (others => '0'); -- Preencher o resto da ROM
            end if;
        end loop;
        return ram_content;
    end function;

    signal mem : ram_type := init_ram_hex;

    begin
    dataout <= mem(to_integer(unsigned(address)));

end tb_ROM;


