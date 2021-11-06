library ieee;
use ieee.std_logic_1164.all;
use work.commons.all;

-- i = number of columns in A matrix
entity secretKey is
  Generic ( i : integer := 16);
  PORT (
    clk: IN std_logic;
    rst: IN std_logic;
    randomNum: IN std_logic_vector (15 DOWNTO 0);
    validRng : IN std_logic;
    secret: OUT t_array (0 to i-1);
    ready: OUT std_logic
  );
end secretKey;

architecture Behavioral of secretKey is  
  SIGNAL k: integer:= 0;
  SIGNAL isReady: std_logic:= '0';
    
begin
  
  ready <= isReady;
  
  -- Loads `i` different random numbers.
  -- `validRng` must be asserted to add to the secret list
  getRand : process(rst, clk)
  begin
    -- On falling edge of Clk signal take value from RNG
    if rst = '1' then
      isReady <= '0';
      secret <= (others => (others => '0'));
    elsif rst = '0' then
        if k < i then
            if falling_edge(Clk) and validRng = '1' then
                secret(k) <= randomNum;
                k <= k + 1;
            end if;
        else
            isReady <= '1';
        end if;
    end if;    
  end process getRand;

end Behavioral;
