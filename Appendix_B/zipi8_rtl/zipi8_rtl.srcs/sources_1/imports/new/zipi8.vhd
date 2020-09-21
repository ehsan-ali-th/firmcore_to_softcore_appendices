----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2019 12:56:46 PM
-- Design Name: 
-- Module Name: zipi8 - Behavioral
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
use work.op_codes.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity zipi8 is
 port (                   
                           address : out std_logic_vector(11 downto 0);
                       bram_enable : out std_logic := '0';
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
                               clk : in std_logic);
end zipi8;

architecture Behavioral of zipi8 is

    -- Components
    
    component state_machine is
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
            t_state : out std_logic_vector (2 downto 1);
            run : out std_logic;
            active_interrupt : out std_logic;
            internal_reset : out std_logic;
            sx_addr4_value : out std_logic;
            interrupt_ack : out std_logic
        );
    end component;

    component register_bank_control is
        Port (
            clk : in std_logic; 
            instruction_17_downto_4  : in std_logic_vector(17 downto 4);
            instruction_0 : in std_logic;
            sx_addr4_value : in std_logic;
            t_state_1 : in std_logic;
            internal_reset : in std_logic;
            shadow_bank : in std_logic;
            bank : out std_logic;
            sx_addr : out  std_logic_vector(4 downto 0);
            sy_addr : out  std_logic_vector(4 downto 0)
        );
    end component;
    
    component decode4_pc_statck is
        Port (
             carry_flag : in std_logic;
             zero_flag : in std_logic;
             instruction_17_downto_12 : in std_logic_vector (17 downto 12);
             active_interrupt : in std_logic;
             pop_stack : out std_logic;
             push_stack : out std_logic;
             pc_mode : out std_logic_vector (2 downto 0)
         );
    end component;
    
    component decode4alu is
        Port (
            clk : in std_logic;   
            carry_flag : in std_logic;
            instruction_16_downto_13  : in std_logic_vector (16 downto 13);
            alu_mux_sel : out std_logic_vector (1 downto 0);
            arith_logical_sel : out std_logic_vector (2 downto 0);
            arith_carry_in : out std_logic
        );
    end component;
    
    component decode4_strobes_enables is
        Port (
            clk : in std_logic;
            t_state_1 : in std_logic;
            strobe_type : in std_logic;
            active_interrupt : in std_logic;
            instruction_17_downto_12 : in std_logic_vector(17 downto 12);
            flag_enable_type : out std_logic;
            register_enable : out std_logic;
            flag_enable : out std_logic;
            k_write_strobe : out std_logic;
            spm_enable : out std_logic;
            write_strobe : out std_logic;
            read_strobe : out std_logic
        );
    end component;

    component flags is
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
            zero_flag : out std_logic;
            carry_flag : out std_logic;
            strobe_type : out std_logic
        );
    end component;
    
    component x12_bit_program_address_generator is
        Port ( 
            clk : in std_logic;
            instruction_12_downto_0 : in std_logic_vector(12 downto 0);
            sx : in std_logic_vector(3 downto 0);
            sy : in std_logic_vector(7 downto 0);
            stack_memory : in std_logic_vector(11 downto 0);
            register_vector : out std_logic_vector(11 downto 0);
            pc_vector : out std_logic_vector(11 downto 0)
        );
    end component;

    component program_counter is
        Port ( 
             clk : in std_logic;
             register_vector : in std_logic_vector(11 downto 0);
             pc_vector : in std_logic_vector(11 downto 0);
             t_state_1 : in std_logic;
             internal_reset : in std_logic;
             pc_mode : in std_logic_vector(2 downto 0);
             pc : out std_logic_vector(11 downto 0)
        );
    end component;    
    
    component stack is
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
            shadow_carry_flag : out std_logic;
            shadow_zero_flag : out std_logic;
            shadow_bank : out std_logic;
            stack_memory : out std_logic_vector (11 downto 0);
            special_bit : out std_logic;
            stack_pointer_carry : out std_logic_vector (4 downto 0)
        );
    end component;    
    
    component two_banks_of_16_gp_reg is
        Port ( 
            clk : in std_logic;
            alu_result: in std_logic_vector(7 downto 0);    
            sx_addr: in std_logic_vector(4 downto 0);    
            sy_addr: in std_logic_vector(4 downto 0);   
            register_enable : in std_logic; 
            sx: out std_logic_vector(7 downto 0);
            sy: out std_logic_vector(7 downto 0)
        );
    end component;
    
    component sel_of_2nd_op_to_alu_and_port_id is
        Port ( 
            sy : in std_logic_vector (7 downto 0);
            instruction_7_downto_0 : in std_logic_vector (7 downto 0);
            instruction_12 : in std_logic;
            --arith_carry_in : in std_logic;
            sy_or_kk : out std_logic_vector (7 downto 0)
        );
    end component;
    
    component sel_of_out_port_value is
        Port ( 
            sx : in std_logic_vector (7 downto 0);
            instruction_11_downto_4 : in std_logic_vector (11 downto 4);
            instruction_13 : in std_logic;
            out_port : out std_logic_vector (7 downto 0)
        );
    end component;
    
    component arith_and_logic_operations is
        Port ( 
            clk : in std_logic;
            sy_or_kk : in std_logic_vector (7 downto 0);
            sx : in std_logic_vector (7 downto 0);
            arith_logical_sel : in std_logic_vector (2 downto 0);
            arith_carry_in : in std_logic;
            arith_logical_result : out std_logic_vector (7 downto 0);
            carry_arith_logical_7 : out std_logic
        );
    end component;    
    
    component shift_and_rotate_operations is
        Port ( 
            clk : in std_logic;
            instruction_7 : in std_logic;
            instruction_3_downto_0 : in std_logic_vector (3 downto 0);
            carry_flag : in std_logic;
            sx : in std_logic_vector (7 downto 0);
            shift_rotate_result : out std_logic_vector (7 downto 0)
        );
    end component;
    
    component spm_with_output_reg is
    Port (
         clk : in std_logic;
         sx : in std_logic_vector (7 downto 0);
         sy_or_kk : in std_logic_vector (7 downto 0);
         spm_enable : in std_logic;
         spm_data : out std_logic_vector (7 downto 0)
     );
    end component;

    component mux_outputs_from_alu_spm_input_ports is
        Port ( 
            arith_logical_result : in std_logic_vector (7 downto 0);        
            shift_rotate_result : in std_logic_vector (7 downto 0);        
            in_port : in std_logic_vector (7 downto 0);        
            spm_data : in std_logic_vector (7 downto 0);        
            alu_mux_sel : in std_logic_vector (1 downto 0);        
            alu_result : out std_logic_vector (7 downto 0)        
        );
    end component;
    
    -- Internal Signals
    
    -- state_machine
    signal t_state : std_logic_vector (2 downto 1);
    signal run: std_logic; 
    signal active_interrupt: std_logic; 
    signal internal_reset: std_logic; 
    signal sx_addr4_value: std_logic; 
    
    -- Register bank control
    signal sx_addr : std_logic_vector (4 downto 0);
    signal sy_addr : std_logic_vector (4 downto 0);
    signal bank: std_logic; 
        
    -- Decoding for Program Counter and Stack
    signal pop_stack: std_logic; 
    signal push_stack: std_logic; 
    signal pc_mode: std_logic_vector (2 downto 0);  
    
    -- Decoding for ALU
    signal alu_mux_sel: std_logic_vector (1 downto 0);  
    signal arith_logical_sel: std_logic_vector (2 downto 0);  
    signal arith_carry_in: std_logic;
    
    -- Decoding for strobes and enables
    signal flag_enable_type: std_logic;
    signal register_enable: std_logic;
    signal flag_enable: std_logic;
    signal spm_enable: std_logic;
    
    -- flags
    signal zero_flag: std_logic;
    signal carry_flag: std_logic;
    signal strobe_type: std_logic;
    
    -- 12-bit Program Address Generation
    signal register_vector: std_logic_vector (11 downto 0);  
    signal pc_vector: std_logic_vector (11 downto 0);  
    
    -- Program Counter
    signal pc: std_logic_vector (11 downto 0);  
    
    -- Stack
     signal shadow_carry_flag: std_logic;
     signal shadow_zero_flag: std_logic;
     signal shadow_bank: std_logic;
     signal stack_memory: std_logic_vector (11 downto 0);
     signal special_bit: std_logic;
     signal stack_pointer_carry: std_logic_vector (4 downto 0);  
       
     -- Two banks of 16 general purpose registers
     signal sx: std_logic_vector (7 downto 0);
     signal sy: std_logic_vector (7 downto 0);

    -- Selection of second operand to ALU and port_id
    signal sy_or_kk: std_logic_vector (7 downto 0);
     
    -- Arithmetic and Logical operations
    signal arith_logical_result: std_logic_vector (7 downto 0);
    signal carry_arith_logical_7: std_logic;
    
    -- Shift and Rotate operations
    signal shift_rotate_result: std_logic_vector (7 downto 0);
    
    -- Scratchpad Memory with output register
    signal spm_data: std_logic_vector (7 downto 0);
    
    -- Multiplex outputs from ALU function, scratch pad memory and input port
    signal alu_result: std_logic_vector (7 downto 0);
    
    
     
     

    
   
