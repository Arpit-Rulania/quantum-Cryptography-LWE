----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/05/2021 01:15:54 PM
-- Design Name: 
-- Module Name: rngnum_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rngnum_tb is
--  Port ( );
end rngnum_tb;

architecture Behavioral of rngnum_tb is
    COMPONENT rngnum IS
    PORT (Clk, Rst: IN std_logic;
          output: OUT std_logic_vector (15 DOWNTO 0));
    END COMPONENT;
    SIGNAL Clk_s, Rst_s: std_logic;
    SIGNAL output_s: std_logic_vector(15 DOWNTO 0);
    SIGNAL poutput_s: std_logic_vector(15 DOWNTO 0);
    COMPONENT primenumgen is
    PORT (Clk, Rst: IN std_logic;
        poutput: OUT std_logic_vector (15 DOWNTO 0));
    END COMPONENT;
begin
    CompToTest: rngnum PORT MAP (Clk_s, Rst_s, output_s);
    primetest: primenumgen PORT MAP (Clk_s, Rst_s, poutput_s);
 
    Clk_proc: PROCESS
    BEGIN
        Clk_s <= '1';
        WAIT FOR 10 ns;
        Clk_s <= '0';
        WAIT FOR 10 ns;
    END PROCESS clk_proc;
                      
    Vector_proc: PROCESS
    BEGIN
        Rst_s <= '1';
        WAIT FOR 5 NS;
        Rst_s <= '0';
        FOR index IN 0 To 4 LOOP
            WAIT UNTIL Clk_s='1' AND Clk_s'EVENT;
        END LOOP;
        WAIT FOR 5 NS;
        ASSERT output_s = X"88" REPORT "Failed output=88";
        WAIT;
    END PROCESS Vector_proc;

end Behavioral;
