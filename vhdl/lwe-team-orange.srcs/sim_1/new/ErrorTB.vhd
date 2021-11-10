library IEEE;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity ErrorTB is

end ErrorTB;

architecture Behavioral of ErrorTB is

    component ErrorMatrixGen
    port (
        clk:                in  std_logic; -- rising edge active.
        rst:                in  std_logic; -- active high.
        error:              out std_logic_vector(15 downto 0);
        error_normalised:   out integer );
    end component;
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal error : std_logic_vector(15 downto 0);
   
   constant clk_period : time := 10 ns;
begin

   uut: ErrorMatrixGen port map (
          clk => clk,
          rst => rst,
          error => error
        );
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;

   reset_process: process
   begin        
        rst <= '1';
        wait for clk_period*2;
        rst <= '0';
        wait for 1000000ns;
   end process;

end;