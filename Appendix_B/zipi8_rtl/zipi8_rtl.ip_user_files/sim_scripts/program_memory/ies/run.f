-makelib ies_lib/xil_defaultlib -sv \
  "/home/esi/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/home/esi/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/home/esi/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_2 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../zipi8_rtl.srcs/sources_1/ip/program_memory/sim/program_memory.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

