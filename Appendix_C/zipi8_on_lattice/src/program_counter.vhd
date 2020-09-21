----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2019 11:15:52 PM
-- Design Name: 
-- Module Name: program_counter - Behavioral
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

entity program_counter is
    Port ( 
         clk : in std_logic;
         register_vector : in std_logic_vector(11 downto 0);
         pc_vector : in std_logic_vector(11 downto 0);
         t_state_1 : in std_logic;
         internal_reset : in std_logic;
         pc_mode : in std_logic_vector(2 downto 0);
         pc : out std_logic_vector(11 downto 0) := B"0000_0000_0000"
    );
end program_counter;

architecture Behavioral of program_counter is

    signal pc_value :  std_logic_vector(11 downto 0);
    signal half_pc :  std_logic_vector(11 downto 0);
    signal carry_pc :  std_logic_vector(10 downto 0);
    
begin

    flipflops_R_CE_process: process (clk, internal_reset, pc_value, t_state_1) begin
        if rising_edge(clk) then
            if (internal_reset = '1') then 
                pc <= B"0000_0000_0000";    
            elsif t_state_1 = '1' then
                pc <= pc_value;
            end if;    
        end if;
     end process flipflops_R_CE_process; 

    -- note: half_pc depends on generic interrupt_vector. For now we set it to constant 0x3FF

    -- calculate half_pc(0)
    -- LUT INIT = 0x00AA00FF33CC0F00
    -- y = AB'C' + AC'F + A'B'CD' + A'BC'E + A'BCE'
    -- register_vector(0)               = F
    -- pc_vector(0)                     = E
    -- pc(0)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(0) <=  
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(0)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and not pc(0)) or
			(not pc_mode(2) and pc_mode(1) and not pc_mode(0) and pc_vector(0)) or
			(not pc_mode(2) and pc_mode(1) and pc_mode(0) and not pc_vector(0));             

    -- calculate half_pc(1)
    -- LUT INIT = 0x00AA00FFCCCCF000
    -- y = A'BE + AB'C' + AC'F + A'B'CD
    -- register_vector(1)               = F
    -- pc_vector(1)                     = E
    -- pc(1)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(1) <=  
			(not pc_mode(2) and pc_mode(1) and pc_vector(1)) or
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(1)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and pc(1));            

    -- calculate half_pc(2)
    -- LUT INIT = 0x00AA00FF33CC0F00
    -- y = AB'C' + AC'F + A'B'CD' + A'BC'E + A'BCE'
    -- register_vector(2)               = F
    -- pc_vector(2)                     = E
    -- pc(2)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(2) <=  
		   (not pc_mode(2) and pc_mode(1) and pc_vector(2)) or
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(2)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and pc(2));         

   -- calculate half_pc(3)
    -- LUT INIT = 0x00AA00FF33CC0F00
    -- y = AB'C' + AC'F + A'B'CD' + A'BC'E + A'BCE'
    -- register_vector(3)               = F
    -- pc_vector(3)                     = E
    -- pc(3)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(3) <=  
		   (not pc_mode(2) and pc_mode(1) and pc_vector(3)) or
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(3)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and pc(3));             

   -- calculate half_pc(4)
    -- LUT INIT = 0x00AA00FF33CC0F00
    -- y = AB'C' + AC'F + A'B'CD' + A'BC'E + A'BCE'
    -- register_vector(4)               = F
    -- pc_vector(4)                     = E
    -- pc(4)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(4) <=  
			(not pc_mode(2) and pc_mode(1) and pc_vector(4)) or
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(4)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and pc(4));             

    -- calculate half_pc(*)
    -- LUT INIT = 0x00AA00FF33CC0F00
    -- y = AB'C' + AC'F + A'B'CD' + A'BC'E + A'BCE'
    -- register_vector(5)               = F
    -- pc_vector(5)                     = E
    -- pc(5)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(5) <=  
		  (not pc_mode(2) and pc_mode(1) and pc_vector(5)) or
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(5)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and pc(5));             
    
    -- calculate half_pc(6)
    -- LUT INIT = 0x00AA00FF33CC0F00
    -- y = AB'C' + AC'F + A'B'CD' + A'BC'E + A'BCE'
    -- register_vector(6)               = F
    -- pc_vector(6)                     = E
    -- pc(6)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(6) <=  
		   (not pc_mode(2) and pc_mode(1) and pc_vector(6)) or
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(6)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and pc(6));            
    
    -- calculate half_pc(7)
    -- LUT INIT = 0x00AA00FF33CC0F00
    -- y = AB'C' + AC'F + A'B'CD' + A'BC'E + A'BCE'
    -- register_vector(7)               = F
    -- pc_vector(7)                     = E
    -- pc(7)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(7) <=  
			(not pc_mode(2) and pc_mode(1) and pc_vector(7)) or
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(7)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and pc(7));           

    -- calculate half_pc(8)
    -- LUT INIT = 0x00AA00FF33CC0F00
    -- y = AB'C' + AC'F + A'B'CD' + A'BC'E + A'BCE'
    -- register_vector(8)               = F
    -- pc_vector(8)                     = E
    -- pc(8)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(8) <=  
			(not pc_mode(2) and pc_mode(1) and pc_vector(8)) or
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(8)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and pc(8));               
            
    -- calculate half_pc(9)
    -- LUT INIT = 0x00AA00FF33CC0F00
    -- y = AB'C' + AC'F + A'B'CD' + A'BC'E + A'BCE'
    -- register_vector(9)               = F
    -- pc_vector(9)                     = E
    -- pc(9)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(9) <=  
			(not pc_mode(2) and pc_mode(1) and pc_vector(9)) or
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(9)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and pc(9));              
    
    -- calculate half_pc(10)
    -- LUT INIT = 0x00AA00FF33CC0F00
    -- y = AB'C' + AC'F + A'B'CD' + A'BC'E + A'BCE'
    -- register_vector(10)               = F
    -- pc_vector(10)                     = E
    -- pc(10)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(10) <=  
			(not pc_mode(2) and pc_mode(1) and pc_vector(10)) or
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(10)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and pc(10));               
    
    -- calculate half_pc(11)
    -- LUT INIT = 0x00AA00FF33CC0F00
    -- y = AB'C' + AC'F + A'B'CD' + A'BC'E + A'BCE'
    -- register_vector(11)               = F
    -- pc_vector(11)                     = E
    -- pc(11)                            = D
    -- pc_mode(0)	                    = C
    -- pc_mode(1)	                    = B
    -- pc_mode(2)	                    = A
	half_pc(11) <=  
			(not pc_mode(2) and pc_mode(1) and pc_vector(11)) or
			(pc_mode(2) and not pc_mode(1) and not pc_mode(0)) or
			(pc_mode(2) and not pc_mode(0) and register_vector(11)) or
			(not pc_mode(2) and not pc_mode(1) and pc_mode(0) and pc(11));             
    
    pc_value(0) <= half_pc(0) xor '0';
    pc_value(1) <= half_pc(1) xor carry_pc(0);
    pc_value(2) <= half_pc(2) xor carry_pc(1);
    pc_value(3) <= half_pc(3) xor carry_pc(2);
    pc_value(4) <= half_pc(4) xor carry_pc(3);
    pc_value(5) <= half_pc(5) xor carry_pc(4);
    pc_value(6) <= half_pc(6) xor carry_pc(5);
    pc_value(7) <= half_pc(7) xor carry_pc(6);
    pc_value(8) <= half_pc(8) xor carry_pc(7);
    pc_value(9) <= half_pc(9) xor carry_pc(8);
    pc_value(10) <= half_pc(10) xor carry_pc(9);
    pc_value(11) <= half_pc(11) xor carry_pc(10);
    
    -- pc_muxcy0
    -- calculate carry_pc(0)
    calc_carry_pc0_process: process (pc_mode(0), half_pc(0)) begin
        case half_pc(0) is
           when '0' =>
             carry_pc(0) <= pc_mode(0);
           when '1' =>
             carry_pc(0) <= '0';	
           when others =>
             carry_pc(0) <= 'X';
        end case; 
    end process calc_carry_pc0_process;
    
    -- pc_muxcy1
    -- calculate carry_pc(1)
    calc_carry_pc1_process: process (carry_pc(0), half_pc(1)) begin
        case half_pc(1) is
           when '0' =>
             carry_pc(1) <= '0';
           when '1' =>
             carry_pc(1) <= carry_pc(0);	
           when others =>
             carry_pc(1) <= 'X';
        end case; 
    end process calc_carry_pc1_process;
    
    -- pc_muxcy2
    -- calculate carry_pc(2)
    calc_carry_pc2_process: process (carry_pc(1), half_pc(2)) begin
        case half_pc(2) is
           when '0' =>
             carry_pc(2) <= '0';
           when '1' =>
             carry_pc(2) <= carry_pc(1);	
           when others =>
             carry_pc(2) <= 'X';
        end case; 
    end process calc_carry_pc2_process;
    
    -- pc_muxcy3
    -- calculate carry_pc(3)
    calc_carry_pc3_process: process (carry_pc(2), half_pc(3)) begin
        case half_pc(3) is
           when '0' =>
             carry_pc(3) <= '0';
           when '1' =>
             carry_pc(3) <= carry_pc(2);	
           when others =>
             carry_pc(3) <= 'X';
        end case; 
    end process calc_carry_pc3_process;
    
    -- pc_muxcy4
    -- calculate carry_pc(4)
    calc_carry_pc4_process: process (carry_pc(3), half_pc(4)) begin
        case half_pc(4) is
           when '0' =>
             carry_pc(4) <= '0';
           when '1' =>
             carry_pc(4) <= carry_pc(3);	
           when others =>
             carry_pc(4) <= 'X';
        end case; 
    end process calc_carry_pc4_process;
    
    -- pc_muxcy5
    -- calculate carry_pc(5)
    calc_carry_pc5_process: process (carry_pc(4), half_pc(5)) begin
        case half_pc(5) is
           when '0' =>
             carry_pc(5) <= '0';
           when '1' =>
             carry_pc(5) <= carry_pc(4);	
           when others =>
             carry_pc(5) <= 'X';
        end case; 
    end process calc_carry_pc5_process;
    
    -- pc_muxcy6
    -- calculate carry_pc(6)
    calc_carry_pc6_process: process (carry_pc(5), half_pc(6)) begin
        case half_pc(6) is
           when '0' =>
             carry_pc(6) <= '0';
           when '1' =>
             carry_pc(6) <= carry_pc(5);	
           when others =>
             carry_pc(6) <= 'X';
        end case; 
    end process calc_carry_pc6_process;
    
    -- pc_muxcy7
    -- calculate carry_pc(7)
    calc_carry_pc7_process: process (carry_pc(6), half_pc(7)) begin
        case half_pc(7) is
           when '0' =>
             carry_pc(7) <= '0';
           when '1' =>
             carry_pc(7) <= carry_pc(6);	
           when others =>
             carry_pc(7) <= 'X';
        end case; 
    end process calc_carry_pc7_process;
    
    -- pc_muxcy8
    -- calculate carry_pc(8)
    calc_carry_pc8_process: process (carry_pc(7), half_pc(8)) begin
        case half_pc(8) is
           when '0' =>
             carry_pc(8) <= '0';
           when '1' =>
             carry_pc(8) <= carry_pc(7);	
           when others =>
             carry_pc(8) <= 'X';
        end case; 
    end process calc_carry_pc8_process;
    
    -- pc_muxcy9
    -- calculate carry_pc(9)
    calc_carry_pc9_process: process (carry_pc(8), half_pc(9)) begin
        case half_pc(9) is
           when '0' =>
             carry_pc(9) <= '0';
           when '1' =>
             carry_pc(9) <= carry_pc(8);	
           when others =>
             carry_pc(9) <= 'X';
        end case; 
    end process calc_carry_pc9_process;
    
    -- pc_muxcy10
    -- calculate carry_pc(10)
    calc_carry_pc10_process: process (carry_pc(9), half_pc(10)) begin
        case half_pc(10) is
           when '0' =>
             carry_pc(10) <= '0';
           when '1' =>
             carry_pc(10) <= carry_pc(9);	
           when others =>
             carry_pc(10) <= 'X';
        end case; 
    end process calc_carry_pc10_process;
    
  
    
end Behavioral;
