library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ultrasonic_controller is
    Port ( clk     : in  STD_LOGIC;
           rst     : in  STD_LOGIC;
           en_1mhz : in  STD_LOGIC;
           echo    : in  STD_LOGIC;
           trig    : out STD_LOGIC;
           dist_cm : out integer range 0 to 400;
           valid   : out STD_LOGIC);
end ultrasonic_controller;

architecture Behavioral of ultrasonic_controller is
    type state_type is (IDLE, TRIGGER, WAIT_ECHO, MEASURE, DONE);
    signal state      : state_type := IDLE;
    signal timer      : integer range 0 to 65000 := 0;
    signal echo_time  : integer range 0 to 30000 := 0;
    signal echo_sync1, echo_sync2 : std_logic;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state   <= IDLE;
                trig    <= '0';
                valid   <= '0';
                dist_cm <= 400;
            elsif en_1mhz = '1' then
                echo_sync1 <= echo;
                echo_sync2 <= echo_sync1;

                case state is
                    when IDLE =>
                        timer <= 0; trig <= '0'; valid <= '0';
                        if timer = 25000 then
                            state <= TRIGGER; timer <= 0;
                        else
                            timer <= timer + 1;
                        end if;

                    when TRIGGER =>
                        trig <= '1';
                        if timer = 10 then
                            trig <= '0'; state <= WAIT_ECHO; timer <= 0;
                        else
                            timer <= timer + 1;
                        end if;

                    when WAIT_ECHO =>
                        if echo_sync2 = '1' then
                            state <= MEASURE; echo_time <= 0; timer <= 0;
                        elsif timer = 15000 then
                            state <= DONE; echo_time <= 15000;
                        else
                            timer <= timer + 1;
                        end if;

                    when MEASURE =>
                        if echo_sync2 = '0' then
                            state <= DONE;
                        elsif timer = 15000 then
                            state <= DONE; echo_time <= 15000;
                        else
                            echo_time <= echo_time + 1;
                            timer     <= timer + 1;
                        end if;

                    when DONE =>
                        dist_cm <= echo_time / 58;
                        valid   <= '1';
                        state   <= IDLE;
                end case;
            end if;
        end if;
    end process;
end Behavioral;
