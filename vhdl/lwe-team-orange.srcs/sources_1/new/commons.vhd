library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



package commons is
  --type t_array is array (natural range <>) of std_logic_vector(15 downto 0);
  type t_array is array (0 to 15) of std_logic_vector(15 downto 0);
  
  --type d_array is array (0 to 15) of std_logic_vector(15 downto 0);
  type amat_array is array (natural range <>) of t_array; --<------
end package commons;
