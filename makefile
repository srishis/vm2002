all: setup compile run quit

setup:
		vlib work
		vmap work work

compile:
		vlog vm2002_pkg.sv vm2002.sv vm2002_tb.sv 
		vopt top -o top_optimized  +acc +cover=sbfec
		
run:
		vsim top_optimized -coverage
		log /* -r
		run -all
		coverage save vm_2002.ucdb
		vcover report vm_2002.ucdb 
		vcover report vm_2002.ucdb -cvg -details
		
quit: 
		quit -sim