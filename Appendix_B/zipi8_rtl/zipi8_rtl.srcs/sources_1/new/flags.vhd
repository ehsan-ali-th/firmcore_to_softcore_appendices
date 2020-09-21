----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2019 03:43:58 PM
-- Design Name: 
-- Module Name: flags - Behavioral
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

entity flags is
    Port ( 
        clk : in std_logic;
        instruction_16_downto_13  : in std_logic_vector(16 downto 13);
        carry_arith_logical_7 : in std_logic;
        instruction_7 : in std_logic;
        instruction_3 : in std_logic;
        arith_logical_result  : in std_logic_vector(7 downto 0);
        shadow_carry_flag : in std_logic;
        flag_enable : in std_logic;
        alu_result  : in std_logic_vector(7 downto 0);
        internal_reset : in std_logic;
        shadow_zero_flag : in std_logic;
        sx_0 : in std_logic;
        sx_7 : in std_logic;
        zero_flag : out std_logic := '0';
        carry_flag : out std_logic := '0';
        strobe_type : out std_logic := '0'
    );
end flags;

architecture Behavioral of flags is

    signal arith_carry_value : std_logic := '0';
    signal arith_carry : std_logic := '0';
    signal lower_parity : std_logic := '0';
    signal lower_parity_sel : std_logic := '0';
    signal upper_parity : std_logic := '0';
    signal shift_carry_value : std_logic := '0';
    signal shift_carry : std_logic := '0';
    signal parity : std_logic := '0';
    signal carry_lower_parity : std_logic := '0';
    signal drive_carry_in_zero : std_logic := '0';
    signal carry_flag_value : std_logic := '0';
    signal carry_in_zero : std_logic := '0';
    signal lower_zero : std_logic := '1';
    signal lower_zero_sel : std_logic := '0';
    signal carry_lower_zero : std_logic := '1';
    signal use_zero_flag_value : std_logic := '0';
    signal middle_zero_sel : std_logic := '1';
    signal use_zero_flag : std_logic := '0';
    signal middle_zero : std_logic := '0';
    signal carry_middle_zero : std_logic := '1';
    signal upper_zero_sel : std_logic := '1';
    signal zero_flag_value : std_logic := '1';
    
