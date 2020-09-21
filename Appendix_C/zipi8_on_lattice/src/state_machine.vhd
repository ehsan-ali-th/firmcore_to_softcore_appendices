----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2019 05:42:22 PM
-- Design Name: 
-- Module Name: state_machine - Behavioral
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

entity state_machine is
    Port ( 
        clk : in std_logic;
        sleep : in std_logic;
        interrupt : in std_logic;
        reset : in std_logic;
        special_bit : in std_logic;
        instruction_17_downto_13  : in std_logic_vector(17 downto 13);
        instruction_0 : in std_logic;
        stack_pointer_carry_4 : in std_logic;
        bank : in std_logic;
        t_state : out std_logic_vector (2 downto 1) := "00";
        run : out std_logic := '0';
        active_interrupt : out std_logic := '0';
        internal_reset : out std_logic := '0';
        sx_addr4_value : out std_logic := '0';
        interrupt_ack : out std_logic := '0'
    );
end state_machine;

architecture Behavioral of state_machine is

    signal  run_value : std_logic := '0';
    signal  internal_reset_value : std_logic := '1';
    signal  sync_sleep : std_logic := '0';
    signal  sync_interrupt : std_logic := '0';
    signal  t_state_value : std_logic_vector (2 downto 1) := "10";
    signal  interrupt_enable_value : std_logic := '0';
    signal  interrupt_enable : std_logic := '0';
    signal  active_interrupt_value : std_logic := '0';
    signal  loadstar_type : std_logic := '0';
    signal  int_enable_type : std_logic := '0';
    
begin

    flipflops_process: process (clk) begin
        if rising_edge(clk) then
                        run <= run_value;
             internal_reset <= internal_reset_value;
                 sync_sleep <= sleep;    
                    t_state <= t_state_value;   
           interrupt_enable <= interrupt_enable_value;     
             sync_interrupt <= interrupt;
           active_interrupt <= active_interrupt_value;
              interrupt_ack <= active_interrupt;
        end if;
     end process flipflops_process; 

    -- fill the buffers
--    run <= run_buf;
--    internal_reset <= internal_reset_buf;
--    t_state <= t_state_buf;
    
    -- calculate run_value
    -- LUT INIT = 0x00000EEE
    -- y = A'B'E + A'C'E + A'B'D + A'C'D
    -- run 					    = E
    -- internal_reset 			= D
    -- stack_pointer_carry(4) 	= C
    -- t_state(2) 				= B
    -- reset 					= A
	run_value <= (not reset and not t_state(2) and run) or
				 (not reset and not stack_pointer_carry_4 and run) or 
				 (not reset and not t_state(2) and internal_reset) or
				 (not reset and not stack_pointer_carry_4 and internal_reset);                 
    
    -- calculate internal_reset_value
    -- LUT INIT = 0xFFFFF555
    -- y = E' + A + BC
    -- run 					    = E
    -- internal_reset 			= D
    -- stack_pointer_carry(4) 	= C
    -- t_state(2) 				= B
    -- reset 					= A
	internal_reset_value <= not run or reset or (t_state(2) and stack_pointer_carry_4);             
    
    -- calculate t_state_value
    -- LUT INIT for t_state_value(1)  0x00C4004C
    -- LUT INIT for t_state_value(2)  0x0083000B
    -- y(1) = B'DE' + A'B'C'D + AB'CD
    -- y(2) = B'C'D' + A'B'C'E + AB'CDE
    -- t_state(1)			    = E
    -- t_state(2)   			= D
    -- sync_sleep            	= C
    -- internal_reset			= B
    -- special_bit				= A
	t_state_value(1) <=  (not internal_reset and t_state(2) and not t_state(1)) or
						 (not special_bit and not internal_reset and not sync_sleep and t_state(2)) or
						 (special_bit and not internal_reset and sync_sleep and t_state(2));  
	t_state_value(2) <=  (not internal_reset and not sync_sleep and not t_state(2)) or
						 (not special_bit and not internal_reset and not sync_sleep and t_state(1)) or
						 (special_bit and not internal_reset and sync_sleep and t_state(2) and t_state(1));            
    
  -- calculate interrupt_enable_value
    -- LUT INIT = 0x000000000000CAAA
    -- y =  A'B'C'F + A'B'D'F + A'B'CDE
    -- interrupt_enable         = F 
    -- instruction_0		    = E
    -- int_enable_type 			= D
    -- t_state(1)            	= C
    -- active_interrupt			= B
    -- internal_reset   		= A
	interrupt_enable_value <=  (not internal_reset and not active_interrupt and not t_state(1) and interrupt_enable) or 
							   (not internal_reset and not active_interrupt and not int_enable_type and interrupt_enable) or 
							   (not internal_reset and not active_interrupt and t_state(1) and int_enable_type and instruction_0);             
    
    -- calculate active_interrupt_value
    -- LUT INIT = 0x80808080
    -- y =  CDE
    -- interrupt_enable		    = E
    -- t_state(2) 			    = D
    -- sync_interrupt           = C
    -- bank			            = B
    -- loadstar_type   		    = A
	active_interrupt_value <=  sync_interrupt and t_state(2) and interrupt_enable;             
    
    -- calculate sx_addr4_value
    -- LUT INIT = 0xCC33FF00 
    -- y =  A'B + BD + AB'D'
    -- interrupt_enable		    = E
    -- t_state(2) 			    = D
    -- sync_interrupt           = C
    -- bank			            = B
    -- loadstar_type   		    = A
	sx_addr4_value <=  (not loadstar_type and bank) or 
					   (bank and t_state(2)) or
					   (loadstar_type and not bank and not t_state(2));             
    
    -- calculate loadstar_type
    -- LUT INIT = 0x00000800
    -- y = A'BC'DE
    -- instruction(13)		    = E
    -- instruction(14) 		    = D
    -- instruction(15)          = C
    -- instruction(16)	        = B
    -- instruction(17)          = A
	loadstar_type <= (not instruction_17_downto_13(17)) and
						   instruction_17_downto_13(16) and
					 (not instruction_17_downto_13(15)) and
						   instruction_17_downto_13(14) and
						   instruction_17_downto_13(13);             
    
    -- calculate int_enable_type
    -- LUT INIT = 0x00100000 
    -- y = AB'CD'E'
    -- instruction(13)		    = E
    -- instruction(14) 		    = D
    -- instruction(15)          = C
    -- instruction(16)	        = B
    -- instruction(17)          = A
	int_enable_type <=     instruction_17_downto_13(17) and
					 (not instruction_17_downto_13(16)) and
						   instruction_17_downto_13(15) and
					 (not instruction_17_downto_13(14)) and
					 (not instruction_17_downto_13(13));             

end Behavioral;
