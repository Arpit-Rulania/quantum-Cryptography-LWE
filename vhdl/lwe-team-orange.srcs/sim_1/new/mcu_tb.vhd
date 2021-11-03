----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/03/2021 06:48:41 PM
-- Design Name: 
-- Module Name: mcu_tb - Behavioral
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

entity mcu_tb is
end mcu_tb;

architecture Behavioral of mcu_tb is
    SIGNAL Clk_s, Rst_s, reseedd, mcuinitt: std_logic;
    Signal nseed : std_logic_vector(31 downto 0);
    
    
begin

    inst_muc: entity work.mcu
    port map (
        mcuClk => Clk_s,
        mcuRst => Rst_s,
        mcuReseed => reseedd,
        mcuNewseed => nseed,
        mcuInit => mcuinitt
    );

    Clk_proc: PROCESS
    BEGIN
        Clk_s <= '1';
        WAIT FOR 10 ns;
        Clk_s <= '0';
        WAIT FOR 10 ns;
    END PROCESS clk_proc;
    
    test_proc: PROCESS
    BEGIN
        Rst_s <= '1';
        WAIT FOR 5 NS;
        Rst_s <= '0';
        mcuinitt <= '1';
        FOR index IN 0 To 4 LOOP
            WAIT UNTIL Clk_s='1' AND Clk_s'EVENT;
        END LOOP;
        WAIT FOR 5 NS;
        --ASSERT output_s = X"88" REPORT "Failed output=88";
        WAIT;
    END PROCESS test_proc;
    
end Behavioral;
