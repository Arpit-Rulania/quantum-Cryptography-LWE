-- Dot product and modulo utility
-- NOTE: Multiplies an `i` vector with another `i` vector
-- Outputs a single value 

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use work.commons.all;

entity matrixmult is
  Generic (i : integer:=16);
  Port ( 
    clk : in std_logic;
    rst : in std_logic;
    inQ : in std_logic_vector (i-1 downto 0);
    inA : in t_array;
    inB : in t_array;
    output : out std_logic_vector (i-1 downto 0);
    ready : out std_logic
  );
end matrixmult;

architecture Behavioral of matrixmult is
  
  -- Create components for row multiplier
  -- 2 stages: inA & inB -> dotproduct -> modulo -> output
  signal dotReady : std_logic;
  signal dotOut : std_logic_vector (i-1 downto 0);
  
  signal rstReady : std_logic;
  signal rstMod : std_logic;
  
  signal rstMod_control : std_logic;
begin

  ready <= rstReady and not rst;
  rstMod_control <= rst or rstMod;

  MODRST:
  process (clk)
  begin
    if rising_edge(clk) then
        rstMod <= not dotReady;
    end if;
  end process;

  Stage1:
  entity work.dotproduct 
      generic map (i => i) 
      port map (
        clk => clk,
        rst => rst,
        A => inA,
        B => inB,
        inQ => inQ,
        C => dotOut,
        ready => dotReady
      );

  Stage2:
  entity work.variableMod 
      generic map (i => i)
      port map (
        clk => clk,
        rst => rstMod_control,
        inQ => inQ,
        input => dotOut,
        output => output,
        ready => rstReady
      );

end Behavioral;
