vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.top_tb -classdebug -uvmcontrol=all
add wave /top_tb/alsu_if/*
run -all