----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.10.2021 00:43:10
-- Design Name: 
-- Module Name: variableMod8 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity variableMod8 is
    Port ( clk : in std_logic; 
           rst : in std_logic;
           inQ : in STD_LOGIC_VECTOR (7 downto 0);
           input : in STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (7 downto 0);
           ready : out std_logic
       );
end variableMod8;

architecture Behavioral of variableMod8 is
    signal intermediate : unsigned(7 downto 0);
    signal q_out : std_logic_vector(7 downto 0) := (others => '0');
    signal isReady : std_logic := '0';
    
    signal scaled_q : unsigned(7 downto 0);
    signal hasScaled : boolean;
begin
    output <= q_out;
    ready <= isReady;
    
    process(clk)
    begin
    
        if rising_edge(clk) then
            if rst = '1' then
                scaled_q <= unsigned(inQ);
                intermediate <= unsigned(input);
                q_out <= (others => '0');
                isReady <= '0';
                hasScaled <= false;
            elsif isReady = '0' then
             
                -- OPTIMISATION - https://math.stackexchange.com/questions/3559467/how-is-calculating-the-modulus-using-this-formula-faster
                
                -- if mod 0
                ---- unfortunate.
                
                -- Unlikely that we'll get these
                if unsigned(inQ) = 1 then
                    -- X mod 1 = 0
                    q_out <= (others => '0');
                    isReady <= '1';
                elsif unsigned(inQ) = 2 then
                    -- X mod 2 = LSB
                    q_out <= "0000000" & input(0);
                    isReady <= '1';
                else
                if hasScaled = false and scaled_q < intermediate then
                        -- Left shift, multiply by two, arrange the bits
                        -- idk
                        scaled_q <= scaled_q(6 downto 0) & '0';
                    else 
                        hasScaled <= true;
    
                        if intermediate < unsigned(inQ) then
                            q_out <= std_logic_vector(intermediate);
                            isReady <= '1';
                        else
                            -- Subtract multiples of Q
                            if scaled_q <= intermediate then
                                -- The exit condition for hasScaled causes scaled_q >= intermediate
                                -- Ensure we only subtract if scaled_q intermediate
                                intermediate <= intermediate - scaled_q;
                            end if;
                            
                            scaled_q <= '0' & scaled_q(7 downto 1);                        
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
