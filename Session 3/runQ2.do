vlib work
vlog ./Assignment/package.sv 
vlog ./Assignment/counter.v ./Assignment/counter_tb.sv +cover -covercells
vsim -voptargs=+acc counter_tb -cover
add wave *
coverage save counter_tb.ucdb -onexit 
run -all