begin

    state_machine_i: state_machine 
        port map (
                             clk => clk,
                           sleep => sleep,
                       interrupt => interrupt,
                           reset => reset,
                     special_bit => special_bit,
        instruction_17_downto_13 => instruction(17 downto 13),
                   instruction_0 => instruction(0),
           stack_pointer_carry_4 => stack_pointer_carry(4),
                            bank => bank,
                         t_state => t_state,
                             run => run,
                active_interrupt => active_interrupt,
                  internal_reset => internal_reset,
                  sx_addr4_value => sx_addr4_value,
                   interrupt_ack => interrupt_ack   
        );
        
        bram_enable <= t_state (2);
        
    register_bank_control_i: register_bank_control 
        port map (
                             clk => clk ,
        instruction_17_downto_4  => instruction(17 downto 4),
                   instruction_0 => instruction(0),
                  sx_addr4_value => sx_addr4_value,
                       t_state_1 => t_state(1),
                  internal_reset => internal_reset,
                     shadow_bank => shadow_bank,
                            bank => bank,
                         sx_addr => sx_addr,
                         sy_addr => sy_addr 
        );

    decode4_pc_statck_i: decode4_pc_statck
        port map (
                      carry_flag => carry_flag,
                       zero_flag => zero_flag,
        instruction_17_downto_12 => instruction(17 downto 12),
                active_interrupt => active_interrupt,
                       pop_stack => pop_stack,
                      push_stack => push_stack,
                         pc_mode => pc_mode
        );
        
    decode4alu_i: decode4alu
        port map (
                                 clk => clk,   
                          carry_flag => carry_flag,
            instruction_16_downto_13 => instruction(16 downto 13),
                         alu_mux_sel => alu_mux_sel,
                   arith_logical_sel => arith_logical_sel,
                      arith_carry_in => arith_carry_in
        );
            
    decode4_strobes_enables_i: decode4_strobes_enables
        port map (
                                 clk => clk, 
                           t_state_1 => t_state(1), 
                         strobe_type => strobe_type, 
                    active_interrupt => active_interrupt, 
            instruction_17_downto_12 => instruction(17 downto 12), 
                    flag_enable_type => flag_enable_type, 
                     register_enable => register_enable, 
                         flag_enable => flag_enable, 
                      k_write_strobe => k_write_strobe, 
                          spm_enable => spm_enable, 
                        write_strobe => write_strobe , 
                         read_strobe => read_strobe 
        );          
        
    flags_i: flags
        port map (
                                 clk => clk,
            instruction_16_downto_13 => instruction (16 downto 13),
                 carry_arith_logical_7 => carry_arith_logical_7,
                       instruction_7 => instruction(7),
                       instruction_3 => instruction(3),
                  arith_logical_result => arith_logical_result(7 downto 0),
                   shadow_carry_flag => shadow_carry_flag,
                         flag_enable => flag_enable,
                          alu_result => alu_result,
                      internal_reset => internal_reset,
                    shadow_zero_flag => shadow_zero_flag,
                                sx_0 => sx(0),
                                sx_7 => sx(7),
                           zero_flag => zero_flag,
                          carry_flag => carry_flag,
                         strobe_type => strobe_type
        );          
        
    x12_bit_program_address_generator_i: x12_bit_program_address_generator
        port map (
            clk => clk,
            instruction_12_downto_0 => instruction (12 downto 0),
                                 sx => sx (3 downto 0),
                                 sy => sy,
                       stack_memory => stack_memory,
                    register_vector => register_vector,
                          pc_vector => pc_vector
        );   
        
    program_counter_i: program_counter
        port map (
                                clk => clk,
                    register_vector => register_vector,
                          pc_vector => pc_vector,
                          t_state_1 => t_state(1),
                     internal_reset => internal_reset,
                            pc_mode => pc_mode,
                                 pc => pc
        );             
        
        address <= pc;
        
    stack_i: stack
        port map (
                            clk => clk,
                     carry_flag => carry_flag,
                      zero_flag => zero_flag,
                           bank => bank,
                            run => run,
                             pc => pc,
                        t_state => t_state,
                 internal_reset => internal_reset,
                      pop_stack => pop_stack,
                     push_stack => push_stack,
              shadow_carry_flag => shadow_carry_flag,
               shadow_zero_flag => shadow_zero_flag,
                    shadow_bank => shadow_bank,
                   stack_memory => stack_memory,
                    special_bit => special_bit,
            stack_pointer_carry => stack_pointer_carry
        );  
        
    two_banks_of_16_gp_reg_i: two_banks_of_16_gp_reg
        port map (
                        clk => clk,
                  alu_result => alu_result,
                    sx_addr => sx_addr, 
                    sy_addr => sy_addr,
            register_enable => register_enable,
                         sx => sx,
                         sy => sy
        ); 
        
    sel_of_2nd_op_to_alu_and_port_id_i: sel_of_2nd_op_to_alu_and_port_id
        port map (
                        sy => sy,
    instruction_7_downto_0 => instruction(7 downto 0),
            instruction_12 => instruction(12),
            --arith_carry_in => arith_carry_in,
                  sy_or_kk => sy_or_kk
        );                     
        
        port_id <= sy_or_kk;
        
    sel_of_out_port_value_i: sel_of_out_port_value
    port map (
                             sx => sx,
        instruction_11_downto_4 => instruction (11 downto 4),
                 instruction_13 => instruction (13),
                       out_port => out_port
        );  
        
     arith_and_logic_operations_i: arith_and_logic_operations
        port map (
                           clk => clk,
                      sy_or_kk => sy_or_kk,
                            sx => sx,
               arith_logical_sel => arith_logical_sel,
                arith_carry_in => arith_carry_in,
          arith_logical_result => arith_logical_result,
          carry_arith_logical_7 => carry_arith_logical_7
        ); 
        
    shift_and_rotate_operations_i: shift_and_rotate_operations
        port map (
                           clk => clk,
                 instruction_7 => instruction(7),
        instruction_3_downto_0 => instruction(3 downto 0),
                    carry_flag => carry_flag,
                            sx => sx,
           shift_rotate_result => shift_rotate_result
        ); 
        
    spm_with_output_reg_i: spm_with_output_reg
        port map (
                           clk => clk,
                            sx => sx,
                      sy_or_kk => sy_or_kk,
                    spm_enable => spm_enable,
                      spm_data => spm_data 
        );
        
    mux_outputs_from_alu_spm_input_ports_i : mux_outputs_from_alu_spm_input_ports
        port map (
            arith_logical_result => arith_logical_result,  
             shift_rotate_result => shift_rotate_result,      
                         in_port => in_port,      
                        spm_data => spm_data,     
                     alu_mux_sel => alu_mux_sel,     
                      alu_result => alu_result
        );
        
end Behavioral;        
