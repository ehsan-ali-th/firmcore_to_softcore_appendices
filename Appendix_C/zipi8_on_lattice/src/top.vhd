----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2019 12:07:08 AM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
     port (                        
        CLK_3P3_MHZ : in std_logic;
        BTN1 : in std_logic;
		LED1 : out std_logic
     );
end top;

architecture Behavioral of top is

    COMPONENT program_memory  PORT (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
      );
    END COMPONENT;    

    COMPONENT zipi8 PORT (
                           address : out std_logic_vector(11 downto 0);
                       bram_enable : out std_logic;
                          out_port : out std_logic_vector(7 downto 0);
                           port_id : out std_logic_vector(7 downto 0);
                      write_strobe : out std_logic;
                    k_write_strobe : out std_logic;
                       read_strobe : out std_logic;
                     interrupt_ack : out std_logic;
                     
                       instruction : in std_logic_vector(17 downto 0);
                           in_port : in std_logic_vector(7 downto 0);
                         interrupt : in std_logic;
                             sleep : in std_logic;
                             reset : in std_logic;
                               clk : in std_logic
    );
    END COMPONENT;
    
    -- signals
    signal         port_id : std_logic_vector(7 downto 0);
    signal    write_strobe : std_logic;
    signal  k_write_strobe : std_logic;
    signal        out_port : std_logic_vector(7 downto 0);
    signal     read_strobe : std_logic;
    signal   interrupt_ack : std_logic;
    signal         address : std_logic_vector(11 downto 0) := B"0000_0000_0000" ;
    signal     instruction : std_logic_vector(17 downto 0);
    signal     bram_enable : std_logic;
    
begin

       
    test_program : program_memory PORT MAP (
        clka => CLK_3P3_MHZ,
         ena => bram_enable,
         wea => "0",
       addra => address,
        dina => B"00_0000_0000_0000_0000",
       douta => instruction
      );

    processor_zipi8 : zipi8 PORT MAP (
            address => address, 
        instruction => instruction,
        bram_enable => bram_enable,
            in_port => X"00",
           out_port => out_port,
            port_id => port_id,
       write_strobe => write_strobe,
     k_write_strobe => k_write_strobe,
        read_strobe => read_strobe,
          interrupt => '0',
      interrupt_ack => interrupt_ack,
             sleep  => '0',
             reset  => BTN1,
               clk  => CLK_3P3_MHZ
    );
    
    
    LED1 <= out_port(0);

end Behavioral;
