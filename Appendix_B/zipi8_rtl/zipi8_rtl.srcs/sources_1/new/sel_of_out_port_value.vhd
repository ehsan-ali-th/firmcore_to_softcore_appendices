----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2019 09:33:37 AM
-- Design Name: 
-- Module Name: sel_of_port_value - Behavioral
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

entity sel_of_out_port_value is
    Port ( 
        sx : in std_logic_vector (7 downto 0);
        instruction_11_downto_4 : in std_logic_vector (11 downto 4);
        instruction_13 : in std_logic;
        out_port : out std_logic_vector (7 downto 0) := B"0000_0000"
    );
end sel_of_out_port_value;

architecture Behavioral of sel_of_out_port_value is

begin

    -- calculate out_port(0)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- sx(0)                = E
    -- instruction(4) 	    = D
    -- sx(1)                = C
    -- instruction(5)	    = B
    -- instruction(13)      = A
        out_port(0) <= 
             (not instruction_13 and sx(0)) or 
             (instruction_13 and instruction_11_downto_4(4)); 
    
    -- calculate out_port(1)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- sx(0)                = E
    -- instruction(4) 	    = D
    -- sx(1)                = C
    -- instruction(5)	    = B
    -- instruction(13)      = A
        out_port(1) <= 
             (not instruction_13 and sx(1)) or 
             (instruction_13 and instruction_11_downto_4(5)); 

    -- calculate out_port(2)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- sx(2)                = E
    -- instruction(6) 	    = D
    -- sx(3)                = C
    -- instruction(7)	    = B
    -- instruction(13)      = A
        out_port(2) <= 
             (not instruction_13 and sx(2)) or 
             (instruction_13 and instruction_11_downto_4(6)); 
    
    -- calculate out_port(3)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- sx(2)                = E
    -- instruction(6) 	    = D
    -- sx(3)                = C
    -- instruction(7)	    = B
    -- instruction(13)      = A
        out_port(3) <= 
             (not instruction_13 and sx(3)) or 
             (instruction_13 and instruction_11_downto_4(7)); 

    -- calculate out_port(4)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- sx(4)                = E
    -- instruction(8) 	    = D
    -- sx(5)                = C
    -- instruction(9)	    = B
    -- instruction(13)      = A
        out_port(4) <= 
             (not instruction_13 and sx(4)) or 
             (instruction_13 and instruction_11_downto_4(8)); 
    
    -- calculate out_port(5)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- sx(4)                = E
    -- instruction(8) 	    = D
    -- sx(5)                = C
    -- instruction(9)	    = B
    -- instruction(13)      = A
        out_port(5) <= 
             (not instruction_13 and sx(5)) or 
             (instruction_13 and instruction_11_downto_4(9)); 

    -- calculate out_port(6)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- sx(6)                = E
    -- instruction(10) 	    = D
    -- sx(7)                = C
    -- instruction(11)	    = B
    -- instruction(13)      = A
        out_port(6) <= 
             (not instruction_13 and sx(6)) or 
             (instruction_13 and instruction_11_downto_4(10)); 
    
    -- calculate out_port(7)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- sx(6)                = E
    -- instruction(10) 	    = D
    -- sx(7)                = C
    -- instruction(11)	    = B
    -- instruction(13)      = A
        out_port(7) <= 
             (not instruction_13 and sx(7)) or 
             (instruction_13 and instruction_11_downto_4(11)); 


end Behavioral;
