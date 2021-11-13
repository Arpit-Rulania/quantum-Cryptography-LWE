library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity variableMod16_TB is
--  Port ( );
  constant delay : time := 20ns;
end variableMod16_TB;

architecture Behavioral of variableMod16_TB is
    signal clk : std_logic;
    
    signal inQ : std_logic_vector(15 downto 0);
    signal input : std_logic_vector(15 downto 0);
    
    signal output : std_logic_vector(15 downto 0);
    signal ready : std_logic;
    
    signal rst : std_logic := '1';
    
    signal cycles : integer := 0;
begin
    c: entity work.ClockProvider PORT MAP (clk => clk);
    v: entity work.variableMod
         GENERIC MAP (
           i => 16
         )
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
            -- Output should be 2
        wait for delay;
          rst <= '1';
        inQ <= std_logic_vector(to_unsigned(3, inQ'length));
        input <= std_logic_vector(to_unsigned(254, input'length));
        wait for delay;
        rst <= '0';
        -- wait until ready = '1';
        wait until output = std_logic_vector(to_unsigned(2, output'length));      
        
        -- Output should be 1
        wait for delay;
          rst <= '1';
        inQ <= std_logic_vector(to_unsigned(2, inQ'length));
        input <= std_logic_vector(to_unsigned(5, input'length));
        wait for delay;
        rst <= '0';
        -- wait until ready = '1';
        wait until output = std_logic_vector(to_unsigned(1, output'length));
        
        -- Output should be 2
        wait for delay;
        rst <= '1';
        inQ <= std_logic_vector(to_unsigned(3, inQ'length));
        input <= std_logic_vector(to_unsigned(5, input'length));
        wait for delay;
        rst <= '0';
        -- wait until ready = '1';
        wait until output = std_logic_vector(to_unsigned(2, output'length));
        
        -- Output should be 6
        -- No need to mod
        wait for delay;
        rst <= '1';
        inQ <= std_logic_vector(to_unsigned(20, inQ'length));
        input <= std_logic_vector(to_unsigned(6, input'length));
        wait for delay;
        rst <= '0';
        -- wait until ready = '1';
        wait until output = std_logic_vector(to_unsigned(6, output'length));
        
        -- Output should be 0
        wait for delay;
        rst <= '1';
        inQ <= std_logic_vector(to_unsigned(2, inQ'length));
        input <= std_logic_vector(to_unsigned(128, input'length));
        wait for delay;
        rst <= '0';
        wait until ready = '1';
        -- wait until output = std_logic_vector(to_unsigned(0, output'length));

        -- Output should be 9
        wait for delay;
        rst <= '1';
        inQ <= std_logic_vector(to_unsigned(17, inQ'length));
        input <= std_logic_vector(to_unsigned(128, input'length));
        wait for delay;
        rst <= '0';
        -- wait until ready = '1';        
        wait until output = std_logic_vector(to_unsigned(9, output'length));
        
        -- Output should be 0
        wait for delay;
        rst <= '1';
        inQ <= std_logic_vector(to_unsigned(128, inQ'length));
        input <= std_logic_vector(to_unsigned(128, input'length));
        wait for delay;
        rst <= '0';
        wait until ready = '1';        
        -- wait until output = std_logic_vector(to_unsigned(0, output'length));

        -- Output should be 128
        wait for delay;
        rst <= '1';
        inQ <= std_logic_vector(to_unsigned(129, inQ'length));
        input <= std_logic_vector(to_unsigned(128, input'length));
        wait for delay;
        rst <= '0';
        -- wait until ready = '1';        
        wait until output = std_logic_vector(to_unsigned(128, output'length));
        
        rst <= '1';
        wait;
        
    end process;
         
end Behavioral;
