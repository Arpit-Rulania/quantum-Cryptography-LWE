library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;
entity ApproxMulTB is

end ApproxMulTB;

architecture Behavioral of ApproxMulTB is

constant clkPeriod  : time := 100 ns;

signal r_clk   : std_logic := '0';
signal r_reset : std_logic := '0';
signal result : std_logic_vector(31 downto 0);
signal ready : std_logic;

component ApproxMul is
    port(
        clk : in std_logic;
        rst : in std_logic;
        in1    : in std_logic_vector(15 downto 0);
        in2    : in std_logic_vector(15 downto 0);
        output  : out std_logic_vector(31 downto 0);
        ready : out std_logic
        );
end component;
signal a : std_logic_vector(15 downto 0):="0000000001000010";
signal b : std_logic_vector(15 downto 0):="0000000000001011";

begin
   
    UUT: ApproxMul
    port map(
        clk => r_clk,
        rst => r_reset,
        in1 => a,
        in2 => b,
        output => result,
        ready => ready
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
