library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockProvider is
    Generic (
        period : time := 10ns
    );
    Port ( clk : out STD_LOGIC);
end ClockProvider;

architecture ClockProvider of ClockProvider is
    signal clock_signal : STD_LOGIC := '0';
begin 
   clk <= clock_signal;
   
   p_CLK_GEN : process is begin
        wait for period/2;
        clock_signal <= not clock_signal;
    end process p_CLK_GEN; 
    
end ClockProvider;
