--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.commons.all;

--entity decrypt_TB is
--end decrypt_TB;

--architecture Behavioral of decrypt_TB is
--    signal clk : std_logic;
--    signal rst : std_logic := '1';
--    signal ready : std_logic;
--    signal cycles : integer := 0;
--    constant delay : time := 20ns;
    
--    signal output : std_logic;
--    signal inU : arr := (8,4,0,8);
----    signal inV : unsigned := 
    
--    signal inS: arr := (4,7,5,5);
     
--begin
--    c: entity work.ClockProvider PORT MAP ( clk => clk );
--    d: entity work.decrypt
--         PORT MAP (
--            clk => clk,
--            rst => rst,
--            sizeM => to_unsigned(4, 8),
--            inQ => std_logic_vector(to_unsigned(23, 8)), 
--            inS => inS,
            
--            inU => inU,
--            inV => to_unsigned(22, 8),
--            outM => output,
--            ready => ready );

--    timing: process(clk) begin
--        if rising_edge(clk) then
--            if rst = '1' then
--              cycles <= 0;
--            elsif ready = '0' then
--              cycles <= cycles + 1;
--            end if;
--        end if;
--    end process;
    
--    process begin
--        wait for delay;
        
--        rst <= '1';
--        wait for delay;
--        rst <= '0';
--        wait until ready = '1';
        
--        wait;
    
--    end process;
    
--end Behavioral;
