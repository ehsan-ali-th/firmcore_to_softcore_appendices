----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2019 01:55:40 PM
-- Design Name: 
-- Module Name: ram - Behavioral
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

entity ram is
     generic (DATA_WIDTH : positive;
           ADDRESS_WIDTH : positive);
    port ( 
        WCLK : in std_logic;
        WE : in std_logic;
        DI: in std_logic_vector (DATA_WIDTH-1 downto 0);
        ADDR: in std_logic_vector (ADDRESS_WIDTH-1 downto 0);
        DO: out std_logic_vector (DATA_WIDTH-1 downto 0) 
    );
end ram;

architecture Behavioral of ram is
    type ram_type is array ((2**ADDR'length) - 1 downto 0) of std_logic_vector(DI'range);
    signal ram_s : ram_type := (others=> (others=>'0'));
begin

    -- Synchronous write, asynchronous read
    RamProc: process(WCLK) begin
        if rising_edge(WCLK) then
          if WE = '1' then
            ram_s(to_integer(unsigned(ADDR))) <= DI;
          end if;
            
        end if;
    end process RamProc;

    DO <= ram_s(to_integer(unsigned(ADDR)));

end Behavioral;