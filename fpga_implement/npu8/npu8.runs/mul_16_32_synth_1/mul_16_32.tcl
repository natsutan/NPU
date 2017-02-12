# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -msgmgr_mode ooc_run
create_project -in_memory -part xcku035-fbva676-3-e

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.cache/wt [current_project]
set_property parent.project_path /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_ip -quiet /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32.xci
set_property is_locked true [get_files /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32.xci]

foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

set cached_ip [config_ip_cache -export -no_bom -use_project_ipc -dir /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.runs/mul_16_32_synth_1 -new_name mul_16_32 -ip [get_ips mul_16_32]]

if { $cached_ip eq {} } {

synth_design -top mul_16_32 -part xcku035-fbva676-3-e -mode out_of_context

#---------------------------------------------------------
# Generate Checkpoint/Stub/Simulation Files For IP Cache
#---------------------------------------------------------
catch {
 write_checkpoint -force -noxdef -rename_prefix mul_16_32_ mul_16_32.dcp

 set ipCachedFiles {}
 write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ mul_16_32_stub.v
 lappend ipCachedFiles mul_16_32_stub.v

 write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ mul_16_32_stub.vhdl
 lappend ipCachedFiles mul_16_32_stub.vhdl

 write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ mul_16_32_sim_netlist.v
 lappend ipCachedFiles mul_16_32_sim_netlist.v

 write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ mul_16_32_sim_netlist.vhdl
 lappend ipCachedFiles mul_16_32_sim_netlist.vhdl

 config_ip_cache -add -dcp mul_16_32.dcp -move_files $ipCachedFiles -use_project_ipc -ip [get_ips mul_16_32]
}

rename_ref -prefix_all mul_16_32_

write_checkpoint -force -noxdef mul_16_32.dcp

catch { report_utilization -file mul_16_32_utilization_synth.rpt -pb mul_16_32_utilization_synth.pb }

if { [catch {
  file copy -force /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.runs/mul_16_32_synth_1/mul_16_32.dcp /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  write_verilog -force -mode synth_stub /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode synth_stub /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_verilog -force -mode funcsim /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode funcsim /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}


} else {


if { [catch {
  file copy -force /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.runs/mul_16_32_synth_1/mul_16_32.dcp /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  file rename -force /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.runs/mul_16_32_synth_1/mul_16_32_stub.v /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  file rename -force /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.runs/mul_16_32_synth_1/mul_16_32_stub.vhdl /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  file rename -force /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.runs/mul_16_32_synth_1/mul_16_32_sim_netlist.v /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  file rename -force /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.runs/mul_16_32_synth_1/mul_16_32_sim_netlist.vhdl /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

}; # end if cached_ip 

if {[file isdir /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.ip_user_files/ip/mul_16_32]} {
  catch { 
    file copy -force /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32_stub.v /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.ip_user_files/ip/mul_16_32
  }
}

if {[file isdir /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.ip_user_files/ip/mul_16_32]} {
  catch { 
    file copy -force /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.srcs/sources_1/ip/mul_16_32/mul_16_32_stub.vhdl /media/natu/data/proj/myproj/NPU/fpga_implement/npu8/npu8.ip_user_files/ip/mul_16_32
  }
}