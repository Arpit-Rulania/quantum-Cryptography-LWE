library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity ErrorMatrixGen is
    port (
        clk:                in  std_logic; -- rising edge active.
        rst:                in  std_logic; -- active high.
        ready:              out std_logic;
      --  seed_1:             in std_logic_vector(15 downto 0);
      --  seed_2:             in std_logic_vector(15 downto 0);
      --  seed_3:             in std_logic_vector(15 downto 0);
      --  seed_4:             in std_logic_vector(15 downto 0);
        error:              out std_logic_vector(15 downto 0);
        error_normalised:   out integer :=0
     );
end ErrorMatrixGen;

architecture Behavioral of ErrorMatrixGen is
    signal xoro_1 : std_logic_vector(15 downto 0);
    signal xoro_2 : std_logic_vector(15 downto 0);
    signal xoro_3 : std_logic_vector(15 downto 0);
    signal xoro_4 : std_logic_vector(15 downto 0);
    signal valid_1: std_logic;
    signal valid_2: std_logic;
    signal valid_3: std_logic;
    signal valid_4: std_logic;
    
    signal adder_inA : std_logic_vector(17 downto 0);
    signal adder_inB : std_logic_vector(17 downto 0);
    signal adder_out : std_logic_vector(17 downto 0);
    
    type statetype is (s0, s1, s2);
    signal state, next_state: statetype := s0;
    
    signal firstCycleCompleted : std_logic := '0';
begin
    xoro1: entity work.xoroshiroRNG 
    generic map (init_seed => "11011011001010101011011101101100")
    port map(
          clk => clk,
          rst => rst,
          should_reseed => '0',
          newseed => "11111111111111111111111111111111",
          enable => '1',
          out_valid => valid_1,
          out_data => xoro_1
          );
    xoro2: entity work.xoroshiroRNG 
    generic map (init_seed => "11111011111010101011011101101100")
    port map(
          clk => clk,
          rst => rst,
          should_reseed => '0',
          newseed => "11111111111111111111111111111111",
          enable => '1',
          out_valid => valid_2,
          out_data => xoro_2
          );
    xoro3: entity work.xoroshiroRNG 
    generic map (init_seed => "00001011001010101011011101101100")
    port map(
          clk => clk,
          rst => rst,
          should_reseed => '0',
          newseed => "11111111111111111111111111111111",
          enable => '1',
          out_valid => valid_3,
          out_data => xoro_3
          );
    xoro4: entity work.xoroshiroRNG 
    generic map (init_seed => "11111111111000111111111000011111")
    port map(
          clk => clk,
          rst => rst,
          should_reseed => '0',
          newseed => "11111111111111111111111111111111",
          enable => '1',
          out_valid => valid_4,
          out_data => xoro_4
          );
    adder1 : entity work.adder
      port map (
        a => adder_inA,
        b => adder_inB,
        clk => clk,
        r => adder_out
    );
    
process(clk, rst)
begin
    if rising_edge(clk) then
        if rst = '1' then
            state <= s0;
            firstCycleCompleted <= '0';
            
            error <= (others => '0');
            error_normalised <= 0;
        else
            ready <= '0';
            
            case state is
                when s0 =>
                    adder_inA <= "00"&xoro_1;
                    adder_inB <= "00"&xoro_2;
                    state <= s1; -- next state
                    
                    if firstCycleCompleted = '1' then
                        ready <= '1';
                        error <= adder_out(17 downto 2);
                        error_normalised <= (to_integer(unsigned(adder_out(17 downto 2))) - 32768)/12000;
                    end if;
                when s1 =>
                    adder_inA <= adder_out;
                    adder_inB <= "00"&xoro_3;
                    state <= s2; -- next state
                    
                when s2 =>
                    adder_inA <= adder_out;
                    adder_inB <= "00"&xoro_4;
                    firstCycleCompleted <= '1';
                    state <= s0; -- next state
            end case;
        end if;
    end if;
end process;


process(clk, state, xoro_1, xoro_2, xoro_3, xoro_4, adder_out)

begin

end process;

end Behavioral;
