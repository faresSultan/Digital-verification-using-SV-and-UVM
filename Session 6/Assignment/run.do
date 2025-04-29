vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.top_tb -classdebug -uvmcontrol=all
add wave /top_tb/alsu_if/*
add wave -position insertpoint  \
sim:/top_tb/DUT/alsuSVA/invalid \
sim:/top_tb/DUT/alsuSVA/invalid_opcode \
sim:/top_tb/DUT/alsuSVA/invalid_red_op
run -all