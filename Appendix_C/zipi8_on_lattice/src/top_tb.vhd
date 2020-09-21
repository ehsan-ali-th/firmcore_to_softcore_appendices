----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2019 12:31:34 AM
-- Design Name: 
-- Module Name: test_zipi8 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_zipi8 is
--  Port ( );
end test_zipi8;

    architecture Behavioral of test_zipi8 is

    component top is
        port (                        
              CLK_3P3_MHZ : in std_logic;
              BTN1 : in std_logic;
              LED1 : in std_logic
        );
    end component;

    constant half_period100 : time := 5 ns; -- produce 100Mhz clock  

    signal clk: std_logic := '0';
    signal reset: std_logic := '0';
    
    signal LED1: std_logic;
    
begin
    clk <= not clk after half_period100;

	uut: top port map (
        CLK_3P3_MHZ => clk,
        BTN1 => reset,
        LED1 => LED1
    );
    
    tb: process begin
        report "Test Started!" severity note;
        reset <= '0';
        wait for 3500ns;
        reset <= '1';
        wait for 20ns;
        reset <= '0';
      
        wait; -- wait forever
    end process;
	
end Behavioral;
