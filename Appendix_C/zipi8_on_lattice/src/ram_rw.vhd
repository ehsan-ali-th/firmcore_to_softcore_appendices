----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2019 02:32:54 AM
-- Design Name: 
-- Module Name: ram32m_behav - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library synplify;

use synplify.attributes.all; 

entity ram_rw is
    generic (DATA_WIDTH : positive;
           ADDRESS_WIDTH : positive);
    port ( 
        WCLK : in std_logic;
        WE : in std_logic;
        DI: in std_logic_vector (DATA_WIDTH-1 downto 0);
        ADDR_RD: in std_logic_vector (ADDRESS_WIDTH-1 downto 0);
        ADDR_WR: in std_logic_vector (ADDRESS_WIDTH-1 downto 0);
        DO: out std_logic_vector (DATA_WIDTH-1 downto 0) 
    );
end ram_rw;

architecture Behavioral of ram_rw is
	
	attribute syn_keep : boolean;
	attribute syn_preserve : boolean;
	attribute syn_noprune : boolean;
	
    type ram_type is array ((2**ADDR_RD'length) - 1 downto 0) of std_logic_vector(DI'range);
    signal ram_s_RD_WR : ram_type := (others=> (others=>'0'));

	attribute syn_keep of ram_s_RD_WR : signal is true;
	attribute syn_preserve of ram_s_RD_WR : signal is true;
	attribute syn_noprune of ram_s_RD_WR : signal is true;
begin

    -- Synchronous write, asynchronous read
    RamProc: process(WCLK) begin
        if rising_edge(WCLK) then
          if WE = '1' then
            ram_s_RD_WR(to_integer(unsigned(ADDR_WR))) <= DI;
          end if;
            
        end if;
    end process RamProc;

    DO <= ram_s_RD_WR(to_integer(unsigned(ADDR_RD)));

end Behavioral;