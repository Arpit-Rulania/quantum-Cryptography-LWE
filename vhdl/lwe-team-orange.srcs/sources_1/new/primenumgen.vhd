library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity primenumgen is
    PORT (Clk, Rst: IN std_logic;
        index: in std_logic_vector(15 downto 0);
        poutput: OUT std_logic_vector (15 DOWNTO 0));
end primenumgen;

architecture Behavioral of primenumgen is
    type t_Data is array (0 to 31) of std_logic_vector (15 DOWNTO 0);
    signal r_Data : t_Data := ("0000000000000010", "0000000000000011", "0000000000000101", "0000000000000111", 
                               "0000000000001011", "0000000000001101", "0000000000010001", "0000000000010011",
                               "0000000000010111", "0000000000011101", "0000000000011111", "0000000000100101",
                               "0000000000101001", "0000000000101111", "0000000000110101", "0000000000111011",
                               "0000000000111101", "0000000001000011", "0000000001000111", "0000000001001001",
                               "0000000001001111", "0000000001010011", "0000000001011001", "0000000001100001",
                               "0000000001100101", "0000000001100111", "0000000001101011", "0000000001101101",
                               "0000000001110001", "0000000001111111", "0000000010000011", "0000000010001001"
                                );
    --signal index_integer: integer;
begin
   -- index_integer <= to_integer(unsigned(index));
    --index_integer <= conv_integer(index);
    --index_integer <= to_integer(unsigned(index));
   -- index_integer <= index1;
    poutput <= r_Data(to_integer(unsigned(index(4 downto 0))));
end Behavioral;