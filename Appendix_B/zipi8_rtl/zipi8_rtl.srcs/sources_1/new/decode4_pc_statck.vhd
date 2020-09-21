----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2019 04:34:57 PM
-- Design Name: 
-- Module Name: decode4_pc_statck - Behavioral
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

entity decode4_pc_statck is
    Port (
         carry_flag : in std_logic;
         zero_flag : in std_logic;
         instruction_17_downto_12 : in std_logic_vector (17 downto 12);
         active_interrupt : in std_logic;
         pop_stack : out std_logic := '0';
         push_stack : out std_logic := '0';
         pc_mode : out std_logic_vector (2 downto 0) := B"001"
     );
end decode4_pc_statck;

architecture Behavioral of decode4_pc_statck is

     signal pc_move_is_valid : std_logic := '0';
     signal returni_type : std_logic := '0';
     signal move_type : std_logic := '1';
     
begin

 -- calculate pc_move_is_valid
    -- LUT INIT = 0x00100000 
    -- y =  AB' + AC'D'E + AC'DE' + ACD'F + ACDF'
    -- carry_flag                       = F
    -- zero_flag    		            = E
    -- instruction_17_downto_12(14) 	= D
    -- instruction_17_downto_12(15)     = C
    -- instruction_17_downto_12(16)	    = B
    -- instruction_17_downto_12(17)     = A
        pc_move_is_valid <= (instruction_17_downto_12(17) and not instruction_17_downto_12(16)) or
                            (instruction_17_downto_12(17) and not instruction_17_downto_12(15) and not instruction_17_downto_12(14) and zero_flag) or
                            (instruction_17_downto_12(17) and not instruction_17_downto_12(15) and instruction_17_downto_12(14) and not zero_flag) or
                            (instruction_17_downto_12(17) and instruction_17_downto_12(15) and not instruction_17_downto_12(14) and carry_flag) or 
                            (instruction_17_downto_12(17)and instruction_17_downto_12(15) and instruction_17_downto_12(14) and not carry_flag);             
    
    -- calculate returni_type
    -- LUT INIT = 0x00000200
    -- y = A'BC'D'E 
    -- instruction_17_downto_12(12)     = E
    -- instruction_17_downto_12(13) 	= D
    -- instruction_17_downto_12(14)     = C
    -- instruction_17_downto_12(15)	    = B
    -- instruction_17_downto_12(16)     = A
    
        returni_type <=     ((not instruction_17_downto_12(16)) and
                                instruction_17_downto_12(15) and 
                            (not instruction_17_downto_12(14)) and 
                            (not instruction_17_downto_12(13)) and
                                instruction_17_downto_12(12));             
    
    -- calculate move_type
    -- LUT INIT = 0x77770277
    -- y = B'D' + B'E' + AD' + AE' + C'D'E
    -- instruction_17_downto_12(12)     = E
    -- instruction_17_downto_12(13) 	= D
    -- instruction_17_downto_12(14)     = C
    -- instruction_17_downto_12(15)	    = B
    -- instruction_17_downto_12(16)     = A
       move_type <= (not instruction_17_downto_12(15) and not instruction_17_downto_12(13)) or
                    (not instruction_17_downto_12(15) and not instruction_17_downto_12(12)) or 
                    (instruction_17_downto_12(16) and not instruction_17_downto_12(13)) or
                    (instruction_17_downto_12(16) and not instruction_17_downto_12(12)) or
                    (not instruction_17_downto_12(14) and not instruction_17_downto_12(13) and instruction_17_downto_12(12));             
    
    -- calculate pc_mode(0)
    -- LUT INIT = 0x000023FF
    -- y = A'B' + A'C'D' + A'D'E
    -- instruction_17_downto_12(12)     = E
    -- returni_type 	                = D
    -- move_type                        = C
    -- pc_move_is_valid         	    = B
    -- active_interrupt                 = A
        pc_mode(0) <= (not active_interrupt and not pc_move_is_valid) or
                      (not active_interrupt and not move_type and not returni_type) or
                      (not active_interrupt and not returni_type and instruction_17_downto_12(12));              


    -- calculate pc_mode(1)
    -- LUT INIT = 0x0000F000
    -- y = A'BC + AB'C'D'E'
    -- instruction_17_downto_12(12)     = E
    -- returni_type 	                = D
    -- move_type                        = C
    -- pc_move_is_valid         	    = B
    -- active_interrupt                 = A
       pc_mode(1) <= (not active_interrupt and pc_move_is_valid and move_type) or
                    (active_interrupt and not pc_move_is_valid and not move_type and not returni_type and not instruction_17_downto_12(12));             


    -- calculate pc_mode(2)
    -- LUT INIT = 0xFFFFFFFF00040000
    -- y =  A + BC'D'EF'
    -- instruction_17_downto_12(12)     = F
    -- instruction_17_downto_12(14)     = E
    -- instruction_17_downto_12(15) 	= D
    -- instruction_17_downto_12(16)     = C
    -- instruction_17_downto_12(17)     = B
    -- active_interrupt                 = A
       pc_mode(2) <=  active_interrupt or
                      (instruction_17_downto_12(17) and not instruction_17_downto_12(16) and not instruction_17_downto_12(15)
                        and instruction_17_downto_12(14) and not instruction_17_downto_12(12));             
    
    -- calculate pop_stack
    -- LUT INIT = 0x00002000
    -- y = A'BCD'E
    -- instruction_17_downto_12(12)     = E
    -- instruction_17_downto_12(13) 	= D
    -- move_type                        = C
    -- pc_move_is_valid         	    = B
    -- active_interrupt                 = A
       pop_stack <= not active_interrupt and pc_move_is_valid and move_type and not instruction_17_downto_12(13) and instruction_17_downto_12(12);             
    
    -- calculate push_stack
    -- LUT INIT = 0xFFFF1000
    -- y = A + BCD'E'
    -- instruction_17_downto_12(12)     = E
    -- instruction_17_downto_12(13) 	= D
    -- move_type                        = C
    -- pc_move_is_valid         	    = B
    -- active_interrupt                 = A
       push_stack <=  active_interrupt or
                     (pc_move_is_valid and move_type and not instruction_17_downto_12(13) and not instruction_17_downto_12(12));             

end Behavioral;

