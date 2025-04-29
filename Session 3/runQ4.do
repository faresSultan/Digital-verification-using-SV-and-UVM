vlib work
vlog ./Assignment/RAM.sv ./Assignment/RAM_tb.sv +cover -covercells
vsim -voptargs=+acc RAM_tb -cover
add wave *
coverage save RAM_tb.ucdb -onexit -du my_mem 
run -all



