----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2019 01:09:51 AM
-- Design Name: 
-- Module Name: spm_with_output_reg - Behavioral
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

entity spm_with_output_reg is
    Port (
         clk : in std_logic;
         sx : in std_logic_vector (7 downto 0);
         sy_or_kk : in std_logic_vector (7 downto 0);
         spm_enable : in std_logic;
         spm_data : out std_logic_vector (7 downto 0) := B"0000_0000"
     );
end spm_with_output_reg;

architecture Behavioral of spm_with_output_reg is

    component ram is        
        generic (
            DATA_WIDTH : positive;
            ADDRESS_WIDTH : positive);
        port ( 
        WCLK : in std_logic;
        WE : in std_logic;
        DI: in std_logic_vector (DATA_WIDTH-1 downto 0);
        ADDR: in std_logic_vector (ADDRESS_WIDTH-1 downto 0);
        DO: out std_logic_vector (DATA_WIDTH-1 downto 0)
    );
    end component;
    
    signal spm_ram_data : std_logic_vector (7 downto 0) := B"0000_0000";

begin

   flipflops_process: process (clk) begin
    if rising_edge(clk) then
        spm_data <= spm_ram_data;
    end if;
   end process flipflops_process; 
    
   spm_ram: ram 
        generic map (
            DATA_WIDTH => 8,        -- 256x8-bit RAM
            ADDRESS_WIDTH => 8    
        )
        port map (
            WCLK => clk,
            WE => spm_enable,
            DI => sx,
            ADDR => sy_or_kk,
            DO => spm_ram_data    
        );
        
end Behavioral;
