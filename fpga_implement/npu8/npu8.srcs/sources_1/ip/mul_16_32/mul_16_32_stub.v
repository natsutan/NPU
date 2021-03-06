// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
// Date        : Sat Jan 21 22:59:39 2017
// Host        : natu-OMEN-by-HP-Laptop running 64-bit Ubuntu 16.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32_stub.v
// Design      : mul_16_32
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku035-fbva676-3-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_12,Vivado 2016.4" *)
module mul_16_32(CLK, A, B, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[15:0],B[31:0],P[47:0]" */;
  input CLK;
  input [15:0]A;
  input [31:0]B;
  output [47:0]P;
endmodule
