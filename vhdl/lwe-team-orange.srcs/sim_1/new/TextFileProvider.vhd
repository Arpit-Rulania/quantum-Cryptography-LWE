LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE std.textio.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY TextFileProvider IS
END TextFileProvider;

ARCHITECTURE Behavioural OF TextFileProvider IS
  SIGNAL clk : STD_LOGIC;

  FILE file_input : text;
  FILE file_output : text;

  -- for debug
  SIGNAL v_byte : STD_LOGIC_VECTOR(7 DOWNTO 0);

  SIGNAL v_bit : STD_LOGIC;

  TYPE StateType IS (SETUP, PROCESS_LINE, PROCESS_CHAR, PROCESS_BIT, FINISH);
  SIGNAL state : StateType := SETUP;
BEGIN
  c : ENTITY work.ClockProvider PORT MAP (clk => clk);

  PROCESS (clk)

    -- Text buffers
    VARIABLE v_ILINE : line;
    VARIABLE v_OLINE : line;

    VARIABLE v_char : CHARACTER;
    VARIABLE v_byte_temp : STD_LOGIC_VECTOR(7 DOWNTO 0);
    VARIABLE counter : INTEGER RANGE 0 TO 7;
  BEGIN
    IF rising_edge(clk) THEN
      CASE state IS

        WHEN setup =>
          file_open(file_input, "input_tests.txt", read_mode);
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
          v_bit <= v_byte_temp(7);
          v_byte_temp := v_byte_temp(6 DOWNTO 0) & '0';

          IF (counter = 7) THEN
            state <= PROCESS_CHAR;
          END IF;

          counter := counter + 1;
        WHEN FINISH =>
          -- Do nothing

      END CASE;
    END IF;
  END PROCESS;
END Behavioural;