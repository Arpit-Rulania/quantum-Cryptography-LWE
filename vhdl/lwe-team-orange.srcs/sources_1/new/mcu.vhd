library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

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
    type StateType is (
        GenerateQ,
        GenerateA, GenerateSecret, GenerateErrorMatrix,
        GenerateB, GenerateB_post_setup, GenerateB_post,
        
        Idle, -- Idle
        Encrypt, Decrypt -- Execution
    );
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
    
    -- Signals for q value selection
    signal q_ready : std_logic;
    signal q_rst : std_logic;
    signal q_enable : std_logic;
    
    -- signals for secret key
    signal secret_output : t_array; -- intermediate signal; gets stored into secret_matrix on completion
    signal secret_rst : std_logic; 
    signal secret_ready : std_logic; 
    
    -- signals for matrix mult
    signal mult_rst : std_logic;
    signal mult_out : std_logic_vector(15 downto 0);
    signal mult_ready : std_logic;
    signal mult_inA: t_array;
    signal mult_inB: t_array;
    
    -- signals for error matrix generator
    signal errorGen_ready : std_logic;
    signal errorGen_value : integer;
    
    -- signals for modulo unit
    signal mod_rst: std_logic;
    signal mod_input: std_logic_vector(15 downto 0);
    signal mod_output: std_logic_vector(15 downto 0);
    signal mod_ready: std_logic;
    
    signal Amatrix : amat_array (0 to 15); -- IMPORTANT NOTE CHANGE 15 TO SOME GENERIC LATER. IT IS 15 RN FOR TESTING PURPOSES.
    signal Bmatrix : t_array;  
    signal secret_key : t_array;
    
    signal rowCounter : integer := 0;
    
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
 
    -- Instantitate secret vector generation module.
    inst_secvector: entity work.secretVector
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
            output => secret_output,
            ready => secret_ready
        );
        
    -- Instantiate prime number lookup module.
    inst_primelookup: entity work.primeLookup
        port map (
            clk => clk,
            rst => q_rst,
            enable => q_enable,
            index => data_rng,
            ready => q_ready,
            output => q_value 
        );
        
    -- Instantiate matrixmult module.
    inst_mmult: entity work.matrixmult
        port map (
            clk => clk,
            rst => mult_rst,
            inQ => q_value,
            inA => mult_inA,
            inB => mult_inB,
            output  => mult_out,
            ready => mult_ready
        );
    
    inst_errMtx: entity work.errormatrixgen
        port map (
            clk => clk,
            rst => rst,
            ready => errorGen_ready,
            error_normalised => errorGen_value
        );
    
    inst_mod: entity work.variableMod
        generic map (i => 16)
        port map (
            clk => clk,
            rst => mod_rst,
            inQ => q_value,
            input => mod_input,
            output => mod_output,
            ready => mod_ready
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
                
                State <= GenerateQ;
                
                secret_rst <= rst;
                secret_key <= (others => (others => '0'));
                
                Bmatrix <= (others => (others => '0'));
                Amatrix <= (others => (others => (others => '0')));
                
                mult_inA <= (others => (others => '0'));
                mult_inB <= (others => (others => '0'));
                
                mod_rst <= '1';
                
                mult_rst <= '1';
                
                q_rst <= '1';
                q_enable <= '0'; -- Enabled during GenerateQ               
                
                rowCounter <= 0;
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
                    WHEN GenerateQ =>
                        q_rst <= '0';                         
                        if valid_rng = '1' then
                            q_enable <= '1';
                        end if;
                        
                        -- Separated condition !important
                        if q_ready = '1' then
                            State <= GenerateA;
                        end if;                        
                
                    WHEN GenerateA =>
                        if rowCounter < 16 then   --- 16 SHOULD NOT BE HARDCODED IT IS THE NUMBER OF ROWS....................................................
                            secret_rst <= '0';
                            if secret_ready = '1' then
                                Amatrix(rowCounter) <= secret_output;
                                rowCounter <= rowCounter + 1;
                                secret_rst <= '1';
                            end if;
                        else
                            rowCounter <= 0;
                            State <= GenerateSecret;
                        end if;
                    
                    When GenerateSecret => 
                        secret_rst <= '0';
                        if secret_ready = '1' then
                            secret_rst <= '1';
                            mult_rst <= '1';
                            secret_key <= secret_output;
                            State <= GenerateErrorMatrix;
                        end if;

                    WHEN GenerateErrorMatrix => 
                        if rowCounter < 16 then
                            if errorGen_ready = '1' then
                                Bmatrix(rowCounter) <= std_logic_vector(to_unsigned(errorGen_value, Bmatrix(rowCounter)'length));
                                rowCounter <= rowCounter + 1;
                            end if;
                        else
                            rowCounter <= 0;
                            State <= GenerateB;
                        end if;
                        
                    WHEN GenerateB =>
                        --signals to activate multiplier.
                        mult_inB <= secret_key;
                        secret_rst <= '0';
                        
                        if rowCounter < 16 then       -- HAVE TO FIND A WAY TO GET ALL 3 CASES DEFINED INSTEAD OF USING 16.
                            if mult_ready = '1' then
                                Bmatrix(rowCounter) <= Bmatrix(rowCounter) + mult_out;
                                mult_rst <= '1';
                                rowCounter <= rowCounter + 1;                                
                            else
                                mult_inA <= Amatrix(rowCounter);
                                mult_rst <= '0'; 
                            end if;
                        else
                            rowCounter <= 0;
                            State <= GenerateB_post_setup;
                        end if;
                    
                    WHEN GenerateB_post_setup =>
                        mod_input <= Bmatrix(rowCounter);
                        State <= GenerateB_post;
                        
                    WHEN GenerateB_post => 
                        -- Fixup values to fit within 0 <= x < q
                        -- Needed because the error matrix could spit out -1 (0xFFFFFFFF)
                        if rowCounter < 16 then
                            if mod_ready = '1' then
                                Bmatrix(rowCounter) <= mod_output; -- Store result
                                
                                mod_rst <= '1'; -- Prime modulo unit to load next value
                                if rowCounter /= 15 then
                                    mod_input <= Bmatrix(rowCounter + 1);
                                end if;
                                
                                rowCounter <= rowCounter + 1;
                            else
                                mod_rst <= '0'; 
                            end if;
                        else
                            rowCounter <= 0;
                            State <= Idle;
                        end if;
                    
                    WHEN Idle => 
                    
                    
                        
                    -- Encryption module goes here
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
