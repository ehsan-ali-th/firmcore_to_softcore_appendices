----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2019 11:56:01 AM
-- Design Name: 
-- Module Name: shift_and_rotate_operations - Behavioral
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

entity shift_and_rotate_operations is
    Port ( 
        clk : in std_logic;
        instruction_7 : in std_logic;
        instruction_3_downto_0 : in std_logic_vector (3 downto 0);
        carry_flag : in std_logic;
        sx : in std_logic_vector (7 downto 0);
        shift_rotate_result : out std_logic_vector (7 downto 0) := X"41"
    );
end shift_and_rotate_operations;

architecture Behavioral of shift_and_rotate_operations is
    
    signal shift_rotate_value: std_logic_vector(7 downto 0) := B"0000_0000";
    signal shift_in_bit: std_logic := '0';
    
begin

    flipflops_R_process: process (clk) begin
        if rising_edge(clk) then
            if (instruction_7 = '1') then           -- D flop-flop with synchronous S
               shift_rotate_result <= B"0100_0001";
            else   
               shift_rotate_result <= shift_rotate_value;
            end if;    
        end if;
    end process flipflops_R_process;   
    
    -- calculate shift_in_bit
    -- LUT INIT = 0xBFBC8F8CB3B08380
    -- y =  DEF + CD'E' + BDE' + AD'E
    -- instruction(0)               = F
    -- instruction(1)               = E
    -- instruction(2)               = D
    -- carry_flag                   = C
    -- sx(0)	                    = B
    -- sx(7)                        = A
        shift_in_bit <= 
            (instruction_3_downto_0(2) and instruction_3_downto_0(1) and instruction_3_downto_0(0)) or
            (carry_flag and not instruction_3_downto_0(2) and not instruction_3_downto_0(1)) or
            (sx(0) and instruction_3_downto_0(2) and not instruction_3_downto_0(1)) or
            (sx(7) and not instruction_3_downto_0(2) and instruction_3_downto_0(1));

    -- calculate shift_rotate_value(0)
    -- LUT INIT = 0xCCCCAAAA
    -- y = A'E + AD
    -- shift_in_bit                     = E
    -- sx(1)                            = D
    -- sx(0)                            = C
    -- sx(2)	                        = B
    -- instruction(3)                   = A
        shift_rotate_value(0) <= 
            (not instruction_3_downto_0(3) and shift_in_bit) or
            (instruction_3_downto_0(3) and sx(1));
    
    -- calculate shift_rotate_value(1)
    -- LUT INIT = 0xFF00F0F0
    -- y = A'C + AB
    -- shift_in_bit                     = E
    -- sx(1)                            = D
    -- sx(0)                            = C
    -- sx(2)	                        = B
    -- instruction(3)                   = A
        shift_rotate_value(1) <= 
            (not instruction_3_downto_0(3) and sx(0)) or 
            (instruction_3_downto_0(3) and sx(2));

    -- calculate shift_rotate_value(2)
    -- LUT INIT = 0xCCCCAAAA
    -- y = A'E + AD
    -- sx(1)                            = E
    -- sx(3)                            = D
    -- sx(2)                            = C
    -- sx(4)	                        = B
    -- instruction(3)                   = A
        shift_rotate_value(2) <= 
            (not instruction_3_downto_0(3) and sx(1)) or
            (instruction_3_downto_0(3) and sx(3));
    
    -- calculate shift_rotate_value(3)
    -- LUT INIT = 0xFF00F0F0
    -- y = A'C + AB
    -- sx(1)                            = E
    -- sx(3)                            = D
    -- sx(2)                            = C
    -- sx(4)	                        = B
    -- instruction(3)                   = A
        shift_rotate_value(3) <= 
            (not instruction_3_downto_0(3) and sx(2)) or 
            (instruction_3_downto_0(3) and sx(4));

    -- calculate shift_rotate_value(4)
    -- LUT INIT = 0xCCCCAAAA
    -- y = A'E + AD
    -- sx(3)                            = E
    -- sx(5)                            = D
    -- sx(4)                            = C
    -- sx(6)	                        = B
    -- instruction(3)                   = A
        shift_rotate_value(4) <= 
            (not instruction_3_downto_0(3) and sx(3)) or
            (instruction_3_downto_0(3) and sx(5));
    
    -- calculate shift_rotate_value(3)
    -- LUT INIT = 0xFF00F0F0
    -- y = A'C + AB
    -- sx(3)                            = E
    -- sx(5)                            = D
    -- sx(4)                            = C
    -- sx(6)	                        = B
    -- instruction(3)                   = A
        shift_rotate_value(5) <= 
            (not instruction_3_downto_0(3) and sx(4)) or 
            (instruction_3_downto_0(3) and sx(6));

    -- calculate shift_rotate_value(6)
    -- LUT INIT = 0xCCCCAAAA
    -- y = A'E + AD
    -- sx(5)                            = E
    -- sx(7)                            = D
    -- sx(6)                            = C
    -- shift_in_bit                     = B
    -- instruction(3)                   = A
        shift_rotate_value(6) <= 
            (not instruction_3_downto_0(3) and sx(5)) or
            (instruction_3_downto_0(3) and sx(7));
    
    -- calculate shift_rotate_value(7)
    -- LUT INIT = 0xFF00F0F0
    -- y = A'C + AB
    -- sx(5)                            = E
    -- sx(7)                            = D
    -- sx(6)                            = C
    -- shift_in_bit                     = B
    -- instruction(3)                   = A
        shift_rotate_value(7) <= 
            (not instruction_3_downto_0(3) and sx(6)) or 
            (instruction_3_downto_0(3) and shift_in_bit);


end Behavioral;
