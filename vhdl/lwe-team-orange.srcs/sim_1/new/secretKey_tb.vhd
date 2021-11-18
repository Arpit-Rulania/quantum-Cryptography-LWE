library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.commons.all;

entity secretVector_TB is
end secretVector_TB;

architecture Behavioral of secretVector_TB is
    SIGNAL clk: std_logic;
    SIGNAL rst: std_logic;
    
    SIGNAL ready: std_logic;
    SIGNAL secret: t_array (0 to 15);
    
    
    SIGNAL validRng : std_logic := '0';
    signal randomNum:  std_logic_vector (15 DOWNTO 0);
        
begin
    SecretToTest: entity work.secretVector 
        Generic MAP (
            i => 16
        )
        PORT MAP (
            clk => clk,
            rst => rst,
            randomNum => randomNum,
            validRng => validRng,
            output => secret,
            ready => ready
       );

    c: entity work.ClockProvider PORT MAP ( clk => clk );
    
    -- 'random' "readyness" generator
    rng_stub1: process begin

        wait until rising_edge(clk);
        validRng <= '0';

        wait until rising_edge(clk);
        validRng <= '0';

        wait until rising_edge(clk);
        validRng <= '1';

        wait until rising_edge(clk);
        validRng <= '0';

        wait until rising_edge(clk);
        validRng <= '1';

        wait until rising_edge(clk);
        validRng <= '1';

        wait until rising_edge(clk);
        validRng <= '0';

        wait until rising_edge(clk);
        validRng <= '0';

        wait until rising_edge(clk);
        validRng <= '0'; 
               
        wait until rising_edge(clk);
        validRng <= '0';

        wait until rising_edge(clk);
        validRng <= '0'; 
               

        wait until rising_edge(clk);
        validRng <= '1';
    end process;

    -- Pseudo-random generator
    rng_stub2: process begin
        wait until rising_edge(clk);
        randomNum <= std_logic_vector(to_unsigned(25723, randomNum'length));

        wait until rising_edge(clk);
        randomNum <= std_logic_vector(to_unsigned(38236, randomNum'length));

        wait until rising_edge(clk);
        randomNum <= std_logic_vector(to_unsigned(26337, randomNum'length));
        
        wait until rising_edge(clk);
        randomNum <= std_logic_vector(to_unsigned(1142, randomNum'length));

        wait until rising_edge(clk);
        randomNum <= std_logic_vector(to_unsigned(13396, randomNum'length));
        
        wait until rising_edge(clk);
        randomNum <= std_logic_vector(to_unsigned(50252, randomNum'length));

        wait until rising_edge(clk);
        randomNum <= std_logic_vector(to_unsigned(64594, randomNum'length));
    end process;

    Vector_proc: PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR 20 NS;
        rst <= '0';
        
        WAIT UNTIL ready = '1';
        WAIT FOR 400 NS;
        
        rst <= '1';
        WAIT;
    END PROCESS Vector_proc;

end Behavioral;
