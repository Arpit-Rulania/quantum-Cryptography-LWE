use work.commons.all;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decrypt is

    Port ( 
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sizeM : in unsigned(7 downto 0); -- 15
    
           inQ : in STD_LOGIC_VECTOR (7 downto 0);
           inS : in arr;
           
           inU : in arr;
           inV : in unsigned(7 downto 0);
           
           outM : out STD_LOGIC;
           ready : out STD_LOGIC
          );
end decrypt;


architecture Behavioural of decrypt is
    signal output : std_logic;
    signal isReady : std_logic := '0';
    signal upperBoundQ : unsigned(7 downto 0);
    
    signal mult_in1: std_logic_vector(7 downto 0);
    signal mult_in2: std_logic_vector(7 downto 0);
    signal mult_ready: std_logic;
    signal mult_rst: std_logic;
    signal mult_output: std_logic_vector(7 downto 0);
    signal mult_rst_signal: std_logic; -- Assigned 
    
    signal mod_ready : std_logic;
    signal mod_output : std_logic_vector(7 downto 0);
    signal mod_rst: std_logic;

    signal mod_rst_signal: std_logic; -- Assigned     
    
    signal sum: unsigned(7 downto 0);

    signal count_M : integer := 0;
    signal isWaitingForMultiplier: boolean := false;
    signal isMultiplierPrimed: boolean := false;
    
    type StateType is (MULTIPLY, SUBTRACT, MODULO);
    signal State : StateType := MULTIPLY;
begin
    outM <= output;
    ready <= isReady;
    upperBoundQ <= unsigned("11" & not(inQ(7 downto 2))) + 1;
    mult_rst_signal <= rst or mult_rst;
    mod_rst_signal <= rst or mod_rst;
    
    theSingleMultiplierOhMyGoodnessAreWeDoingAPipeLine: entity work.multiply8
        PORT MAP (
            clk => clk,
            rst => mult_rst_signal,
            in1 => mult_in1,
            in2 => mult_in2,
            ready => mult_ready,
            output => mult_output
         );
         
    thankGoodnessWeOnlyNeedOneModuloComponent: entity work.variableMod8
        PORT MAP (
            clk => clk,
            rst => mod_rst_signal,
            inQ => inQ,
            input => std_logic_vector(sum),
            output => mod_output,
            ready => mod_ready
        );         

    process(clk)
    begin
    
    
    -- OPIMISATIONS
    -- Preload the first multiplication?
    -- Check if zero and skip?
    
        if rising_edge(clk) then
            if rst = '1' then
                output <= '1';
                isReady <= '0';
                count_M <= 0;
                sum <= (others => '0');
                count_M <= 0;
                mult_rst <= '1';
                mod_rst <= '1';
                isWaitingForMultiplier <= false;
                State <= MULTIPLY;
            elsif isReady = '0' then
                case State is
                    when MULTIPLY => 
                        if isWaitingForMultiplier then
                            if mult_ready = '1' then
                                isWaitingForMultiplier <= false;
                                sum <= sum + unsigned(mult_output);
                                count_M <= count_M  + 1;
                                mult_rst <= '1';
                            end if;
                            
                            -- if mult_ready = '0' then stall and wait for completion
                        elsif sizeM = count_M then
                            State <= SUBTRACT;
                            
                        elsif isMultiplierPrimed then
                            isMultiplierPrimed <= false;
                            mult_rst <= '0';
                            isWaitingForMultiplier <= true;
                        else
                            isMultiplierPrimed <= true;
                            mult_in1 <= std_logic_vector(to_unsigned(inU(count_M), 8));
                            mult_in2 <= std_logic_vector(to_unsigned(inS(count_M), 8));
                        end if;
                    when SUBTRACT =>
                    
                        -- Save a cycle by always computing this subtraction, and doing it out of the process?
                        sum <= inV - sum;
                        State <= MODULO;
                        
                    when MODULO =>
                        mod_rst <= '0';
                        if mod_ready = '1' then
                            if mod_output < "00" & inQ(7 downto 2) or mod_output > std_logic_vector(upperBoundQ) then
                               output <= '0';
                            else
                               output <= '1';         
                            end if;
                            isReady <= '1';
                        end if;                        
                end case;        
            end if;
        end if;
    end process;
    
end Behavioural;
