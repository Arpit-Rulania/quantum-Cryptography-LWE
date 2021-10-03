----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/09/26 07:22:49
-- Design Name: 
-- Module Name: RNG_TB - Behavioral
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

entity RNG_TB is
--  Port ( );
end RNG_TB;

architecture Behavioral of RNG_TB is
    component rng
        generic ( data_width:natural:= 8);
        Port ( clk : in std_logic;
            reset: in std_logic;
            data_out: out unsigned(data_width - 1 downto 0)
            );
    end component;
    constant clk_period : time := 10 ns;
    signal data_1: unsigned(7 downto 0);
    --signal data_2: unsigned(7 downto 0);
   --signal data_3: unsigned(7 downto 0);
    --signal data_4: unsigned(7 downto 0);
   -- signal data_5: unsigned(7 downto 0);
    signal clk: std_logic;
    signal reset: std_logic;
begin
    uut1: rng port map ( 
        clk => clk,
        data_out => data_1,
        reset => reset
        );
    clk_process  : process is
        variable sum: natural:= 0;
    begin
       clk <= '0';
       sum := sum + 1;
       reset <= '1';
       if (sum > 2) then
           reset <= '0';
       end if;
       wait for clk_period/2;
       clk <= '1';
       sum := sum + 1;
       reset <= '1';
       if (sum > 2) then
           reset <= '0';
       end if;
       wait for clk_period/2;
    end process;
    
  --  reset_process  : process is
  --  begin
    --    reset <= '1';
    --    wait for clk_period*2;
     --   reset <= '0';
       -- wait for clk_period*2;
   -- end process;
end Behavioral;
