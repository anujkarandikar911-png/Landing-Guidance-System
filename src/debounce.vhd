library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce is
    Port ( clk     : in  STD_LOGIC;
           en_1khz : in  STD_LOGIC;
           btn_in  : in  STD_LOGIC;
           btn_out : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    signal shift_reg : std_logic_vector(3 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if en_1khz = '1' then
                shift_reg <= shift_reg(2 downto 0) & btn_in;
                if    shift_reg = "1111" then btn_out <= '1';
                elsif shift_reg = "0000" then btn_out <= '0';
                end if;
            end if;
        end if;
    end process;
end Behavioral;
