LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

ENTITY mcu_tb IS
END mcu_tb;

ARCHITECTURE Behavioral OF mcu_tb IS
    SIGNAL clk, rst, reseed : STD_LOGIC;
    SIGNAL seed : STD_LOGIC_VECTOR(31 DOWNTO 0) := std_logic_vector(to_unsigned(789623428, 32));
BEGIN

    c : ENTITY work.ClockProvider PORT MAP (clk => clk);

    inst_uut : ENTITY work.mcu
        PORT MAP (
            clk => clk,
            rst => rst,
            should_reseed => reseed,
            seed => seed
        );

    test_proc : PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR 20 NS;
        
        rst <= '0';
        ---FOR index IN 0 TO 4 LOOP
        --    WAIT UNTIL clk = '1' AND clk'EVENT;
        --END LOOP;
        --WAIT FOR 5 NS;
        --ASSERT output_s = X"88" REPORT "Failed output=88";
        WAIT;
    END PROCESS test_proc;

END Behavioral;