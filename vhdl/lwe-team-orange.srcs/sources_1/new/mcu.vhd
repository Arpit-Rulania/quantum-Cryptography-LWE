----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2021 06:18:11 PM
-- Design Name: 
-- Module Name: mcu - Behavioral
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
library work;
use work.commons.all;

-- Add external signals if nessesary.
entity mcu is
    Port ( mcuClk : in STD_LOGIC;
           mcuRst : in STD_LOGIC;
           mcuReseed : in STD_LOGIC;
           mcuNewseed : in STD_LOGIC_VECTOR(31 downto 0);
           mcuInit : in STD_LOGIC);
end mcu;

architecture Behavioral of mcu is
    -- State signals
    signal stepOne : std_logic;
    signal stepEncrypt : std_logic;
    signal stepDecrypt : std_logic;
    -- Signals for rng
    signal rst_rng : std_logic;
    signal reseed_rng : std_logic;
    signal newseed_rng : std_logic_vector(31 downto 0);
    signal ready_rng : std_logic;
    signal valid_rng : std_logic;
    signal data_rng : std_logic_vector(15 downto 0);
    -- signals for secret key
    signal secretk : t_array (0 to 15);  
    signal secret_ready : std_logic;    
         
begin
    -- Place all module port map definitions up here!
    -- Instantiate rng component.
    inst_prng: entity work.xoroshiroRNG
        generic map (
            init_seed => "11011011001010101010011101101100" )
        port map (
            clk         => mcuClk,
            rst         => rst_rng,
            reseed      => reseed_rng,
            newseed     => newseed_rng,
            out_ready   => ready_rng,
            out_valid   => valid_rng,
            out_data    => data_rng);
 
    -- Instantitate secret key module.
    inst_seckey: entity work.secretKey
        generic map (
            i => 16)
        port map (
            Clk => mcuClk, 
            Rst => mcuRst,
            randomNum => data_rng,
            validRng => valid_rng,
            secret => secretk,
            ready => secret_ready);
    
    -- This is the main reset for the mcu.
    -- If anything needs to be reset fully to 
    -- start over like the rng or secret key need 
    -- to be emptied, then chuck that here.
    rstProc: process(mcuRst)
    begin
        if mcuRst = '1' then
            -- Next four lines reset the rng module.
            rst_rng <= '1';
            reseed_rng <= '0';
            newseed_rng <= (others => '0');
            ready_rng <= '0';
        end if;
        if mcuRst = '0' then
            rst_rng <= '0';
        end if;
    end process rstProc;
    
    -- This process just reseeds the rng.
    reseedProc: process(mcuReseed)
    begin
        if mcuReseed = '1' then
            -- Next four lines reset the rng module.
            rst_rng <= '0';
            reseed_rng <= '1';
            newseed_rng <= mcuNewseed;
            ready_rng <= '0';
        end if;
    end process reseedProc;
    
    -- When everything needs to be initalied it happens here.
    -- For example the secret key and A matrix can be made here.
    -- once the two are made it will trigger the signal "stepOne".!!!!!!! IMPT
    -- Create a different process with an appropriate signal then
    -- to do the dot product and make the B matrix.
    initialiseProc: process(mcuInit)
    begin
        if mcuInit = '1' then
            ready_rng <= '1';
        else
            ready_rng <= '0';
        end if;
    end process initialiseProc;
    
    -- multiplication process trigerred by stepOne signal.
    -- once complete it will trigger stepEncrypt
    bMatrixProc: process(stepOne)
    begin
        --signals to activate multiplier.
    end process bMatrixProc;
    
    -- Encryption module goes here
    -- once complete it will trigger stepDecrypt
    encryptProc: process(stepEncrypt)
    begin
        --signals to activate encryption.
    end process encryptProc;
    
    -- Decryption module here.
    decryptProc: process(stepDecrypt)
    begin
        --signals to activate decryption.
    end process decryptProc;
    
end Behavioral;
