----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2019 12:31:34 AM
-- Design Name: 
-- Module Name: test_zipi8 - Behavioral
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

use STD.textio.all;
use ieee.std_logic_textio.all;

use std.env.stop;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_zipi8 is
--  Port ( );
end test_zipi8;

    architecture Behavioral of test_zipi8 is

    component top is
        port (                        
              GPIO_PB_SW0 : in std_logic;
              CLK_300_N : in std_logic;
              CLK_300_P : in std_logic;
              GPIO_LED_0_LS_ZIPI8 : out std_logic;
              GPIO_LED_0_LS_KCPSM6 : out std_logic
        );
    end component;

    constant half_period100 : time := 5 ns; -- produce 100Mhz clock  


    signal clk100Mhz_p: std_logic := '0';
    signal clk100Mhz_n: std_logic := '1';
    signal reset: std_logic := '0';
    
    signal led_zipi8: std_logic;
    signal led_kcpsm6: std_logic;
 
    alias uut_clk is << signal uut.clk : std_logic >>;
    
begin
    clk100Mhz_p <= not clk100Mhz_p after half_period100;
    clk100Mhz_n <= not clk100Mhz_n after half_period100;
    
    

    uut: top port map (
        GPIO_PB_SW0 => reset,
        CLK_300_N => clk100Mhz_n,
        CLK_300_P => clk100Mhz_p,
        GPIO_LED_0_LS_ZIPI8 => led_zipi8,
        GPIO_LED_0_LS_KCPSM6 => led_kcpsm6
    );
    
    tb: process begin
        report "Test Started!" severity note;
        reset <= '1';
        wait for 200ns;
        reset <= '0';       -- running period for zipi8
        wait for 1000000ns;
        report "Simulation Finished." severity note;
        stop;
    end process;
    
    instruction_seq_dump : process(uut_clk)
        file file_handler      : text;  -- open write_mode is "zipi8_instructions.txt";
        variable  outline  : line;
        variable file_is_open:  boolean := false;
        
        alias zipi8_instruction is  << signal uut.instruction : std_logic_vector(17 downto 0) >>;
        alias zipi8_reset is        << signal uut.mb_reset : std_logic >>;
    begin
        
        if not file_is_open then
            file_open (file_handler, "zipi8_instructions.txt", write_mode);
            file_is_open := true;
        end if;
        
        if rising_edge(uut_clk) then  
            if(zipi8_reset = '0') then
                hwrite(outline, "00" & zipi8_instruction);
                writeline(file_handler, outline);
            end if;
        end if;
    end process instruction_seq_dump;
    
    -- This process checks the input/output of both cores: zipi8 vs kcpsm6
    test_io_ports: process  (uut_clk)
        alias zipi8_address is << signal uut.address : std_logic_vector(11 downto 0) >>;
        alias zipi8_bram_enable is << signal uut.bram_enable : std_logic >>;
        alias zipi8_out_port is << signal uut.out_port : std_logic_vector(7 downto 0) >>;
        alias zipi8_port_id is << signal uut.port_id : std_logic_vector(7 downto 0) >>;
        alias zipi8_write_strobe is << signal uut.write_strobe : std_logic >>;
        alias zipi8_k_write_strobe is << signal uut.k_write_strobe : std_logic >>;
        alias zipi8_read_strobe is << signal uut.read_strobe : std_logic >>;
        alias zipi8_interrupt_ack is << signal uut.interrupt_ack : std_logic >>;
    
        alias kcpsm6_address is << signal uut.kcpsm6_address : std_logic_vector(11 downto 0) >>;
        alias kcpsm6_bram_enable is << signal uut.kcpsm6_bram_enable : std_logic >>;
        alias kcpsm6_out_port is << signal uut.kcpsm6_out_port : std_logic_vector(7 downto 0) >>;
        alias kcpsm6_port_id is << signal uut.kcpsm6_port_id : std_logic_vector(7 downto 0) >>;
        alias kcpsm6_write_strobe is << signal uut.kcpsm6_write_strobe : std_logic >>;
        alias kcpsm6_k_write_strobe is << signal uut.kcpsm6_k_write_strobe : std_logic >>;
        alias kcpsm6_read_strobe is << signal uut.kcpsm6_read_strobe : std_logic >>;
        alias kcpsm6_interrupt_ack is << signal uut.kcpsm6_interrupt_ack : std_logic >>;
    begin
        if rising_edge(uut_clk) then
            assert (zipi8_address = kcpsm6_address) 
                report "address port mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_bram_enable = kcpsm6_bram_enable) 
                report "bram_enable port mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_out_port = kcpsm6_out_port) 
                report "out_port port mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_port_id = kcpsm6_port_id) 
                report "port_id port mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_write_strobe = kcpsm6_write_strobe) 
                report "write_strobe port mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_k_write_strobe = kcpsm6_k_write_strobe) 
                report "k_write_strobe port mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_read_strobe = kcpsm6_read_strobe) 
                report "read_strobe port mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_interrupt_ack = kcpsm6_interrupt_ack) 
                report "interrupt_ack port mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
        end if;    
    end process;

    -- This process checks the input/output of both cores: zipi8 vs kcpsm6
    test_internal_signals: process  (uut_clk)

        -------------------------------------------------------------------------------------------
        --
        -- State Machine and Interrupt
        --	 
        alias zipi8_t_state_value is                    << signal uut.processor_zipi8.state_machine_i.t_state_value : std_logic_vector(2 downto 1) >>;
        alias zipi8_t_state is                                << signal uut.processor_zipi8.state_machine_i.t_state : std_logic_vector(2 downto 1) >>;
        alias zipi8_run_value is                            << signal uut.processor_zipi8.state_machine_i.run_value : std_logic >>;
        alias zipi8_run is                                        << signal uut.processor_zipi8.state_machine_i.run : std_logic >>;
        alias zipi8_internal_reset_value is      << signal uut.processor_zipi8.state_machine_i.internal_reset_value : std_logic >>;
        alias zipi8_internal_reset is                  << signal uut.processor_zipi8.state_machine_i.internal_reset : std_logic >>;
        alias zipi8_sync_sleep is                          << signal uut.processor_zipi8.state_machine_i.sync_sleep : std_logic >>;
        alias zipi8_int_enable_type is                << signal uut.processor_zipi8.state_machine_i.int_enable_type : std_logic >>;
        alias zipi8_interrupt_enable_value is  << signal uut.processor_zipi8.state_machine_i.interrupt_enable_value : std_logic >>;
        alias zipi8_interrupt_enable is              << signal uut.processor_zipi8.state_machine_i.interrupt_enable : std_logic >>;
        alias zipi8_sync_interrupt is                  << signal uut.processor_zipi8.state_machine_i.sync_interrupt : std_logic >>;
        alias zipi8_active_interrupt_value is  << signal uut.processor_zipi8.state_machine_i.active_interrupt_value : std_logic >>;
        alias zipi8_active_interrupt is              << signal uut.processor_zipi8.state_machine_i.active_interrupt : std_logic >>;
    
        alias kcpsm6_t_state_value is                    << signal uut.processor_kcpsm6.t_state_value : std_logic_vector(2 downto 1) >>;
        alias kcpsm6_t_state is                                << signal uut.processor_kcpsm6.t_state : std_logic_vector(2 downto 1) >>;
        alias kcpsm6_run_value is                            << signal uut.processor_kcpsm6.run_value : std_logic >>;
        alias kcpsm6_run is                                        << signal uut.processor_kcpsm6.run : std_logic >>;
        alias kcpsm6_internal_reset_value is      << signal uut.processor_kcpsm6.internal_reset_value : std_logic >>;
        alias kcpsm6_internal_reset is                  << signal uut.processor_kcpsm6.internal_reset : std_logic >>;
        alias kcpsm6_sync_sleep is                          << signal uut.processor_kcpsm6.sync_sleep : std_logic >>;
        alias kcpsm6_int_enable_type is                << signal uut.processor_kcpsm6.int_enable_type : std_logic >>;
        alias kcpsm6_interrupt_enable_value is  << signal uut.processor_kcpsm6.interrupt_enable_value : std_logic >>;
        alias kcpsm6_interrupt_enable is              << signal uut.processor_kcpsm6.interrupt_enable : std_logic >>;
        alias kcpsm6_sync_interrupt is                  << signal uut.processor_kcpsm6.sync_interrupt : std_logic >>;
        alias kcpsm6_active_interrupt_value is  << signal uut.processor_kcpsm6.active_interrupt_value : std_logic >>;
        alias kcpsm6_active_interrupt is              << signal uut.processor_kcpsm6.active_interrupt : std_logic >>;
    
    
        --
        -- Arithmetic and Logical Functions
        --	 
        alias zipi8_arith_logical_sel is << signal uut.processor_zipi8.arith_logical_sel : std_logic_vector(2 downto 0) >>;
        alias zipi8_arith_carry_in is << signal uut.processor_zipi8.arith_carry_in : std_logic >>;
        alias zipi8_arith_carry_value is << signal uut.processor_zipi8.flags_i.arith_carry_value : std_logic >>;
        alias zipi8_arith_carry is << signal uut.processor_zipi8.flags_i.arith_carry : std_logic >>;
        alias zipi8_half_arith_logical is << signal uut.processor_zipi8.arith_and_logic_operations_i.half_arith_logical : std_logic_vector(7 downto 0) >>;
        alias zipi8_logical_carry_mask is << signal uut.processor_zipi8.arith_and_logic_operations_i.logical_carry_mask : std_logic_vector(7 downto 0) >>;
        alias zipi8_carry_arith_logical is << signal uut.processor_zipi8.arith_and_logic_operations_i.carry_arith_logical : std_logic_vector(7 downto 0) >>;
        alias zipi8_arith_logical_value is << signal uut.processor_zipi8.arith_and_logic_operations_i.arith_logical_value : std_logic_vector(7 downto 0) >>;
        alias zipi8_arith_logical_result is << signal uut.processor_zipi8.arith_logical_result : std_logic_vector(7 downto 0) >>;
        
        alias kcpsm6_arith_logical_sel is << signal uut.processor_kcpsm6.arith_logical_sel : std_logic_vector(2 downto 0) >>;
        alias kcpsm6_arith_carry_in is << signal uut.processor_kcpsm6.arith_carry_in : std_logic >>;
        alias kcpsm6_arith_carry_value is << signal uut.processor_kcpsm6.arith_carry_value : std_logic >>;
        alias kcpsm6_arith_carry is << signal uut.processor_kcpsm6.arith_carry : std_logic >>;
        alias kcpsm6_half_arith_logical is << signal uut.processor_kcpsm6.half_arith_logical : std_logic_vector(7 downto 0) >>;
        alias kcpsm6_logical_carry_mask is << signal uut.processor_kcpsm6.logical_carry_mask : std_logic_vector(7 downto 0) >>;
        alias kcpsm6_carry_arith_logical is << signal uut.processor_kcpsm6.carry_arith_logical : std_logic_vector(7 downto 0) >>;
        alias kcpsm6_arith_logical_value is << signal uut.processor_kcpsm6.arith_logical_value : std_logic_vector(7 downto 0) >>;
        alias kcpsm6_arith_logical_result is << signal uut.processor_kcpsm6.arith_logical_result : std_logic_vector(7 downto 0) >>;
        
        
        --
        -- Shift and Rotate Functions
        --	 
        alias zipi8_shift_rotate_value is << signal     uut.processor_zipi8.shift_and_rotate_operations_i.shift_rotate_value : std_logic_vector(7 downto 0) >>;
        alias zipi8_shift_rotate_result is << signal    uut.processor_zipi8.shift_and_rotate_operations_i.shift_rotate_result : std_logic_vector(7 downto 0) >>;
        alias zipi8_shift_in_bit is << signal           uut.processor_zipi8.shift_and_rotate_operations_i.shift_in_bit : std_logic >>;
        
        alias kcpsm6_shift_rotate_value is << signal     uut.processor_kcpsm6.shift_rotate_value : std_logic_vector(7 downto 0) >>;
        alias kcpsm6_shift_rotate_result is << signal    uut.processor_kcpsm6.shift_rotate_result : std_logic_vector(7 downto 0) >>;
        alias kcpsm6_shift_in_bit is << signal           uut.processor_kcpsm6.shift_in_bit : std_logic >>;
        
        --
        -- ALU structure  
        --	 
        alias zipi8_alu_result is << signal             uut.processor_zipi8.alu_result : std_logic_vector(7 downto 0) >>;
        alias zipi8_alu_mux_sel_value is << signal      uut.processor_zipi8.decode4alu_i.alu_mux_sel_value : std_logic_vector(1 downto 0) >>;
        alias zipi8_alu_mux_sel is << signal            uut.processor_zipi8.alu_mux_sel : std_logic_vector(1 downto 0) >>;
        
        alias kcpsm6_alu_result is << signal             uut.processor_kcpsm6.alu_result : std_logic_vector(7 downto 0) >>;
        alias kcpsm6_alu_mux_sel_value is << signal      uut.processor_kcpsm6.alu_mux_sel_value : std_logic_vector(1 downto 0) >>;
        alias kcpsm6_alu_mux_sel is << signal            uut.processor_kcpsm6.alu_mux_sel : std_logic_vector(1 downto 0) >>;
        
        --
        -- Strobes
        --	
        alias zipi8_strobe_type is << signal            uut.processor_zipi8.flags_i.strobe_type : std_logic >>;
        alias zipi8_write_strobe_value is << signal     uut.processor_zipi8.decode4_strobes_enables_i.write_strobe_value : std_logic >>;
        alias zipi8_k_write_strobe_value is << signal   uut.processor_zipi8.decode4_strobes_enables_i.k_write_strobe_value : std_logic >>;
        alias zipi8_read_strobe_value is << signal      uut.processor_zipi8.decode4_strobes_enables_i.read_strobe_value : std_logic >>;
        
        alias kcpsm6_strobe_type is << signal            uut.processor_kcpsm6.strobe_type : std_logic >>;
        alias kcpsm6_write_strobe_value is << signal     uut.processor_kcpsm6.write_strobe_value : std_logic >>;
        alias kcpsm6_k_write_strobe_value is << signal   uut.processor_kcpsm6.k_write_strobe_value : std_logic >>;
        alias kcpsm6_read_strobe_value is << signal      uut.processor_kcpsm6.read_strobe_value : std_logic >>;
        
        --
        -- Flags
        --	
        alias zipi8_flag_enable_type is << signal       uut.processor_zipi8.flag_enable_type : std_logic >>;
        alias zipi8_flag_enable_value is << signal      uut.processor_zipi8.decode4_strobes_enables_i.flag_enable_value : std_logic >>;
        alias zipi8_flag_enable is << signal            uut.processor_zipi8.flag_enable : std_logic >>; 
        alias zipi8_lower_parity is << signal           uut.processor_zipi8.flags_i.lower_parity : std_logic >>;
        alias zipi8_lower_parity_sel is << signal       uut.processor_zipi8.flags_i.lower_parity_sel : std_logic >>;
        alias zipi8_carry_lower_parity is << signal     uut.processor_zipi8.flags_i.carry_lower_parity : std_logic >>;
        alias zipi8_upper_parity is << signal           uut.processor_zipi8.flags_i.upper_parity : std_logic >>;
        alias zipi8_parity is << signal                 uut.processor_zipi8.flags_i.parity : std_logic >>;
        alias zipi8_shift_carry_value is << signal     uut.processor_zipi8.flags_i.shift_carry_value : std_logic >>;
        alias zipi8_shift_carry is << signal            uut.processor_zipi8.flags_i.shift_carry : std_logic >>;
        alias zipi8_carry_flag_value is << signal       uut.processor_zipi8.flags_i.carry_flag_value : std_logic >>;
        alias zipi8_carry_flag is << signal             uut.processor_zipi8.flags_i.carry_flag : std_logic >>;
        alias zipi8_use_zero_flag_value is << signal    uut.processor_zipi8.flags_i.use_zero_flag_value : std_logic >>;
        alias zipi8_use_zero_flag is << signal          uut.processor_zipi8.flags_i.use_zero_flag : std_logic >>;
        alias zipi8_drive_carry_in_zero is << signal    uut.processor_zipi8.flags_i.drive_carry_in_zero : std_logic >>;
        alias zipi8_carry_in_zero is << signal          uut.processor_zipi8.flags_i.carry_in_zero : std_logic >>;
        alias zipi8_lower_zero is << signal             uut.processor_zipi8.flags_i.lower_zero : std_logic >>;
        alias zipi8_lower_zero_sel is << signal         uut.processor_zipi8.flags_i.lower_zero_sel : std_logic >>;
        alias zipi8_carry_lower_zero is << signal       uut.processor_zipi8.flags_i.carry_lower_zero : std_logic >>;
        alias zipi8_middle_zero is << signal            uut.processor_zipi8.flags_i.middle_zero : std_logic >>;
        alias zipi8_middle_zero_sel is << signal        uut.processor_zipi8.flags_i.middle_zero_sel : std_logic >>;
        alias zipi8_carry_middle_zero is << signal      uut.processor_zipi8.flags_i.carry_middle_zero : std_logic >>;
        alias zipi8_upper_zero_sel is << signal         uut.processor_zipi8.flags_i.upper_zero_sel : std_logic >>;
        alias zipi8_zero_flag_value is << signal        uut.processor_zipi8.flags_i.zero_flag_value : std_logic >>;
        alias zipi8_zero_flag is << signal              uut.processor_zipi8.zero_flag : std_logic >>;
        
        alias kcpsm6_flag_enable_type is << signal       uut.processor_kcpsm6.flag_enable_type : std_logic >>;
        alias kcpsm6_flag_enable_value is << signal      uut.processor_kcpsm6.flag_enable_value : std_logic >>;
        alias kcpsm6_flag_enable is << signal            uut.processor_kcpsm6.flag_enable : std_logic >>; 
        alias kcpsm6_lower_parity is << signal           uut.processor_kcpsm6.lower_parity : std_logic >>;
        alias kcpsm6_lower_parity_sel is << signal       uut.processor_kcpsm6.lower_parity_sel : std_logic >>;
        alias kcpsm6_carry_lower_parity is << signal     uut.processor_kcpsm6.carry_lower_parity : std_logic >>;
        alias kcpsm6_upper_parity is << signal           uut.processor_kcpsm6.upper_parity : std_logic >>;
        alias kcpsm6_parity is << signal                 uut.processor_kcpsm6.parity : std_logic >>;
        alias kcpsm6_shift_carry_value is << signal      uut.processor_kcpsm6.shift_carry_value : std_logic >>;
        alias kcpsm6_shift_carry is << signal            uut.processor_kcpsm6.shift_carry : std_logic >>;
        alias kcpsm6_carry_flag_value is << signal       uut.processor_kcpsm6.carry_flag_value : std_logic >>;
        alias kcpsm6_carry_flag is << signal             uut.processor_kcpsm6.carry_flag : std_logic >>;
        alias kcpsm6_use_zero_flag_value is << signal    uut.processor_kcpsm6.use_zero_flag_value : std_logic >>;
        alias kcpsm6_use_zero_flag is << signal          uut.processor_kcpsm6.use_zero_flag : std_logic >>;
        alias kcpsm6_drive_carry_in_zero is << signal    uut.processor_kcpsm6.drive_carry_in_zero : std_logic >>;
        alias kcpsm6_carry_in_zero is << signal          uut.processor_kcpsm6.carry_in_zero : std_logic >>;
        alias kcpsm6_lower_zero is << signal             uut.processor_kcpsm6.lower_zero : std_logic >>;
        alias kcpsm6_lower_zero_sel is << signal         uut.processor_kcpsm6.lower_zero_sel : std_logic >>;
        alias kcpsm6_carry_lower_zero is << signal       uut.processor_kcpsm6.carry_lower_zero : std_logic >>;
        alias kcpsm6_middle_zero is << signal            uut.processor_kcpsm6.middle_zero : std_logic >>;
        alias kcpsm6_middle_zero_sel is << signal        uut.processor_kcpsm6.middle_zero_sel : std_logic >>;
        alias kcpsm6_carry_middle_zero is << signal      uut.processor_kcpsm6.carry_middle_zero : std_logic >>;
        alias kcpsm6_upper_zero_sel is << signal         uut.processor_kcpsm6.upper_zero_sel : std_logic >>;
        alias kcpsm6_zero_flag_value is << signal        uut.processor_kcpsm6.zero_flag_value : std_logic >>;
        alias kcpsm6_zero_flag is << signal              uut.processor_kcpsm6.zero_flag : std_logic >>;
    
        --
        -- Scratch Pad Memory
        --	 
        alias zipi8_spm_enable_value is << signal       uut.processor_zipi8.decode4_strobes_enables_i.spm_enable_value : std_logic >>;
        alias zipi8_spm_enable is << signal             uut.processor_zipi8.spm_enable : std_logic >>;
        alias zipi8_spm_ram_data is << signal           uut.processor_zipi8.spm_with_output_reg_i.spm_ram_data : std_logic_vector(7 downto 0) >>;
        alias zipi8_spm_data is << signal               uut.processor_zipi8.spm_data : std_logic_vector(7 downto 0) >>;
    
        alias kcpsm6_spm_enable_value is << signal       uut.processor_kcpsm6.spm_enable_value : std_logic >>;
        alias kcpsm6_spm_enable is << signal             uut.processor_kcpsm6.spm_enable : std_logic >>;
        alias kcpsm6_spm_ram_data is << signal           uut.processor_kcpsm6.spm_ram_data : std_logic_vector(7 downto 0) >>;
        alias kcpsm6_spm_data is << signal               uut.processor_kcpsm6.spm_data : std_logic_vector(7 downto 0) >>;
        
        
        --
        -- Registers
        --	 
        alias zipi8_regbank_type is << signal           uut.processor_zipi8.register_bank_control_i.regbank_type : std_logic >>;
        alias zipi8_bank_value is << signal             uut.processor_zipi8.register_bank_control_i.bank_value : std_logic >>;
        alias zipi8_bank is << signal                   uut.processor_zipi8.bank : std_logic >>;
        alias zipi8_loadstar_type is << signal          uut.processor_zipi8.state_machine_i.loadstar_type : std_logic >>;
        alias zipi8_sx_addr4_value is << signal         uut.processor_zipi8.sx_addr4_value : std_logic >>;
        alias zipi8_register_enable_type is << signal   uut.processor_zipi8.decode4_strobes_enables_i.register_enable_type : std_logic >>;
        alias zipi8_register_enable_value is << signal  uut.processor_zipi8.decode4_strobes_enables_i.register_enable_value : std_logic >>;
        alias zipi8_register_enable is << signal        uut.processor_zipi8.register_enable : std_logic >>;
        alias zipi8_sx_addr is << signal                uut.processor_zipi8.sx_addr : std_logic_vector(4 downto 0) >>;
        alias zipi8_sy_addr is << signal                uut.processor_zipi8.sy_addr : std_logic_vector(4 downto 0) >>;
        alias zipi8_sx is << signal                     uut.processor_zipi8.sx : std_logic_vector(7 downto 0) >>;
        alias zipi8_sy is << signal                     uut.processor_zipi8.sy : std_logic_vector(7 downto 0) >>;
        
        alias kcpsm6_regbank_type is << signal           uut.processor_kcpsm6.regbank_type : std_logic >>;
        alias kcpsm6_bank_value is << signal             uut.processor_kcpsm6.bank_value : std_logic >>;
        alias kcpsm6_bank is << signal                   uut.processor_kcpsm6.bank : std_logic >>;
        alias kcpsm6_loadstar_type is << signal          uut.processor_kcpsm6.loadstar_type : std_logic >>;
        alias kcpsm6_sx_addr4_value is << signal         uut.processor_kcpsm6.sx_addr4_value : std_logic >>;
        alias kcpsm6_register_enable_type is << signal   uut.processor_kcpsm6.register_enable_type : std_logic >>;
        alias kcpsm6_register_enable_value is << signal  uut.processor_kcpsm6.register_enable_value : std_logic >>;
        alias kcpsm6_register_enable is << signal        uut.processor_kcpsm6.register_enable : std_logic >>;
        alias kcpsm6_sx_addr is << signal                uut.processor_kcpsm6.sx_addr : std_logic_vector(4 downto 0) >>;
        alias kcpsm6_sy_addr is << signal                uut.processor_kcpsm6.sy_addr : std_logic_vector(4 downto 0) >>;
        alias kcpsm6_sx is << signal                     uut.processor_kcpsm6.sx : std_logic_vector(7 downto 0) >>;
        alias kcpsm6_sy is << signal                     uut.processor_kcpsm6.sy : std_logic_vector(7 downto 0) >>;
        
        --
        -- Second Operand 
        --	 
        alias zipi8_sy_or_kk is << signal               uut.processor_zipi8.sy_or_kk : std_logic_vector(7 downto 0) >>;
    
        alias kcpsm6_sy_or_kk is << signal               uut.processor_kcpsm6.sy_or_kk : std_logic_vector(7 downto 0) >>;
        
        --
        -- Program Counter 
        --	 
        alias zipi8_pc_move_is_valid is << signal       uut.processor_zipi8.decode4_pc_statck_i.pc_move_is_valid : std_logic >>;
        alias zipi8_move_type is << signal              uut.processor_zipi8.decode4_pc_statck_i.move_type : std_logic >>;
        alias zipi8_returni_type is << signal           uut.processor_zipi8.decode4_pc_statck_i.returni_type : std_logic >>;
        alias zipi8_pc_mode is << signal                uut.processor_zipi8.pc_mode : std_logic_vector(2 downto 0) >>;
        alias zipi8_register_vector is << signal        uut.processor_zipi8.register_vector : std_logic_vector(11 downto 0) >>;
        alias zipi8_half_pc is << signal                uut.processor_zipi8.program_counter_i.half_pc : std_logic_vector(11 downto 0) >>;
        alias zipi8_carry_pc is << signal               uut.processor_zipi8.program_counter_i.carry_pc : std_logic_vector(10 downto 0) >>;
        alias zipi8_pc_value is << signal               uut.processor_zipi8.program_counter_i.pc_value : std_logic_vector(11 downto 0) >>;
        alias zipi8_pc is << signal                     uut.processor_zipi8.program_counter_i.pc : std_logic_vector(11 downto 0) >>;
        alias zipi8_pc_vector is << signal              uut.processor_zipi8.program_counter_i.pc_vector : std_logic_vector(11 downto 0) >>;
        
        alias kcpsm6_pc_move_is_valid is << signal       uut.processor_kcpsm6.pc_move_is_valid : std_logic >>;
        alias kcpsm6_move_type is << signal              uut.processor_kcpsm6.move_type : std_logic >>;
        alias kcpsm6_returni_type is << signal           uut.processor_kcpsm6.returni_type : std_logic >>;
        alias kcpsm6_pc_mode is << signal                uut.processor_kcpsm6.pc_mode : std_logic_vector(2 downto 0) >>;
        alias kcpsm6_register_vector is << signal        uut.processor_kcpsm6.register_vector : std_logic_vector(11 downto 0) >>;
        alias kcpsm6_half_pc is << signal                uut.processor_kcpsm6.half_pc : std_logic_vector(11 downto 0) >>;
        alias kcpsm6_carry_pc is << signal               uut.processor_kcpsm6.carry_pc : std_logic_vector(10 downto 0) >>;
        alias kcpsm6_pc_value is << signal               uut.processor_kcpsm6.pc_value : std_logic_vector(11 downto 0) >>;
        alias kcpsm6_pc is << signal                     uut.processor_kcpsm6.pc : std_logic_vector(11 downto 0) >>;
        alias kcpsm6_pc_vector is << signal              uut.processor_kcpsm6.pc_vector : std_logic_vector(11 downto 0) >>;
    
        
        --
        -- Program Counter Stack 
        --	 
        alias zipi8_push_stack is << signal             uut.processor_zipi8.push_stack : std_logic >>;
        alias zipi8_pop_stack is << signal              uut.processor_zipi8.pop_stack : std_logic >>;
        alias zipi8_stack_memory is << signal           uut.processor_zipi8.stack_memory : std_logic_vector(11 downto 0) >>;
        alias zipi8_return_vector is << signal          uut.processor_zipi8.x12_bit_program_address_generator_i.return_vector : std_logic_vector(11 downto 0) >>;
        alias zipi8_stack_carry_flag is << signal       uut.processor_zipi8.stack_i.stack_carry_flag : std_logic >>;
        alias zipi8_shadow_carry_flag is << signal      uut.processor_zipi8.shadow_carry_flag : std_logic >>;
        alias zipi8_stack_zero_flag is << signal        uut.processor_zipi8.stack_i.stack_zero_flag : std_logic >>;
        alias zipi8_shadow_zero_value is << signal      uut.processor_zipi8.stack_i.shadow_zero_value : std_logic >>;
        alias zipi8_shadow_zero_flag is << signal       uut.processor_zipi8.shadow_zero_flag : std_logic >>;
        alias zipi8_stack_bank is << signal             uut.processor_zipi8.stack_i.stack_bank : std_logic >>;
        alias zipi8_shadow_bank is << signal            uut.processor_zipi8.shadow_bank : std_logic >>;
        alias zipi8_stack_bit is << signal              uut.processor_zipi8.stack_i.stack_bit : std_logic >>;
        alias zipi8_special_bit is << signal            uut.processor_zipi8.special_bit : std_logic >>;
        alias zipi8_half_pointer_value is << signal     uut.processor_zipi8.stack_i.half_pointer_value : std_logic_vector(4 downto 0) >>;
        alias zipi8_feed_pointer_value is << signal     uut.processor_zipi8.stack_i.feed_pointer_value : std_logic_vector(4 downto 0) >>;
        alias zipi8_stack_pointer_carry is << signal    uut.processor_zipi8.stack_pointer_carry : std_logic_vector(4 downto 0) >>;
        alias zipi8_stack_pointer_value is << signal    uut.processor_zipi8.stack_i.stack_pointer_value : std_logic_vector(4 downto 0) >>;
        alias zipi8_stack_pointer is << signal          uut.processor_zipi8.stack_i.stack_pointer : std_logic_vector(4 downto 0) >>;
    
        alias kcpsm6_push_stack is << signal             uut.processor_kcpsm6.push_stack : std_logic >>;
        alias kcpsm6_pop_stack is << signal              uut.processor_kcpsm6.pop_stack : std_logic >>;
        alias kcpsm6_stack_memory is << signal           uut.processor_kcpsm6.stack_memory : std_logic_vector(11 downto 0) >>;
        alias kcpsm6_return_vector is << signal          uut.processor_kcpsm6.return_vector : std_logic_vector(11 downto 0) >>;
        alias kcpsm6_stack_carry_flag is << signal       uut.processor_kcpsm6.stack_carry_flag : std_logic >>;
        alias kcpsm6_shadow_carry_flag is << signal      uut.processor_kcpsm6.shadow_carry_flag : std_logic >>;
        alias kcpsm6_stack_zero_flag is << signal        uut.processor_kcpsm6.stack_zero_flag : std_logic >>;
        alias kcpsm6_shadow_zero_value is << signal      uut.processor_kcpsm6.shadow_zero_value : std_logic >>;
        alias kcpsm6_shadow_zero_flag is << signal       uut.processor_kcpsm6.shadow_zero_flag : std_logic >>;
        alias kcpsm6_stack_bank is << signal             uut.processor_kcpsm6.stack_bank : std_logic >>;
        alias kcpsm6_shadow_bank is << signal            uut.processor_kcpsm6.shadow_bank : std_logic >>;
        alias kcpsm6_stack_bit is << signal              uut.processor_kcpsm6.stack_bit : std_logic >>;
        alias kcpsm6_special_bit is << signal            uut.processor_kcpsm6.special_bit : std_logic >>;
        alias kcpsm6_half_pointer_value is << signal     uut.processor_kcpsm6.half_pointer_value : std_logic_vector(4 downto 0) >>;
        alias kcpsm6_feed_pointer_value is << signal     uut.processor_kcpsm6.feed_pointer_value : std_logic_vector(4 downto 0) >>;
        alias kcpsm6_stack_pointer_carry is << signal    uut.processor_kcpsm6.stack_pointer_carry : std_logic_vector(4 downto 0) >>;
        alias kcpsm6_stack_pointer_value is << signal    uut.processor_kcpsm6.stack_pointer_value : std_logic_vector(4 downto 0) >>;
        alias kcpsm6_stack_pointer is << signal          uut.processor_kcpsm6.stack_pointer : std_logic_vector(4 downto 0) >>;

    begin
        if rising_edge(uut_clk) then
        
            -------------------------------------------------------------------------------------------
            --
            -- State Machine and Interrupt
            --	 
            assert (zipi8_t_state_value = kcpsm6_t_state_value) 
                report "t_state_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_t_state = kcpsm6_t_state) 
                report "t_state internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_run_value = kcpsm6_run_value) 
                report "zipi8_run_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_run = kcpsm6_run) 
                report "zipi8_run internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_internal_reset_value = kcpsm6_internal_reset_value) 
                report "zipi8_internal_reset_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_internal_reset = kcpsm6_internal_reset) 
                report "zipi8_internal_reset internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_sync_sleep = kcpsm6_sync_sleep) 
                report "zipi8_sync_sleep internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_int_enable_type = kcpsm6_int_enable_type) 
                report "zipi8_int_enable_type internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_interrupt_enable_value = kcpsm6_interrupt_enable_value) 
                report "zipi8_interrupt_enable_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_interrupt_enable = kcpsm6_interrupt_enable) 
                report "zipi8_interrupt_enable internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_sync_interrupt = kcpsm6_sync_interrupt) 
                report "zipi8_sync_interrupt internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_active_interrupt_value = kcpsm6_active_interrupt_value) 
                report "zipi8_active_interrupt_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_active_interrupt = kcpsm6_active_interrupt) 
                report "zipi8_active_interrupt internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
                

            --
            -- Arithmetic and Logical Functions
            --	 
            assert (zipi8_arith_logical_sel = kcpsm6_arith_logical_sel) 
                report "arith_logical_sel internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_arith_carry_in = kcpsm6_arith_carry_in) 
                report "arith_carry_in internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_arith_carry_value = kcpsm6_arith_carry_value) 
                report "arith_carry_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_arith_carry = kcpsm6_arith_carry) 
                report "arith_carry internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_half_arith_logical = kcpsm6_half_arith_logical) 
                report "half_arith_logical internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_logical_carry_mask = kcpsm6_logical_carry_mask) 
                report "logical_carry_mask internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_carry_arith_logical = kcpsm6_carry_arith_logical) 
                report "carry_arith_logical internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_arith_logical_value = kcpsm6_arith_logical_value) 
                report "arith_logical_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure; 
            assert (zipi8_arith_logical_result = kcpsm6_arith_logical_result) 
                report "arith_logical_result internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
                
            --
            -- Shift and Rotate Functions
            --	 
            assert (zipi8_shift_rotate_value = kcpsm6_shift_rotate_value) 
                report "shift_rotate_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_shift_rotate_result = kcpsm6_shift_rotate_result) 
                report "shift_rotate_result internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_shift_in_bit = kcpsm6_shift_in_bit) 
                report "shift_in_bit internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
                
            --
            -- ALU structure
            --	 
            assert (zipi8_alu_result = kcpsm6_alu_result) 
                report "alu_result internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_alu_mux_sel_value = kcpsm6_alu_mux_sel_value) 
                report "alu_mux_sel_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_alu_mux_sel = kcpsm6_alu_mux_sel) 
                report "alu_mux_sel internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            
            
            --
            -- Strobes
            --	
            assert (zipi8_strobe_type = kcpsm6_strobe_type) 
                report "strobe_type internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_write_strobe_value = kcpsm6_write_strobe_value) 
                report "write_strobe_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_k_write_strobe_value = kcpsm6_k_write_strobe_value) 
                report "k_write_strobe_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_read_strobe_value = kcpsm6_read_strobe_value) 
                report "read_strobe_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
                
            --
            -- Flags
            --	
            assert (zipi8_flag_enable_type = kcpsm6_flag_enable_type) 
                report "flag_enable_type internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_flag_enable_value = kcpsm6_flag_enable_value) 
                report "flag_enable_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_flag_enable = kcpsm6_flag_enable) 
                report "flag_enable internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_lower_parity = kcpsm6_lower_parity) 
                report "lower_parity internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_lower_parity_sel = kcpsm6_lower_parity_sel) 
                report "lower_parity_sel internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_carry_lower_parity = kcpsm6_carry_lower_parity) 
                report "carry_lower_parity internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_upper_parity = kcpsm6_upper_parity) 
                report "upper_parity internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_parity = kcpsm6_parity) 
                report "parity internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_shift_carry_value = kcpsm6_shift_carry_value) 
                report "shift_carry_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_shift_carry = kcpsm6_shift_carry) 
                report "shift_carry internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_carry_flag_value = kcpsm6_carry_flag_value) 
                report "carry_flag_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_carry_flag = kcpsm6_carry_flag) 
                report "carry_flag internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
                
            assert (zipi8_use_zero_flag_value = kcpsm6_use_zero_flag_value) 
                report "use_zero_flag_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_use_zero_flag = kcpsm6_use_zero_flag) 
                report "use_zero_flag internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_drive_carry_in_zero = kcpsm6_drive_carry_in_zero) 
                report "drive_carry_in_zero internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_carry_in_zero = kcpsm6_carry_in_zero) 
                report "carry_in_zero internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_lower_zero = kcpsm6_lower_zero) 
                report "lower_zero internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_lower_zero_sel = kcpsm6_lower_zero_sel) 
                report "lower_zero_sel internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_carry_lower_zero = kcpsm6_carry_lower_zero) 
                report "carry_lower_zero internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_middle_zero = kcpsm6_middle_zero) 
                report "middle_zero internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_middle_zero_sel = kcpsm6_middle_zero_sel) 
                report "middle_zero_sel internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_carry_middle_zero = kcpsm6_carry_middle_zero) 
                report "carry_middle_zero internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_upper_zero_sel = kcpsm6_upper_zero_sel) 
                report "upper_zero_sel internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_zero_flag_value = kcpsm6_zero_flag_value) 
                report "zero_flag_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_zero_flag = kcpsm6_zero_flag) 
                report "zero_flag internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            
            --
            -- Scratch Pad Memory
            --	 
            assert (zipi8_spm_enable_value = kcpsm6_spm_enable_value) 
                report "spm_enable_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_spm_enable = kcpsm6_spm_enable) 
                report "spm_enable internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_spm_ram_data = kcpsm6_spm_ram_data) 
                report "spm_ram_data internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_spm_data = kcpsm6_spm_data) 
                report "spm_data internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
                
            --
            -- Registers
            --	 
            assert (zipi8_regbank_type = kcpsm6_regbank_type) 
                report "regbank_type internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_bank_value = kcpsm6_bank_value) 
                report "bank_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_bank = kcpsm6_bank) 
                report "bank internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_loadstar_type = kcpsm6_loadstar_type) 
                report "loadstar_type internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_sx_addr4_value = kcpsm6_sx_addr4_value) 
                report "sx_addr4_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_register_enable_type = kcpsm6_register_enable_type) 
                report "register_enable_type internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_register_enable_value = kcpsm6_register_enable_value) 
                report "register_enable_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_register_enable = kcpsm6_register_enable) 
                report "register_enable internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_sx_addr = kcpsm6_sx_addr) 
                report "sx_addr internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_sy_addr = kcpsm6_sy_addr) 
                report "sy_addr internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_sx = kcpsm6_sx) 
                report "sx internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_sy = kcpsm6_sy) 
                report "sy internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
                
                
            --
            -- Second Operand 
            --	 
            assert (zipi8_sy_or_kk = kcpsm6_sy_or_kk) 
                report "sy_or_kk internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
                
            --
            -- Program Counter 
            --	 
            assert (zipi8_pc_move_is_valid = kcpsm6_pc_move_is_valid) 
                report "pc_move_is_valid internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_move_type = kcpsm6_move_type) 
                report "move_type internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_returni_type = kcpsm6_returni_type) 
                report "returni_type internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_pc_mode = kcpsm6_pc_mode) 
                report "pc_mode internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_register_vector = kcpsm6_register_vector) 
                report "register_vector internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_half_pc = kcpsm6_half_pc) 
                report "half_pc internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_carry_pc = kcpsm6_carry_pc) 
                report "carry_pc internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_pc_value = kcpsm6_pc_value) 
                report "pc_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_pc = kcpsm6_pc) 
                report "pc internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_pc_vector = kcpsm6_pc_vector) 
                report "pc_vector internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
                
            --
            -- Program Counter Stack 
            --	
            assert (zipi8_push_stack = kcpsm6_push_stack) 
                report "push_stack internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_pop_stack = kcpsm6_pop_stack) 
                report "pc_vector internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_stack_memory = kcpsm6_stack_memory) 
                report "stack_memory internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_return_vector = kcpsm6_return_vector) 
                report "return_vector internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_stack_carry_flag = kcpsm6_stack_carry_flag) 
                report "stack_carry_flag internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_shadow_carry_flag = kcpsm6_shadow_carry_flag) 
                report "shadow_carry_flag internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_stack_zero_flag = kcpsm6_stack_zero_flag) 
                report "stack_zero_flag internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_shadow_zero_value = kcpsm6_shadow_zero_value) 
                report "shadow_zero_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_shadow_zero_flag = kcpsm6_shadow_zero_flag) 
                report "shadow_zero_flag internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_stack_bank = kcpsm6_stack_bank) 
                report "stack_bank internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_shadow_bank = kcpsm6_shadow_bank) 
                report "shadow_bank internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_stack_bit = kcpsm6_stack_bit) 
                report "stack_bit internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_special_bit = kcpsm6_special_bit) 
                report "special_bit internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_half_pointer_value = kcpsm6_half_pointer_value) 
                report "half_pointer_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_feed_pointer_value = kcpsm6_feed_pointer_value) 
                report "feed_pointer_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_stack_pointer_carry = kcpsm6_stack_pointer_carry) 
                report "stack_pointer_carry internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_stack_pointer_value = kcpsm6_stack_pointer_value) 
                report "stack_pointer_value internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
            assert (zipi8_stack_pointer = kcpsm6_stack_pointer) 
                report "stack_pointer internal signal mismatch @ " & integer'image (now / 1ns) & " ns" severity failure;
                 
        end if;    
    end process;
    
end Behavioral;
