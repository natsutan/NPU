#!/bin/bash -f
xv_path="/media/natu/data/xilinx/Vivado/2016.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim tb_top_behav -key {Behavioral:q_mul_01:Functional:tb_top} -tclbatch tb_top.tcl -view /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8_top_behav.wcfg -log simulate.log
