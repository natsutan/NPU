onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib mul8_16_opt

do {wave.do}

view wave
view structure
view signals

do {mul8_16.udo}

run -all

quit -force
