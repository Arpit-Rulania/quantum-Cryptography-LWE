
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockProvider_TB is
    signal clock: std_logic;
end ClockProvider_TB;

architecture Behavioral of ClockProvider_TB is
begin
    c: entity work.ClockProvider PORT MAP ( clk => clock );
end Behavioral;
