library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use work.commons.all;

entity dotproduct is
    Generic (
         width : integer := 16;
         dim   : integer := 4
    );
    Port (
        clk: in std_logic;
        rst: in std_logic;
        A : in t_array;
        B : in t_array;
        inQ : in std_logic_vector (width-1 downto 0);
        C : out std_logic_vector (width-1 downto 0);
        ready : out std_logic
    );
end dotproduct;

architecture Behavioral of dotproduct is
    type expanded_t_array is array (0 to 15) of std_logic_vector((width*2)-1 downto 0);

    -- Signals for intermediate results
    signal mult_results: expanded_t_array;
    signal mult_ready: std_logic_vector (0 to dim-1);
    signal counter: integer := 0;
    signal sum: unsigned((2*width) - 1 downto 0) := to_unsigned(0, 2*width);
    
    signal mod_operation_primed : std_logic;
    signal mod_enable : std_logic;
    signal mod_enable_control : std_logic;
    signal mod_output : std_logic_vector(2*width - 1 downto 0);
    signal mod_ready : std_logic;
    
    signal expanded_q: std_logic_vector(2*width - 1 downto 0);
begin

    expanded_q <= (2*width-1 downto width => '0') & inQ;
    mod_enable_control <= not mod_enable;
    

    -- Generate multiple instances of the multiplication A
    -- Perform 16 simultaneous multiplications on the integers comprising the vector
    GEN_MULT:
    for n in 0 to dim-1 generate
        MULT: entity work.dgn_mitchellmul8bit
            Generic map (sz => width) 
            Port MAP (
                X => A(n),
                Y => B(n),
                M => mult_results(n)
            );
    end generate GEN_MULT;
    
    VMOD:
    entity work.variableMod 
        generic map (i => 2*width)
        port map (
            clk => clk,
            rst => mod_enable_control,
            inQ => expanded_q,
            input => std_logic_vector(sum),
            output => mod_output,
            ready => mod_ready
        );
    
    
    REDUCE:
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sum <= to_unsigned(0, sum'length);
                counter <= 0;
                ready <= '0';
                
                mod_operation_primed <= '0';
                mod_enable <= '0';
            elsif counter = dim then
                C <= std_logic_vector(sum(width-1 downto 0));
                ready <= '1';
            elsif mod_enable = '1' then
                if mod_ready = '1' then
                    mod_enable <= '0';
                    mod_operation_primed <= '0';
                    sum <= unsigned(mod_output);
                    counter <= counter + 1;
                end if;
            else               
                if mod_operation_primed = '0' then
                    mod_operation_primed <= '1';
                    sum <= sum + unsigned(mult_results(counter));
                else
                    mod_enable <= '1';
                end if;                
            end if;
        end if;     
    end process;

end Behavioral;
