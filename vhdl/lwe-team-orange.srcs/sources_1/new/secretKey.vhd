----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/05/2021 12:55:16 PM
-- Design Name: 
-- Module Name: rngnum - Behavioral
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

-- i = number of columns in A matrix
entity secretKey is
  Generic ( i : integer:=16);
  PORT (Clk, Rst: IN std_logic;
    secret: OUT t_array (0 to i-1);
    ready: OUT std_logic);
end secretKey;

architecture Behavioral of secretKey is
  component rngnum is
    PORT (Clk, Rst: IN std_logic;
      output: OUT std_logic_vector (15 DOWNTO 0));
      --readyOUT: OUT std_logic);
  end component;  
  
  SIGNAL a: std_logic_vector (15 DOWNTO 0);
  SIGNAL k: integer:= 0;
  SIGNAL isReady: std_logic:= '0';
  --SIGNAL randReady: std_logic;
    
begin
  
  ready <= isReady;
  Stage0: rngnum PORT MAP (Clk, Rst, a);
  getRand : process(a, k, Clk)
  begin
    -- On falling edge of Clk signal take value from RNG
    if k < i then
        if falling_edge(Clk) then
            secret(k) <= a;
            k <= k + 1;
        end if;
    else
        isReady <= '1';
    end if;
    
  end process getRand;

end Behavioral;
