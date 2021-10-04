----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.10.2021 00:25:02
-- Design Name: 
-- Module Name: multiply8 - Behavioral
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

entity multiply8 is
    Port ( in1 : in STD_LOGIC_VECTOR (7 downto 0);
           in2 : in STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (7 downto 0);
           ready : out STD_LOGIC);
end multiply8;

architecture Behavioral of multiply8 is

begin
    ent : ENTITY work.multiply
            GENERIC MAP (
              i => 8
            )
            PORT MAP (
              in1 => in1,
              in2 => in2,
              output => output,
              ready => ready
            );  
end Behavioral;
