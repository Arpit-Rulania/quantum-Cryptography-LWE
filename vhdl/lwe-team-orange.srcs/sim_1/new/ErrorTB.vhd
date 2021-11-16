library IEEE;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity ErrorTB is
end ErrorTB;

architecture Behavioral of ErrorTB is
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal error : std_logic_vector(15 downto 0);
   
   constant clk_period : time := 10 ns;
begin

   uut: entity work.ErrorMatrixGen port map (
          clk => clk,
          rst => rst,
          error => error
        );
   
   c: entity work.ClockProvider PORT MAP ( clk => clk );

   reset_process: process
   begin        
        rst <= '1';
        wait for clk_period*2;
        rst <= '0';
        wait for 1000000ns;
   end process;

end;