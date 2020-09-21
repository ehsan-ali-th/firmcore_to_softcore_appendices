----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2019 12:18:39 AM
-- Design Name: 
-- Module Name: decode4_strobes_enables - Behavioral
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

entity decode4_strobes_enables is
    Port (
        clk : in std_logic;
        t_state_1 : in std_logic;
        strobe_type : in std_logic;
        active_interrupt : in std_logic;
        instruction_17_downto_12 : in std_logic_vector(17 downto 12);
        flag_enable_type : out std_logic := '0';
        register_enable : out std_logic := '0';
        flag_enable : out std_logic := '0';
        k_write_strobe : out std_logic := '0';
        spm_enable : out std_logic := '0';
        write_strobe : out std_logic := '0';
        read_strobe : out std_logic := '0'
    );
end decode4_strobes_enables;

architecture Behavioral of decode4_strobes_enables is
    signal  register_enable_type : std_logic := '1';
    signal  flag_enable_value : std_logic := '0';
    signal  register_enable_value : std_logic := '0';
    signal  k_write_strobe_value : std_logic := '0';
    signal  spm_enable_value : std_logic := '0';
    signal  read_strobe_value : std_logic := '0';
    signal  write_strobe_value : std_logic := '0';
    
    begin

      flipflops_R_process: process (clk) begin
        if rising_edge(clk) then
            if (active_interrupt = '1') then
                register_enable <= '0';
                flag_enable     <= '0';       
                register_enable <= '0';      
                k_write_strobe  <= '0';      
                spm_enable      <= '0';   
                read_strobe     <= '0';
                write_strobe    <= '0';
            else 
                register_enable <= register_enable_type;
                flag_enable <= flag_enable_value;       
                register_enable <= register_enable_value;      
                k_write_strobe <= k_write_strobe_value;      
                spm_enable <= spm_enable_value;   
                read_strobe <= read_strobe_value;
                write_strobe <= write_strobe_value;
            end if;   
        end if;
     end process flipflops_R_process; 

    -- calculate flag_enable_type
    -- LUT INIT = 0x0010F7CE
    -- y = A'B'D + A'DE' + A'BD' + BCD + A'B'C'E + ACD'E'
    -- instruction_17_downto_12(13)     = E
    -- instruction_17_downto_12(14) 	= D
    -- instruction_17_downto_12(15)     = C
    -- instruction_17_downto_12(16)	    = B
    -- instruction_17_downto_12(17)     = A
	flag_enable_type <= (not instruction_17_downto_12(17) and not instruction_17_downto_12(16) and instruction_17_downto_12(14)) or 
						(not instruction_17_downto_12(17) and instruction_17_downto_12(14) and not instruction_17_downto_12(13)) or 
						(not instruction_17_downto_12(17) and instruction_17_downto_12(16) and not instruction_17_downto_12(14)) or 
						(instruction_17_downto_12(16) and instruction_17_downto_12(15) and instruction_17_downto_12(14)) or 
						(not instruction_17_downto_12(17) and not instruction_17_downto_12(16) and not instruction_17_downto_12(15) and instruction_17_downto_12(13)) or 
						(instruction_17_downto_12(17) and instruction_17_downto_12(15) and not instruction_17_downto_12(14) and not instruction_17_downto_12(13));             
    
    -- calculate register_enable_type
    -- LUT INIT = 0x00013F3F0
    -- y = A'C' + A'D' + B'C'D'E'
    -- instruction_17_downto_12(13)     = E
    -- instruction_17_downto_12(14) 	= D
    -- instruction_17_downto_12(15)     = C
    -- instruction_17_downto_12(16)	    = B
    -- instruction_17_downto_12(17)     = A
	register_enable_type <= (not instruction_17_downto_12(17) and not instruction_17_downto_12(15)) or
        (not instruction_17_downto_12(17) and not instruction_17_downto_12(14)) or
        (not instruction_17_downto_12(16) and not instruction_17_downto_12(15) and not instruction_17_downto_12(14) and not instruction_17_downto_12(13));             
    
    -- calculate flag_enable_value
    -- LUT INIT = 0xA0AA0000
    -- y = AB'E + ACE
    -- flag_enable_type                 = E
    -- register_enable_type 	        = D
    -- instruction_17_downto_12(12)     = C
    -- instruction_17_downto_12(17)	    = B
    -- t_state(1)                       = A
	flag_enable_value <= (t_state_1 and not instruction_17_downto_12(17) and flag_enable_type) or 
						 (t_state_1 and instruction_17_downto_12(12) and flag_enable_type);             
     
    -- calculate register_enable_value
    -- LUT INIT = 0xC0CC0000
    -- y = AB'D + ACD
    -- flag_enable_type                 = E
    -- register_enable_type 	        = D
    -- instruction_17_downto_12(12)     = C
    -- instruction_17_downto_12(17)	    = B
    -- t_state(1)                       = A
	register_enable_value <= (t_state_1 and not instruction_17_downto_12(17) and register_enable_type) or
							 (t_state_1 and instruction_17_downto_12(12) and register_enable_type);             
    
    -- calculate k_write_strobe_value
    -- LUT INIT = 0x20000000
    -- y =  ABCD'E
    -- instruction_17_downto_12(13)     = E
    -- instruction_17_downto_12(14)     = D
    -- instruction_17_downto_12(17)     = C
    -- strobe_type	                    = B
    -- t_state(1)                       = A
	k_write_strobe_value <= t_state_1 and strobe_type and instruction_17_downto_12(17) and not instruction_17_downto_12(14) and instruction_17_downto_12(13);             
    
   -- calculate spm_enable_value
    -- LUT INIT = 0x80000000
    -- y =  ABCDE
    -- instruction_17_downto_12(13)     = E
    -- instruction_17_downto_12(14)     = D
    -- instruction_17_downto_12(17)     = C
    -- strobe_type	                    = B
    -- t_state(1)                       = A
	spm_enable_value <= t_state_1 and strobe_type and instruction_17_downto_12(17) and instruction_17_downto_12(14) and instruction_17_downto_12(13);             
    
    -- calculate read_strobe_value
    -- LUT INIT = 0x01000000
    -- y =  ABC'D'E'
    -- instruction_17_downto_12(13)     = E
    -- instruction_17_downto_12(14)     = D
    -- instruction_17_downto_12(17)     = C
    -- strobe_type	                    = B
    -- t_state(1)                       = A
	read_strobe_value <= t_state_1 and strobe_type and not instruction_17_downto_12(17) and not instruction_17_downto_12(14) and not instruction_17_downto_12(13);             
    
    -- calculate write_strobe_value
    -- LUT INIT = 0x40000000
    -- y =  ABCDE'
    -- instruction_17_downto_12(13)     = E
    -- instruction_17_downto_12(14)     = D
    -- instruction_17_downto_12(17)     = C
    -- strobe_type	                    = B
    -- t_state(1)                       = A
	write_strobe_value <= t_state_1 and strobe_type and instruction_17_downto_12(17) and instruction_17_downto_12(14) and not instruction_17_downto_12(13);             
          
end Behavioral;
