library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rngnum_tb is
--  Port ( );
end rngnum_tb;

architecture Behavioral of rngnum_tb is
    constant clk_period : time := 10 ns;
    COMPONENT rngnum IS
    PORT (Clk, Rst: IN std_logic;
          output: OUT std_logic_vector (15 DOWNTO 0));
    END COMPONENT;
    SIGNAL Clk, Rst: std_logic;
    SIGNAL output_s: std_logic_vector(15 DOWNTO 0);
    SIGNAL poutput_s: std_logic_vector(15 DOWNTO 0);
    COMPONENT primenumgen is
    PORT (Clk, Rst: IN std_logic;
        index: in std_logic_vector(15 downto 0);
        poutput: OUT std_logic_vector (15 DOWNTO 0));
    END COMPONENT;
begin
    CompToTest: rngnum PORT MAP (Clk, Rst, output_s);
    primetest: primenumgen PORT MAP (Clk, Rst, output_s, poutput_s);
 
--    Clk_proc: PROCESS
--    BEGIN
--        Clk_s <= '1';
--        WAIT FOR 10 ns;
--        Clk_s <= '0';
--        WAIT FOR 10 ns;
--    END PROCESS clk_proc;
                      
--    Vector_proc: PROCESS
--    BEGIN
--        Rst_s <= '1';
--        WAIT FOR 5 NS;
--        Rst_s <= '0';
--        FOR index IN 0 To 4 LOOP
--            WAIT UNTIL Clk_s='1' AND Clk_s'EVENT;
--        END LOOP;
--        WAIT FOR 5 NS;
--        ASSERT output_s = X"88" REPORT "Failed output=88";
--        WAIT;
--    END PROCESS Vector_proc;

    clk_process  : process is
        variable sum: natural:= 0;
    begin
       Clk <= '0';
       sum := sum + 1;
       Rst <= '1';
       if (sum > 2) then
           Rst <= '0';
       end if;
       wait for clk_period/2;
       Clk <= '1';
       sum := sum + 1;
       Rst <= '1';
       if (sum > 2) then
           Rst <= '0';
       end if;
       wait for clk_period/2;
    end process;
    
end Behavioral;