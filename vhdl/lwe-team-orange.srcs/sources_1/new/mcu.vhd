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
        seed : in STD_LOGIC_VECTOR(31 downto 0)
    );
end mcu;

architecture Behavioral of mcu is
    type StateType is (GenerateA, GenerateSecret, GenerateB, Encrypt, Decrypt);
    signal State : StateType;
    
    
    signal q_value: std_logic_vector(15 downto 0) := "0101010110101101";
    -- TODO: Change this programmatically in the GenerateQ stage (To be created)
    
    -- Signals for rng
    signal rst_rng : std_logic;
    signal should_reseed_rng : std_logic;
    signal newseed_rng : std_logic_vector(31 downto 0);
    signal enable_rng : std_logic;
    signal valid_rng : std_logic;
    signal data_rng : std_logic_vector(15 downto 0);
    
    -- signals for secret key
    signal secretk : t_array; 
    signal secret_rst : std_logic; 
    signal secret_ready : std_logic; 
    
    -- The following is the spot A matrix is stored
    SIGNAL Asize: integer:= 0; -- IMPORTANT NOTE, THIS SIGNAL GOES UPTO 15 FOR NOW, WILL GO UP TO GIVEN GENERIC LATER. (generic is number of rows of A)
    signal Amatrix : amat_array (0 to 15); -- IMPORTANT NOTE CHANGE 15 TO SOME GENERIC LATER. IT IS 15 RN FOR TESTING PURPOSES.  
    signal secret_matrix : t_array; 
    
begin
    -- Place all module port map definitions up here!
    -- Instantiate rng component.
    inst_prng: entity work.xoroshiroRNG
        port map (
            clk              => clk,
            rst              => rst_rng,
            should_reseed    => should_reseed_rng,
            newseed          => newseed_rng,
            enable           => enable_rng,
            out_valid        => valid_rng,
            out_data         => data_rng
        );
 
    -- Instantitate secret key module.
    inst_seckey: entity work.secretKey
        generic map (
            i => 16,      -- i is the length of the row i.e. number of columns
            bitsize => 16 -- bitsize is the number of bits the number is made of.... make it a generic later or not???
        )
        port map (
            clk => clk, 
            rst => secret_rst,
            inQ => q_value,    
            randomNum => data_rng,
            validRng => valid_rng,
            secret => secretk,
            ready => secret_ready
        );
        
    -- Instantiate prime number generator module.
    inst_primenumgenz: entity work.primenumgen
        port map (
            Clk => clk,
            Rst => rst,
            index => data_rng,
            poutput => q_value 
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
                enable_rng <= '0';
                should_reseed_rng <= '0';
                newseed_rng <= (others => '0');
                
                State <= GenerateA;
                
                secret_rst <= rst;
                secret_matrix <= (others => (others => '0'));

                Amatrix <= (others => (others => (others => '0')));
                Asize <= 0;
            elsif should_reseed = '1' then
                -- Next four lines reset the rng module.
                rst_rng <= '0';
                should_reseed_rng <= '1';
                newseed_rng <= seed;
                enable_rng <= '0';
            else
                rst_rng <= '0';
                enable_rng <= '1';
                
                case State is
                    WHEN GenerateA =>
                        if Asize < 16 then   --- 16 SHOULD NOT BE HARDCODED IT IS THE NUMBER OF ROWS....................................................
                            secret_rst <= '0';
                            if secret_ready = '1' then
                                Amatrix(Asize) <= secretk;
                                Asize <= Asize + 1;
                                secret_rst <= '1';
                            end if;
                        else
                            State <= GenerateSecret;
                        end if;
                    
                    When GenerateSecret => 
                        secret_rst <= '0';
                        if secret_ready = '1' then
                            secret_rst <= '1';
                            State <= GenerateB;
                            secret_matrix <= secretK;
                        end if;

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
