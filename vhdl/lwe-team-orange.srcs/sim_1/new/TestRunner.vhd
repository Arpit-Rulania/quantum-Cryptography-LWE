LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TestRunner IS

    -- Bit sizes
    CONSTANT cfg_bitWidth : INTEGER := 16;

    -- m
    CONSTANT cfg_aHeight : INTEGER := 16;

    -- n
    CONSTANT cfg_aWidth : INTEGER := 16; -- MAX 16

END TestRunner;

ARCHITECTURE Behavioral OF TestRunner IS
    SIGNAL clk : STD_LOGIC;

    SIGNAL in_enable : STD_LOGIC := '0';
    SIGNAL in_bit : STD_LOGIC;
    SIGNAL in_ready : STD_LOGIC;
    SIGNAL in_finished : STD_LOGIC;

    SIGNAL mcu_rst : STD_LOGIC := '1';
    SIGNAL mcu_should_reseed : STD_LOGIC := '0';
    SIGNAL mcu_seed : STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(789623428, 32));
    SIGNAL mcu_ctrlLoad : STD_LOGIC;
    SIGNAL mcu_ctrlEncrypt : STD_LOGIC;
    SIGNAL mcu_ctrlDecrypt : STD_LOGIC;
    SIGNAL mcu_inM : STD_LOGIC;
    SIGNAL mcu_outM : STD_LOGIC;
    SIGNAL mcu_ready : STD_LOGIC;

    SIGNAL M_in : STD_LOGIC;
    SIGNAL M_out : STD_LOGIC;

    TYPE StateType IS (
        Start,
        InitMCU,
        SyncFileReader,
        ReadBit,
        Run1,
        Run2,
        Run3,
        Run4,
        Run5,
        Run6,
        Finish
    );
    SIGNAL State : StateType := Start;

    --
    SIGNAL builder : STD_LOGIC_VECTOR(0 TO 7) := (OTHERS => '1');
    SIGNAL decoded : STD_LOGIC_VECTOR(0 TO 7) := (OTHERS => '0');

BEGIN
    mcu_inM <= M_in;

    PROCESS (clk) IS
        VARIABLE counter : INTEGER RANGE 0 TO 7 := 0;
    BEGIN
        IF rising_edge(clk) THEN
            in_enable <= '0';

            CASE State IS
                WHEN start =>
                    mcu_rst <= '1';
                    State <= InitMCU;
                    M_in <= 'U';

                WHEN InitMCU =>
                    mcu_rst <= '0';
                    -- Wait for initial load
                    IF mcu_ready = '1' THEN
                        State <= SyncFileReader;
                    END IF;
                WHEN SyncFileReader =>
                    IF in_ready = '1' THEN
                        IF counter = 0 THEN
                            decoded <= builder;
                        END IF;
                        in_enable <= '1';
                        State <= ReadBit;
                    END IF;

                WHEN ReadBit =>
                    in_enable <= '0';
                    IF in_finished = '1' THEN
                        State <= Finish;
                    ELSE

                        mcu_ctrlLoad <= '1';
                        M_in <= in_bit;
                        State <= Run1;
                    END IF;

                    -- Stage: Load and return to idle
                WHEN Run1 =>
                    in_enable <= '0';
                    mcu_ctrlLoad <= '0';

                    IF mcu_ready = '0' THEN
                        State <= Run2;
                    END IF;

                    -- Stage: Idle, start encrypt
                WHEN Run2 =>
                    mcu_ctrlEncrypt <= '1';

                    IF mcu_ready = '0' THEN
                        State <= Run3;
                    END IF;

                    -- Stage: Encrypt
                WHEN Run3 =>
                    mcu_ctrlEncrypt <= '0';
                    IF mcu_ready = '1' THEN
                        State <= Run4;
                    END IF;

                    -- Stage: Idle
                WHEN Run4 =>
                    mcu_ctrlDecrypt <= '1';

                    IF mcu_ready = '0' THEN
                        State <= Run5;
                    END IF;

                    -- Stage: Decrypt
                WHEN Run5 =>
                    mcu_ctrlDecrypt <= '0';
                    IF mcu_ready = '1' THEN
                        State <= Run6;
                    END IF;

                WHEN Run6 =>
                    M_out <= mcu_outM;
                    builder(counter) <= mcu_outM;

                    -- M_out <= M_in;
                    -- builder(counter) <= M_in;

                    IF counter = 7 THEN
                        counter := 0;
                    ELSE
                        counter := counter + 1;
                    END IF;

                    State <= SyncFileReader;

                WHEN Finish =>
                    -- idle
            END CASE;

        END IF;

    END PROCESS;

    c : ENTITY work.ClockProvider PORT MAP (clk => clk);
    fileReader : ENTITY work.TextFileProvider_Queued
        GENERIC MAP(
            fileName => "measure_in.txt"
        )
        PORT MAP(
            clk => clk,
            outBit => in_bit,
            enable => in_enable,
            ready => in_ready,
            finished => in_finished
        );

    mcu : ENTITY work.mcu
        GENERIC MAP(
            bitWidth => cfg_bitWidth,
            aHeight => cfg_aHeight,
            aWidth => cfg_aWidth
        )
        PORT MAP(
            clk => clk,
            rst => mcu_rst,
            should_reseed => mcu_should_reseed,
            seed => mcu_seed,
            ctrlLoad => mcu_ctrlLoad,
            ctrlEncrypt => mcu_ctrlEncrypt,
            ctrlDecrypt => mcu_ctrlDecrypt,
            inM => mcu_inM,
            outM => mcu_outM,
            ready => mcu_ready
        );

END Behavioral;