begin

    flipflops_process: process (clk) begin
        if rising_edge(clk) then
            arith_carry <= arith_carry_value;
            shift_carry <= shift_carry_value;
            use_zero_flag <= use_zero_flag_value;
        end if;
     end process flipflops_process; 

     flipflops_R_CE_process: process (clk) begin
        if rising_edge(clk) then
            if (internal_reset = '1') then 
                zero_flag <= '0';
                carry_flag <= '0';
            elsif flag_enable = '1' then
                zero_flag <= zero_flag_value;
                carry_flag <= carry_flag_value;
            end if;    
        end if;
     end process flipflops_R_CE_process; 
     
     
    
    -- gates 
    arith_carry_value <= carry_arith_logical_7 xor '0';
    parity <= carry_lower_parity xor upper_parity;
    
    -- calculate lower_parity
    -- LUT INIT = 0x0010F7CE
    -- y = B'CD' + B'CE' + BC'D' + BC'E' + B'C'DE + BCDE
    -- instruction_16_downto_13(13)     = E
    -- carry_flag 	                    = D
    -- arith_logical_result(0)            = C
    -- arith_logical_result(1)	        = B
    -- 1                                = A
	lower_parity <= (not arith_logical_result(1) and arith_logical_result(0) and not carry_flag) or 
					(not arith_logical_result(1) and arith_logical_result(0) and not instruction_16_downto_13(13)) or 
					(arith_logical_result(1) and not arith_logical_result(0) and not carry_flag) or 
					(arith_logical_result(1) and not arith_logical_result(0) and not instruction_16_downto_13(13)) or 
					(not arith_logical_result(1) and not arith_logical_result(0) and carry_flag and instruction_16_downto_13(13)) or 
					(arith_logical_result(1)and arith_logical_result(0) and carry_flag and instruction_16_downto_13(13));             

    -- calculate lower_parity_sel
    -- LUT INIT = 0x0010F7CE
    -- y = 0
    -- instruction_16_downto_13(13)     = E
    -- carry_flag 	                    = D
    -- arith_logical_result(0)          = C
    -- arith_logical_result(1)	        = B
    -- 1                                = A
	lower_parity_sel <= '0';             

    -- calculate upper_parity
    -- LUT INIT = 0x6996966996696996
    -- y =  A'B'C'D'E'F + A'B'C'D'EF' + A'B'C'DE'F' + A'B'C'DEF + A'B'CD'E'F' + A'B'CD'EF + A'B'CDE'F + A'B'CDEF' + 
    --      A'BC'D'E'F' + A'BC'D'EF + A'BC'DE'F + A'BC'DEF' + A'BCD'E'F + A'BCD'EF' + A'BCDE'F' + A'BCDEF + AB'C'D'E'F' +
    --      AB'C'D'EF + AB'C'DE'F + AB'C'DEF' + AB'CD'E'F + AB'CD'EF' + AB'CDE'F' + AB'CDEF + ABC'D'E'F + ABC'D'EF' +
    --      ABC'DE'F' + ABC'DEF + ABCD'E'F' + ABCD'EF + ABCDE'F + ABCDEF'
    --      Note: This is 6 input xor
    -- arith_logical_result(2)            = F
    -- arith_logical_result(3)            = E
    -- arith_logical_result(4)            = D
    -- arith_logical_result(5)            = C
    -- arith_logical_result(6)	        = B
    -- arith_logical_result(7)            = A
	upper_parity <=  
        (not arith_logical_result(7) and not arith_logical_result(6) and not arith_logical_result(5) and not arith_logical_result(4) and not arith_logical_result(3) and arith_logical_result(2)) or
        (not arith_logical_result(7) and not arith_logical_result(6) and not arith_logical_result(5) and not arith_logical_result(4) and arith_logical_result(3) and not arith_logical_result(2)) or
        (not arith_logical_result(7) and not arith_logical_result(6) and not arith_logical_result(5) and arith_logical_result(4) and not arith_logical_result(3) and not arith_logical_result(2)) or
        (not arith_logical_result(7) and not arith_logical_result(6) and not arith_logical_result(5) and arith_logical_result(4) and arith_logical_result(3) and arith_logical_result(2)) or
        (not arith_logical_result(7) and not arith_logical_result(6) and arith_logical_result(5) and not arith_logical_result(4) and not arith_logical_result(3) and not arith_logical_result(2)) or
        (not arith_logical_result(7) and not arith_logical_result(6) and arith_logical_result(5) and not arith_logical_result(4) and arith_logical_result(3) and arith_logical_result(2)) or
        (not arith_logical_result(7) and not arith_logical_result(6) and arith_logical_result(5) and arith_logical_result(4) and not arith_logical_result(3) and arith_logical_result(2)) or
        (not arith_logical_result(7) and not arith_logical_result(6) and arith_logical_result(5) and arith_logical_result(4) and arith_logical_result(3) and not arith_logical_result(2)) or
        (not arith_logical_result(7) and arith_logical_result(6) and not arith_logical_result(5) and not arith_logical_result(4) and not arith_logical_result(3) and not arith_logical_result(2)) or
        (not arith_logical_result(7) and arith_logical_result(6) and not arith_logical_result(5) and not arith_logical_result(4) and arith_logical_result(3) and arith_logical_result(2)) or
        (not arith_logical_result(7) and arith_logical_result(6) and not arith_logical_result(5) and arith_logical_result(4) and not arith_logical_result(3) and arith_logical_result(2)) or
        (not arith_logical_result(7) and arith_logical_result(6) and not arith_logical_result(5) and arith_logical_result(4) and arith_logical_result(3) and not arith_logical_result(2)) or
        (not arith_logical_result(7) and arith_logical_result(6) and arith_logical_result(5) and not arith_logical_result(4) and not arith_logical_result(3) and arith_logical_result(2)) or
        (not arith_logical_result(7) and arith_logical_result(6) and arith_logical_result(5) and not arith_logical_result(4) and arith_logical_result(3) and not arith_logical_result(2)) or
        (not arith_logical_result(7) and arith_logical_result(6) and arith_logical_result(5) and arith_logical_result(4) and not arith_logical_result(3) and not arith_logical_result(2)) or
        (not arith_logical_result(7) and arith_logical_result(6) and arith_logical_result(5) and arith_logical_result(4) and arith_logical_result(3) and arith_logical_result(2)) or
        (arith_logical_result(7) and not arith_logical_result(6) and not arith_logical_result(5) and not arith_logical_result(4) and not arith_logical_result(3) and not arith_logical_result(2)) or
        (arith_logical_result(7) and not arith_logical_result(6) and not arith_logical_result(5) and not arith_logical_result(4) and arith_logical_result(3) and arith_logical_result(2)) or
        (arith_logical_result(7) and not arith_logical_result(6) and not arith_logical_result(5) and arith_logical_result(4) and not arith_logical_result(3) and arith_logical_result(2)) or
        (arith_logical_result(7) and not arith_logical_result(6) and not arith_logical_result(5) and arith_logical_result(4) and arith_logical_result(3) and not arith_logical_result(2)) or
        (arith_logical_result(7) and not arith_logical_result(6) and arith_logical_result(5) and not arith_logical_result(4) and not arith_logical_result(3) and arith_logical_result(2)) or
        (arith_logical_result(7) and not arith_logical_result(6) and arith_logical_result(5) and not arith_logical_result(4) and arith_logical_result(3) and not arith_logical_result(2)) or
        (arith_logical_result(7) and not arith_logical_result(6) and arith_logical_result(5) and arith_logical_result(4) and not arith_logical_result(3) and not arith_logical_result(2)) or
        (arith_logical_result(7) and not arith_logical_result(6) and arith_logical_result(5) and arith_logical_result(4) and arith_logical_result(3) and arith_logical_result(2)) or
        (arith_logical_result(7) and arith_logical_result(6) and not arith_logical_result(5) and not arith_logical_result(4) and not arith_logical_result(3) and arith_logical_result(2)) or
        (arith_logical_result(7) and arith_logical_result(6) and not arith_logical_result(5) and not arith_logical_result(4) and arith_logical_result(3) and not arith_logical_result(2)) or
        (arith_logical_result(7) and arith_logical_result(6) and not arith_logical_result(5) and arith_logical_result(4) and not arith_logical_result(3) and not arith_logical_result(2)) or
        (arith_logical_result(7) and arith_logical_result(6) and not arith_logical_result(5) and arith_logical_result(4) and arith_logical_result(3) and arith_logical_result(2)) or
        (arith_logical_result(7) and arith_logical_result(6) and arith_logical_result(5) and not arith_logical_result(4) and not arith_logical_result(3) and not arith_logical_result(2)) or
        (arith_logical_result(7) and arith_logical_result(6) and arith_logical_result(5) and not arith_logical_result(4) and arith_logical_result(3) and arith_logical_result(2)) or
        (arith_logical_result(7) and arith_logical_result(6) and arith_logical_result(5) and arith_logical_result(4) and not arith_logical_result(3) and arith_logical_result(2)) or
        (arith_logical_result(7) and arith_logical_result(6) and arith_logical_result(5) and arith_logical_result(4) and arith_logical_result(3) and not arith_logical_result(2));
    
    -- calculate shift_carry_value
    -- LUT INIT = 0xFFFFAACCF0F0F0F0
    -- y = A'D + AB + AC'E + ACF
    -- sx(0)                        = F
    -- sx(7)                        = E
    -- shadow_carry_flag            = D
    -- instruction(3)               = C
    -- instruction(7)	            = B
    -- instruction_16_downto_13(16) = A
	shift_carry_value <=  
		(not instruction_16_downto_13(16) and shadow_carry_flag) or
		(instruction_16_downto_13(16) and instruction_7) or
		(instruction_16_downto_13(16) and not instruction_3 and sx_7) or
		(instruction_16_downto_13(16) and instruction_3 and sx_0);
    
    -- parity_muxcy
    -- calculate carry_lower_parity
    calc_carry_lower_parity_process: process (lower_parity_sel, lower_parity) begin
        case lower_parity_sel is
           when '0' =>
             carry_lower_parity <= lower_parity;
           when '1' =>
             carry_lower_parity <= '0';	
           when others =>
             carry_lower_parity <= 'X';
        end case; 
    end process calc_carry_lower_parity_process;

  -- calculate drive_carry_in_zero
    -- LUT INIT = 0xF0AA0000
    -- y = AB'E + ABC
    -- shift_carry                      = E
    -- arith_carry 	                    = D
    -- parity                           = C
    -- instruction(14)	                = B
    -- instruction(15)                  = A
	drive_carry_in_zero <= 
		(instruction_16_downto_13(15) and not instruction_16_downto_13(14) and shift_carry) or
		(instruction_16_downto_13(15) and instruction_16_downto_13(14) and parity);             
    
    -- calculate carry_flag_value
    -- LUT INIT = 0x3333AACCF0AA0000
    -- y =  ABE' + A'BC'F + A'BCD + AB'C'E + AB'CF
    -- shift_carry                      = F
    -- arith_carry 	                    = E
    -- parity                           = D
    -- instruction(14)	                = C
    -- instruction(15)                  = B
    -- instruction(16)                  = A
	carry_flag_value <= 
		(instruction_16_downto_13(16) and instruction_16_downto_13(15) and not arith_carry) or
		(not instruction_16_downto_13(16) and instruction_16_downto_13(15) and not instruction_16_downto_13(14) and shift_carry) or
		(not instruction_16_downto_13(16) and instruction_16_downto_13(15) and instruction_16_downto_13(14) and parity) or
		(instruction_16_downto_13(16) and not instruction_16_downto_13(15) and not instruction_16_downto_13(14) and arith_carry) or
		(instruction_16_downto_13(16) and not instruction_16_downto_13(15) and instruction_16_downto_13(14) and shift_carry);             
    
    -- init_zero_muxcy
    -- calculate carry_lower_parity
    calc_carry_in_zero_process: process (drive_carry_in_zero, carry_flag_value) begin
        case carry_flag_value is
           when '0' =>
             carry_in_zero <= drive_carry_in_zero;
           when '1' =>
             carry_in_zero <= '0';	
           when others =>
             carry_in_zero <= 'X';
        end case; 
    end process calc_carry_in_zero_process;
    
    -- calculate lower_zero
    -- LUT INIT = 0x00000001
    -- y = A'B'C'D'E'
    -- alu_result(0)            = E
    -- alu_result(1)            = D
    -- alu_result(2)            = C
    -- alu_result(3)	        = B
    -- alu_result(4)            = A
	lower_zero <= not alu_result(4) and not alu_result(3) and not alu_result(2) and not alu_result(1) and not alu_result(0);             
    
    -- calculate lower_zero_sel
    -- LUT INIT = 0x00000000
    -- y =  0
    -- alu_result(0)            = E
    -- alu_result(1)            = D
    -- alu_result(2)            = C
    -- alu_result(3)	        = B
    -- alu_result(4)            = A  
    lower_zero_sel <= '0';             
    
    
    -- lower_zero_muxcy
    -- calculate carry_lower_zero
    calc_carry_lower_zero_process: process (lower_zero, lower_zero_sel, carry_in_zero) begin
        case lower_zero_sel is
           when '0' =>
             carry_lower_zero <= lower_zero;
           when '1' =>
             carry_lower_zero <= carry_in_zero;	
           when others =>
             carry_lower_zero <= 'X';
        end case; 
    end process calc_carry_lower_zero_process;
    
    -- calculate strobe_type
    -- LUT INIT = 0x00F000F0
    -- y =  B'C
    -- instruction_16_downto_13(13)            = E
    -- instruction_16_downto_13(14)            = D
    -- instruction_16_downto_13(15)            = C
    -- instruction_16_downto_13(16)	           = B
    -- 1                                       = A
	strobe_type <= NOT instruction_16_downto_13(16) AND instruction_16_downto_13(15);             
    
    -- calculate use_zero_flag_value
    -- LUT INIT = 0xA2800000
    -- y =  ACDE + ABD'E
    -- instruction_16_downto_13(13)            = E
    -- instruction_16_downto_13(14)            = D
    -- instruction_16_downto_13(15)            = C
    -- instruction_16_downto_13(16)	           = B
    -- 1                                       = A
	use_zero_flag_value <= 
		(instruction_16_downto_13(15) and instruction_16_downto_13(14) and instruction_16_downto_13(13)) or
		(instruction_16_downto_13(16) and not instruction_16_downto_13(14) and instruction_16_downto_13(13));             
  
    -- calculate middle_zero
    -- LUT INIT = 0x00000000
    -- y = 0
    -- use_zero_flag                    = E
    -- zero_flag                        = D
    -- alu_result(5)                    = C
    -- alu_result(6)	                = B
    -- alu_result(7)                    = A
	middle_zero <= '0';             
    
    -- calculate middle_zero_sel
    -- LUT INIT = 0x0000000D
    -- y = A'B'C'E' + A'B'C'D
    -- use_zero_flag                    = E
    -- zero_flag                        = D
    -- alu_result(5)                    = C
    -- alu_result(6)	                = B
    -- alu_result(7)                    = A
	middle_zero_sel <= 
        (not alu_result(7) and not alu_result(6) and not alu_result(5) and not use_zero_flag) or
        (not alu_result(7) and not alu_result(6) and not alu_result(5) and zero_flag);             
    
    -- middle_zero_muxcy
    -- calculate carry_middle_zero
    calc_carry_middle_zero_process: process (middle_zero_sel, middle_zero,  carry_lower_zero) begin
        case middle_zero_sel is
           when '0' =>
             carry_middle_zero <= middle_zero;
           when '1' =>
             carry_middle_zero <= carry_lower_zero;	
           when others =>
             carry_middle_zero <= 'X';
        end case; 
    end process calc_carry_middle_zero_process;

    -- calculate upper_zero_sel
    -- LUT INIT = 0xFBFF000000000000
    --  y = ABC' + ABE' + ABF + ABD
    --  y = 0 + E' + F + D 
    -- instruction_16_downto_13(14)     = F
    -- instruction_16_downto_13(15)     = E
    -- instruction_16_downto_13(16)     = D
    -- 1                                = C
    -- 1	                            = B
    -- 1                                = A
	upper_zero_sel <= not instruction_16_downto_13(15) or
						  instruction_16_downto_13(14) or
						  instruction_16_downto_13(16);             

    -- upper_zero_muxcy
    -- calculate zero_flag_value
    calc_zero_flag_value_process: process (shadow_zero_flag, carry_middle_zero, upper_zero_sel) begin
        case upper_zero_sel is
           when '0' =>
             zero_flag_value <= shadow_zero_flag;
           when '1' =>
             zero_flag_value <= carry_middle_zero;	
           when others =>
             zero_flag_value <= 'X';
        end case; 
    end process calc_zero_flag_value_process;
        
end Behavioral;
