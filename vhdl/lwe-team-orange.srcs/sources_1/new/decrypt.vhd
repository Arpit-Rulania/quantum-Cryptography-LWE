LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE work.commons.ALL;

ENTITY decrypt IS
    GENERIC (
        dim : integer;
        width : integer
    );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
     

        inQ : IN STD_LOGIC_VECTOR (width-1 DOWNTO 0);
        inS : IN t_array;

        inU : IN t_array;
        inV : IN unsigned(width-1 DOWNTO 0);

        outM : OUT STD_LOGIC;
        ready : OUT STD_LOGIC
    );
END decrypt;
ARCHITECTURE Behavioural OF decrypt IS
    SIGNAL output : STD_LOGIC;
    SIGNAL isReady : STD_LOGIC := '0';

    SIGNAL dot_ready : STD_LOGIC;
    SIGNAL dot_rst : STD_LOGIC;
    SIGNAL dot_output : STD_LOGIC_VECTOR(width-1 DOWNTO 0);
    SIGNAL dot_rst_signal : STD_LOGIC; -- Assigned 

    SIGNAL mod_ready : STD_LOGIC;
    SIGNAL mod_output : STD_LOGIC_VECTOR(width-1 DOWNTO 0);
    SIGNAL mod_rst : STD_LOGIC;
    SIGNAL mod_rst_signal : STD_LOGIC; -- Assigned     

    SIGNAL sum : unsigned(width-1 DOWNTO 0);
    SIGNAL output_intermediate : STD_LOGIC_VECTOR(width-1 DOWNTO 0);

    SIGNAL isModuloFlipped : BOOLEAN := false;
    

    TYPE StageEnum IS (DOTPRODUCT, SUBTRACT, MODULO, FINAL);
    SIGNAL Stage : StageEnum := DOTPRODUCT;
BEGIN
    outM <= output;
    ready <= isReady;
    dot_rst_signal <= rst OR dot_rst;
    mod_rst_signal <= rst OR mod_rst;
    
    
    inst_dotproduct: entity work.dotproduct
    generic map (width => width, dim => dim) 
    port map (
      clk => clk,
      rst => dot_rst_signal,
      A => inS,
      B => inU,
      inQ => inQ,
      C => dot_output,
      ready => dot_ready
    );

    inst_modulo : ENTITY work.variableMod
        PORT MAP(
            clk => clk,
            rst => mod_rst_signal,
            inQ => inQ,
            input => STD_LOGIC_VECTOR(sum),
            output => mod_output,
            ready => mod_ready
        );


    PROCESS (clk)
    BEGIN
        -- OPIMISATIONS
        -- Preload the first multiplication?
        -- Check if zero and skip?

        IF rising_edge(clk) THEN
            IF rst = '1' THEN
                output <= '0';
                isReady <= '0';
                sum <= (OTHERS => '0');
                output_intermediate <= (OTHERS => '0');
                
                dot_rst <= '1';
                mod_rst <= '1';

                isModuloFlipped <= false;
                Stage <= DOTPRODUCT;
            ELSIF isReady = '0' THEN
                CASE Stage IS
                    WHEN DOTPRODUCT =>
                        dot_rst <= '0';
                        
                        IF dot_ready = '1' THEN
                            Stage <= SUBTRACT;
                            dot_rst <= '1';
                        END IF;

                    WHEN SUBTRACT =>

                        IF inV < unsigned(dot_output) THEN
                           isModuloFlipped <= true;
                           sum <= unsigned(dot_output) - inV;
                        ELSE
                           sum <= inV - unsigned(dot_output);
                        END IF;
                        
                        Stage <= MODULO;

                    WHEN MODULO =>
                        mod_rst <= '0';
                        
                        IF mod_ready = '1' THEN
                            IF isModuloFlipped THEN
                                output_intermediate <= std_logic_vector(unsigned('0' & inQ(width-1 downto 1)) - unsigned(mod_output));
                            ELSE
                                output_intermediate <= std_logic_vector(unsigned(mod_output) - unsigned(inQ(width-1 downto 2)));
                            END IF;
                        
                            Stage <= FINAL;
                        END IF;
                    WHEN FINAL => 
                        IF output_intermediate < '0' & inQ(width-1 downto 1) THEN
                            output <= '1';
                        ELSE
                            output <= '0';
                        END IF;
                        isReady <= '1';                        
                END CASE;
            END IF;
        END IF;
    END PROCESS;

END Behavioural;
