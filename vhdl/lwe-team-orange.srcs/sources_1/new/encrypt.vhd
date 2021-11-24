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
    Port ( clk : in std_logic;
           rst : in std_logic;
           inM : in std_logic; --bit to be encrypted.
           inQ : in std_logic_vector(15 downto 0);
           inA : in t_array;
           inB : in std_logic_vector(15 downto 0);
           outU : out t_array;
           outV : out std_logic_vector(15 downto 0);
           ready : out std_logic);
end encrypt;

architecture Behavioral of encrypt is
    signal modInput : std_logic_vector(15 downto 0);
    signal modReady : std_logic;
    signal qbytwo : std_logic_vector(15 downto 0) := (others => '0');
    signal outrdy : std_logic;
    signal vCalc : std_logic;
    signal tempModRst : std_logic;
    signal tempoutVal : std_logic_vector(15 downto 0);
    signal counter : integer := 0; 
    signal uArrt : t_array;
    signal incSig : std_logic := '1';
    type StateType is (
        a,b,c,d,e,f,g
    );
    signal State : StateType;

begin
    ready <= outrdy;       
        
    ModVComponent : ENTITY work.variableMod
        GENERIC MAP (
            i => 16
        )
        PORT MAP(
            clk => clk,
            rst => tempModRst,
            inQ => inQ,
            input => modInput,
            output => tempoutVal,
            ready => modReady
        );
    
    encrypt : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                tempModRst <= '1';
                outrdy <= '0';
                if inM = '1' then
                    modInput <= std_logic_vector(unsigned(inB(15 downto 0)) - unsigned('0' & inQ(15 downto 1)));
                elsif inM = '0' then
                    modInput <= inB;
                end if;
                vCalc <= '1';
            end if;
            if rst = '0' and vCalc = '1' then
                tempModRst <= '0';
                if modReady = '1' then
                    outV <= tempoutVal;
                    modInput <= inA(0);
                    vCalc <= '0';
                end if;
            end if;
            if rst = '0' and vCalc = '0' then
                case State is 
                    When a =>
                        if counter < A_width then
                            State <= b;
                        else 
                            State <= g;
                        end if;
                    When b =>
                        if modReady = '0' then
                            State <= c;
                        else 
                            State <= d; 
                        end if;
                    When c =>
                        tempModRst <= '0';
                        if modReady = '1' then
                            State <= d;
                        end if;
                    When d =>
                        uArrt(counter) <= tempoutVal;
                        State <= e;
                    When e =>
                        tempModRst <= '1';
                        State <= f;
                    When f =>
                        counter <= counter + 1;
                        modInput <= inA(counter);
                        State <= a;
                    When g =>
                        outU <= uArrt;
                        outrdy <= '1'; 
                end case;
            
            end if;
        end if;
    end process;
    
end Behavioral;
