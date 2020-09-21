----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2019 07:20:36 PM
-- Design Name: 
-- Module Name: stack - Behavioral
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
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

library ice;
use  ice.all;

--library sb_ice40_components_syn;
--use sb_ice40_components_syn.components.all;	 

entity stack is
    Port (
        clk : in std_logic;
        carry_flag : in std_logic;
        zero_flag : in std_logic;
        bank : in std_logic;
        run : in std_logic;
        pc : in std_logic_vector (11 downto 0);
        t_state : in std_logic_vector (2 downto 1);
        internal_reset : in std_logic;
        pop_stack : in std_logic;
        push_stack : in std_logic;
        shadow_carry_flag : out std_logic := '0';
        shadow_zero_flag : out std_logic := '0';
        shadow_bank : out std_logic := '0';
        stack_memory : out std_logic_vector (11 downto 0) := B"0000_0000_0000";
        special_bit : out std_logic := '0';
        stack_pointer_carry : out std_logic_vector (4 downto 0) := B"0_0000"
    );
end stack;

architecture Behavioral of stack is

    component ram is        
        generic (
            DATA_WIDTH : positive;
            ADDRESS_WIDTH : positive);
        port ( 
            WCLK : in std_logic;
	        WE : in std_logic;
	        DI: in std_logic_vector (DATA_WIDTH-1 downto 0);
	        ADDR: in std_logic_vector (ADDRESS_WIDTH-1 downto 0);
	        DO: out std_logic_vector (DATA_WIDTH-1 downto 0) 
        );
    end component;
	
	-- component SB_RAM256x16 is
		-- generic ( 
           -- INIT_0 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_1 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_2 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_3 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_4 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_5 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_6 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_7 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_8 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_9 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
           -- INIT_F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000" 
            -- ) ;
          -- port( 
                -- RDATA : out std_logic_vector( 15  downto 0) ;
                -- RCLK  : in  std_logic ;
                -- RCLKE : in  std_logic := 'H';
                -- RE    : in  std_logic := 'L';
                -- RADDR : in  std_logic_vector( 7  downto 0) ;
                -- WCLK  : in  std_logic ;
                -- WCLKE : in  std_logic := 'H';
                -- WE    : in  std_logic := 'L';
                -- WADDR : in  std_logic_vector( 7  downto 0) ;
                -- MASK  : in  std_logic_vector( 15  downto 0) ;
                -- WDATA : in  std_logic_vector( 15  downto 0)
               -- );
	-- end component;  
    
    signal data_in_ram_low: std_logic_vector (7 downto 0);
    signal stack_pointer: std_logic_vector (4 downto 0) := B"0_0000"; 
    signal data_out_ram_low: std_logic_vector (7 downto 0);
    signal stack_carry_flag: std_logic := '0';
    signal stack_zero_flag: std_logic := '0';
    signal stack_bank: std_logic := '0';
    signal shadow_zero_value: std_logic := '0';
    signal stack_bit: std_logic := '0';
    signal stack_pointer_value: std_logic_vector(4 downto 0) := B"0_0000";
    signal feed_pointer_value: std_logic_vector(4 downto 0) := B"0_0000";
    signal half_pointer_value: std_logic_vector(4 downto 0) := B"0_0000";
    
	signal data_in_ram: std_logic_vector (15 downto 0);
	signal data_out_ram: std_logic_vector (15 downto 0);

	signal not_t_state_1 : std_logic;
	
