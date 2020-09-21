----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2019 10:04:55 AM
-- Design Name: 
-- Module Name: test_top_ram - Behavioral
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

entity test_top_ram is
--  Port ( );
end test_top_ram;

architecture Behavioral of test_top_ram is
    component top_ram is
        Port ( 
            clk : in std_logic;
            WE : in std_logic;
            DI : in std_logic_vector (7 downto 0);
            ADDR : in std_logic_vector (4 downto 0);
            DO : out std_logic_vector (7 downto 0)
            
        );
    end component;

    signal clk : std_logic := '0';
    signal WE : std_logic;
    signal DI : std_logic_vector (7 downto 0);
    signal DO : std_logic_vector (7 downto 0);
    signal ADDR : std_logic_vector (4 downto 0);
    
     constant half_period100 : time := 5 ns; -- produce 100Mhz clock  


begin

    clk <= not clk after half_period100;

    uut: top_ram port map (
        clk => clk,
        WE => WE,
        DI => DI,
        ADDR => ADDR,
        DO => DO
    );
    
     tb: process begin
        WE <= '0';
        ADDR <= "00000";
        DI <= X"00";
     
        report "RAm32M Test Started!" severity note;
        wait for 100ns;
        
        ADDR <= "00000";
        wait for 100ns;
        ADDR <= "00001";
        wait for 100ns;
        ADDR <= "00010";
        wait for 100ns;
        
        
        ADDR <= "00001";
        WE <= '1';
        DI <= X"34";
        wait for 15ns;
        WE <= '0';
        wait for 5ns;
        
        ADDR <= "00000";
        wait for 50ns;
        ADDR <= "00001";
        wait for 50ns;
        ADDR <= "00010";
        wait for 50ns;
              
        wait; -- wait forever
    end process;
    
    

end Behavioral;
