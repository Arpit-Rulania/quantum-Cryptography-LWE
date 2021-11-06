----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/28/2021 12:48:59 AM
-- Design Name: 
-- Module Name: xoroshiro_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xoroshiro_basic_tb is
end xoroshiro_basic_tb;

architecture Behavioral of xoroshiro_basic_tb is
    signal clk:             std_logic;
    signal clock_active:    boolean := false;

    signal s_rst:           std_logic;
    signal s_reseed:        std_logic;
    signal s_newseed:       std_logic_vector(31 downto 0);
    signal s_ready:         std_logic;
    signal s_valid:         std_logic;
    signal s_data:          std_logic_vector(15 downto 0);

begin
    -- Instantiate PRNG.
    inst_prng: entity work.xoroshiroRNG
        generic map (
            init_seed => "11011011001010101010011101101100" )
        port map (
            clk         => clk,
            rst         => s_rst,
            reseed      => s_reseed,
            newseed     => s_newseed,
            out_ready   => s_ready,
            out_valid   => s_valid,
            out_data    => s_data );

    c: entity work.ClockProvider PORT MAP ( clk => clk );

    -- Main simulation process.---------------------------------
    process is
        variable lin: line;
        variable nskip: integer;
        variable v: std_logic_vector(15 downto 0);
    begin
        -- Reset.
        s_rst       <= '1';
        s_reseed    <= '0';
        s_newseed   <= (others => '0');
        s_ready     <= '0';

        -- Start clock.
        clock_active    <= true;

        -- Wait 2 clock cycles, then end reset.
        wait for 30 ns;
        wait until falling_edge(clk);
        s_rst       <= '0';


        -- Wait 1 clock cycle to initialize generator.
        wait until falling_edge(clk);
        s_ready     <= '1';
        -- Produce numbers
        for i in 0 to 7 loop
            -- Go to next cycle.
            wait until falling_edge(clk);
        end loop;


        -- Re-seed generator.
        report "Re-seed generator";
        s_reseed    <= '1';
        s_newseed   <= "10110111001000110111011100101100";
        s_ready     <= '0';
        wait until falling_edge(clk);
        s_reseed    <= '0';
        s_newseed   <= (others => '0');

        -- Wait 1 clock cycle to re-seed generator.
        wait until falling_edge(clk);
        s_ready     <= '1';

        -- Produce numbers
        for i in 0 to 16 loop
            -- Go to next cycle.
            wait until falling_edge(clk);
        end loop;

        clock_active    <= false;
        wait;

    end process;

end Behavioral;
