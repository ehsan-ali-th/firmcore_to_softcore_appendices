----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2019 11:52:44 PM
-- Design Name: 
-- Module Name: test_registers - Behavioral
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

entity test_registers is
--  Port ( );
end test_registers;

architecture Behavioral of test_registers is

    component registers is
    Port (
        reset           : in std_logic;
        clk             : in std_logic;    
        read_reg1       : in std_logic_vector (3 downto 0);
        read_reg2       : in std_logic_vector (3 downto 0);
        write_reg       : in std_logic_vector (3 downto 0);
        write_data      : in std_logic_vector (7 downto 0);
        bank_selector   : in std_logic;
        write_enable    : in std_logic;
        read_data1      : out std_logic_vector (7 downto 0);
        read_data2      : out std_logic_vector (7 downto 0)
    );
    end component;

    constant half_period100 : time := 5 ns; -- produce 100Mhz clock  
    signal clk100Mhz: std_logic := '0';
    signal reset: std_logic := '0';
    
    signal read_reg1: std_logic_vector (3 downto 0);
    signal read_reg2: std_logic_vector (3 downto 0);
    signal write_reg: std_logic_vector (3 downto 0);
    signal write_data: std_logic_vector (7 downto 0);
    signal bank_selector: std_logic;
    signal write_enable: std_logic;
    signal read_data1: std_logic_vector (7 downto 0);
    signal read_data2: std_logic_vector (7 downto 0);
begin

    clk100Mhz <= not clk100Mhz after half_period100;    

    uut: registers port map (
        reset           => reset,
        clk             => clk100Mhz,    
        read_reg1       => read_reg1,
        read_reg2       => read_reg2,
        write_reg       => write_reg,
        write_data      => write_data,
        bank_selector   => bank_selector,
        write_enable    => write_enable,
        read_data1      => read_data1,
        read_data2      => read_data2
    );
    
    tb: process begin
        wait for 100ns;
        reset <= '0';
        wait for 200ns;
        reset <= '1';
        wait for 100ns;
        reset <= '0';
        wait for 100ns;
        bank_selector <= '0';               -- BANK A
        write_enable <= '1';
        write_reg <= B"1000";
        write_data <= B"0001_0001";
        wait for 10ns;
        write_reg <= B"0001";
        write_data <= B"0001_0010";
        wait for 10ns;
        write_enable <= '0';
        read_reg1 <= B"0001";
        read_reg2 <= B"1000";
        
        
        wait; -- wait forever
    end process;

end Behavioral;
