----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/05/2021 12:55:16 PM
-- Design Name: 
-- Module Name: rngnum - Behavioral
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
library work;
use work.pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- i = number of columns in A matrix
entity secretKey is
  Generic ( i : integer:=16);
  PORT (Clk, Rst: IN std_logic;
    secret: OUT t_array (0 to i-1);
    ready: OUT std_logic);
end secretKey;

architecture Behavioral of secretKey is
  
  component xoroshiroRNG is
    generic (
        init_seed:  std_logic_vector(31 downto 0):= "11011011001010101011011101101100" );
    port (
        clk:        in  std_logic; -- rising edge active.
        rst:        in  std_logic; -- active high.
        reseed:     in  std_logic; -- High to request re-seeding.
        newseed:    in  std_logic_vector(31 downto 0); -- New seed value for reseeding.
        out_ready:  in  std_logic;
        out_valid:  out std_logic;
        out_data:   out std_logic_vector(15 downto 0) );
    end component; 
  
  SIGNAL T: std_logic;
  SIGNAL a: std_logic_vector (15 DOWNTO 0):= (others=>'0');
  SIGNAL k: integer:= 0;
  SIGNAL isReady: std_logic:= '0';
  --SIGNAL randReady: std_logic;
  signal rst_rng: std_logic;
  signal reseed_rng:        std_logic;
  signal newseed_rng:       std_logic_vector(31 downto 0);
  signal ready_rng:         std_logic;
  signal valid_rng:         std_logic;
  --signal data_rng:          std_logic_vector(15 downto 0);
    
begin
  
  ready <= isReady;
  --Stage0: rngnum PORT MAP (Clk, Rst, a);
  inst_prng: entity work.xoroshiroRNG
        generic map (
            init_seed => "11011011001010101010011101101100" )
        port map (
            clk         => Clk,
            rst         => rst_rng,
            reseed      => reseed_rng,
            newseed     => newseed_rng,
            out_ready   => ready_rng,
            out_valid   => valid_rng,
            out_data    => a);
            
  getRand : process(a, k, Rst, Clk)
  begin
    -- On falling edge of Clk signal take value from RNG
    if Rst = '1' then
        rst_rng       <= '1';
        reseed_rng    <= '0';
        newseed_rng   <= (others => '0');
        ready_rng     <= '0';
    end if;
    
    if Rst = '0' then
        rst_rng <= '0';
        ready_rng <= '1';
    end if;
    
    if k < i then
        if falling_edge(Clk) and valid_rng = '1' then
            secret(k) <= a;
            k <= k + 1;
        end if;
    else
        isReady <= '1';
        ready_rng <= '0';
    end if;
    
  end process getRand;

end Behavioral;
