----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.10.2021 00:26:05
-- Design Name: 
-- Module Name: multiply - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiply is
    Generic ( i : integer );
    Port ( in1 : in STD_LOGIC_VECTOR(i-1 downto 0);
           in2 : in STD_LOGIC_VECTOR(i-1 downto 0);
           output : out STD_LOGIC_VECTOR(i-1 downto 0);
           ready : out STD_LOGIC);
end multiply;

architecture Behavioral of multiply is
    -- signal sum : integer from 0 to 2;
begin
    -- well...
    output <= std_logic_vector(unsigned(in1) * unsigned(in2));
    ready <= '1';

end Behavioral;
