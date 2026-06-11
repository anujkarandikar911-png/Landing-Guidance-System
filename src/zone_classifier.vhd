library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zone_classifier is
    Port ( clk     : in  STD_LOGIC;
           dist_cm : in  integer range 0 to 400;
           zone    : out std_logic_vector(1 downto 0));
end zone_classifier;

architecture Behavioral of zone_classifier is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if dist_cm <= 15 then
                zone <= "10";    -- DANGER  (0 to 15 cm)
            elsif dist_cm <= 50 then
                zone <= "01";    -- WARNING (16 to 50 cm)
            else
                zone <= "00";    -- SAFE    (> 50 cm)
            end if;
        end if;
    end process;
end Behavioral;
