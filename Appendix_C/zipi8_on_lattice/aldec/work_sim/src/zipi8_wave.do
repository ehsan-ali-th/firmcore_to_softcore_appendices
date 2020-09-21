onerror { resume }
transcript off
add wave -noreg -logic {/top_tb/uut/test_program/clka}
add wave -noreg -logic {/top_tb/uut/test_program/ena}
add wave -noreg -hexadecimal -literal {/top_tb/uut/test_program/wea}
add wave -noreg -hexadecimal -literal {/top_tb/uut/test_program/addra}
add wave -noreg -hexadecimal -literal {/top_tb/uut/test_program/dina}
add wave -noreg -hexadecimal -literal {/top_tb/uut/test_program/douta}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/stack_carry_flag}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/stack_zero_flag}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/stack_bank}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/stack_bit}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/carry_flag}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/zero_flag}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/bank}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/run}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/stack_pointer}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/shadow_zero_value}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/stack_pointer_value}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/data_out_ram_low}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/feed_pointer_value}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/half_pointer_value}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/data_in_ram}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/data_out_ram}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/stack_pointer_carry_buf}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/not_t_state_1}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/~ANONYMOUS~0}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/~ANONYMOUS~39}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/clk}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/pc}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/t_state}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/internal_reset}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/pop_stack}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/push_stack}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/shadow_carry_flag}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/shadow_zero_flag}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/shadow_bank}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/stack_memory}
add wave -noreg -logic {/top_tb/uut/processor_zipi8/stack_i/special_bit}
add wave -noreg -hexadecimal -literal {/top_tb/uut/processor_zipi8/stack_i/stack_pointer_carry}
cursor "Cursor 1" 216092ps  
transcript on
