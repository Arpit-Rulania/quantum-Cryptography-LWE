----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/09/2021 07:00:53 PM
-- Design Name: 
-- Module Name: primenumgen - Behavioral
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

entity primenumgen is
    PORT (Clk, Rst: IN std_logic;
        poutput: OUT std_logic_vector (15 DOWNTO 0));
end primenumgen;

architecture Behavioral of primenumgen is
    type t_Data is array (0 to 3) of std_logic_vector (15 DOWNTO 0);
    signal r_Data : t_Data := ("0000000000000010", "0000000000000011", "0000000000000101", "0000000000000111");
begin
    poutput <= r_Data(1);
end Behavioral;
