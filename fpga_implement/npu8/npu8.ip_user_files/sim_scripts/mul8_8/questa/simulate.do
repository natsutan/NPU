onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib mul8_8_opt

do {wave.do}

view wave
view structure
view signals

do {mul8_8.udo}

run -all

quit -force
