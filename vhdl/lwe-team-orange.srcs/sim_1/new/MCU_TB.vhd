library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mcu_tb is
end mcu_tb;

architecture Behavioral of mcu_tb is
    SIGNAL clk, rst, reseed, init: std_logic;
    Signal nseed : std_logic_vector(31 downto 0);
    
    
begin

    inst_uut: entity work.mcu
    port map (
        mcuClk => clk,
        mcuRst => rst,
        mcuReseed => reseed,
        mcuNewseed => nseed,
        mcuInit => init
    );

    c: entity work.ClockProvider PORT MAP ( clk => clk );
    
    test_proc: PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR 5 NS;
        rst <= '0';
        init <= '1';
        FOR index IN 0 To 4 LOOP
            WAIT UNTIL clk='1' AND clk'EVENT;
        END LOOP;
        WAIT FOR 5 NS;
        --ASSERT output_s = X"88" REPORT "Failed output=88";
        WAIT;
    END PROCESS test_proc;
    
end Behavioral;
