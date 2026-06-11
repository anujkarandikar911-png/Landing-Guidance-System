library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decision_fsm is
    Port ( clk        : in  STD_LOGIC;
           rst        : in  STD_LOGIC;
           zone_rear  : in  std_logic_vector(1 downto 0);
           ir_L       : in  STD_LOGIC;
           ir_R       : in  STD_LOGIC;
           intent_L   : in  STD_LOGIC;
           intent_R   : in  STD_LOGIC;
           danger_flag: out std_logic_vector(1 downto 0);
           status_msg : out std_logic_vector(2 downto 0));
end decision_fsm;

architecture Behavioral of decision_fsm is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                danger_flag <= "00";
                status_msg  <= "000";
            else
                -- Ultrasonic < 15cm OR driver turns into occupied IR blindspot = DANGER
                if zone_rear = "10" or
                   (intent_L = '1' and ir_L = '0') or
                   (intent_R = '1' and ir_R = '0') then
                    danger_flag <= "10";
                    status_msg  <= "010";

                -- Ultrasonic 16-50cm OR object in side blindspot = WARNING
                elsif zone_rear = "01" or ir_L = '0' or ir_R = '0' then
                    danger_flag <= "01";
                    status_msg  <= "001";

                -- Otherwise = SAFE
                else
                    danger_flag <= "00";
                    status_msg  <= "000";
                end if;
            end if;
        end if;
    end process;
end Behavioral;
