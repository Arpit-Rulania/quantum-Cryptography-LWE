library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity variableMod8_TB is
--  Port ( );
  constant delay : time := 20ns;
end variableMod8_TB;

architecture Behavioral of variableMod8_TB is
    signal clk : std_logic;
    
    signal inQ : std_logic_vector(7 downto 0);
    signal input : std_logic_vector(7 downto 0);
    
    signal output : std_logic_vector(7 downto 0);
    signal ready : std_logic;
    
    signal rst : std_logic := '1';
    
    signal cycles : integer := 0;
begin
    c: entity work.ClockProvider PORT MAP (clk => clk);
    v: entity work.variableMod8
         PORT MAP (
           clk => clk,
           rst => rst,
           inQ => inQ,
           input => input,
           output => output,
           ready => ready
       );
    
    timing: process(clk) begin
        if rising_edge(clk) then
            if rst = '1' then
              cycles <= 0;
            elsif ready = '0' then
              cycles <= cycles + 1;
            end if;
        end if;
    end process;
    
    process begin
    
        -- Output should be 1
        wait for delay;
        inQ <= std_logic_vector(to_unsigned(2, inQ'length));
        input <= std_logic_vector(to_unsigned(5, input'length));
        wait for delay;
        rst <= '0';
        wait until ready = '1';
        
        -- Output should be 2
        wait for delay;
        rst <= '1';
        inQ <= std_logic_vector(to_unsigned(3, inQ'length));
        input <= std_logic_vector(to_unsigned(5, input'length));
        wait for delay;
        rst <= '0';
        wait until ready = '1';
        
        -- Output should be 0
        wait for delay;
        rst <= '1';
        inQ <= std_logic_vector(to_unsigned(2, inQ'length));
        input <= std_logic_vector(to_unsigned(128, input'length));
        wait for delay;
        rst <= '0';
        wait until ready = '1';

        -- Output should be 9
        wait for delay;
        rst <= '1';
        inQ <= std_logic_vector(to_unsigned(17, inQ'length));
        input <= std_logic_vector(to_unsigned(128, input'length));
        wait for delay;
        rst <= '0';
        wait until ready = '1';        
        
        -- Output should be 0
        wait for delay;
        rst <= '1';
        inQ <= std_logic_vector(to_unsigned(128, inQ'length));
        input <= std_logic_vector(to_unsigned(128, input'length));
        wait for delay;
        rst <= '0';
        wait until ready = '1';        

        -- Output should be 128
        wait for delay;
        rst <= '1';
        inQ <= std_logic_vector(to_unsigned(129, inQ'length));
        input <= std_logic_vector(to_unsigned(128, input'length));
        wait for delay;
        rst <= '0';
        wait until ready = '1';        
        
        rst <= '1';
        wait;
        
    end process;
         
end Behavioral;
