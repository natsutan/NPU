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
echo "xvlog -m64 --relax -prj tb_top_vlog.prj"
ExecStep $xv_path/bin/xvlog -m64 --relax -prj tb_top_vlog.prj 2>&1 | tee compile.log