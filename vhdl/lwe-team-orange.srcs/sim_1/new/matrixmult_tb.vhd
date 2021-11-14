----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2021 23:01:43
-- Design Name: 
-- Module Name: matrixmult_tb - Behavioral
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

entity matrixmult_tb is
--  Port ( );
end matrixmult_tb;

architecture Behavioral of matrixmult_tb is
    component matrixmult is
    Generic ( i : integer:= 16);
    Port (
      clk : in std_logic;
      rst : in std_logic;
      inQ : in std_logic_vector (15 downto 0);
      rowA : in t_array;
      secret : in t_array;
      rowB : out std_logic_vector (15 downto 0);
      ready : out std_logic
    );
    end component;
    
    SIGNAL Clk_s, Rst_s: std_logic;
    SIGNAL output_s: std_logic_vector(15 DOWNTO 0);
    SIGNAL in1: t_array;
    SIGNAL in2: t_array;
    SIGNAL Q: std_logic_vector (15 downto 0);
    SIGNAL t_ready: std_logic;
    
begin
    CompToTest: matrixmult 
--    generic map (i => 16)
    port map (
        Clk_s,
        Rst_s,
        Q,
        in1,
        in2,
        output_s,
        t_ready
    );
    
    Clk_proc: PROCESS
    BEGIN
        Clk_s <= '1';
        WAIT FOR 10 ns;
        Clk_s <= '0';
        WAIT FOR 10 ns;
    END PROCESS clk_proc;
    
    -- Set up input
    -- Q
    Q <= std_logic_vector(to_unsigned(4651,16));

    -- Input 1:
    in1(0) <= std_logic_vector(to_unsigned(20, 16));
    in1(1) <= std_logic_vector(to_unsigned(15, 16));
    in1(2) <= std_logic_vector(to_unsigned(7, 16));
    in1(3) <= std_logic_vector(to_unsigned(6, 16));
    in1(4) <= std_logic_vector(to_unsigned(36, 16));
    in1(5) <= std_logic_vector(to_unsigned(33, 16));
    in1(6) <= std_logic_vector(to_unsigned(1, 16));
    in1(7) <= std_logic_vector(to_unsigned(9, 16));
    in1(8) <= std_logic_vector(to_unsigned(22, 16));
    in1(9) <= std_logic_vector(to_unsigned(10, 16));
    in1(10) <= std_logic_vector(to_unsigned(8, 16));
    in1(11) <= std_logic_vector(to_unsigned(25, 16));
    in1(12) <= std_logic_vector(to_unsigned(0, 16));
    in1(13) <= std_logic_vector(to_unsigned(18, 16)); 
    in1(14) <= std_logic_vector(to_unsigned(2, 16));
    in1(15) <= std_logic_vector(to_unsigned(27, 16));
    
    -- Input 2:
    in2(0) <= std_logic_vector(to_unsigned(33, 16));
    in2(1) <= std_logic_vector(to_unsigned(37, 16));
    in2(2) <= std_logic_vector(to_unsigned(5, 16));
    in2(3) <= std_logic_vector(to_unsigned(37, 16));
    in2(4) <= std_logic_vector(to_unsigned(25, 16));
    in2(5) <= std_logic_vector(to_unsigned(3, 16));
    in2(6) <= std_logic_vector(to_unsigned(11, 16));
    in2(7) <= std_logic_vector(to_unsigned(22, 16));
    in2(8) <= std_logic_vector(to_unsigned(39, 16));
    in2(9) <= std_logic_vector(to_unsigned(39, 16));
    in2(10) <= std_logic_vector(to_unsigned(6, 16));
    in2(11) <= std_logic_vector(to_unsigned(39, 16));
    in2(12) <= std_logic_vector(to_unsigned(39, 16));
    in2(13) <= std_logic_vector(to_unsigned(19, 16)); 
    in2(14) <= std_logic_vector(to_unsigned(32, 16));
    in2(15) <= std_logic_vector(to_unsigned(5, 16));
    
    Matrixmult_proc: process
    begin
        Rst_s <= '1';
        wait for 30 ns;
        Rst_s <= '0';
        wait;
    end process Matrixmult_proc;

end Behavioral;
