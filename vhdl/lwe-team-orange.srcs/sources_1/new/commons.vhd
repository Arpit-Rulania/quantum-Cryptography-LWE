library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



package commons is

 
  constant c_PIXELS : integer := 65536;
 
 type arr is array(0 to 3) of integer;    

 
--  function Bitwise_AND (
--    i_vector : in std_logic_vector(3 downto 0))
--    return std_logic;
   
end package commons;
 
---- Package Body Section
--package body example_package is
 
--  function Bitwise_AND (
--    i_vector : in std_logic_vector(3 downto 0)
--    )
--    return std_logic is
--  begin
--    return (i_vector (0) and i_vector (1) and i_vector (2) and i_vector (3));
--  end;
 
--end package body example_package;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package commonss is
  type t_array is array (natural range <>) of std_logic_vector(15 downto 0);
end package commonss;
