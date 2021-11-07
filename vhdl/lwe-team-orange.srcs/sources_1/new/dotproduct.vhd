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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package pkg is
    type t_array is array (natural range <>) of std_logic_vector(15 downto 0);
end package;

package body pkg is
end package body;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.pkg.all;

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
        A : in t_array (0 to i-1);
        B : in t_array (0 to i-1);
        C : out std_logic_vector (15 downto 0);
        ready : out std_logic
    );
end dotproduct;

architecture Behavioral of dotproduct is
    
    -- Uses multiplication component
    component mulitply is
        Generic ( i : integer );
        Port (
            clk : in STD_LOGIC; 
            rst : in STD_LOGIC;
            in1 : in STD_LOGIC_VECTOR(i-1 downto 0);
            in2 : in STD_LOGIC_VECTOR(i-1 downto 0);
            output : out STD_LOGIC_VECTOR(i-1 downto 0);
            ready : out STD_LOGIC
        );
    end component;
    
    -- Signals for intermediate results
    signal mult_results: t_array (0 to i-1);
    signal mult_ready: std_logic_vector (0 to i-1);
    signal counter: integer;
    signal sum: unsigned(i-1 downto 0);
    
begin
    -- Generate multiple instances of the multiplication A
    -- Perform 16 simultaneous multiplications on the integers comprising the vector
    GEN_MULT:
    for n in 0 to i-1 generate
        MULT: mulitply
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
    
    RESET_PROCESS:
    process(rst)
    begin
        if rst = '1' then
            sum <= unsigned(0);
            counter <= 0;
            mult_results <= t_array(0);
            mult_ready <= std_logic_vector(0);
            ready <= '0';
        end if;
    end process;
    
    ADDITION:
    process(mult_ready)
    begin
        if counter = i then
            C <= std_logic_vector(sum);
            ready <= '1';
        elsif mult_ready(counter) = '1' then
            sum  <= sum + unsigned(mult_results(counter));
            counter <= counter + 1;
        end if;
    end process;

end Behavioral;
