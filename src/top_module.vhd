library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_module is
    Port ( clk       : in  STD_LOGIC;
           rst_btn   : in  STD_LOGIC;
           echo_rear : in  STD_LOGIC;
           ir_L      : in  STD_LOGIC;
           ir_R      : in  STD_LOGIC;
           btn_L     : in  STD_LOGIC;
           btn_R     : in  STD_LOGIC;
           trig_rear : out STD_LOGIC;
           led_safe  : out STD_LOGIC;
           led_warn  : out STD_LOGIC;
           led_danger: out STD_LOGIC;
           buzzer    : out STD_LOGIC;
           lcd_rs    : out STD_LOGIC;
           lcd_e     : out STD_LOGIC;
           lcd_data  : out std_logic_vector(7 downto 0));
end top_module;

architecture Structural of top_module is
    signal en_1mhz, en_1khz, en_5hz, en_lcd : std_logic;
    signal dist_rear  : integer range 0 to 400;
    signal zone_rear, d_flag : std_logic_vector(1 downto 0);
    signal db_btn_L, db_btn_R : std_logic;
    signal status_msg : std_logic_vector(2 downto 0);
    signal cnt_4khz   : integer range 0 to 12500 := 0;
    signal tone_4khz  : std_logic := '0';
begin
    inst_clk:    entity work.clock_divider      port map(clk, rst_btn, en_1mhz, en_1khz, en_5hz, en_lcd);
    inst_db_L:   entity work.debounce           port map(clk, en_1khz, btn_L, db_btn_L);
    inst_db_R:   entity work.debounce           port map(clk, en_1khz, btn_R, db_btn_R);
    inst_us_rear:entity work.ultrasonic_controller port map(clk, rst_btn, en_1mhz, echo_rear, trig_rear, dist_rear, open);
    inst_zc_rear:entity work.zone_classifier    port map(clk, dist_rear, zone_rear);
    inst_fsm:    entity work.decision_fsm       port map(clk, rst_btn, zone_rear, ir_L, ir_R, db_btn_L, db_btn_R, d_flag, status_msg);
    inst_lcd:    entity work.lcd_controller     port map(clk, rst_btn, en_lcd, status_msg, dist_rear, lcd_rs, lcd_e, lcd_data);

    process(clk)
    begin
        if rising_edge(clk) then
            if cnt_4khz = 12500 then
                cnt_4khz  <= 0;
                tone_4khz <= not tone_4khz;
            else
                cnt_4khz <= cnt_4khz + 1;
            end if;

            led_safe <= '0'; led_warn <= '0'; led_danger <= '0'; buzzer <= '0';

            if    d_flag = "00" then led_safe   <= '1';
            elsif d_flag = "01" then led_warn   <= '1';
            elsif d_flag = "10" then
                led_danger <= '1';
                buzzer     <= tone_4khz;
            end if;
        end if;
    end process;
end Structural;
