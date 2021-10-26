library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rngnum is
    PORT (Clk, Rst: IN std_logic;
        output: OUT std_logic_vector (15 DOWNTO 0));
end rngnum;

architecture Behavioral of rngnum is
    SIGNAL Currstate, Nextstate, a, b, c: std_logic_vector (15 DOWNTO 0);
    SIGNAL feedback, ready: std_logic;
    component mod8 is
    Port ( clk : in std_logic; 
           rst : in std_logic;
           inQ : in STD_LOGIC_VECTOR (15 downto 0);
           input : in STD_LOGIC_VECTOR (15 downto 0);
           output : out STD_LOGIC_VECTOR (15 downto 0);
           ready : out std_logic
       );
    end component;
begin
    StateReg: PROCESS (Clk,Rst)
    BEGIN
        IF (Rst = '1') THEN
            Currstate <= (0 => '1', OTHERS =>'0');
            
        ELSIF (Clk = '1' AND Clk'EVENT) THEN
            Currstate <= Nextstate;
        END IF;
    END PROCESS;
    
    feedback <= Currstate(7) XOR Currstate(4) XOR Currstate(2) XOR Currstate(0);
    Nextstate <= feedback & Currstate(15 DOWNTO 1);
    --stage0: mod8 PORT MAP (Clk, Rst,"0100111000100000", Currstate, output, ready);
    output <= Currstate;

end Behavioral;