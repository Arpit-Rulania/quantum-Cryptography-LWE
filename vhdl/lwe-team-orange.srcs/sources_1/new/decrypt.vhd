LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE work.commons.ALL;

ENTITY decrypt IS

    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        sizeM : IN unsigned(7 DOWNTO 0); -- 15!!!!!!!

        inQ : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        inS : IN arr;

        inU : IN arr;                           --<------ THIS CHANGES TO t_array CROSS REFERENCE WITH ENCRYPT MODULE
        inV : IN unsigned(7 DOWNTO 0);

        outM : OUT STD_LOGIC;
        ready : OUT STD_LOGIC
    );
END decrypt;
ARCHITECTURE Behavioural OF decrypt IS
    SIGNAL output : STD_LOGIC;
    SIGNAL isReady : STD_LOGIC := '0';

    SIGNAL mult_in1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL mult_in2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL mult_ready : STD_LOGIC;
    SIGNAL mult_rst : STD_LOGIC;
    SIGNAL mult_output : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL mult_rst_signal : STD_LOGIC; -- Assigned 
    SIGNAL mod_ready : STD_LOGIC;
    SIGNAL mod_output : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL mod_rst : STD_LOGIC;
    SIGNAL mod_rst_signal : STD_LOGIC; -- Assigned     

    SIGNAL sum : unsigned(7 DOWNTO 0);
    SIGNAL output_intermediate : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL count_M : INTEGER := 0;
    SIGNAL isWaitingForMultiplier : BOOLEAN := false;
    SIGNAL isMultiplierPrimed : BOOLEAN := false;
    SIGNAL isModuloFlipped : BOOLEAN := false;
    

    TYPE StageEnum IS (MULTIPLY, SUBTRACT, MODULO, FINAL);
    SIGNAL Stage : StageEnum := MULTIPLY;
BEGIN
    outM <= output;
    ready <= isReady;
    mult_rst_signal <= rst OR mult_rst;
    mod_rst_signal <= rst OR mod_rst;
    theSingleMultiplierOhMyGoodnessAreWeDoingAPipeLine : ENTITY work.multiply8
        PORT MAP(
            clk => clk,
            rst => mult_rst_signal,
            in1 => mult_in1,
            in2 => mult_in2,
            ready => mult_ready,
            output => mult_output
        );

    thankGoodnessWeOnlyNeedOneModuloComponent : ENTITY work.variableMod8
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
                count_M <= 0;
                sum <= (OTHERS => '0');
                output_intermediate <= (OTHERS => '0');
                count_M <= 0;
                mult_rst <= '1';
                mod_rst <= '1';
                isModuloFlipped <= false;
                isWaitingForMultiplier <= false;
                isMultiplierPrimed <= false;
                Stage <= MULTIPLY;
            ELSIF isReady = '0' THEN
                CASE Stage IS
                    WHEN MULTIPLY =>
                        IF isWaitingForMultiplier THEN
                            IF mult_ready = '1' THEN
                                isWaitingForMultiplier <= false;
                                sum <= sum + unsigned(mult_output);
                                count_M <= count_M + 1;
                                mult_rst <= '1';
                            END IF;

                            -- if mult_ready = '0' then stall and wait for completion
                        ELSIF sizeM = count_M THEN
                            Stage <= SUBTRACT;

                        ELSIF isMultiplierPrimed THEN
                            isMultiplierPrimed <= false;
                            mult_rst <= '0';
                            isWaitingForMultiplier <= true;
                        ELSE
                            isMultiplierPrimed <= true;
                            mult_in1 <= STD_LOGIC_VECTOR(to_unsigned(inU(count_M), 8));
                            mult_in2 <= STD_LOGIC_VECTOR(to_unsigned(inS(count_M), 8));
                        END IF;
                    WHEN SUBTRACT =>

                        -- Save a cycle by always computing this subtraction, and doing it out of the process?
                        IF inV < sum THEN
                           isModuloFlipped <= true;
                           sum <= sum - inV;
                        ELSE
                           sum <= inV - sum;
                        END IF;
                        
                        Stage <= MODULO;

                    WHEN MODULO =>
                        mod_rst <= '0';
                        IF mod_ready = '1' THEN
                            IF isModuloFlipped THEN
                                output_intermediate <= std_logic_vector(unsigned('0' & inQ(7 downto 1)) - unsigned(mod_output));
                            ELSE
                                output_intermediate <= std_logic_vector(unsigned(mod_output) - unsigned("00" & inQ(7 downto 2)));
                            END IF;
                            Stage <= FINAL;
                        END IF;
                    WHEN FINAL => 
                        IF output_intermediate < '0' & inQ(7 downto 1) THEN
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
