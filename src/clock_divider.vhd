library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port ( clk     : in  STD_LOGIC;
           rst     : in  STD_LOGIC;
           en_1mhz : out STD_LOGIC;
           en_1khz : out STD_LOGIC;
           en_5hz  : out STD_LOGIC;
           en_lcd  : out STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is
    signal cnt_1mhz : integer range 0 to 99      := 0;
    signal cnt_1khz : integer range 0 to 99999   := 0;
    signal cnt_5hz  : integer range 0 to 19999999:= 0;
    signal cnt_lcd  : integer range 0 to 999999  := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt_1mhz <= 0; cnt_1khz <= 0; cnt_5hz <= 0; cnt_lcd <= 0;
                en_1mhz  <= '0'; en_1khz <= '0'; en_5hz <= '0'; en_lcd <= '0';
            else
                -- 1 MHz Enable (every 100 ticks)
                if cnt_1mhz = 99 then
                    cnt_1mhz <= 0; en_1mhz <= '1';
                else
                    cnt_1mhz <= cnt_1mhz + 1; en_1mhz <= '0';
                end if;

                -- 1 kHz Enable (every 100,000 ticks)
                if cnt_1khz = 99999 then
                    cnt_1khz <= 0; en_1khz <= '1';
                else
                    cnt_1khz <= cnt_1khz + 1; en_1khz <= '0';
                end if;

                -- 5 Hz Enable (every 20,000,000 ticks)
                if cnt_5hz = 19999999 then
                    cnt_5hz <= 0; en_5hz <= '1';
                else
                    cnt_5hz <= cnt_5hz + 1; en_5hz <= '0';
                end if;

                -- LCD Enable 100 Hz (every 1,000,000 ticks)
                if cnt_lcd = 999999 then
                    cnt_lcd <= 0; en_lcd <= '1';
                else
                    cnt_lcd <= cnt_lcd + 1; en_lcd <= '0';
                end if;
            end if;
        end if;
    end process;
end Behavioral;
