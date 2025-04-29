vlib work
vlog ./Lab1/adder.v ./Lab1/adder_tb.sv +cover -covercells
vsim -voptargs=+acc work.enc_tb -cover
add wave *
coverage save adder_tb.ucdb -onexit -du adder
run -all
quit -sim
vcover report adder_tb.ucdb -details -annotate -all -output coverage_rpt.txt
