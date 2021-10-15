LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY variableMod8 IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        inQ : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        input : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        ready : OUT STD_LOGIC
    );
END variableMod8;

ARCHITECTURE Behavioral OF variableMod8 IS
    SIGNAL intermediate : unsigned(7 DOWNTO 0);
    SIGNAL q_out : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL isReady : STD_LOGIC := '0';

    SIGNAL scaled_q : unsigned(7 DOWNTO 0);
    SIGNAL hasScaled : BOOLEAN;
BEGIN
    output <= q_out;
    ready <= isReady;

    PROCESS (clk)
    BEGIN

        IF rising_edge(clk) THEN
            IF rst = '1' THEN
                scaled_q <= unsigned(inQ);
                intermediate <= unsigned(input);
                q_out <= (OTHERS => '0');
                isReady <= '0';
                hasScaled <= false;
            ELSIF isReady = '0' THEN

                -- OPTIMISATION - https://math.stackexchange.com/questions/3559467/how-is-calculating-the-modulus-using-this-formula-faster

                -- if mod 0
                ---- unfortunate.
                -- TODO: SHOULD THESE GO INTO THE RESET LOOP?
                -- Unlikely that we'll get these
                IF unsigned(inQ) = 1 THEN
                    -- X mod 1 = 0
                    q_out <= (OTHERS => '0');
                    isReady <= '1';
                ELSIF unsigned(inQ) = 2 THEN
                    -- X mod 2 = LSB
                    q_out <= (0 => input(0), OTHERS => '0');
                    isReady <= '1';
                ELSE
                    IF hasScaled = false AND scaled_q < intermediate AND scaled_q(6 DOWNTO 0) /= "0000000" THEN
                        -- Left shift, multiply by two, arrange the bits
                        -- idk
                        scaled_q <= scaled_q(6 DOWNTO 0) & '0';
                    ELSE
                        hasScaled <= true;

                        IF intermediate < unsigned(inQ) THEN
                            q_out <= STD_LOGIC_VECTOR(intermediate);
                            isReady <= '1';
                        ELSE
                            -- Subtract multiples of Q
                            IF scaled_q <= intermediate THEN
                                -- The exit condition for hasScaled causes scaled_q >= intermediate
                                -- Ensure we only subtract if scaled_q intermediate
                                intermediate <= intermediate - scaled_q;
                            END IF;

                            scaled_q <= '0' & scaled_q(7 DOWNTO 1);
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;