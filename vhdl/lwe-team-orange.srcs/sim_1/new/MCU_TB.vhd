LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mcu_tb IS
END mcu_tb;

ARCHITECTURE Behavioral OF mcu_tb IS
    SIGNAL clk, rst, reseed, init : STD_LOGIC;
    SIGNAL nseed : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

    inst_uut : ENTITY work.mcu
        PORT MAP(
            mcuClk => clk,
            mcuRst => rst,
            mcuReseed => reseed,
            mcuNewseed => nseed,
            mcuInit => init
        );

    c : ENTITY work.ClockProvider PORT MAP (clk => clk);

    test_proc : PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR 5 NS;
        rst <= '0';
        init <= '1';
        FOR index IN 0 TO 4 LOOP
            WAIT UNTIL clk = '1' AND clk'EVENT;
        END LOOP;
        WAIT FOR 5 NS;
        --ASSERT output_s = X"88" REPORT "Failed output=88";
        WAIT;
    END PROCESS test_proc;

END Behavioral;