vlib work
vlog DSP.v DSP_tb.sv +cover -covercells
vsim -voptargs=+acc DSP_tb -cover
add wave *
coverage save DSP_tb.ucdb -onexit -du DSP
run -all
quit -sim
vcover report DSP_tb.ucdb -details -annotate -all -output coverage_rpt.txt
