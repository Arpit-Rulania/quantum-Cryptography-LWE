library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity ApproxMul is
    port(
        clk : in std_logic;
        rst : in std_logic;
        approxmul_in_a    : in std_logic_vector(15 downto 0);
        approxmul_in_b    : in std_logic_vector(15 downto 0);
        approxmul_result  : out std_logic_vector(31 downto 0)
        );
end ApproxMul;

architecture Behavioral of ApproxMul is

    signal result: std_logic_vector(31 downto 0);
    signal zero : std_logic_vector(15 downto 0) := "0000000000000000";

    function position_of_leading_one (signal a: std_logic_vector) return integer is
        begin    
        for i in a'low to a'high loop
            if a(15 - i) = '1' then
                return 15 - i;
            end if;
        end loop;
        return -1;
    end function;
 begin
    Approx_Mul: process(rst)
    variable k1 : integer;
    variable k2 : integer;
    variable maxx : integer;
    variable minn : integer;
    variable diff : integer;
    variable fraction_a :std_logic_vector(15 downto 0):= "0000000000000000";
    variable fraction_b :std_logic_vector(15 downto 0):="0000000000000000";
    variable fraction_sum :std_logic_vector(15 downto 0):="0000000000000000";
    begin
        k1 := position_of_leading_one(approxmul_in_a);
        k2 := position_of_leading_one(approxmul_in_b);
        if k1 = 0 then 
            result <= zero(15 downto 0) & approxmul_in_b(15 downto 0);
        elsif k2 = 0 then                  
            result <= zero(15 downto 0) & approxmul_in_a(15 downto 0);
        end if;
        case k1 is
            when 15 => fraction_a (14 downto 0) := approxmul_in_a(14 downto 0);
            when 14 => fraction_a (13 downto 0) := approxmul_in_a(13 downto 0);
            when 13 => fraction_a (12 downto 0) := approxmul_in_a(12 downto 0);
            when 12 => fraction_a (11 downto 0) := approxmul_in_a(11 downto 0);
            when 11 => fraction_a (10 downto 0) := approxmul_in_a(10 downto 0);
            when 10 => fraction_a (9 downto 0) := approxmul_in_a(9 downto 0);
            when 9 => fraction_a (8 downto 0) := approxmul_in_a(8 downto 0);
            when 8 => fraction_a (7 downto 0) := approxmul_in_a(7 downto 0);
            when 7 => fraction_a (6 downto 0) := approxmul_in_a(6 downto 0);
            when 6 => fraction_a (5 downto 0) := approxmul_in_a(5 downto 0);
            when 5 => fraction_a (4 downto 0) := approxmul_in_a(4 downto 0);
            when 4 => fraction_a (3 downto 0) := approxmul_in_a(3 downto 0);
            when 3 => fraction_a (2 downto 0) := approxmul_in_a(2 downto 0);
            when 2 => fraction_a (1 downto 0) := approxmul_in_a(1 downto 0);
            when others => fraction_a (0) := approxmul_in_a(0);
        end case;
        
        case k2 is
            when 15 => fraction_b (14 downto 0) := approxmul_in_b(14 downto 0);
            when 14 => fraction_b (13 downto 0) := approxmul_in_b(13 downto 0);
            when 13 => fraction_b (12 downto 0) := approxmul_in_b(12 downto 0);
            when 12 => fraction_b (11 downto 0) := approxmul_in_b(11 downto 0);
            when 11 => fraction_b (10 downto 0) := approxmul_in_b(10 downto 0);
            when 10 => fraction_b (9 downto 0) := approxmul_in_b(9 downto 0);
            when 9 => fraction_b (8 downto 0) := approxmul_in_b(8 downto 0);
            when 8 => fraction_b (7 downto 0) := approxmul_in_b(7 downto 0);
            when 7 => fraction_b (6 downto 0) := approxmul_in_b(6 downto 0);
            when 6 => fraction_b (5 downto 0) := approxmul_in_b(5 downto 0);
            when 5 => fraction_b (4 downto 0) := approxmul_in_b(4 downto 0);
            when 4 => fraction_b (3 downto 0) := approxmul_in_b(3 downto 0);
            when 3 => fraction_b (2 downto 0) := approxmul_in_b(2 downto 0);
            when 2 => fraction_b (1 downto 0) := approxmul_in_b(1 downto 0);
            when others => fraction_b (0) := approxmul_in_b(0);
        end case;
        
        if k1 > k2 then
            maxx := k1;
            minn := k2;
            diff := k1 - k2;
            case diff is
                when 15 => fraction_b := fraction_b(0) & zero(14 downto 0);
                when 14 => fraction_b := fraction_b(1 downto 0) & zero(13 downto 0);
                when 13 => fraction_b := fraction_b(2 downto 0) & zero(12 downto 0);
                when 12 => fraction_b := fraction_b(3 downto 0) & zero(11 downto 0);
                when 11 => fraction_b := fraction_b(4 downto 0) & zero(10 downto 0);
                when 10 => fraction_b := fraction_b(5 downto 0) & zero(9 downto 0);
                when 9 => fraction_b := fraction_b(6 downto 0) & zero(8 downto 0);
                when 8 => fraction_b := fraction_b(7 downto 0) & zero(7 downto 0);
                when 7 => fraction_b := fraction_b(8 downto 0) & zero(6 downto 0);
                when 6 => fraction_b := fraction_b(9 downto 0) & zero(5 downto 0);
                when 5 => fraction_b := fraction_b(10 downto 0) & zero(4 downto 0);
                when 4 => fraction_b := fraction_b(11 downto 0) & zero(3 downto 0);
                when 3 => fraction_b := fraction_b(12 downto 0) & zero(2 downto 0);
                when 2 => fraction_b := fraction_b(13 downto 0) & zero(1 downto 0);
                when others => fraction_b := fraction_b(14 downto 0) & zero(0);
            end case;
        elsif  k1 < k2 then
            maxx := k2;
            minn := k1;
            diff := k2 - k1;
            case diff is
                when 15 => fraction_a := fraction_a(0) & zero(14 downto 0);
                when 14 => fraction_a := fraction_a(1 downto 0) & zero(13 downto 0);
                when 13 => fraction_a := fraction_a(2 downto 0) & zero(12 downto 0);
                when 12 => fraction_a := fraction_a(3 downto 0) & zero(11 downto 0);
                when 11 => fraction_a := fraction_a(4 downto 0) & zero(10 downto 0);
                when 10 => fraction_a := fraction_a(5 downto 0) & zero(9 downto 0);
                when 9 => fraction_a := fraction_a(6 downto 0) & zero(8 downto 0);
                when 8 => fraction_a := fraction_a(7 downto 0) & zero(7 downto 0);
                when 7 => fraction_a := fraction_a(8 downto 0) & zero(6 downto 0);
                when 6 => fraction_a := fraction_a(9 downto 0) & zero(5 downto 0);
                when 5 => fraction_a := fraction_a(10 downto 0) & zero(4 downto 0);
                when 4 => fraction_a := fraction_a(11 downto 0) & zero(3 downto 0);
                when 3 => fraction_a := fraction_a(12 downto 0) & zero(2 downto 0);
                when 2 => fraction_a := fraction_a(13 downto 0) & zero(1 downto 0);
                when others => fraction_a := fraction_a(14 downto 0) & zero(0);
            end case;
        else
            maxx:= k1;
            minn:= k1;
        end if;
        fraction_sum := fraction_a + fraction_b;
        
        if fraction_sum(maxx) = '0' then 
            fraction_sum(maxx) := '1';
            case minn is
                when 15 => result <= zero(0) & fraction_sum(15 downto 0) & zero(14 downto 0);
                when 14 => result <= zero(1 downto 0) & fraction_sum(15 downto 0) & zero(13 downto 0);
                when 13 => result <= zero(2 downto 0) & fraction_sum(15 downto 0) & zero(12 downto 0);
                when 12 => result <= zero(3 downto 0) & fraction_sum(15 downto 0) & zero(11 downto 0);
                when 11 => result <= zero(4 downto 0) & fraction_sum(15 downto 0) & zero(10 downto 0);
                when 10 => result <= zero(5 downto 0) & fraction_sum(15 downto 0) & zero(9 downto 0);
                when 9 => result <= zero(6 downto 0) & fraction_sum(15 downto 0) & zero(8 downto 0);
                when 8 => result <= zero(7 downto 0) & fraction_sum(15 downto 0) & zero(7 downto 0);
                when 7 => result <= zero(8 downto 0) & fraction_sum(15 downto 0) & zero(6 downto 0);
                when 6 => result <= zero(9 downto 0) & fraction_sum(15 downto 0) & zero(5 downto 0);
                when 5 => result <= zero(10 downto 0) & fraction_sum(15 downto 0) & zero(4 downto 0);
                when 4 => result <= zero(11 downto 0) & fraction_sum(15 downto 0) & zero(3 downto 0);
                when 3 => result <= zero(12 downto 0) & fraction_sum(15 downto 0) & zero(2 downto 0);
                when 2 => result <= zero(13 downto 0) & fraction_sum(15 downto 0) & zero(1 downto 0);
                when others => result <= zero(14 downto 0) & fraction_sum(15 downto 0) & zero(0);
            end case;
        else
            case minn is
                when 14 => result <= zero(0) & fraction_sum(15 downto 0) & zero(14 downto 0);
                when 13 => result <= zero(1 downto 0) & fraction_sum(15 downto 0) & zero(13 downto 0);
                when 12 => result <= zero(2 downto 0) & fraction_sum(15 downto 0) & zero(12 downto 0);
                when 11 => result <= zero(3 downto 0) & fraction_sum(15 downto 0) & zero(11 downto 0);
                when 10 => result <= zero(4 downto 0) & fraction_sum(15 downto 0) & zero(10 downto 0);
                when 9 => result <= zero(5 downto 0) & fraction_sum(15 downto 0) & zero(9 downto 0);
                when 8 => result <= zero(6 downto 0) & fraction_sum(15 downto 0) & zero(8 downto 0);
                when 7 => result <= zero(7 downto 0) & fraction_sum(15 downto 0) & zero(7 downto 0);
                when 6 => result <= zero(8 downto 0) & fraction_sum(15 downto 0) & zero(6 downto 0);
                when 5 => result <= zero(9 downto 0) & fraction_sum(15 downto 0) & zero(5 downto 0);
                when 4 => result <= zero(10 downto 0) & fraction_sum(15 downto 0) & zero(4 downto 0);
                when 3 => result <= zero(11 downto 0) & fraction_sum(15 downto 0) & zero(3 downto 0);
                when 2 => result <= zero(12 downto 0) & fraction_sum(15 downto 0) & zero(2 downto 0);
                when others => result <= zero(13 downto 0) & fraction_sum(15 downto 0) & zero(1 downto 0);
            end case;
        end if;
    end process;
    approxmul_result <= result;
end Behavioral;