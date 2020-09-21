----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2019 03:04:53 PM
-- Design Name: 
-- Module Name: register_bank_control - Behavioral
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

entity register_bank_control is
    Port (
        clk : in std_logic; 
        instruction_17_downto_4  : in std_logic_vector(17 downto 4);
        instruction_0 : in std_logic;
        sx_addr4_value : in std_logic;
        t_state_1 : in std_logic;
        internal_reset : in std_logic;
        shadow_bank : in std_logic;
        bank : out std_logic := '0';
        sx_addr : out  std_logic_vector(4 downto 0) := B"0_0000";
        sy_addr : out  std_logic_vector(4 downto 0) := B"0_0000"
    );
end register_bank_control;

architecture Behavioral of register_bank_control is
     signal  regbank_type : std_logic := '0';
     signal  bank_value : std_logic := '0';
     signal  sx_addr_4 : std_logic  := '0';
     
begin

     flipflops_process: process (clk) begin
        if rising_edge(clk) then
            sx_addr_4 <= sx_addr4_value;
        end if;
     end process flipflops_process; 

     flipflops_R_process: process (clk) begin
        if rising_edge(clk) then
            if (internal_reset = '0') then
                bank <= bank_value;
            end if;       
        end if;
     end process flipflops_R_process; 

    -- calculate regbank_type
    -- LUT INIT = 0x0080020000000000
    -- y = AB'CD'E'F + ABC'DEF
    -- instruction_17_downto_4(12)     = F
    -- instruction_17_downto_4(13)     = E
    -- instruction_17_downto_4(14) 	= D
    -- instruction_17_downto_4(15)     = C
    -- instruction_17_downto_4(16)	    = B
    -- instruction_17_downto_4(17)     = A
	regbank_type <= (instruction_17_downto_4(17) and not instruction_17_downto_4(16) and instruction_17_downto_4(15) 
					and not instruction_17_downto_4(14) and not instruction_17_downto_4(13) and instruction_17_downto_4(12)) or 
					(instruction_17_downto_4(17) and instruction_17_downto_4(16) and not instruction_17_downto_4(15) 
					and instruction_17_downto_4(14) and instruction_17_downto_4(13) and instruction_17_downto_4(12));             
    
    -- calculate bank_value
    -- LUT INIT = 0xACACFF00FF00FF00
    -- y = A'C + B'C + ABD'E + ABDF
    -- instruction_0                    = F
    -- shadow_bank                      = E
    -- instruction_17_downto_4(16) 	= D
    -- bank                             = C
    -- regbank_type	                    = B
    -- t_state_1                        = A
	bank_value <= (not t_state_1 and bank) or 
				  (not regbank_type and bank) or 
				  (t_state_1 and regbank_type and not instruction_17_downto_4(16) and shadow_bank) or 
				  (t_state_1 and regbank_type and instruction_17_downto_4(16) and instruction_0);             
    
    -- form sx_addr and sy_addr
    sx_addr(4 downto 0) <= sx_addr_4 & instruction_17_downto_4(11 downto 8);
    sy_addr(4 downto 0) <= bank & instruction_17_downto_4(7 downto 4);
      
end Behavioral;
