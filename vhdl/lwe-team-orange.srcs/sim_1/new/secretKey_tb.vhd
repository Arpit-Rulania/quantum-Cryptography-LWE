----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2021 12:36:39 AM
-- Design Name: 
-- Module Name: seck_tb - Behavioral
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

package pkg is
  type t_array is array (natural range <>) of std_logic_vector(15 downto 0);
end package;

package body pkg is
end package body;

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seck_tb is
end seck_tb;

architecture Behavioral of seck_tb is
    component secretKey is
        Generic ( i : integer );
        PORT (Clk, Rst: IN std_logic;
            secret: OUT t_array (0 to i-1);
            ready: OUT std_logic);
    end component;
    SIGNAL Clk_s, Rst_s: std_logic;
    SIGNAL output_s: std_logic_vector(15 DOWNTO 0);
    --SIGNAL poutput_s: std_logic_vector(15 DOWNTO 0);
    SIGNAL s_out: t_array (0 to 15);
    SIGNAL t_ready: std_logic;
    
begin
    SecretToTest: secretKey 
        Generic MAP (i => 16)
        PORT MAP (Clk_s, Rst_s, s_out, t_ready);

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
