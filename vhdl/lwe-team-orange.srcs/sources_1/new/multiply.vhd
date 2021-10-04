library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiply is
    Generic ( i : integer );
    Port ( 
           clk : in STD_LOGIC; 
           rst : in STD_LOGIC;
           in1 : in STD_LOGIC_VECTOR(i-1 downto 0);
           in2 : in STD_LOGIC_VECTOR(i-1 downto 0);
           output : out STD_LOGIC_VECTOR(i-1 downto 0);
           ready : out STD_LOGIC);
end multiply;

architecture Behavioural of multiply is
    signal sum : unsigned(i-1 downto 0);
    signal adder : unsigned(i-1 downto 0);
    signal counter : unsigned(i-1 downto 0);
    signal isReady : std_logic;
begin
    -- Link your signals to the outputs
    output <= std_logic_vector(sum);
    ready <= isReady;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sum <= (others => '0');
                isReady <= '0';

                -- Checking for the larger of the addends isn't too important because the bit shifting will limit the cycles to 8
                if unsigned(in1) < unsigned(in2) then
                    adder <= unsigned(in2);
                    counter <= unsigned(in1);
                else
                    adder <= unsigned(in1);
                    counter <= unsigned(in2);
                end if;
            elsif isReady = '0' then
                if counter(0) = '1' then
                    sum <= sum + adder;
                end if;

                adder <= adder(6 downto 0) & '0';     -- adder << 1                
                counter <= '0' & counter(7 downto 1); -- counter >> 1
                -- counter - 1 doesn't take effect until the end of the process
                if counter <= 1 then
                    isReady <= '1';
                end if;
            end if;
        end if;
    end process;
end Behavioural;
