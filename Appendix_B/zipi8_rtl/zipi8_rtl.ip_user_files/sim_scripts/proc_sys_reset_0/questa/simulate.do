onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib proc_sys_reset_0_opt

do {wave.do}

view wave
view structure
view signals

do {proc_sys_reset_0.udo}

run -all

quit -force
