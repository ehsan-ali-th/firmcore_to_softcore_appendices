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

--library sb_ice40_components_syn;
--use sb_ice40_components_syn.components.all;	 

library ice;
use  ice.all;


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
	
	-- component SB_RAM512x8 is
		-- generic ( 
			   -- INIT_0 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_1 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_2 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_3 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_4 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_5 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_6 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_7 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_8 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_9 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			   -- INIT_F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000" 
				-- ) ;
          -- port( 
                -- RDATA : out std_logic_vector( 7  downto 0) ;
                -- RCLK  : in  std_logic ;
                -- RCLKE : in  std_logic := 'H';
                -- RE    : in  std_logic := 'L';
                -- RADDR : in  std_logic_vector( 8  downto 0) ;
                -- WCLK  : in  std_logic ;
                -- WCLKE : in  std_logic := 'H';
                -- WE    : in  std_logic := 'L';
                -- WADDR : in  std_logic_vector( 8  downto 0) ;
                -- WDATA : in  std_logic_vector( 7  downto 0)
               -- );
	-- end component;
	
    signal spm_ram_data : std_logic_vector (7 downto 0) := B"0000_0000";
	signal not_spm_enable : std_logic;
begin	 
	
	not_spm_enable <= not spm_enable;

   flipflops_process: process (clk) begin
    if rising_edge(clk) then
        spm_data <= spm_ram_data;
    end if;
   end process flipflops_process; 
   

	-- spm_ram: SB_RAM512x8
		-- generic map ( 
		   -- INIT_0 => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_1 => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_2 => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_3 => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_4 => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_5 => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_6 => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_7 => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_8 => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_9 => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_A => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_B => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_C => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_D => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_E => X"0000000000000000000000000000000000000000000000000000000000000000",
		   -- INIT_F => X"0000000000000000000000000000000000000000000000000000000000000000" 
		-- ) 
		-- port map (
			-- RDATA => spm_ram_data,
			-- RCLK => clk,
			-- RCLKE => not_spm_enable,
			-- RE => not_spm_enable,
			-- RADDR => ('0' & sy_or_kk),
			-- WCLK=> clk,
			-- WCLKE => spm_enable,
			-- WE => spm_enable,
			-- WADDR => ('0' & sy_or_kk),
			-- WDATA => sx
		-- );
       
	   
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
