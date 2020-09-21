----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2019 12:04:07 PM
-- Design Name: 
-- Module Name: decode4alu - Behavioral
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

entity decode4alu is
  Port (
        clk : in std_logic;   
        carry_flag : in std_logic;
        instruction_16_downto_13 : in std_logic_vector (16 downto 13);
        alu_mux_sel : out std_logic_vector (1 downto 0) := B"00";
        arith_logical_sel : out std_logic_vector (2 downto 0) := B"000" ;
        arith_carry_in : out std_logic := '0'
        
   );
end decode4alu;

architecture Behavioral of decode4alu is
    
    signal alu_mux_sel_value : std_logic_vector (1 downto 0) := B"00";

    begin

  flipflops_process: process (clk) begin
        if rising_edge(clk) then
            alu_mux_sel <= alu_mux_sel_value;             
        end if;
     end process flipflops_process; 
     
    -- calculate alu_mux_sel_value(0)
    -- LUT INIT = 0x04200000 
    -- y = AB'CD'E + ABC'DE'  
    -- instruction_16_downto_13(13)     = E
    -- instruction_16_downto_13(14) 	= D
    -- instruction_16_downto_13(15)     = C
    -- instruction_16_downto_13(16)	    = B
    -- 1                                = A
    calc_alu_mux_sel_value0_process: process (instruction_16_downto_13) begin
        alu_mux_sel_value(0) <= (not instruction_16_downto_13(16) and 
                                     instruction_16_downto_13(15) and 
                                 not instruction_16_downto_13(14) and
                                     instruction_16_downto_13(13))      or 
                                    (instruction_16_downto_13(16) and 
                                 not instruction_16_downto_13(15) and
                                     instruction_16_downto_13(14) and 
                                 not instruction_16_downto_13(13));             
    end process calc_alu_mux_sel_value0_process; 

    -- calculate arith_logical_sel(0)
    -- LUT INIT = 0x03CA0000 
    -- y = AB'C'E + AB'CD + ABC'D'
    -- instruction_16_downto_13(13)     = E
    -- instruction_16_downto_13(14) 	= D
    -- instruction_16_downto_13(15)     = C
    -- instruction_16_downto_13(16)	    = B
    -- 1                                = A
    calc_arith_logical_sel_process: process (instruction_16_downto_13) begin
        arith_logical_sel(0) <= (not instruction_16_downto_13(16) and not instruction_16_downto_13(15) and instruction_16_downto_13(13)) or 
                                (not instruction_16_downto_13(16) and instruction_16_downto_13(15) and instruction_16_downto_13(14)) or
                                (instruction_16_downto_13(16) and not instruction_16_downto_13(15) and not instruction_16_downto_13(14));             
    end process calc_arith_logical_sel_process; 
    
    -- calculate alu_mux_sel_value(1)
    -- LUT INIT = 0x00000F00 
    -- y = A'BC'
    -- carry_flag     = E
    -- instruction_16_downto_13(13) 	= D
    -- instruction_16_downto_13(14)     = C
    -- instruction_16_downto_13(15)	    = B
    -- instruction_16_downto_13(16)     = A
    calc_alu_mux_sel_value1_process: process (instruction_16_downto_13(16), instruction_16_downto_13(15), instruction_16_downto_13(14)) begin
        alu_mux_sel_value(1) <=  not instruction_16_downto_13(16) and instruction_16_downto_13(15) and not instruction_16_downto_13(14);             
    end process calc_alu_mux_sel_value1_process; 
    
  -- calculate arith_carry_in
    -- LUT INIT = 0x77080000
    -- y = ABD' + ABE' + AB'C'DE
    -- carry_flag     = E
    -- instruction_16_downto_13(13) 	= D
    -- instruction_16_downto_13(14)     = C
    -- instruction_16_downto_13(15)	    = B
    -- instruction_16_downto_13(16)     = A
    calc_arith_carry_in_process: process (instruction_16_downto_13, carry_flag) begin
        arith_carry_in <= (instruction_16_downto_13(16) and instruction_16_downto_13(15) and not instruction_16_downto_13(13)) or 
                          (instruction_16_downto_13(16) and instruction_16_downto_13(15) and not carry_flag) or
                          (instruction_16_downto_13(16) and not instruction_16_downto_13(15) and not instruction_16_downto_13(14)
                             and instruction_16_downto_13(13) and carry_flag);             
    end process calc_arith_carry_in_process;     
    
    -- calculate arith_logical_sel(1)
    -- LUT INIT = 0x02000000 
    -- y =  ABC'D'E
    -- instruction_16_downto_13(14)     = E
    -- instruction_16_downto_13(15) 	= D
    -- instruction_16_downto_13(16)     = C
    -- 1	                            = B
    -- 1                                = A
    calc_arith_logical_sel1_process: process (instruction_16_downto_13(16), instruction_16_downto_13(15), instruction_16_downto_13(14)) begin
        arith_logical_sel(1) <=  not instruction_16_downto_13(16) and not instruction_16_downto_13(15) and instruction_16_downto_13(14);             
    end process calc_arith_logical_sel1_process;  
    
    -- calculate arith_logical_sel(2)
    -- LUT INIT = 0xD0000000
    -- y =  ABCE' + ABCD
    -- instruction_16_downto_13(14)     = E
    -- instruction_16_downto_13(15) 	= D
    -- instruction_16_downto_13(16)     = C
    -- 1	                            = B
    -- 1                                = A
    calc_arith_logical_sel2_process: process (instruction_16_downto_13(16), instruction_16_downto_13(15), instruction_16_downto_13(14)) begin
        arith_logical_sel(2) <=  (instruction_16_downto_13(16) and not instruction_16_downto_13(14)) or 
                                 (instruction_16_downto_13(16) and instruction_16_downto_13(15));             
    end process calc_arith_logical_sel2_process;


end Behavioral;
