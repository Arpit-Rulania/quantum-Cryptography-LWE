library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;
entity ApproxMulTB is

end ApproxMulTB;

architecture Behavioral of ApproxMulTB is

constant clkPeriod  : time := 100 ns;
------------------------------
signal r_clk   : std_logic := '0';
signal r_reset : std_logic := '0';
signal result : std_logic_vector(31 downto 0);
------------------------------
component ApproxMul is
    port(
        clk : in std_logic;
        rst : in std_logic;
        approxmul_in_a    : in std_logic_vector(15 downto 0);
        approxmul_in_b    : in std_logic_vector(15 downto 0);
        approxmul_result  : out std_logic_vector(31 downto 0)
        );
end component;
signal a : std_logic_vector(15 downto 0):="0000000111111111";
signal b : std_logic_vector(15 downto 0):="0000000000110101";

begin
   
    
    -- Instantiate the Unit Under Test (UUT)
    UUT: ApproxMul
    port map(
        clk => r_clk,
        rst => r_reset,
        approxmul_in_a => a,
        approxmul_in_b => b,
        approxmul_result => result
            );
    
    p_CLK_GEN : 
    process is
    begin
        wait for clkPeriod /2;
        r_clk <= not r_clk;
    end process p_CLK_GEN;
        
        
    p_RESET : process is
    begin
        r_reset <= '0';
        wait for 2*clkPeriod  ;
        r_reset <= '0';
        wait for 2*clkPeriod  ;
        r_reset <= '0';
        wait for 1 sec;
    end process;

end Behavioral;
