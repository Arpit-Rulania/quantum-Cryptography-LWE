library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.numeric_std_unsigned.all;
USE IEEE.NUMERIC_STD.ALL;
library work;
use work.commons.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity encrypt is
    generic (A_width : integer:=16);
    Port ( Clock : in std_logic;
           Reset : in std_logic;
           M : in std_logic; --bit to be encrypted.
           inQ : in std_logic_vector(15 downto 0);
           sumA : in t_array;
           sumB : in std_logic_vector(15 downto 0);
           u : out t_array;
           v : out std_logic_vector(15 downto 0);
           encrypt_ready : out std_logic);
end encrypt;

architecture Behavioral of encrypt is
    signal modInput : std_logic_vector(15 downto 0);
    signal modOutput : std_logic_vector(15 downto 0);
    signal modReady : std_logic;
    signal modReset : std_logic;
    signal genReady : std_logic_vector(0 to A_width-1);
    signal qbytwo : std_logic_vector(15 downto 0) := (others => '0');
    signal sumBfiltered : std_logic_vector(15 downto 0);
    signal outrdy : std_logic;

begin
    encrypt_ready <= outrdy;

    GEN_MOD:
    for n in 0 to A_width-1 generate
        ModuloComponent : ENTITY work.variableMod
            GENERIC MAP (
                i => 16
            )
            PORT MAP(
                clk => Clock,
                rst => Reset,
                inQ => inQ,
                input => sumA(n),
                output => u(n),
                ready => genReady(n)
            );
    end generate GEN_MOD;        
        
    ModVComponent : ENTITY work.variableMod
        GENERIC MAP (
            i => 16
        )
        PORT MAP(
            clk => Clock,
            rst => Reset,
            inQ => inQ,
            input => modInput,
            output => v,
            ready => modReady
        );
    
    encrypt : process(Clock)
    begin
        if rising_edge(Clock) then
            if Reset = '1' then
                outrdy <= '0';
                if M = '1' then
                    qbytwo <= '0' & inQ(15 downto 1);   -- Q/2
                    --modInput <= sumB - qbytwo;              
                    --modInput <= std_logic_vector(unsigned(sumB(15 downto 0)) - unsigned(qbytwo(15 downto 0)));
                    modInput <= std_logic_vector(unsigned(sumB(15 downto 0)) - unsigned(qbytwo(15 downto 0)));
                elsif M = '0' then
                    modInput <= sumB;
                end if;
            elsif modReady = '1' and genReady(A_width - 1) = '1' then
                outrdy <= '1';
            end if;
        end if;
    end process;
    
end Behavioral;
