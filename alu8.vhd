library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu8 is
    Port (
        a      : in  STD_LOGIC_VECTOR (7 downto 0);
        b      : in  STD_LOGIC_VECTOR (7 downto 0);
        opcode : in  STD_LOGIC_VECTOR (1 downto 0); -- "00":+, "01":-, "10":*, "11":/
        result : out STD_LOGIC_VECTOR (15 downto 0)
    );
end alu8;

architecture Behavioral of alu8 is
begin
    process(a, b, opcode)
        variable a_u, b_u : unsigned(7 downto 0);
        variable res_u   : unsigned(15 downto 0);
    begin
        a_u := unsigned(a);
        b_u := unsigned(b);
        res_u := (others => '0');

        case opcode is
            when "00" => -- Penjumlahan
                res_u := resize(a_u + b_u, 16);
            when "01" => -- Pengurangan
                if a_u >= b_u then
                    res_u := resize(a_u - b_u, 16);
                else
                    res_u := (others => '0');
                end if;
            when "10" => -- Perkalian
                res_u := a_u * b_u;
            when "11" => -- Pembagian
                if b_u /= 0 then
                    res_u := resize(a_u / b_u, 16);
                else
                    res_u := (others => '1'); -- Indikasi Error (Bagi 0)
                end if;
            when others =>
                res_u := (others => '0');
        end case;

        result <= STD_LOGIC_VECTOR(res_u);
    end process;
end Behavioral;