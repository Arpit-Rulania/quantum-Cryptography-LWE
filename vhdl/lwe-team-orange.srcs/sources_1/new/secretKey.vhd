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
    secret: OUT t_array;
    ready: OUT std_logic
  );
end secretKey;

architecture Behavioral of secretKey is  
  SIGNAL k: integer:= 0;
  SIGNAL tempnum: std_logic_vector (15 DOWNTO 0);
  SIGNAL isReady: std_logic:= '0';
  -- Mod compnent signals
  SIGNAL mrst: std_logic:= '1';
  SIGNAL mout: std_logic_vector (15 DOWNTO 0);  --AHAHA CHANGE THIS TO GENERIC LATER.................. !!!!!?!!!!
  SIGNAL mRdy: std_logic:= '0';
  
    
begin
    
    ModuloComponent : ENTITY work.variableMod
        GENERIC MAP (
            i => 16
        )
        PORT MAP(
            clk => clk,
            rst => mrst,
            inQ => "0101010110101101", -- TEMPORARY PRIME FOR TESTING.
            input => tempnum,
            output => mout,
            ready => mRdy
        );
  
  ready <= isReady;
  
  -- Loads `i` different random numbers.
  -- `validRng` must be asserted to add to the secret list
  getRand : process(rst, clk)
  begin
    -- On falling edge of Clk signal take value from RNG
    if rst = '1' then
      isReady <= '0';
      secret <= (others => (others => '0'));
      k <= 0;
      tempnum <= randomNum;
      mrst <= '1';
    elsif rst = '0' then
        if k < i then
            if falling_edge(Clk) and validRng = '1' then
                -- reset mod component, input new numbers, and put output into secret k
                if mRdy = '1' then
                    secret(k) <= mout;
                    k <= k + 1;
                    tempnum <= randomNum;
                    mrst <= '1';
                elsif mRdy = '0' then
                    mrst <= '0';
                end if;
                
                -- secret(k) <= randomNum;
                -- k <= k + 1;
            end if;
        else
            isReady <= '1';
        end if;
    end if;    
  end process getRand;

end Behavioral;
