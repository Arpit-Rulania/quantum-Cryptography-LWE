LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE std.textio.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY TextFileProvider_Queued IS
  GENERIC (
    fileName : STRING
  );
  PORT (
    clk : IN STD_LOGIC;
    enable : IN STD_LOGIC;
    outBit : OUT STD_LOGIC;
    ready : OUT STD_LOGIC;
    finished : OUT STD_LOGIC
  );
END TextFileProvider_Queued;

ARCHITECTURE Behavioural OF TextFileProvider_Queued IS

  FILE file_input : text;

  -- for debug
  SIGNAL v_byte : STD_LOGIC_VECTOR(7 DOWNTO 0);

  SIGNAL v_bit : STD_LOGIC;

  TYPE StateType IS (SETUP, PROCESS_LINE, PROCESS_CHAR, PROCESS_BIT, FINISH);
  SIGNAL state : StateType := SETUP;

BEGIN

  outBit <= v_bit;
  PROCESS (clk)

    -- Text buffers
    VARIABLE v_ILINE : line;
    VARIABLE v_OLINE : line;

    VARIABLE v_char : CHARACTER;
    VARIABLE v_byte_temp : STD_LOGIC_VECTOR(7 DOWNTO 0);
    VARIABLE counter : INTEGER RANGE 0 TO 7;
  BEGIN
    IF rising_edge(clk) THEN
      ready <= '0';
      finished <= '0';
      CASE state IS

        WHEN setup =>
          file_open(file_input, fileName, read_mode);
          state <= PROCESS_LINE;

        WHEN PROCESS_LINE =>
          IF NOT endfile(file_input) THEN
            readline(file_input, v_ILINE);
            state <= PROCESS_CHAR;
          ELSE
            state <= FINISH;
          END IF;

        WHEN process_CHAR =>
          IF v_ILINE'length > 0 THEN
            read(v_ILINE, v_char);
            v_byte <= CONV_STD_LOGIC_VECTOR(CHARACTER'pos(v_char), 8);
            v_byte_temp := CONV_STD_LOGIC_VECTOR(CHARACTER'pos(v_char), 8);
            counter := 0;
            state <= process_BIT;
          ELSE
            file_close(file_input);
            state <= FINISH;
          END IF;

        WHEN process_BIT =>
          ready <= '1';

          v_bit <= v_byte_temp(7);
          
          IF enable = '1' THEN
            v_byte_temp := v_byte_temp(6 DOWNTO 0) & '0';
            IF (counter = 7) THEN
              state <= PROCESS_CHAR;
            END IF;

            counter := counter + 1;
          END IF;
        WHEN FINISH =>
          -- Do nothing
          finished <= '1';
      END CASE;
    END IF;
  END PROCESS;
END Behavioural;