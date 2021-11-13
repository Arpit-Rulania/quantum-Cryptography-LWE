----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2021 00:53:19
-- Design Name: 
-- Module Name: matrixmult - Behavioral
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

entity matrixmult is
  Generic (i : integer:=16);
  Port ( 
    clk : in std_logic;
    rst : in std_logic;
    inQ : in std_logic_vector (15 downto 0);
    rowA : in t_array (0 to i-1);
    secret : in t_array (0 to i-1);
    rowB : out std_logic_vector (15 downto 0);
    ready : out std_logic
  );
end matrixmult;

architecture Behavioral of matrixmult is
  
  -- Create components for row multiplier
  -- 2 stages: rowA & secret -> dotproduct -> modulo -> rowB
  component dotproduct is
    Generic ( i : integer := 16);
    Port (
      clk : in std_logic;
      rst : in std_logic;
      A : in t_array (0 to i-1);
      B : in t_array (0 to i-1);
      C : out std_logic_vector (15 downto 0);
      ready : out std_logic
    );
  end component;

  component variableMod is
    Generic ( i : integer := 16);
    Port (
      clk : in std_logic;
      rst : in std_logic;
      inQ : in std_logic_vector (i-1 downto 0);
      input : in std_logic_vector (i-1 downto 0);
      output : out std_logic_vector (i-1 downto 0);
      ready : out std_logic 
    );
  end component;

  signal dotReady : std_logic;
  signal dotOut : std_logic_vector (15 downto 0);

begin

  Stage1:
  dotproduct port map (
    clk,
    rst,
    rowA,
    secret,
    dotOut,
    dotReady
  );

  Stage2:
  variableMod port map (
    clk,
    not dotReady,
    inQ,
    dotOut,
    rowB,
    ready
  );

end Behavioral;
