vlib work
vlog ./Assignment/package.sv 
vlog ./Assignment/ALSU.v ./Assignment/ALSU_tb.sv +cover -covercells
vsim -voptargs=+acc ALSU_tb -cover
add wave *
coverage save ALSU_tb.ucdb -onexit 
run -all



