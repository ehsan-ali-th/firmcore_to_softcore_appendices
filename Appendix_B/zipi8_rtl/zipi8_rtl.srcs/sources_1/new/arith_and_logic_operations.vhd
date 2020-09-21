----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2019 09:54:33 AM
-- Design Name: 
-- Module Name: arith_and_logic_operations - Behavioral
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

entity arith_and_logic_operations is
    Port ( 
        clk : in std_logic;
        sy_or_kk : in std_logic_vector (7 downto 0);
        sx : in std_logic_vector (7 downto 0);
        arith_logical_sel : in std_logic_vector (2 downto 0);
        arith_carry_in : in std_logic;
        arith_logical_result : out std_logic_vector (7 downto 0) := B"0000_0000";
        carry_arith_logical_7 : out std_logic := '0'
    );
end arith_and_logic_operations;

architecture Behavioral of arith_and_logic_operations is

    signal logical_carry_mask : std_logic_vector (7 downto 0) := B"0000_0000";
    signal half_arith_logical : std_logic_vector (7 downto 0) := B"0000_0000";
    signal arith_logical_value : std_logic_vector (7 downto 0) := B"0000_0000";
    signal carry_arith_logical : std_logic_vector (7 downto 0) := B"0000_0000";
    
begin

    flipflops_process: process (clk) begin
        if rising_edge(clk) then
            arith_logical_result <= arith_logical_value;  
        end if;
     end process flipflops_process; 


    carry_arith_logical_7 <= carry_arith_logical(7);
    
    -- calculate logical_carry_mask(0)
    -- LUT INIT = 0xCCCC0000
    -- y =  AD
    -- sy_or_kk(0)              = E
    -- sx(0) 	                = D
    -- arith_logical_sel(0)     = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)     = A
    calc_logical_carry_mask0_process: process (arith_logical_sel(2), sx(0)) begin
        logical_carry_mask(0) <= 
             arith_logical_sel(2) and sx(0); 
    end process calc_logical_carry_mask0_process; 

    -- calculate half_arith_logical(0)
    -- LUT INIT = 0x69696E8A
    -- y =   A'C'E + C'DE + A'B'DE + A'BD'E + A'BDE' + AC'D'E' + ACD'E + ACDE'
    -- sy_or_kk(0)              = E
    -- sx(0) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_half_arith_logical0_process: process (arith_logical_sel(2 downto 0), sx(0), sy_or_kk(0)) begin
        half_arith_logical(0) <= 
            (not arith_logical_sel(2) and not arith_logical_sel(0) and sy_or_kk(0)) or
            (not arith_logical_sel(0) and sx(0) and sy_or_kk(0)) or
            (not arith_logical_sel(2) and not arith_logical_sel(1) and sx(0) and sy_or_kk(0)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and not sx(0) and sy_or_kk(0)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and sx(0) and not sy_or_kk(0)) or
            (arith_logical_sel(2) and not arith_logical_sel(0) and not sx(0) and not sy_or_kk(0)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and not sx(0) and sy_or_kk(0)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and sx(0) and not sy_or_kk(0)); 
    end process calc_half_arith_logical0_process; 

    -- calculate logical_carry_mask(1)
    -- LUT INIT = 0xCCCC0000
    -- y =  AD
    -- sy_or_kk(1)              = E
    -- sx(1) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_logical_carry_mask1_process: process (arith_logical_sel(2), sx(1)) begin
        logical_carry_mask(1) <= 
             arith_logical_sel(2) and sx(1); 
    end process calc_logical_carry_mask1_process; 

    -- calculate half_arith_logical(1)
    -- LUT INIT = 0x69696E8A
    -- y =   A'C'E + C'DE + A'B'DE + A'BD'E + A'BDE' + AC'D'E' + ACD'E + ACDE'
    -- sy_or_kk(1)              = E
    -- sx(1) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_half_arith_logical1_process: process (arith_logical_sel(2 downto 0), sx(1), sy_or_kk(1)) begin
        half_arith_logical(1) <= 
            (not arith_logical_sel(2) and not arith_logical_sel(0) and sy_or_kk(1)) or
            (not arith_logical_sel(0) and sx(1) and sy_or_kk(1)) or
            (not arith_logical_sel(2) and not arith_logical_sel(1) and sx(1) and sy_or_kk(1)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and not sx(1) and sy_or_kk(1)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and sx(1) and not sy_or_kk(0)) or
            (arith_logical_sel(2) and not arith_logical_sel(0) and not sx(1) and not sy_or_kk(1)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and not sx(1) and sy_or_kk(1)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and sx(1) and not sy_or_kk(1)); 
    end process calc_half_arith_logical1_process; 

    -- calculate logical_carry_mask(2)
    -- LUT INIT = 0xCCCC0000
    -- y =  AD
    -- sy_or_kk(2)              = E
    -- sx(2) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_logical_carry_mask2_process: process (arith_logical_sel(2), sx(2)) begin
        logical_carry_mask(2) <= 
             arith_logical_sel(2) and sx(2); 
    end process calc_logical_carry_mask2_process; 

    -- calculate half_arith_logical(2)
    -- LUT INIT = 0x69696E8A
    -- y =   A'C'E + C'DE + A'B'DE + A'BD'E + A'BDE' + AC'D'E' + ACD'E + ACDE'
    -- sy_or_kk(2)              = E
    -- sx(2) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_half_arith_logical2_process: process (arith_logical_sel(2 downto 0), sx(2), sy_or_kk(2)) begin
        half_arith_logical(2) <= 
            (not arith_logical_sel(2) and not arith_logical_sel(0) and sy_or_kk(2)) or
            (not arith_logical_sel(0) and sx(2) and sy_or_kk(2)) or
            (not arith_logical_sel(2) and not arith_logical_sel(1) and sx(2) and sy_or_kk(2)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and not sx(2) and sy_or_kk(2)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and sx(2) and not sy_or_kk(2)) or
            (arith_logical_sel(2) and not arith_logical_sel(0) and not sx(2) and not sy_or_kk(2)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and not sx(2) and sy_or_kk(2)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and sx(2) and not sy_or_kk(2)); 
    end process calc_half_arith_logical2_process; 

    -- calculate logical_carry_mask(3)
    -- LUT INIT = 0xCCCC0000
    -- y =  AD
    -- sy_or_kk(3)              = E
    -- sx(3) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_logical_carry_mask3_process: process (arith_logical_sel(2), sx(3)) begin
        logical_carry_mask(3) <= 
             arith_logical_sel(2) and sx(3); 
    end process calc_logical_carry_mask3_process; 

    -- calculate half_arith_logical(3)
    -- LUT INIT = 0x69696E8A
    -- y =   A'C'E + C'DE + A'B'DE + A'BD'E + A'BDE' + AC'D'E' + ACD'E + ACDE'
    -- sy_or_kk(3)              = E
    -- sx(3) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_half_arith_logical3_process: process (arith_logical_sel(2 downto 0), sx(3), sy_or_kk(3)) begin
        half_arith_logical(3) <= 
            (not arith_logical_sel(2) and not arith_logical_sel(0) and sy_or_kk(3)) or
            (not arith_logical_sel(0) and sx(3) and sy_or_kk(3)) or
            (not arith_logical_sel(2) and not arith_logical_sel(1) and sx(3) and sy_or_kk(3)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and not sx(3) and sy_or_kk(3)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and sx(3) and not sy_or_kk(3)) or
            (arith_logical_sel(2) and not arith_logical_sel(0) and not sx(3) and not sy_or_kk(3)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and not sx(3) and sy_or_kk(3)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and sx(3) and not sy_or_kk(3)); 
    end process calc_half_arith_logical3_process; 

    -- calculate logical_carry_mask(4)
    -- LUT INIT = 0xCCCC0000
    -- y =  AD
    -- sy_or_kk(4)              = E
    -- sx(4) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_logical_carry_mask4_process: process (arith_logical_sel(2), sx(4)) begin
        logical_carry_mask(4) <= 
             arith_logical_sel(2) and sx(4); 
    end process calc_logical_carry_mask4_process; 

    -- calculate half_arith_logical(4)
    -- LUT INIT = 0x69696E8A
    -- y =   A'C'E + C'DE + A'B'DE + A'BD'E + A'BDE' + AC'D'E' + ACD'E + ACDE'
    -- sy_or_kk(4)              = E
    -- sx(4) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_half_arith_logical4_process: process (arith_logical_sel(2 downto 0), sx(4), sy_or_kk(4)) begin
        half_arith_logical(4) <= 
            (not arith_logical_sel(2) and not arith_logical_sel(0) and sy_or_kk(4)) or
            (not arith_logical_sel(0) and sx(4) and sy_or_kk(4)) or
            (not arith_logical_sel(2) and not arith_logical_sel(1) and sx(4) and sy_or_kk(4)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and not sx(4) and sy_or_kk(4)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and sx(4) and not sy_or_kk(4)) or
            (arith_logical_sel(2) and not arith_logical_sel(0) and not sx(4) and not sy_or_kk(4)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and not sx(4) and sy_or_kk(4)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and sx(4) and not sy_or_kk(4)); 
    end process calc_half_arith_logical4_process; 

    -- calculate logical_carry_mask(5)
    -- LUT INIT = 0xCCCC0000
    -- y =  AD
    -- sy_or_kk(5)              = E
    -- sx(5) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_logical_carry_mask5_process: process (arith_logical_sel(2), sx(5)) begin
        logical_carry_mask(5) <= 
             arith_logical_sel(2) and sx(5); 
    end process calc_logical_carry_mask5_process; 

    -- calculate half_arith_logical(5)
    -- LUT INIT = 0x69696E8A
    -- y =   A'C'E + C'DE + A'B'DE + A'BD'E + A'BDE' + AC'D'E' + ACD'E + ACDE'
    -- sy_or_kk(5)              = E
    -- sx(5) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_half_arith_logical5_process: process (arith_logical_sel(2 downto 0), sx(5), sy_or_kk(5)) begin
        half_arith_logical(5) <= 
            (not arith_logical_sel(2) and not arith_logical_sel(0) and sy_or_kk(5)) or
            (not arith_logical_sel(0) and sx(5) and sy_or_kk(5)) or
            (not arith_logical_sel(2) and not arith_logical_sel(1) and sx(5) and sy_or_kk(5)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and not sx(5) and sy_or_kk(5)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and sx(5) and not sy_or_kk(5)) or
            (arith_logical_sel(2) and not arith_logical_sel(0) and not sx(5) and not sy_or_kk(5)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and not sx(5) and sy_or_kk(5)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and sx(5) and not sy_or_kk(5)); 
    end process calc_half_arith_logical5_process; 

    -- calculate logical_carry_mask(6)
    -- LUT INIT = 0xCCCC0000
    -- y =  AD
    -- sy_or_kk(6)              = E
    -- sx(6) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_logical_carry_mask6_process: process (arith_logical_sel(2), sx(6)) begin
        logical_carry_mask(6) <= 
             arith_logical_sel(2) and sx(6); 
    end process calc_logical_carry_mask6_process; 

    -- calculate half_arith_logical(6)
    -- LUT INIT = 0x69696E8A
    -- y =   A'C'E + C'DE + A'B'DE + A'BD'E + A'BDE' + AC'D'E' + ACD'E + ACDE'
    -- sy_or_kk(6)              = E
    -- sx(6) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_half_arith_logical6_process: process (arith_logical_sel(2 downto 0), sx(6), sy_or_kk(6)) begin
        half_arith_logical(6) <= 
            (not arith_logical_sel(2) and not arith_logical_sel(0) and sy_or_kk(6)) or
            (not arith_logical_sel(0) and sx(6) and sy_or_kk(6)) or
            (not arith_logical_sel(2) and not arith_logical_sel(1) and sx(6) and sy_or_kk(6)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and not sx(6) and sy_or_kk(6)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and sx(6) and not sy_or_kk(6)) or
            (arith_logical_sel(2) and not arith_logical_sel(0) and not sx(6) and not sy_or_kk(6)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and not sx(6) and sy_or_kk(6)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and sx(6) and not sy_or_kk(6)); 
    end process calc_half_arith_logical6_process; 

    -- calculate logical_carry_mask(7)
    -- LUT INIT = 0xCCCC0000
    -- y =  AD
    -- sy_or_kk(7)              = E
    -- sx(7) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_logical_carry_mask7_process: process (arith_logical_sel(2), sx(7)) begin
        logical_carry_mask(7) <= 
             arith_logical_sel(2) and sx(7); 
    end process calc_logical_carry_mask7_process; 

    -- calculate half_arith_logical(7)
    -- LUT INIT = 0x69696E8A
    -- y =   A'C'E + C'DE + A'B'DE + A'BD'E + A'BDE' + AC'D'E' + ACD'E + ACDE'
    -- sy_or_kk(7)              = E
    -- sx(7) 	                = D
    -- arith_logical_sel(0)       = C
    -- arith_logical_sel(1)	    = B
    -- arith_logical_sel(2)       = A
    calc_half_arith_logical7_process: process (arith_logical_sel(2 downto 0), sx(7), sy_or_kk(7)) begin
        half_arith_logical(7) <= 
            (not arith_logical_sel(2) and not arith_logical_sel(0) and sy_or_kk(7)) or
            (not arith_logical_sel(0) and sx(7) and sy_or_kk(7)) or
            (not arith_logical_sel(2) and not arith_logical_sel(1) and sx(7) and sy_or_kk(7)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and not sx(7) and sy_or_kk(7)) or
            (not arith_logical_sel(2) and arith_logical_sel(1) and sx(7) and not sy_or_kk(7)) or
            (arith_logical_sel(2) and not arith_logical_sel(0) and not sx(7) and not sy_or_kk(7)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and not sx(7) and sy_or_kk(7)) or
            (arith_logical_sel(2) and arith_logical_sel(0) and sx(7) and not sy_or_kk(7)); 
    end process calc_half_arith_logical7_process; 

    -- arith_logical_muxcy
    -- calculate carry_arith_logical(0)
    calc_carry_arith_logical0_process: process (logical_carry_mask(0), arith_carry_in, half_arith_logical(0)) begin
        case half_arith_logical(0) is
           when '0' =>
             carry_arith_logical(0) <= logical_carry_mask(0);
           when '1' =>
             carry_arith_logical(0) <= arith_carry_in;	
           when others =>
             carry_arith_logical(0) <= 'X';
        end case; 
    end process calc_carry_arith_logical0_process;

    -- arith_logical_muxcy
    -- calculate carry_arith_logical(1)
    calc_carry_arith_logical1_process: process (logical_carry_mask(1), carry_arith_logical(0), half_arith_logical(1)) begin
        case half_arith_logical(1) is
           when '0' =>
             carry_arith_logical(1) <= logical_carry_mask(1);
           when '1' =>
             carry_arith_logical(1) <= carry_arith_logical(0);	
           when others =>
             carry_arith_logical(1) <= 'X';
        end case; 
    end process calc_carry_arith_logical1_process;

    -- arith_logical_muxcy
    -- calculate carry_arith_logical(2)
    calc_carry_arith_logical2_process: process (logical_carry_mask(2), carry_arith_logical(1), half_arith_logical(2)) begin
        case half_arith_logical(2) is
           when '0' =>
             carry_arith_logical(2) <= logical_carry_mask(2);
           when '1' =>
             carry_arith_logical(2) <= carry_arith_logical(1);	
           when others =>
             carry_arith_logical(2) <= 'X';
        end case; 
    end process calc_carry_arith_logical2_process;

    -- arith_logical_muxcy
    -- calculate carry_arith_logical(3)
    calc_carry_arith_logical3_process: process (logical_carry_mask(3), carry_arith_logical(2), half_arith_logical(3)) begin
        case half_arith_logical(3) is
           when '0' =>
             carry_arith_logical(3) <= logical_carry_mask(3);
           when '1' =>
             carry_arith_logical(3) <= carry_arith_logical(2);	
           when others =>
             carry_arith_logical(3) <= 'X';
        end case; 
    end process calc_carry_arith_logical3_process;

    -- arith_logical_muxcy
    -- calculate carry_arith_logical(4)
    calc_carry_arith_logical4_process: process (logical_carry_mask(4), carry_arith_logical(3), half_arith_logical(4)) begin
        case half_arith_logical(4) is
           when '0' =>
             carry_arith_logical(4) <= logical_carry_mask(4);
           when '1' =>
             carry_arith_logical(4) <= carry_arith_logical(3);	
           when others =>
             carry_arith_logical(4) <= 'X';
        end case; 
    end process calc_carry_arith_logical4_process;

    -- arith_logical_muxcy
    -- calculate carry_arith_logical(5)
    calc_carry_arith_logical5_process: process (logical_carry_mask(5), carry_arith_logical(4), half_arith_logical(5)) begin
        case half_arith_logical(5) is
           when '0' =>
             carry_arith_logical(5) <= logical_carry_mask(5);
           when '1' =>
             carry_arith_logical(5) <= carry_arith_logical(4);	
           when others =>
             carry_arith_logical(5) <= 'X';
        end case; 
    end process calc_carry_arith_logical5_process;

    -- arith_logical_muxcy
    -- calculate carry_arith_logical(6)
    calc_carry_arith_logical6_process: process (logical_carry_mask(6), carry_arith_logical(5), half_arith_logical(6)) begin
        case half_arith_logical(6) is
           when '0' =>
             carry_arith_logical(6) <= logical_carry_mask(6);
           when '1' =>
             carry_arith_logical(6) <= carry_arith_logical(5);	
           when others =>
             carry_arith_logical(6) <= 'X';
        end case; 
    end process calc_carry_arith_logical6_process;

    -- arith_logical_muxcy
    -- calculate carry_arith_logical(7)
    calc_carry_arith_logical7_process: process (logical_carry_mask(7), carry_arith_logical(6), half_arith_logical(7)) begin
        case half_arith_logical(7) is
           when '0' =>
             carry_arith_logical(7) <= logical_carry_mask(7);
           when '1' =>
             carry_arith_logical(7) <= carry_arith_logical(6);	
           when others =>
             carry_arith_logical(7) <= 'X';
        end case; 
    end process calc_carry_arith_logical7_process;


    -- arith_logical_xorcy
    arith_logical_value(0) <= half_arith_logical(0) xor arith_carry_in;   
    arith_logical_value(1) <= half_arith_logical(1) xor carry_arith_logical(0);   
    arith_logical_value(2) <= half_arith_logical(2) xor carry_arith_logical(1);   
    arith_logical_value(3) <= half_arith_logical(3) xor carry_arith_logical(2);   
    arith_logical_value(4) <= half_arith_logical(4) xor carry_arith_logical(3);   
    arith_logical_value(5) <= half_arith_logical(5) xor carry_arith_logical(4);   
    arith_logical_value(6) <= half_arith_logical(6) xor carry_arith_logical(5);   
    arith_logical_value(7) <= half_arith_logical(7) xor carry_arith_logical(6);   

end Behavioral;
