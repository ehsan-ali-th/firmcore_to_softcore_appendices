----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2019 07:08:29 PM
-- Design Name: 
-- Module Name: x12_bit_program_address_generator7 - Behavioral
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

entity x12_bit_program_address_generator is
    Port ( 
        clk : in std_logic;
        instruction_12_downto_0 : in std_logic_vector(12 downto 0);
        sx : in std_logic_vector(3 downto 0);
        sy : in std_logic_vector(7 downto 0);
        stack_memory : in std_logic_vector(11 downto 0);
        register_vector : out std_logic_vector(11 downto 0) := B"0000_0000_0000";
        pc_vector : out std_logic_vector(11 downto 0) := B"0000_0000_0000"
    );
end x12_bit_program_address_generator;

architecture Behavioral of x12_bit_program_address_generator is

    signal return_vector : std_logic_vector (11 downto 0) := B"0000_0000_0000";

begin
     register_vector <= sx(3 downto 0) & sy;
       
      flipflops_process: process (clk) begin
        if rising_edge(clk) then
            return_vector <= stack_memory;   
        end if;
     end process flipflops_process; 
     
    -- calculate pc_vector(0)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- instruction_12_downto_0(0)       = E
    -- return_vector(0)                 = D
    -- instruction_12_downto_0(1)       = C
    -- return_vector(1)	                = B
    -- instruction_12_downto_0(12)      = A
    -- Note: it looks like a mux
    calc_pc_vector0_process: process (instruction_12_downto_0(12), instruction_12_downto_0(0), return_vector(0)) begin
        pc_vector(0) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(0)) or 
                        (instruction_12_downto_0(12) and return_vector(0));             
    end process calc_pc_vector0_process;     

    -- calculate pc_vector(1)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- instruction_12_downto_0(0)       = E
    -- return_vector(0)                 = D
    -- instruction_12_downto_0(1)       = C
    -- return_vector(1)	                = B
    -- instruction_12_downto_0(12)      = A
    -- Nnote: it looks like a mux
    calc_pc_vector1_process: process (instruction_12_downto_0(12), instruction_12_downto_0(1), return_vector(1)) begin
        pc_vector(1) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(1)) or
                        (instruction_12_downto_0(12) and return_vector(1));             
    end process calc_pc_vector1_process;  
    
    -- calculate pc_vector(2)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- instruction_12_downto_0(2)       = E
    -- return_vector(2)                 = D
    -- instruction_12_downto_0(3)       = C
    -- return_vector(3)	                = B
    -- instruction_12_downto_0(12)      = A
    -- Nnote: it looks like a mux
    calc_pc_vector2_process: process (instruction_12_downto_0(12), instruction_12_downto_0(2), return_vector(2)) begin
        pc_vector(2) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(2)) or 
                        (instruction_12_downto_0(12) and return_vector(2));             
    end process calc_pc_vector2_process;     

    -- calculate pc_vector(3)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- instruction_12_downto_0(2)       = E
    -- return_vector(2)                 = D
    -- instruction_12_downto_0(3)       = C
    -- return_vector(3)	                = B
    -- instruction_12_downto_0(12)      = A
    -- Nnote: it looks like a mux
    calc_pc_vector3_process: process (instruction_12_downto_0(12), instruction_12_downto_0(3), return_vector(3)) begin
        pc_vector(3) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(3)) or
                        (instruction_12_downto_0(12) and return_vector(3));             
    end process calc_pc_vector3_process;     
 
    -- calculate pc_vector(4)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- instruction_12_downto_0(4)       = E
    -- return_vector(4)                 = D
    -- instruction_12_downto_0(5)       = C
    -- return_vector(5)	                = B
    -- instruction_12_downto_0(12)      = A
    -- Nnote: it looks like a mux
    calc_pc_vector4_process: process (instruction_12_downto_0(12), instruction_12_downto_0(4), return_vector(4)) begin
        pc_vector(4) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(4)) or 
                        (instruction_12_downto_0(12) and return_vector(4));             
    end process calc_pc_vector4_process;     

    -- calculate pc_vector(5)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- instruction_12_downto_0(4)       = E
    -- return_vector(4)                 = D
    -- instruction_12_downto_0(5)       = C
    -- return_vector(5)	                = B
    -- instruction_12_downto_0(12)      = A
    -- Nnote: it looks like a mux
    calc_pc_vector5_process: process (instruction_12_downto_0(12), instruction_12_downto_0(5), return_vector(5)) begin
        pc_vector(5) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(5)) or
                        (instruction_12_downto_0(12) and return_vector(5));             
    end process calc_pc_vector5_process;  
    
    -- calculate pc_vector(6)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- instruction_12_downto_0(6)       = E
    -- return_vector(6)                 = D
    -- instruction_12_downto_0(7)       = C
    -- return_vector(7)	                = B
    -- instruction_12_downto_0(12)      = A
    -- Nnote: it looks like a mux
    calc_pc_vector6_process: process (instruction_12_downto_0(12), instruction_12_downto_0(6), return_vector(6)) begin
        pc_vector(6) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(6)) or 
                        (instruction_12_downto_0(12) and return_vector(6));             
    end process calc_pc_vector6_process;     

    -- calculate pc_vector(7)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- instruction_12_downto_0(6)       = E
    -- return_vector(6)                 = D
    -- instruction_12_downto_0(7)       = C
    -- return_vector(7)	                = B
    -- instruction_12_downto_0(12)      = A
    -- Nnote: it looks like a mux
    calc_pc_vector7_process: process (instruction_12_downto_0(12), instruction_12_downto_0(7), return_vector(7)) begin
        pc_vector(7) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(7)) or
                        (instruction_12_downto_0(12) and return_vector(7));             
    end process calc_pc_vector7_process;
    
    -- calculate pc_vector(8)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- instruction_12_downto_0(8)       = E
    -- return_vector(8)                 = D
    -- instruction_12_downto_0(9)       = C
    -- return_vector(9)	                = B
    -- instruction_12_downto_0(12)      = A
    -- Nnote: it looks like a mux
    calc_pc_vector8_process: process (instruction_12_downto_0(12), instruction_12_downto_0(8), return_vector(8)) begin
        pc_vector(8) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(8)) or 
                        (instruction_12_downto_0(12) and return_vector(8));             
    end process calc_pc_vector8_process;     

    -- calculate pc_vector(9)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- instruction_12_downto_0(8)       = E
    -- return_vector(8)                 = D
    -- instruction_12_downto_0(9)       = C
    -- return_vector(9)	                = B
    -- instruction_12_downto_0(12)      = A
    -- Nnote: it looks like a mux
    calc_pc_vector9_process: process (instruction_12_downto_0(12), instruction_12_downto_0(9), return_vector(9)) begin
        pc_vector(9) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(9)) or
                        (instruction_12_downto_0(12) and return_vector(9));             
    end process calc_pc_vector9_process;         

    -- calculate pc_vector(10)
    -- LUT INIT = 0xCCCCAAAA
    -- y =  A'E + AD
    -- instruction_12_downto_0(10)       = E
    -- return_vector(10)                 = D
    -- instruction_12_downto_0(11)       = C
    -- return_vector(11)                 = B
    -- instruction_12_downto_0(12)       = A
    -- Nnote: it looks like a mux
    calc_pc_vector10_process: process (instruction_12_downto_0(12), instruction_12_downto_0(10), return_vector(10)) begin
        pc_vector(10) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(10)) or 
                        (instruction_12_downto_0(12) and return_vector(10));             
    end process calc_pc_vector10_process;     

    -- calculate pc_vector(11)
    -- LUT INIT = 0xFF00F0F0
    -- y =  A'C + AB
    -- instruction_12_downto_0(8)       = E
    -- return_vector(8)                 = D
    -- instruction_12_downto_0(9)       = C
    -- return_vector(9)	                = B
    -- instruction_12_downto_0(12)      = A
    -- Nnote: it looks like a mux
    calc_pc_vector11_process: process (instruction_12_downto_0(12), instruction_12_downto_0(11), return_vector(11)) begin
        pc_vector(11) <=  
                        (not instruction_12_downto_0(12) and instruction_12_downto_0(11)) or
                        (instruction_12_downto_0(12) and return_vector(11));             
    end process calc_pc_vector11_process;         
    
             
end Behavioral;
