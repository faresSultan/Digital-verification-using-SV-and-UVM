vlib work
vlog package.sv 
vlog ALSU.v Assignment2.sv +cover -covercells
vsim -voptargs=+acc Q3 -cover
add wave *
coverage save ALSU_tb.ucdb -onexit -du ALSU
run -all



