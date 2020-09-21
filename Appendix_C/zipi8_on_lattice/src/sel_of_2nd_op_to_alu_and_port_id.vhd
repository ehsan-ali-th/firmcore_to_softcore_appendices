----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2019 12:41:34 AM
-- Design Name: 
-- Module Name: sel_of_2nd_op_to_alu_and_port_id - Behavioral
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

entity sel_of_2nd_op_to_alu_and_port_id is
    Port ( 
        sy : in std_logic_vector (7 downto 0);
        instruction_7_downto_0 : in std_logic_vector (7 downto 0);
        instruction_12 : in std_logic;
        arith_carry_in : in std_logic;
        sy_or_kk : out std_logic_vector (7 downto 0) := B"0000_0000"
    );
end sel_of_2nd_op_to_alu_and_port_id;

architecture Behavioral of sel_of_2nd_op_to_alu_and_port_id is

begin

    -- calculate sy_or_kk(0)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- sy(0)                = E
    -- instruction(0) 	    = D
    -- sy(1)                = C
    -- instruction(1)	    = B
    -- instruction(12)      = A
        sy_or_kk(0) <= 
             (not instruction_12 and sy(0)) or 
             (instruction_12 and instruction_7_downto_0(0)); 

    -- calculate sy_or_kk(1)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- sy(0)                = E
    -- instruction(0) 	    = D
    -- sy(1)                = C
    -- instruction(1)	    = B
    -- instruction(12)      = A
        sy_or_kk(1) <= 
             (not instruction_12 and sy(1)) or 
             (instruction_12 and instruction_7_downto_0(1)); 

    -- calculate sy_or_kk(2)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- sy(2)                = E
    -- instruction(2) 	    = D
    -- sy(3)                = C
    -- instruction(3)	    = B
    -- instruction(12)      = A
        sy_or_kk(2) <= 
             (not instruction_12 and sy(2)) or 
             (instruction_12 and instruction_7_downto_0(2)); 

    -- calculate sy_or_kk(3)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- sy(2)                = E
    -- instruction(2) 	    = D
    -- sy(3)                = C
    -- instruction(3)	    = B
    -- instruction(12)      = A
        sy_or_kk(3) <= 
             (not instruction_12 and sy(3)) or 
             (instruction_12 and instruction_7_downto_0(3)); 
    
    -- calculate sy_or_kk(4)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- sy(4)                = E
    -- instruction(4) 	    = D
    -- sy(5)                = C
    -- instruction(5)	    = B
    -- instruction(12)      = A
        sy_or_kk(4) <= 
             (not instruction_12 and sy(4)) or 
             (instruction_12 and instruction_7_downto_0(4)); 

    -- calculate sy_or_kk(5)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- sy(4)                = E
    -- instruction(4) 	    = D
    -- sy(5)                = C
    -- instruction(5)	    = B
    -- instruction(12)      = A
        sy_or_kk(5) <= 
             (not instruction_12 and sy(5)) or 
             (instruction_12 and instruction_7_downto_0(5)); 
  
   -- calculate sy_or_kk(6)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- sy(6)                = E
    -- instruction(6) 	    = D
    -- sy(7)                = C
    -- instruction(7)	    = B
    -- instruction(12)      = A
        sy_or_kk(6) <= 
             (not instruction_12 and sy(6)) or 
             (instruction_12 and instruction_7_downto_0(6)); 

    -- calculate sy_or_kk(7)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- sy(6)                = E
    -- instruction(6) 	    = D
    -- sy(7)                = C
    -- instruction(7)	    = B
    -- instruction(12)      = A
        sy_or_kk(7) <= 
             (not instruction_12 and sy(7)) or 
             (instruction_12 and instruction_7_downto_0(7)); 
       
end Behavioral;
