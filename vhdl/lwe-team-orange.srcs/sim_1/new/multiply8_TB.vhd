library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiply8_TB is
--  Port ( );
end multiply8_TB;

architecture Behavioral of multiply8_TB is
    signal clk : std_logic;
    signal rst : std_logic := '1';
    signal ready : std_logic;
    signal cycles : integer := 0;
    constant delay : time := 20ns;
    
    signal in1 : std_logic_vector(7 downto 0);
    signal in2 : std_logic_vector(7 downto 0);
    signal output : std_logic_vector(7 downto 0);
begin
    c: entity work.ClockProvider PORT MAP ( clk => clk );
    m: entity work.multiply8 
         PORT MAP (
            clk => clk,
            rst => rst,
            in1 => in1,
            in2 => in2,
            ready => ready,
            output => output
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
        in1 <= std_logic_vector(to_unsigned(5, in1'length));
        in2 <= std_logic_vector(to_unsigned(4, in2'length));
        wait for delay;
        rst <= '0';
        
        wait until ready = '1';
        
        wait;
    
    end process;
    
end Behavioral;
