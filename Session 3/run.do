vlib work
vlog ./Lab1/package.sv 
vlog ./Lab1/alu.sv ./Assignment/alu_tb.sv +cover -covercells
vsim -voptargs=+acc alu_seq_tb -cover
add wave *
coverage save alu_seq_tb.ucdb -onexit 
run -all
coverage exclude -src ./Lab1/alu.sv -line 18 -code s



