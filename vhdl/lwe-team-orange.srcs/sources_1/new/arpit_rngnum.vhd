----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/05/2021 12:55:16 PM
-- Design Name: 
-- Module Name: rngnum - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
--            a <= not(not(not(not(not("0000100000000100")))));
--            b <= not(not(not(not(not("1001000001000100")))));
--            c <= not(not(not(not(not("0100110000100001")))));
            Currstate <= (0 => '1', OTHERS =>'0');
            
        ELSIF (Clk = '1' AND Clk'EVENT) THEN
            Currstate <= Nextstate;
        END IF;
    END PROCESS;
    
--    feedback <= Currstate(7) XOR Currstate(4) XOR Currstate(2) XOR Currstate(0);
    feedback <= Currstate(7) XOR Currstate(4) XOR Currstate(2) XOR Currstate(0);
    Nextstate <= feedback & Currstate(15 DOWNTO 1);
    --stage0: mod8 PORT MAP (Clk, Rst,"0100111000100000", Currstate, output, ready);
    output <= Currstate;
--    lessrng: PROCESS
--    BEGIN
--        IF (Currstate < "1000000011101000") THEN
--            output <= Currstate;
--        END IF;
--    END PROCESS;
    
--    selector: PROCESS (Rst)
--    BEGIN
--        IF (Rst = '1') THEN
--            output <= "0000000000000000";
--        ELSE
--            output <= Currstate;
--        END IF;
--    END PROCESS;
