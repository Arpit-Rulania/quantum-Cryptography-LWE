----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/09/26 07:06:07
-- Design Name: 
-- Module Name: RNG - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rng is
    generic ( data_width:natural:= 8);
    Port ( clk : in std_logic;
            reset: in std_logic;
            data_out: out unsigned(data_width - 1 downto 0)
            );
end rng;

architecture Behavioral of rng is
    signal feedback: std_logic;
    signal reg: unsigned(data_width - 1 downto 0);
begin
   -- reg <= (others => '0');
    feedback <= reg(7) xor reg(0);
    latch: process(clk, reset)
    begin
        if(reset = '1') then
            --reg <= (others => '0');
            reg <= "00000001";
        elsif (clk = '1' and clk'event) then
            reg <= reg(reg'high - 1 downto 0) & feedback;
        end if;
    end process;
    output: process(clk)
    begin
        if(clk = '1' and clk'event) then
            if(reg(7) = '0') then
                data_out <= reg;
            end if;
        end if;
    end process;
end Behavioral;

