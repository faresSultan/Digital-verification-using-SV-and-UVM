vlib work
vlog config_reg_buggy_questa.svp config_reg_tb.sv  +cover -covercells
vsim -voptargs=+acc config_reg_tb -cover
add wave *
coverage save config_reg_tb.ucdb -onexit 
run -all




