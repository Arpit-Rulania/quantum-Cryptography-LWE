----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.10.2021 00:43:10
-- Design Name: 
-- Module Name: variableMod8 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity variableMod8 is
    Port ( clk : in std_logic; 
           rst : in std_logic;
           inQ : in STD_LOGIC_VECTOR (7 downto 0);
           input : in STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (7 downto 0);
           ready : out std_logic
       );
end variableMod8;

architecture Behavioral of variableMod8 is
    signal q_int : std_logic_vector(7 downto 0) := input;
    signal q_out : std_logic_vector(7 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_int <= (others => '0');
                q_out <= (others => '0');
            else
                if unsigned(q_int) > unsigned(inQ) then
                    q_int <= std_logic_vector(unsigned(q_int) - unsigned(inQ));
                    ready <= '0';
                else
                    q_out <= q_int;
                    ready <= '1';
                end if;
            end if;
        end if;
    end process;

end Behavioral;
