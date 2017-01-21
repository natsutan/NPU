proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.cache/wt [current_project]
  set_property parent.project_path /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.xpr [current_project]
  set_property ip_output_repo /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  add_files -quiet /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.runs/synth_1/npu8_top.dcp
  add_files -quiet /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul17_16/mul17_16.dcp
  set_property netlist_only true [get_files /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul17_16/mul17_16.dcp]
  add_files -quiet /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul8_16/mul8_16.dcp
  set_property netlist_only true [get_files /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul8_16/mul8_16.dcp]
  add_files -quiet /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul8_8/mul8_8.dcp
  set_property netlist_only true [get_files /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul8_8/mul8_8.dcp]
  add_files -quiet /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul16_16/mul16_16.dcp
  set_property netlist_only true [get_files /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul16_16/mul16_16.dcp]
  read_xdc -mode out_of_context -ref mul8_16 -cells U0 /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul8_16/mul8_16_ooc.xdc
  set_property processing_order EARLY [get_files /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul8_16/mul8_16_ooc.xdc]
  read_xdc -mode out_of_context -ref mul8_8 -cells U0 /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul8_8/mul8_8_ooc.xdc
  set_property processing_order EARLY [get_files /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul8_8/mul8_8_ooc.xdc]
  read_xdc -mode out_of_context -ref mul16_16 -cells U0 /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul16_16/mul16_16_ooc.xdc
  set_property processing_order EARLY [get_files /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul16_16/mul16_16_ooc.xdc]
  link_design -top npu8_top -part xcku035-fbva676-3-e
  write_hwdef -file npu8_top.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force npu8_top_opt.dcp
  catch { report_drc -file npu8_top_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force npu8_top_placed.dcp
  catch { report_io -file npu8_top_io_placed.rpt }
  catch { report_utilization -file npu8_top_utilization_placed.rpt -pb npu8_top_utilization_placed.pb }
  catch { report_control_sets -verbose -file npu8_top_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force npu8_top_routed.dcp
  catch { report_drc -file npu8_top_drc_routed.rpt -pb npu8_top_drc_routed.pb -rpx npu8_top_drc_routed.rpx }
  catch { report_methodology -file npu8_top_methodology_drc_routed.rpt -rpx npu8_top_methodology_drc_routed.rpx }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file npu8_top_timing_summary_routed.rpt -rpx npu8_top_timing_summary_routed.rpx }
  catch { report_power -file npu8_top_power_routed.rpt -pb npu8_top_power_summary_routed.pb -rpx npu8_top_power_routed.rpx }
  catch { report_route_status -file npu8_top_route_status.rpt -pb npu8_top_route_status.pb }
  catch { report_clock_utilization -file npu8_top_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force npu8_top_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