begin

    flipflops_process: process (clk) begin
        if rising_edge(clk) then
            shadow_carry_flag <= stack_carry_flag;
            shadow_zero_value <= stack_zero_flag;
            shadow_zero_flag <= shadow_zero_value;
            shadow_bank <= stack_bank;
            special_bit <= stack_bit;
        end if;
     end process flipflops_process; 
     
    flipflops_R_process: process (clk) begin
        if rising_edge(clk) then
            if (internal_reset = '1') then 
               stack_pointer <= B"00000";
            else   
               stack_pointer <= stack_pointer_value;
            end if;    
        end if;
    end process flipflops_R_process;      


	-- stack_ram256X16_inst : SB_RAM256x16
		-- generic map (
			-- INIT_0 => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_1 => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_2 => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_3 => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_4 => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_5 => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_6 => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_7 => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_8 => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_9 => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_A => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_B => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_C => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_D => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_E => X"0000000000000000000000000000000000000000000000000000000000000000",
			-- INIT_F => X"0000000000000000000000000000000000000000000000000000000000000000"
		-- )
		-- port map (
			-- RDATA => data_out_ram,
			-- RADDR => ("000" & stack_pointer),
			-- RCLK => clk,
			-- RCLKE => not_t_state_1,
			-- RE => not_t_state_1,
			-- WADDR => ("000" & stack_pointer),
			-- WCLK=> clk,
			-- WCLKE => t_state(1),
			-- WDATA => data_in_ram,
			-- MASK => X"0000",
			-- WE => t_state(1)
		-- );
		
		not_t_state_1 <= not t_state(1);
		
		stack_ram: ram
        generic map (
            DATA_WIDTH => 16,        -- 32x16-bit RAM
            ADDRESS_WIDTH => 5    
        )
        port map (
            WCLK => clk,
            WE => t_state(1),
            DI => data_in_ram,
            ADDR => stack_pointer,
            DO => data_out_ram    
        );
        
	data_out_ram_low <= data_out_ram(7 downto 0);
	stack_memory(11 downto 4) <= data_out_ram(15 downto 8);

	data_in_ram <= (pc(11 downto 4) & data_in_ram_low);
  
    data_in_ram_low <= pc(3 downto 0) & run & bank & zero_flag & carry_flag;
    stack_carry_flag <= data_out_ram_low(0);
    stack_zero_flag <= data_out_ram_low(1);
    stack_bank <= data_out_ram_low(2);
    stack_bit <= data_out_ram_low(3);
    stack_memory(3 downto 0) <= data_out_ram_low (7 downto 4);
    
    -- stack_ram_high: ram 
            -- generic map (
            -- DATA_WIDTH => 8,        -- 32x8-bit RAM
            -- ADDRESS_WIDTH => 5    
        -- )
        -- port map (
            -- WCLK => clk,
            -- WE => t_state(1),
            -- DI => pc(11 downto 4),
            -- ADDR => stack_pointer,
            -- DO => stack_memory(11 downto 4)    
        -- );
    
    -- calculate feed_pointer_value(0)
    -- LUT INIT = 0xAAAAAAAA
    -- y = E
    -- stack_pointer(0)             = E
    -- pop_stack 	                = D
    -- push_stack                   = C
    -- t_state(1)	                = B
    -- t_state(2)                   = A
	feed_pointer_value(0) <= stack_pointer(0); 
    
    -- calculate half_pointer_value(0)
    -- LUT INIT = 0x001529AA
    -- y = A'B'E + A'C'DE + A'CD'E + AB'C'E' + AB'D'E' + A'BC'D'E'
    -- stack_pointer(0)             = E
    -- pop_stack 	                = D
    -- push_stack                   = C
    -- t_state(1)	                = B
    -- t_state(2)                   = A
	half_pointer_value(0) <= 
		(not t_state(2) and not t_state(1) and stack_pointer(0)) or
		(not t_state(2) and not push_stack and pop_stack and stack_pointer(0)) or
		(not t_state(2) and push_stack and not pop_stack and stack_pointer(0)) or
		(t_state(2) and not t_state(1) and not push_stack and not stack_pointer(0)) or
		(t_state(2) and not t_state(1) and not pop_stack and not stack_pointer(0)) or
		(not t_state(2) and t_state(1) and not push_stack and not pop_stack and not stack_pointer(0)); 

    -- calculate feed_pointer_value(1)
    -- LUT INIT = 0xAAAAAAAA
    -- y = E
    -- stack_pointer(1)             = E
    -- pop_stack 	                = D
    -- push_stack                   = C
    -- t_state(1)	                = B
    -- t_state(2)                   = A
	feed_pointer_value(1) <= stack_pointer(1); 
    
    -- calculate half_pointer_value(1)
    -- LUT INIT = 0x002A252A
    -- y = B'C'E + B'D'E + A'CD'E + A'BC'E'
    -- stack_pointer(1)             = E
    -- pop_stack 	                = D
    -- push_stack                   = C
    -- t_state(1)	                = B
    -- t_state(2)                   = A
	half_pointer_value(1) <= 
		(not t_state(1) and not push_stack and stack_pointer(1)) or
		(not t_state(1) and not pop_stack and stack_pointer(1)) or
		(not t_state(2) and push_stack and not pop_stack and stack_pointer(1)) or
		(not t_state(2) and t_state(1) and not push_stack and not stack_pointer(1)); 
    
    -- calculate feed_pointer_value(2)
    -- LUT INIT = 0xAAAAAAAA
    -- y = E
    -- stack_pointer(2)             = E
    -- pop_stack 	                = D
    -- push_stack                   = C
    -- t_state(1)	                = B
    -- t_state(2)                   = A
	feed_pointer_value(2) <= stack_pointer(2); 
    
    -- calculate half_pointer_value(2)
    -- LUT INIT = 0x002A252A
    -- y = B'C'E + B'D'E + A'CD'E + A'BC'E'
    -- stack_pointer(2)             = E
    -- pop_stack 	                = D
    -- push_stack                   = C
    -- t_state(1)	                = B
    -- t_state(2)                   = A
	half_pointer_value(2) <= 
		(not t_state(1) and not push_stack and stack_pointer(2)) or
		(not t_state(1) and not pop_stack and stack_pointer(2)) or
		(not t_state(2) and push_stack and not pop_stack and stack_pointer(2)) or
		(not t_state(2) and t_state(1) and not push_stack and not stack_pointer(2));  
    
    -- calculate feed_pointer_value(3)
    -- LUT INIT = 0xAAAAAAAA
    -- y = E
    -- stack_pointer(3)             = E
    -- pop_stack 	                = D
    -- push_stack                   = C
    -- t_state(1)	                = B
    -- t_state(2)                   = A
	feed_pointer_value(3) <= stack_pointer(3); 
    
    -- calculate half_pointer_value(3)
    -- LUT INIT = 0x002A252A
    -- y = B'C'E + B'D'E + A'CD'E + A'BC'E'
    -- stack_pointer(3)             = E
    -- pop_stack 	                = D
    -- push_stack                   = C
    -- t_state(1)	                = B
    -- t_state(2)                   = A
	half_pointer_value(3) <= 
		(not t_state(1) and not push_stack and stack_pointer(3)) or
		(not t_state(1) and not pop_stack and stack_pointer(3)) or
		(not t_state(2) and push_stack and not pop_stack and stack_pointer(3)) or
		(not t_state(2) and t_state(1) and not push_stack and not stack_pointer(3)); 

    -- calculate feed_pointer_value(4)
    -- LUT INIT = 0xAAAAAAAA
    -- y = E
    -- stack_pointer(4)             = E
    -- pop_stack 	                = D
    -- push_stack                   = C
    -- t_state(1)	                = B
    -- t_state(2)                   = A
	feed_pointer_value(4) <= stack_pointer(4); 
    
    -- calculate half_pointer_value(4)
    -- LUT INIT = 0x002A252A
    -- y = B'C'E + B'D'E + A'CD'E + A'BC'E'
    -- stack_pointer(3)             = E
    -- pop_stack 	                = D
    -- push_stack                   = C
    -- t_state(1)	                = B
    -- t_state(2)                   = A
	half_pointer_value(4) <= 
		(not t_state(1) and not push_stack and stack_pointer(4)) or
		(not t_state(1) and not pop_stack and stack_pointer(4)) or
		(not t_state(2) and push_stack and not pop_stack and stack_pointer(4)) or
		(not t_state(2) and t_state(1) and not push_stack and not stack_pointer(4)); 

    -- stack_muxcy
    -- calculate stack_pointer_carry(0)
    calc_cstack_pointer_carry0_process: process (feed_pointer_value(0), half_pointer_value(0)) begin
        case half_pointer_value(0) is
           when '0' =>
             stack_pointer_carry(0) <= feed_pointer_value(0);
           when '1' =>
             stack_pointer_carry(0) <= '0';	
           when others =>
             stack_pointer_carry(0) <= 'X';
        end case; 
    end process calc_cstack_pointer_carry0_process;

    -- stack_muxcy
    -- calculate stack_pointer_carry(1)
    calc_cstack_pointer_carry1_process: process (feed_pointer_value(1), half_pointer_value(1), stack_pointer_carry(0)) begin
        case half_pointer_value(1) is
           when '0' =>
             stack_pointer_carry(1) <= feed_pointer_value(1);
           when '1' =>
             stack_pointer_carry(1) <= stack_pointer_carry(0);	
           when others =>
             stack_pointer_carry(1) <= 'X';
        end case; 
    end process calc_cstack_pointer_carry1_process;

    -- stack_muxcy
    -- calculate stack_pointer_carry(2)
    calc_cstack_pointer_carry2_process: process (feed_pointer_value(2), half_pointer_value(2), stack_pointer_carry(1)) begin
        case half_pointer_value(2) is
           when '0' =>
             stack_pointer_carry(2) <= feed_pointer_value(2);
           when '1' =>
             stack_pointer_carry(2) <= stack_pointer_carry(1);	
           when others =>
             stack_pointer_carry(2) <= 'X';
        end case; 
    end process calc_cstack_pointer_carry2_process;

    -- stack_muxcy
    -- calculate stack_pointer_carry(3)
    calc_cstack_pointer_carry3_process: process (feed_pointer_value(3), half_pointer_value(3), stack_pointer_carry(2)) begin
        case half_pointer_value(3) is
           when '0' =>
             stack_pointer_carry(3) <= feed_pointer_value(3);
           when '1' =>
             stack_pointer_carry(3) <= stack_pointer_carry(2);	
           when others =>
             stack_pointer_carry(3) <= 'X';
        end case; 
    end process calc_cstack_pointer_carry3_process;
    
    -- stack_muxcy
    -- calculate stack_pointer_carry(4)
    calc_cstack_pointer_carry4_process: process (feed_pointer_value(4), half_pointer_value(4), stack_pointer_carry(3)) begin
        case half_pointer_value(4) is
           when '0' =>
             stack_pointer_carry(4) <= feed_pointer_value(4);
           when '1' =>
             stack_pointer_carry(4) <= stack_pointer_carry(3);	
           when others =>
             stack_pointer_carry(4) <= 'X';
        end case; 
    end process calc_cstack_pointer_carry4_process;    

    -- stack_xorcy
   stack_pointer_value(0) <= half_pointer_value(0) xor '0';
   stack_pointer_value(1) <= half_pointer_value(1) xor stack_pointer_carry(0);
   stack_pointer_value(2) <= half_pointer_value(2) xor stack_pointer_carry(1);
   stack_pointer_value(3) <= half_pointer_value(3) xor stack_pointer_carry(2);
   stack_pointer_value(4) <= half_pointer_value(4) xor stack_pointer_carry(3);
  
        
end Behavioral; 
