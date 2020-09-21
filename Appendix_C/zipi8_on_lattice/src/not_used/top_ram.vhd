----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2019 09:57:02 AM
-- Design Name: 
-- Module Name: top_ram - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity top_ram is
    Port ( 
        clk : in std_logic;
        WE : in std_logic;
        DI : in std_logic_vector (7 downto 0);
        ADDR : in std_logic_vector (4 downto 0);
        DO : out std_logic_vector (7 downto 0)
        
    );
end top_ram;

architecture Behavioral of top_ram is

begin

        stack_ram_low : RAM32M
      generic map (INIT_A => X"0000000000000000", 
                   INIT_B => X"0000000000000000", 
                   INIT_C => X"0000000000000000", 
                   INIT_D => X"0000000000000000") 
      port map (    DOA => DO(1 downto 0), 
                    DOB => DO(3 downto 2),
                    DOC => DO(5 downto 4), 
                    DOD => DO(7 downto 6),
                    ADDRA => ADDR,
                    ADDRB => ADDR, 
                    ADDRC => ADDR, 
                    ADDRD => ADDR,
                    DIA => DI(1 downto 0), 
                    DIB => DI(3 downto 2),
                    DIC => DI(5 downto 4),
                    DID => DI(7 downto 6),
                    WE => WE, 
                    WCLK => clk );        

end Behavioral;

