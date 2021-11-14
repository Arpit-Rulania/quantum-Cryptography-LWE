----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2021 16:44:55
-- Design Name: 
-- Module Name: dotproduct - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.commons.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dotproduct is
    Generic ( i : integer:= 16);
    Port (
        clk: in std_logic;
        rst: in std_logic;
        A : in t_array;
        B : in t_array;
        C : out std_logic_vector (15 downto 0);
        ready : out std_logic
    );
end dotproduct;

architecture Behavioral of dotproduct is
    
    -- Uses multiplication component
--    component mulitply is
--        Generic ( i : integer );
--        Port (
--            clk : in STD_LOGIC; 
--            rst : in STD_LOGIC;
--            in1 : in STD_LOGIC_VECTOR(i-1 downto 0);
--            in2 : in STD_LOGIC_VECTOR(i-1 downto 0);
--            output : out STD_LOGIC_VECTOR(i-1 downto 0);
--            ready : out STD_LOGIC
--        );
--    end component;
    
    -- Signals for intermediate results
    signal mult_results: t_array;
    signal mult_ready: std_logic_vector (0 to i-1);
    signal counter: integer := 0;
    signal sum: unsigned(i-1 downto 0) := to_unsigned(0, i);
    
begin
    -- Generate multiple instances of the multiplication A
    -- Perform 16 simultaneous multiplications on the integers comprising the vector
    GEN_MULT:
    for n in 0 to i-1 generate
        MULT: entity work.multiply
            Generic MAP (i => 16)
            Port MAP (
                clk,
                rst,
                A(n),
                B(n),
                mult_results(n),
                mult_ready(n)
            );
    end generate GEN_MULT;
    
    ADDITION:
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sum <= to_unsigned(0, 16);
                counter <= 0;
--                mult_results <= (others => (others => '0'));
--                mult_ready <= (others => '0');
                ready <= '0';
            elsif counter = i then
                C <= std_logic_vector(sum);
                ready <= '1';
            elsif mult_ready(counter) = '1' then
                sum  <= sum + unsigned(mult_results(counter));
                counter <= counter + 1;
            end if;
        end if;     
    end process;

end Behavioral;
