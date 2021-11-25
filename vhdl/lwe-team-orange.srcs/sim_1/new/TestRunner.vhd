library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity TestRunner is
    
    -- Bit sizes
    constant cfg_bitWidth : integer := 16;
    
    -- m
    constant cfg_aHeight : integer := 16;
    
    -- n
    constant cfg_aWidth : integer := 16; -- MAX 16

end TestRunner;

architecture Behavioral of TestRunner is
    signal clk : STD_LOGIC;
    
    signal in_enable : std_logic;
    
    signal in_ready : std_logic;
    signal in_finished : std_logic;
    
    signal mcu_rst : std_logic;
    signal mcu_should_reseed : std_logic;
    signal mcu_seed : STD_LOGIC_VECTOR(31 downto 0) := std_logic_vector(to_unsigned(789623428, 32));
signal       mcu_ctrlLoad    :  STD_LOGIC;
      signal   mcu_ctrlEncrypt : STD_LOGIC;
        signal mcu_ctrlDecrypt :  STD_LOGIC;
        signal mcu_ready       : STD_LOGIC;
        
        
    type StateType is (
       Start,
       InitMCU,
       Ready,
       Finish
    );
    signal State : StateType := Start;
begin

process (clk) begin
    if rising_edge(clk) then
        case State IS
            when start =>
                mcu_rst <= '1';
                State <= InitMCU;
                
            when InitMCU =>
                mcu_rst <= '0';
                -- Wait for initial load
                if mcu_ready = '1' then
                    State <= Ready;
                end if;
                
            when Ready =>
            
            when Finish =>
        
end case;

    end if;

end process;







c: entity work.ClockProvider PORT MAP ( clk => clk );


fileReader: entity work.TextFileProvider_Queued 
    GENERIC MAP (
      fileName => "measure_in.txt"
    )
    PORT MAP (
      clk => clk,
      enable => in_enable,
      ready => in_ready,
      finished => in_finished
    );

mcu: entity work.mcu
    GENERIC MAP (
        bitWidth => cfg_bitWidth,
        aHeight => cfg_aHeight,
        aWidth => cfg_aWidth
    )
    port map (
        clk => clk,
        rst => mcu_rst,
        should_reseed => mcu_should_reseed,
        seed => mcu_seed,
        
        
        ctrlLoad    => mcu_ctrlLoad,
        ctrlEncrypt => mcu_ctrlEncrypt,
        ctrlDecrypt => mcu_ctrlDecrypt,
        ready       => mcu_ready
    );

end Behavioral;
