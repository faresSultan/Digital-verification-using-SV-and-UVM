vlib work
vlog package.sv counter_tb.sv 
vlog counter.v counter_tb_SVA.sv counter_top.sv +cover -covercells
vsim -voptargs=+acc top -cover
add wave -position insertpoint sim:/top/tb/counterIF/*
coverage save counter_tb.ucdb -onexit 
run -all




