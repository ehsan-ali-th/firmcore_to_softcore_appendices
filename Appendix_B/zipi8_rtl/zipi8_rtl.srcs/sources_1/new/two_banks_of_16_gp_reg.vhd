----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2019 11:16:37 PM
-- Design Name: 
-- Module Name: two_banks_of_16_gp_reg - Behavioral
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

entity two_banks_of_16_gp_reg is
    Port ( 
        clk : in std_logic;
        alu_result: in std_logic_vector(7 downto 0);    
        sx_addr: in std_logic_vector(4 downto 0);    
        sy_addr: in std_logic_vector(4 downto 0);   
        register_enable : in std_logic; 
        sx: out std_logic_vector(7 downto 0) := B"0000_0000";
        sy: out std_logic_vector(7 downto 0) := B"0000_0000"
    );
end two_banks_of_16_gp_reg;

architecture Behavioral of two_banks_of_16_gp_reg is
     component ram is        
        generic (
            DATA_WIDTH : positive;
            ADDRESS_WIDTH : positive);
        port ( 
            WCLK : in std_logic;
            WE : in std_logic;
            DI: in std_logic_vector (7 downto 0);
            ADDR: in std_logic_vector (4 downto 0);
            DO: out std_logic_vector (7 downto 0)
        );
    end component;
    
    component ram32m_behav is
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
    end component;
    
begin

    sx_bank: ram 
        generic map (
            DATA_WIDTH => 8,        -- 16x8-bit RAM
            ADDRESS_WIDTH => 5    
        )
        port map (
            WCLK => clk,
            WE => register_enable,
            DI => alu_result,
            ADDR => sx_addr,
            DO => sx    
        );

    sy_bank: ram32m_behav 
        generic map (
            DATA_WIDTH => 8,        -- 16x8-bit RAM
            ADDRESS_WIDTH => 5    
        )
        port map (
            WCLK => clk,
            WE => register_enable,
            DI => alu_result,
            ADDR_RD => sy_addr,
            ADDR_WR => sx_addr,
            DO => sy    
        );

       
end Behavioral;
