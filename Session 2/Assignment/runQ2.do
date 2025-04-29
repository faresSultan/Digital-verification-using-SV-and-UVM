vlib work
vlog package.sv +define+WIDTH=4
vlog counter.v Assignment2.sv +cover -covercells
vsim -voptargs=+acc Q2 -cover
add wave *
coverage save counter_tb.ucdb -onexit -du counter
run -all
quit -sim
vcover report counter_tb.ucdb -details -annotate -all -output coverage_rpt.txt
