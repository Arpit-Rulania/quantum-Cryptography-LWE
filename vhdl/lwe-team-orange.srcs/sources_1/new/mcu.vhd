library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.commons.all;

-- Add external signals if nessesary.
entity mcu is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        should_reseed : in STD_LOGIC;
        seed : in STD_LOGIC_VECTOR(31 downto 0);
        init : in STD_LOGIC
    );
end mcu;

architecture Behavioral of mcu is
    type StateType is (Initialise, GenerateB, Encrypt, Decrypt);
    signal State : StateType;
    
    -- Signals for rng
    signal rst_rng : std_logic;
    signal should_reseed_rng : std_logic;
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
            init_seed => "11011011001010101010011101101100" ---- TODO:
        )
        port map (
            clk              => clk,
            rst              => rst_rng,
            should_reseed    => should_reseed_rng,
            newseed          => newseed_rng,
            out_ready        => ready_rng,
            out_valid        => valid_rng,
            out_data         => data_rng
        );
 
    -- Instantitate secret key module.
    inst_seckey: entity work.secretKey
        generic map (
            i => 16
        )
        port map (
            clk => clk, 
            rst => rst,
            ready => secret_ready,
            
            randomNum => data_rng,
            validRng => valid_rng,

            secret => secretk
        );
    

    main: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- This is the main reset for the mcu.
                -- If anything needs to be reset fully to 
                -- start over like the rng or secret key need 
                -- to be emptied, the next four lines reset the rng module.
                rst_rng <= rst;
                should_reseed_rng <= '0';
                newseed_rng <= (others => '0');
                ready_rng <= '0';
                State <= Initialise;
            elsif should_reseed = '1' then
                -- Next four lines reset the rng module.
                rst_rng <= '0';
                should_reseed_rng <= '1';
                newseed_rng <= seed;
                ready_rng <= '0';
            else
                case State is
                    -- When everything needs to be initalised it happens here.
                    -- For example the secret key and A matrix can be made here.
                    -- once the two are made it will trigger the signal "stepOne".!!!!!!! IMPT
                    -- Create a different process with an appropriate signal then
                    -- to do the dot product and make the B matrix.
                    WHEN Initialise =>
                        if init = '1' then
                            ready_rng <= '1';
                        else
                            ready_rng <= '0';
                        end if;


                    -- multiplication process trigerred by stepOne signal.
                    -- once complete it will trigger stepEncrypt
                    WHEN GenerateB =>
                        --signals to activate multiplier.

                    -- Encryption module goes here
                    -- once complete it will trigger stepDecrypt
                    WHEN Encrypt =>
                        --signals to activate encryption.

                    -- Decryption module here.
                    WHEN Decrypt =>
                      --signals to activate decryption.
                end case;
            end if;
        end if;

    end process;
end Behavioral;
