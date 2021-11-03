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
library ieee;
use ieee.std_logic_1164.all;
use work.commons.all;

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
        randomNum: IN std_logic_vector (15 DOWNTO 0);
        validRng : IN std_logic;
        secret: OUT t_array (0 to i-1);
        ready: OUT std_logic);
end secretKey;

architecture Behavioral of secretKey is  
  SIGNAL k: integer:= 0;
  SIGNAL isReady: std_logic:= '0';
    
begin
  
  ready <= isReady;
        
  getRand : process(randomNum, k, Rst, Clk, validRng)
  begin
    -- On falling edge of Clk signal take value from RNG
    if Rst = '1' then
        --clear the array.
    end if;
    
    if Rst = '0' then
        if k < i then
            if falling_edge(Clk) and validRng = '1' then
                secret(k) <= randomNum;
                k <= k + 1;
            end if;
        else
            isReady <= '1';
        end if;
    end if;    
  end process getRand;

end Behavioral;
