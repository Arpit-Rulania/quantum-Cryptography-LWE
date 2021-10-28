LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE std.textio.ALL;
 use ieee.std_logic_arith.all;
USE ieee.std_logic_textio.ALL;

ENTITY TextFileProvider IS
END TextFileProvider;

ARCHITECTURE Behavioural OF TextFileProvider IS
  SIGNAL clk : STD_LOGIC;

  FILE file_input : text;
  FILE file_output : text;
  SIGNAL v_byte: STD_LOGIC_VECTOR(7 downto 0);

BEGIN
  c : ENTITY work.ClockProvider PORT MAP (clk => clk);
  
  PROCESS
    
    
    
    -- Text buffers
    VARIABLE v_ILINE : line;
    VARIABLE v_OLINE : line;

    VARIABLE v_char : CHARACTER;
    
    VARIABLE out_error : STD_LOGIC;
    
   


BEGIN
      file_open(file_input, "input_tests.txt", read_mode);
   

--    file_open(file_output, "output_tests.txt", write_mode);

    WHILE NOT endfile(file_input) LOOP
      readline(file_input, v_ILINE);

      WHILE v_ILINE'length > 0 LOOP
        wait until clk = '1';
        read(v_ILINE, v_char);
        v_byte <= CONV_STD_LOGIC_VECTOR(character'pos(v_char), 8);
      END LOOP;
    END LOOP;

    -- Bye bye
    file_close(file_input);
--    file_close(file_output);
    WAIT;
  END PROCESS;

END Behavioural;