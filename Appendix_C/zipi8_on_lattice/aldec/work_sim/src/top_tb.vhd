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

use STD.textio.all;
use ieee.std_logic_textio.all;

use std.env.stop;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_tb is
--  Port ( );
end top_tb;

    architecture Behavioral of top_tb is

    component top is
        port (                        
              CLK_3P3_MHZ : in std_logic;
              BTN1 : in std_logic;
              LED1 : out std_logic
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
        reset <= '1';
        wait for 200ns;
        reset <= '0';       -- running period for zipi8
        wait for 48000ns;
        report "Simulation Finished." severity note;		
		stop;
    end process; 
	
	instruction_seq_dump : process(clk)
        file file_handler      : text;  -- open write_mode is "zipi8_lattice_insts.txt";
        variable  outline  : line;
        variable file_is_open:  boolean := false;
        
        alias zipi8_instruction is  << signal uut.instruction : std_logic_vector(17 downto 0) >>;
        alias zipi8_reset is        << signal uut.BTN1 : std_logic >>;
    begin
        
        if not file_is_open then
            file_open (file_handler, "zipi8_lattice_insts.txt", write_mode);
            file_is_open := true;
        end if;
        
        if rising_edge(clk) then  
            if(zipi8_reset = '0') then
                hwrite(outline, "00" & zipi8_instruction);
                writeline(file_handler, outline);
            end if;
        end if;
    end process instruction_seq_dump;
	
end Behavioral;
