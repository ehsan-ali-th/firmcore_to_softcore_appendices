// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Sat Jul 27 03:15:45 2019
// Host        : esi-OMEN-by-HP-Laptop-15-dc0xxx running 64-bit Ubuntu 19.04
// Command     : write_verilog -force -mode synth_stub
//               /home/esi/workspace/Vivado_2018.3/zcu104/zipi8_rtl/zipi8_rtl.srcs/sources_1/ip/program_memory/program_memory_stub.v
// Design      : program_memory
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3" *)
module program_memory(clka, ena, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[11:0],dina[17:0],douta[17:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [11:0]addra;
  input [17:0]dina;
  output [17:0]douta;
endmodule
