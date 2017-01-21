#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/media/natu/data/xilinx/SDK/2016.4/bin:/media/natu/data/xilinx/Vivado/2016.4/ids_lite/ISE/bin/lin64:/media/natu/data/xilinx/Vivado/2016.4/bin
else
  PATH=/media/natu/data/xilinx/SDK/2016.4/bin:/media/natu/data/xilinx/Vivado/2016.4/ids_lite/ISE/bin/lin64:/media/natu/data/xilinx/Vivado/2016.4/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=/media/natu/data/xilinx/Vivado/2016.4/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/media/natu/data/xilinx/Vivado/2016.4/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .init_design.begin.rst
EAStep vivado -log npu8_top.vdi -applog -m64 -stack 2000 -product Vivado -messageDb vivado.pb -mode batch -source npu8_top.tcl -notrace


