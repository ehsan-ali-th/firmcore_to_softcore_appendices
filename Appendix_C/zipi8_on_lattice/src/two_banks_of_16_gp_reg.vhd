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


library IEEE, synplify;
use IEEE.STD_LOGIC_1164.ALL;

library synplify;

use synplify.attributes.all; 

library ice;
use  ice.all;

--library sb_ice40_components_syn;
--use sb_ice40_components_syn.components.all;	 


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
			DI: in std_logic_vector (DATA_WIDTH-1 downto 0);
			ADDR: in std_logic_vector (ADDRESS_WIDTH-1 downto 0);
			DO: out std_logic_vector (DATA_WIDTH-1 downto 0) 
        );
    end component;	  
	
	 component ram_rw is
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
    
   
	
	
	-- attribute syn_keep : boolean;
	-- attribute syn_preserve : boolean;
	-- attribute syn_noprune : boolean;
	
	-- attribute syn_keep of ram:  component is true;
	-- attribute syn_preserve of ram:  component is true;
	-- attribute syn_noprune of ram:  component is true;

	-- attribute syn_keep of ram32m_behav:  component is true;
	-- attribute syn_preserve of ram32m_behav:  component is true;
	-- attribute syn_noprune of ram32m_behav:  component is true;
	
	signal not_register_enable : std_logic;
    
begin
	
	--not_register_enable <= not register_enable;

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

    sy_bank: ram_rw 
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
		
	-- sx_bank_ram512X8_inst : SB_RAM512x8
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
			-- RDATA => sx,
			-- RCLK => clk,
			-- RCLKE => not_register_enable,
			-- RE => not_register_enable,
			-- RADDR => ("0000" & sx_addr),
			-- WCLK=> clk,
			-- WCLKE => register_enable,
			-- WE => register_enable,
			-- WADDR => ("0000" & sx_addr),
			-- WDATA => alu_result
		-- );
		
	-- sy_bank_ram512X8_inst : SB_RAM512x8
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
			-- RDATA => sy,
			-- RCLK => clk,
			-- RCLKE => not_register_enable,
			-- RE => not_register_enable,
			-- RADDR => ("0000" & sy_addr),
			-- WCLK=> clk,
			-- WCLKE => register_enable,
			-- WE => register_enable,
			-- WADDR => ("0000" & sx_addr),
			-- WDATA => alu_result
		-- );

       
end Behavioral;
