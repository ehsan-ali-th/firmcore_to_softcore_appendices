----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2019 06:40:45 PM
-- Design Name: 
-- Module Name: mux_outputs from_alu_spm_input_ports - Behavioral
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

entity mux_outputs_from_alu_spm_input_ports is
    Port ( 
        arith_logical_result : in std_logic_vector (7 downto 0);        
        shift_rotate_result : in std_logic_vector (7 downto 0);        
        in_port : in std_logic_vector (7 downto 0);        
        spm_data : in std_logic_vector (7 downto 0);        
        alu_mux_sel : in std_logic_vector (1 downto 0);        
        alu_result : out std_logic_vector (7 downto 0) := B"0000_0000"       
    );
end mux_outputs_from_alu_spm_input_ports;

architecture Behavioral of mux_outputs_from_alu_spm_input_ports is

begin

    -- parity_muxcy
    -- calculate alu_result
    calc_alu_result_process: process (alu_mux_sel, arith_logical_result, shift_rotate_result, in_port, spm_data) begin
        case alu_mux_sel is
           when "00" =>
             alu_result <= arith_logical_result;
           when "01" =>
             alu_result <= shift_rotate_result;	
           when "10" =>
             alu_result <= in_port;	
           when "11" =>
             alu_result <= spm_data;	
           when others =>
             alu_result <= "--------";
        end case; 
    end process calc_alu_result_process;

end Behavioral;
