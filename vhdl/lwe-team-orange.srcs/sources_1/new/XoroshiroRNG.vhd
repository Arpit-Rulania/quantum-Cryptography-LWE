----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/27/2021 11:27:47 PM
-- Design Name: 
-- Module Name: xoroshiroRNG - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xoroshiroRNG is
    generic (
        -- Default seed value.
        init_seed:  std_logic_vector(31 downto 0):= "11011011001010101011011101101100" );

    port (
        clk:        in  std_logic; -- rising edge active.
        rst:        in  std_logic; -- active high.
        reseed:     in  std_logic; -- High to request re-seeding.
        newseed:    in  std_logic_vector(31 downto 0); -- New seed value for reseeding.
        -- High when the user accepts the current random data word
        -- and requests new random data for the next clock cycle.
        out_ready:  in  std_logic;
        -- High when valid random data is available on the output.
        -- Low during the first clock cycle after reset and after re-seeding
        out_valid:  out std_logic;
        -- A new random word appears after every rising clock edge
        -- where out_ready = '1'.
        out_data:   out std_logic_vector(15 downto 0) );
end xoroshiroRNG;

architecture Behavioral of xoroshiroRNG is
    signal reg_state_s0:    std_logic_vector(15 downto 0) := init_seed(15 downto 0);    -- 16 -> 0    15->0
    signal reg_state_s1:    std_logic_vector(15 downto 0) := init_seed(31 downto 16);  -- 33 -> 17    31->16
    -- Output register.
    signal reg_valid:       std_logic := '0';
    signal reg_output:      std_logic_vector(15 downto 0) := (others => '0');
    -- Shift left.---------------------------------
    function shiftl(x: std_logic_vector; b: integer)
        return std_logic_vector
    is
        constant n: integer := x'length;
        variable y: std_logic_vector(n-1 downto 0);
    begin
        y(n-1 downto b) := x(x'high-b downto x'low);
        y(b-1 downto 0) := (others => '0');
        return y;
    end function;
    -- Rotate left.--------------------------------
    function rotl(x: std_logic_vector; b: integer)
        return std_logic_vector
    is
        constant n: integer := x'length;
        variable y: std_logic_vector(n-1 downto 0);
    begin
        y(n-1 downto b) := x(x'high-b downto x'low);
        y(b-1 downto 0) := x(x'high downto x'high-b+1);
        return y;
    end function;
    
begin
    out_valid   <= reg_valid;
    out_data    <= reg_output;

    -- Synchronous process.
    process (clk) is
    begin
        if rising_edge(clk) then

            if out_ready = '1' or reg_valid = '0' then

                -- Prepare output word.
                reg_valid       <= '1';
                reg_output      <= std_logic_vector(unsigned(reg_state_s0) +
                                                    unsigned(reg_state_s1));

                -- Update internal state.
                reg_state_s0    <= reg_state_s0 xor
                                   reg_state_s1 xor
                                   rotl(reg_state_s0, 7) xor
                                   shiftl(reg_state_s0, 5) xor
                                   shiftl(reg_state_s1, 5);

                reg_state_s1    <= rotl(reg_state_s0, 11) xor
                                   rotl(reg_state_s1, 11);

            end if;

            -- Re-seed function.
            if reseed = '1' then
                reg_state_s0    <= newseed(15 downto 0);
                reg_state_s1    <= newseed(31 downto 16);
                reg_valid       <= '0';
            end if;

            -- Synchronous reset.
            if rst = '1' then
                reg_state_s0    <= init_seed(15 downto 0);
                reg_state_s1    <= init_seed(31 downto 16);
                reg_valid       <= '0';
                reg_output      <= (others => '0');
            end if;

        end if;
    end process;
end Behavioral;
