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
        error_normalised:   out integer :=0 );
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
    
    signal adder_1 : std_logic_vector(17 downto 0);
    signal adder_2 : std_logic_vector(17 downto 0);
    signal adder_3 : std_logic_vector(17 downto 0);
    
    type statetype is (s0, s1, s2);
    signal state, next_state: statetype := s0;
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
        a => adder_1,
        b => adder_2,
        clk => clk,
        r => adder_3
    );
    
process(clk, rst)
begin
    if rising_edge(clk) then
        if rst = '1' then
            state <= s0;
            error <= (others => '0');
        else
            ready <= '0';
            if state = s0 then
                ready <= '1';
                error <= adder_3(17 downto 2);
                error_normalised <= (to_integer(unsigned(adder_3(17 downto 2))) - 32768)/12000;
            end if;
            state <= next_state;
        end if;
    end if;
end process;


process(clk, state, xoro_1, xoro_2, xoro_3, xoro_4, adder_3)

begin
    case state is
        when s0 =>
            adder_1 <= "00"&xoro_1;
            adder_2 <= "00"&xoro_2;
            next_state <= s1;
        when s1 =>
            adder_1 <= adder_3;
            adder_2 <= "00"&xoro_3;
            next_state <= s2;
        when s2 =>
            adder_1 <= adder_3;
            adder_2 <= "00"&xoro_4;
            next_state <= s0;
    end case;
end process;

end Behavioral;
